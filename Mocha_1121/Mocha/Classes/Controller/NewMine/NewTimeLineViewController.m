//
//  NewTimeLineViewController.m
//  Mocha
//
//  Created by sunqichao on 15/9/5.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewTimeLineViewController.h"
#import "TimeLineTableViewCell.h"
#import "PhotoViewDetailController.h"
#import "PhotoBrowseViewController.h"
#import "UIScrollView+MJRefresh.h"

@interface NewTimeLineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, assign) int thisPage;

@property (nonatomic, strong) NSFetchedResultsController *timeLineFetched;

@end

@implementation NewTimeLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lastIndexId = @"0";
    self.thisPage = 1;
    self.title = self.currentTitle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"refreshTableView" object:nil];
    [self addFooter];
    [self addHeader];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.navigationController.navigationBarHidden = NO;

}

- (void)refreshTableView
{
    [self getCoreDataFetch];
    
    
}

#pragma mark add
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addHeaderWithCallback:^{
        vc.lastIndexId = @"0";
        self.thisPage = 1;
        [vc getTimeLineData];
    }];
    [self.tableView headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addFooterWithCallback:^{
        self.thisPage++;
        [vc getTimeLineData];
    }];
}

- (void)endRefreshing
{
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
    }
}

//先取缓存的动态数据，若没有，再从服务端取
- (void)getCoreDataFetch
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ AND index<%d",self.uid,self.thisPage*10];
    //查询条件
    self.timeLineFetched = [PhotoInfo MR_fetchAllGroupedBy:nil withPredicate:predicate sortedBy:@"createline" ascending:NO];
    
    if (self.timeLineFetched.fetchedObjects.count > 0) {
        [self.tableView reloadData];
        
    }
    
}

- (void)getTimeLineData
{
    NSDictionary *params = [AFParamFormat formatGetPhotoListParams:self.uid lastindex:self.lastIndexId];
    [AFNetwork getPhotoList:params success:^(id data){
        [self endRefreshing];

        if ([data[@"status"] integerValue] == kRight) {
            NSArray *array = data[@"data"];
            if ([array count] <= 0) {
                
            }
            else{
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                    int max = self.thisPage;
                    int min = self.thisPage-1;
                    if (min<0) {
                        min=0;
                    }
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ AND index<%d AND index>=%d",self.uid,max*10,min*10];  //查询条件
                    
                    [PhotoInfo MR_deleteAllMatchingPredicate:predicate inContext:localContext];
                } completion:^(BOOL contextDidSave, NSError *error) {
                    
                    [PhotoEngine savePhotoInfoWithArray:array uid:self.uid block:^(BOOL success, NSError *error) {
                        
                    }];
                }];
                
                
                if ([self.lastIndexId isEqualToString:@"0"]) {
                    self.dataArray = [NSMutableArray arrayWithArray:array];
                }
                else{
                    for (int i=0; i<array.count; i++) {
                        if (![self.dataArray containsObject:array[i]]) {
                            [self.dataArray addObject:array[i]];
                        }
                    }
                }
                
                if (array.count>0) {
                    NSString *pid = [NSString stringWithFormat:@"%@",array[array.count-1][@"id"]];
                    self.lastLastIndexId = self.lastIndexId;
                    self.lastIndexId = pid;
                    
                }
            }

        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
        
    }failed:^(NSError *error){

        
    }];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

#pragma mark tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 0.0;
    PhotoInfo *diction = self.timeLineFetched.fetchedObjects[indexPath.row];
    
    NSString *tags = [NSString stringWithFormat:@"%@",diction.tags];
    NSString *title = [NSString stringWithFormat:@"%@",diction.title];
    float imgH = kPhotoHeight;
    
    height = 155+imgH;
    
    if (indexPath.row==self.timeLineFetched.fetchedObjects.count-1) {
        height = height+10;
    }
    NSArray *users = [PhotoEngine changeSetToArray:diction.likeUsers];
    
    if (users.count==0) {
        height = height-40;
    }
    if (tags.length==0) {
        height = height-20;
        
    }
    if (title.length==0) {
        height = height-20;
        
    }

    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TimeLineTableViewCell *cell = nil;
    NSString *identifier = @"TimeLineTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [TimeLineTableViewCell getTimeLineCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell.likeButton addTarget:self action:@selector(cellLikeMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.privateButton addTarget:self action:@selector(cellCollectionMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cell.commentButton addTarget:self action:@selector(cellCommentMethod:) forControlEvents:UIControlEventTouchUpInside];
    if (self.timeLineFetched.fetchedObjects.count>indexPath.row) {
        PhotoInfo *photo = self.timeLineFetched.fetchedObjects[indexPath.row];
        
        [cell setCellViewWithDiction:photo indexpath:indexPath];
        
        
    }
    
    return cell;
}

