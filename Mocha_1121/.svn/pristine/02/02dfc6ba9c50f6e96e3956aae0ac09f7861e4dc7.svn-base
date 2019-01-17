//
//  WatchedViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "WatchedViewController.h"
#import "WatchedTableViewCell.h"
#import "MJRefresh.h"

@interface WatchedViewController ()

@property (nonatomic, assign) int currentIndex;
@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL isNeedToRefresh;

@property (nonatomic, strong) NSString *thisUid;

@end

@implementation WatchedViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isNeedToRefresh) {
        [self setWatchedDataWithUid:self.thisUid];
    }
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initLocalData];
    
    [self initViews];
    
    [self initNotifications];
    
    [self addFooter];
    
}

- (void)initLocalData
{
    self.watchedArray = [NSMutableArray array];
}

- (void)initViews
{
    self.title = [NSString stringWithFormat:@"%@的关注",self.selfTitle?self.selfTitle:@"我"];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, view.frame.size.width - 30, 20)];
    self.numberLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    _numberLabel.font = kFont14;
    [view addSubview:self.numberLabel];
    
    self.watchTableView.tableHeaderView = view;
    self.watchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [vc.watchTableView addFooterWithCallback:^{
        [vc setWatchedDataWithUid:vc.thisUid];
    }];
}

- (void)initNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadWatchTableView:) name:@"cancelLikeNotification" object:nil];
}

- (void)reloadWatchTableView:(NSNotification *)sender{
    NSString *str = sender.object;
    for (NSDictionary *dic in self.watchedArray) {
        if ([dic[@"id"] isEqualToString:str]) {
            [self.watchedArray removeObject:dic];
            break;
        }
    }
    [self.watchTableView reloadData];
}

- (void)setWatchedDataWithUid:(NSString *)uid
{    
    if (uid) {
        self.thisUid = uid;
        
        NSDictionary *params = [AFParamFormat formatFollowListParams:uid index:[NSString stringWithFormat:@"%d",self.currentIndex]];
        
        [AFNetwork getFollowList:params  success:^(id data){
            if ([data[@"status"] integerValue] == kRight) {
                NSArray *dataArr = data[@"data"];
                _total = [data[@"total"] integerValue];
                self.numberLabel.text =[NSString stringWithFormat:@"全部关注(%@):",[NSNumber numberWithInteger:_total]];
                if (dataArr.count==0) {
                    if (self.currentIndex == 0){
                        self.numberLabel.text =[NSString stringWithFormat:@"暂无关注"];
                        _numberLabel.textAlignment = NSTextAlignmentCenter;
                    }
                }
                else
                {
                    if (self.currentIndex == 0) {
                        self.watchedArray = dataArr.mutableCopy;
                        
                    }
                    else{
                        [self.watchedArray addObjectsFromArray:dataArr.mutableCopy];
                    }
                    self.currentIndex = [data[@"lastindex"] intValue];
                    
                    [self.watchTableView reloadData];
                    
                }
            } else if([data[@"status"] integerValue] == kReLogin){
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                self.numberLabel.text =[NSString stringWithFormat:@"请重新登录"];
                _numberLabel.textAlignment = NSTextAlignmentCenter;
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
          [self.watchTableView footerEndRefreshing];
        }failed:^(NSError *error){
            
        }];
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
    
}

- (void)processData:(NSArray *)array
{
    [self.watchedArray removeAllObjects];
    
    for (int i=0;i<array.count;i++)
    {
        NSDictionary *diction = array[i];
        NSString *name = [NSString stringWithFormat:@"%@",diction[@"nickname"]];
        NSString *sex = [NSString stringWithFormat:@"%@",diction[@"sex"]];
        NSString *head_pic = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
        if ([sex isEqualToString:@"1"]) {
            sex = @"男";
        }else
        {
            sex = @"女";
        }
        NSDictionary *resultDic = @{@"name":name,@"info":sex,@"url":head_pic};
        [self.watchedArray addObject:resultDic];
    }
    [self.watchTableView reloadData];
}

#pragma mark - IBAction


//tableview


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.watchedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"WatchedTableViewCell";
    WatchedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [WatchedTableViewCell getWatchedCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    NSDictionary *diction = self.watchedArray[indexPath.row];

    NSString *name = [NSString stringWithFormat:@"%@",diction[@"nickname"]];
    NSString *sex = [NSString stringWithFormat:@"%@",diction[@"sex"]];
    NSString *head_pic = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
    if ([sex isEqualToString:@"1"]) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    NSString *relationship = [NSString stringWithFormat:@"%@",diction[@"relationship"]];
    if ([relationship isEqualToString:@"1"]) {
        cell.choseImageView.image = [UIImage imageNamed:@"icon006-r11.png"];
    }else
    {
        cell.choseImageView.image = [UIImage imageNamed:@"icon006-r12.png"];
    }
    cell.nameLabel.text = name?name:@"";
    cell.infoLabel.text = sex?sex:@"";
    
    NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
    NSString *url = [NSString stringWithFormat:@"%@%@",head_pic,jpg];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    cell.choseImageView.frame = CGRectMake(kScreenWidth-45, 21, 29, 28);
    cell.headerImageView.layer.cornerRadius = 3;
    cell.headerImageView.clipsToBounds = YES;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"取消关注";
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.isAllowDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *diction = self.watchedArray[indexPath.row];
        
        [self.watchedArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        NSString *targetUid = [NSString stringWithFormat:@"%@",diction[@"id"]];
        NSDictionary *params = [AFParamFormat formatFollowParams:uid toUid:targetUid];
        [AFNetwork followCancel:params  success:^(id data){
            if ([data[@"status"] integerValue] == kRight) {
                [LeafNotification showInController:self withText:[NSString stringWithFormat:@"%@",@"取消关注成功"]];
                
            }else if([data[@"status"] integerValue] == kReLogin){
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
        }failed:^(NSError *error){
            
        }];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *diction = self.watchedArray[indexPath.row];
    self.isNeedToRefresh = YES;
    
    NSString *userName = diction[@"nickname"];
    NSString *uid = diction[@"id"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
