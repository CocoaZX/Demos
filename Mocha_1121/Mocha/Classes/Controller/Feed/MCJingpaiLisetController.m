//
//  MCJingpaiLisetController.m
//  Mocha
//
//  Created by TanJian on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiLisetController.h"
#import "UIScrollView+MJRefresh.h"
#import "headerForDetailVCFirstSection.h"
#import "DetailVCJingpaiCell.h"

@interface MCJingpaiLisetController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong)MCJingpaiDetailModel *model;

@property (nonatomic, strong) NSMutableArray *jingpaiListArray;
@property (nonatomic, strong) UILabel *headerLabel;
@property (nonatomic, strong) NSString *lastIndex;

@end

@implementation MCJingpaiLisetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"竞拍列表";
    self.lastIndex = @"";
    self.mainTableView.tableFooterView = [[UIView alloc] init];

    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
    
    [self getJingpaiList];
    [self addHeader];
    
}

#pragma mark private

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.mainTableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"";
        [self getJingpaiList];
        
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


#pragma mark 网络请求方法
- (void)getJingpaiList{
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"auctionId":self.auctionID}];
    
    [AFNetwork getAuctionInfo:params path:PathForAuctionInfo success:^(id data) {
        
        NSDictionary *dict = data[@"data"];
        if ([data[@"status"] integerValue] == kRight) {
            
            MCJingpaiDetailModel *model = [[MCJingpaiDetailModel alloc]initWithDictionary:dict error:nil];
            self.model = model;
            
        }else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        [self.mainTableView reloadData];
        [self endRefreshing];
    } failed:^(NSError *error) {
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅"];
    }];
    
    
}



#pragma mark tableView代理

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.auctors.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailVCJingpaiCell *cell = [[DetailVCJingpaiCell alloc]init];
    cell.superVC = self;
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setupUI:self.model.auctors[indexPath.row]];
    
    if (indexPath.row == 0) {
        cell.profitLabel.hidden = YES;
    }else{
        cell.winImageView.hidden = YES;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    headerForDetailVCFirstSection *view = [[headerForDetailVCFirstSection alloc]init];
    view.frame = CGRectMake(0,0 , kDeviceWidth, 44);
    view.checkAllButton.hidden = YES;
    view.backgroundColor = [UIColor whiteColor];
    [view setupUI:self.model];
    
    return view;
}

@end