- (void)cellLikeMethod:(UIButton *)button
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        PhotoInfo *photo = self.timeLineFetched.fetchedObjects[button.tag];
        
        if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
            [button setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"likedButton"] forState:UIControlStateNormal];
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            NSString *photoId = photo.pid;
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSArray *saveData = [PhotoInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pid = %@",photo.pid] inContext:localContext];
                PhotoInfo *saveInfo = saveData[0];
                saveInfo.islike = @"1";
            }];
            
            NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid];
            [AFNetwork likeAdd:dict success:^(id data){
            
                if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }
            }failed:^(NSError *error){
                
            }];
            
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            NSString *photoId = photo.pid;
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSArray *saveData = [PhotoInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pid = %@",photo.pid] inContext:localContext];
                PhotoInfo *saveInfo = saveData[0];
                saveInfo.islike = @"0";
            }];
            
            NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid];
            [AFNetwork likeCancel:dict success:^(id data){
                
                if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }
            }failed:^(NSError *error){
                
            }];
        }
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
    }
    
    
}

- (void)cellCollectionMethod:(UIButton *)button
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        PhotoInfo *photo = self.timeLineFetched.fetchedObjects[button.tag];
        
        if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
            [button setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"unCollection"] forState:UIControlStateNormal];
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            NSString *photoId = photo.pid;
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSArray *saveData = [PhotoInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pid = %@",photo.pid] inContext:localContext];
                PhotoInfo *saveInfo = saveData[0];
                saveInfo.isfavorite = @"1";
            }];
            
            
            NSDictionary *dict = [AFParamFormat formatFavoriteActionParams:photoId userId:uid];
            [AFNetwork favoriteAdd:dict success:^(id data){
                
                if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }
            }failed:^(NSError *error){
                
            }];
            
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            NSString *photoId = photo.pid;
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                NSArray *saveData = [PhotoInfo MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"pid = %@",photo.pid] inContext:localContext];
                PhotoInfo *saveInfo = saveData[0];
                saveInfo.isfavorite = @"0";
            }];
            
            NSDictionary *dict = [AFParamFormat formatFavoriteActionParams:photoId userId:uid];
            [AFNetwork favoriteCancel:dict success:^(id data){
                
                if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }
            }failed:^(NSError *error){
                
            }];
        }
        
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
    }
    
}

- (void)cellCommentMethod:(UIButton *)button
{
    
    PhotoInfo *photo = self.timeLineFetched.fetchedObjects[button.tag];
    
    NSString *photoId = photo.pid;
    PhotoViewDetailController *detail = [[PhotoViewDetailController alloc] initWithNibName:@"PhotoViewDetailController" bundle:[NSBundle mainBundle]];
    [detail requestWithPhotoId:photoId uid:self.uid];
    detail.isFromTimeLine = YES;
    [self.navigationController pushViewController:detail animated:YES];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *uid = self.uid;
    if (uid) {
        PhotoBrowseViewController *photo = [[PhotoBrowseViewController alloc] initWithNibName:@"PhotoBrowseViewController" bundle:[NSBundle mainBundle]];
        photo.startWithIndex = indexPath.row;
        photo.currentUid = self.uid;
        photo.lastIndexId = self.lastIndexId;

        self.lastIndexId = self.lastLastIndexId;
        [photo setDataFromTimeLineWithUid:self.uid andArray:self.dataArray];
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT synchronize];
        
        [self.navigationController pushViewController:photo animated:YES];
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
    }
    
}


@end
