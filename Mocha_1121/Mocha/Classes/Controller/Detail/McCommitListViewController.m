//
//  McCommitListViewController.m
//  Mocha
//
//  Created by renningning on 14-11-24.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McCommitListViewController.h"
#import "McListTableViewCell.h"
#import "PhotoViewDetailController.h"

#import "MJRefresh.h"

@interface McCommitListViewController ()
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, retain) NSString *lastIndex;

@end

@implementation McCommitListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"Comment", nil);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _listArray = [NSMutableArray arrayWithCapacity:0];
    self.lastIndex = @"0";
    
    [self addHeader];
    [self addFooter];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark add
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        [vc requestGetCommitList];
    }];
    [self.tableView headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addFooterWithCallback:^{
        [vc requestGetCommitList];
    }];
}

#pragma mark Request
- (void)requestGetCommitList
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:_lastIndex forKey:@"lastindex"];
    [dict setValue:@"2" forKey:@"commentType"];
    NSDictionary *param = [AFParamFormat formatGetCommentListParams:dict];
    [AFNetwork getCommentsMyList:param success:^(id data){
        [self getCommitsListDone:data];
    }failed:^(NSError *error){
        [self endRefreshing];
    }];
}

- (void)getCommitsListDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *arr = data[@"data"];
        
        if ([arr count] > 0) {
            if ([_lastIndex isEqualToString:@"0"]) {
                [self.listArray removeAllObjects];
                self.listArray = [NSMutableArray arrayWithArray:arr];
            }
            else{
                [self.listArray addObjectsFromArray:arr];
            }
            
            _lastIndex = [NSString stringWithFormat:@"%@",[_listArray lastObject][@"id"]];
            [self.tableView reloadData];
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
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
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
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dict = [_listArray objectAtIndex:indexPath.row];
    
    [cell setItemValueWithDict:dict];
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
    
    return [cell getContentViewHeightWithDict:dict];
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
    view.text = @"暂无评论";
    
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
    [photoDetailVC requestWithPhotoId:dict[@"photoid"] uid:dict[@"uid"]];
    photoDetailVC.isFromTimeLine = YES;
    [self.navigationController pushViewController:photoDetailVC animated:YES];
}

@end
