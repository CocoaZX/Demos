//
//  MyDaShangListViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/31.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "MyDaShangListViewController.h"
#import "McListTableViewCell.h"
#import "PhotoViewDetailController.h"
#import "GoodsForPhotoDetailCell.h"

#import "MJRefresh.h"
@interface MyDaShangListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, retain) NSString *lastIndex;


@end

@implementation MyDaShangListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"MyGift", nil);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    self.lastIndex = @"0";
    
    [self addHeader];
    [self addFooter];
    
}

#pragma mark add
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.mainTableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        [vc requestGetCommitList];
    }];
    [self.mainTableView headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.mainTableView addFooterWithCallback:^{
        [vc requestGetCommitList];
    }];
}

#pragma mark Request
- (void)requestGetCommitList
{
    NSDictionary *diction = [AFParamFormat formatTempleteParams:@{@"lastindex":_lastIndex}];
    //原有的获取打赏列表信息请求
//    [AFNetwork getShangMyList:diction success:^(id data){
//        [self getCommitsListDone:data];
//    }failed:^(NSError *error){
//        [self endRefreshing];
//    }];
    [AFNetwork getVGoodsMyList:diction success:^(id data) {
        NSLog(@"%@",data);
        [self getCommitsListDone:data];
    } failed:^(NSError *error) {
        [self endRefreshing];
    }];
}



- (void)getCommitsListDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *arr = data[@"data"];
        NSLog(@"%@",data);
        if ([arr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                [self.listArray removeAllObjects];
                self.listArray = [NSMutableArray arrayWithArray:arr];
            }
            else{
                [self.listArray addObjectsFromArray:arr];
            }
            
            _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            [self.mainTableView reloadData];
        }
        
    }
    else if([data[@"status"] integerValue] == kReLogin){
        [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT synchronize];
        [self.navigationController popViewControllerAnimated:YES];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
    
    [self endRefreshing];
    
}



- (void)endRefreshing
{
    if ([self.mainTableView isHeaderRefreshing]) {
        [self.mainTableView headerEndRefreshing];
    }
    if ([self.mainTableView isFooterRefreshing]) {
        [self.mainTableView footerEndRefreshing];
    }
}


#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"ListTableCell%@",[NSNumber numberWithInteger:indexPath.row]];
    McListTableViewCell *cell = (McListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[McListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    
    [cell setItemValueWithDict_shang:dict];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"ListTableCell%@",[NSNumber numberWithInteger:indexPath.row]];
    McListTableViewCell *cell = (McListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[McListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    return [cell getContentViewHeightWithDict_shang:dict];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *view = [[UILabel alloc] init];
    if (_listArray.count <= 0) {
        [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    }
    else{
        [view setFrame:CGRectMake(0, 0, self.view.frame.size.width, 0)];
    }
    view.textAlignment = NSTextAlignmentCenter;
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = [UIColor lightGrayColor];
    view.text = @"暂无打赏记录";
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (_listArray.count <= 0){
        return 40.0;
    }
    return 0.0;
}

//UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    PhotoViewDetailController *photoDetailVC = [[PhotoViewDetailController alloc] init];
    NSLog(@"%@",dict);
    if ([dict[@"from_object_type"] isEqualToString:@"11"]) {
        [photoDetailVC requestWithVideoId:dict[@"objectData"][@"id"] uid:dict[@"uid"]];
    }else{
        [photoDetailVC requestWithPhotoId:dict[@"objectData"][@"id"] uid:dict[@"uid"]];
    }
    photoDetailVC.isFromTimeLine = YES;
    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

@end
