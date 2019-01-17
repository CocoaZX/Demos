//
//  YuEMingXiViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/20.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuEMingXiViewController.h"
#import "MingXiTableViewCell.h"
#import "MJRefresh.h"


@interface YuEMingXiViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, retain) NSString *lastIndex;
@property (strong, nonatomic) UILabel *footerView;

@end

@implementation YuEMingXiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = @[].mutableCopy;
    self.lastIndex = @"0";
    
    [self addHeader];
    [self addFooter];
//    [self getServiceData];
}

- (UIView *)footerView
{
    if (!_footerView) {
        _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        _footerView.text = @"暂无数据";
        _footerView.textColor = [UIColor lightGrayColor];
        _footerView.textAlignment = NSTextAlignmentCenter;
        _footerView.font = [UIFont systemFontOfSize:16];
    }
    return _footerView;
}

#pragma mark add
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.mainTableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        [vc getServiceData];
    }];
    [self.mainTableView headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.mainTableView addFooterWithCallback:^{
        [vc getServiceData];
    }];
}

- (void)getServiceData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *type = @"";
    if ([self.title isEqualToString:NSLocalizedString(@"goldDetail", nil)]) {
        type = @"3";
    }else if([self.title isEqualToString:NSLocalizedString(@"balancesDetail", nil)]){
        type = @"1";
    }
    NSLog(@"%@",type);
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid,@"type":type,@"lastindex":_lastIndex}];
    [AFNetwork postRequeatDataParams:params path:PathUserWalletAccountLogs success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshing];
        NSLog(@"%@",params);
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if ([_lastIndex isEqualToString:@"0"]) {
                    [self.dataArray removeAllObjects];
                    self.dataArray = [NSMutableArray arrayWithArray:arr];
                }
                else{
                    [self.dataArray addObjectsFromArray:arr];
                }
                
                _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                [self.mainTableView reloadData];
            }
            
            if (self.dataArray.count==0) {
                
                self.mainTableView.tableFooterView = self.footerView;

            }else
            {
                self.mainTableView.tableFooterView = [[UIView alloc] init];
                
            }
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self endRefreshing];

        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];        
    }];
    
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

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MingXiTableViewCell *cell = nil;
    NSString *identifier = @"MingXiTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MingXiTableViewCell getMingXiTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.moneyLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    NSDictionary *diction = self.dataArray[indexPath.row];
    NSString *titleStr = [NSString stringWithFormat:@"%@",diction[@"description"]];
    NSString *timeStr = [NSString stringWithFormat:@"%@",diction[@"create_time"]];
    NSString *income = [NSString stringWithFormat:@"%@",diction[@"income"]];
    NSString *moneyStr = @"";
    if ([self.title isEqualToString:NSLocalizedString(@"goldDetail", nil)]) {
        moneyStr = [NSString stringWithFormat:@"+%@",diction[@"coin"]];
        if ([income isEqualToString:@"0"]) {
            cell.moneyLabel.textColor = RGB(54, 156, 36);
            moneyStr = [NSString stringWithFormat:@"-%@",diction[@"coin"]];
        }

    }else if([self.title isEqualToString:NSLocalizedString(@"balancesDetail", nil)]){
        moneyStr = [NSString stringWithFormat:@"+%@",diction[@"money"]];
        if ([income isEqualToString:@"0"]) {
            cell.moneyLabel.textColor = RGB(54, 156, 36);
            
            moneyStr = [NSString stringWithFormat:@"-%@",diction[@"money"]];
        }
    }
    
    
    
    
    cell.titleLabel.text = titleStr;
    cell.timeLabel.text = timeStr;
    cell.moneyLabel.text = moneyStr;
    
    
    return cell;
}


@end
