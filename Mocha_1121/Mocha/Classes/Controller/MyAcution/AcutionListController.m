//
//  AcutionListController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionListController.h"
#import "MJRefresh.h"
#import "AcutionTableCell.h"
#import "AcutionPublisherCheckController.h"
#import "AcutionJoinDetailController.h"
#import "AcutionPublishSuccessController.h"
@interface AcutionListController ()<UITableViewDataSource,UITableViewDelegate>


@property(nonatomic,strong)UIView *zanWuView;

@property(nonatomic,assign)BOOL isMyPublish;

@property(nonatomic,copy)NSString *pageSize;
@property(nonatomic,copy)NSString *lastIndex;
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation AcutionListController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞拍详情";
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //区别两种视图
    if([_acutionType isEqualToString:@"publish"]){
        _isMyPublish = YES;
    }else{
        _isMyPublish = NO;
    }
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.zanWuView];
     self.zanWuView.hidden = YES;
    
    _pageSize= @"10";
    //初始化视图
    [self _initViews];
}

 //初始化视图
- (void)_initViews{
    
    [self addHeader];
    [self addFooter];
}



#pragma mark - 数据下拉刷新设置
- (void)addHeader
{
    __weak typeof(self) vc = self;
    [_tableView addHeaderWithCallback:^{
        //下拉重新加载数据
        vc.lastIndex = @"0";
        if (vc.isMyPublish) {
            [vc requestAcutionList];
        }else{
            [vc requestAcutionList];
        }
    }];
    [self.tableView headerBeginRefreshing];
}


- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addFooterWithCallback:^{
        //vc.lastIndex = @"0";
        if (vc.isMyPublish) {
            [vc requestAcutionList];
        }else{
            [vc requestAcutionList];
        }
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

#pragma mark - 获取数据

- (void)requestAcutionList{
    if(!getCurrentUid()){
        return;
    }
    NSString *type = @"";
    if (_isMyPublish) {
        type = @"0";
    }else{
        type = @"1";
    }
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"type":type,@"lastindex":_lastIndex}];
    
    [AFNetwork postRequeatDataParams:params path:PathPostForAuctionList success:^(id data) {
        [self endRefreshing];
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                //已经存在数据，先清空再保存
                if([_lastIndex isEqualToString:@"0"]){
                    [self.dataSource removeAllObjects];
                    [self.dataSource addObjectsFromArray:arr];
                }else{
                    [self.dataSource addObjectsFromArray:arr];
                }
                //保存索引
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            }else{
                if ([self.dataSource count] >0) {
                    self.zanWuView.hidden = YES;
                }else{
                    self.zanWuView.hidden = NO;
                }
                
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                }
            }
            [self.tableView reloadData];
            
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    } failed:^(NSError *error) {
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}


//自己发布活动
- (void)requestPublishedAcution{
    
}

//自己参加的活动
- (void)requestJoinAcution
{
    
}

#pragma mark UITableViewDelegate
//返回组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_isMyPublish) {
        return self.dataSource.count;
    }
    return self.dataSource.count;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"AcutionCell";
    AcutionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [AcutionTableCell getAcutionTableCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
    cell.dataDic = self.dataSource[indexPath.row];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //取出当前的竞拍信息
    NSDictionary *acutioninfoDic = self.dataSource[indexPath.row];
    //选中单元格
    if(_isMyPublish){
        //发布者
        //竞拍优胜，待使用，进入使用详情
        AcutionPublisherCheckController *publishVc = [[AcutionPublisherCheckController alloc] initWithNibName:@"AcutionPublisherCheckController" bundle:nil];
        publishVc.acutionDic = acutioninfoDic;
        [self.superVC.navigationController pushViewController:publishVc animated:YES];
     }else{
        //参与者
        NSString *code = getSafeString(acutioninfoDic[@"code"]) ;
         NSString *optionCode = getSafeString(acutioninfoDic[@"opCode"]);
        //判断验证码
        if (code && code.length>0) {
            //进入发送竞拍码的界面
            AcutionJoinDetailController *joinVC = [[AcutionJoinDetailController alloc] initWithNibName:@"AcutionJoinDetailController" bundle:nil];
            joinVC.acutionDic = acutioninfoDic;
            [self.superVC.navigationController pushViewController:joinVC animated:YES];
        }else if(optionCode && [optionCode isEqualToString:@"3"]){
            //进入竞拍成功的界面
            AcutionPublishSuccessController *vc = [[AcutionPublishSuccessController alloc] initWithNibName:@"AcutionPublishSuccessController" bundle:nil];
            vc.acutionDic = acutioninfoDic;
            [self.superVC.navigationController pushViewController:vc animated:YES];
         }

    }
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 155;
}

#pragma mark - set/get方法
- (UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView  alloc] initWithFrame:CGRectMake(30, 0, kDeviceWidth- 30 *2, kDeviceHeight-kNavHeight -60) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}


- (UIView *)zanWuView{
    if (_zanWuView == nil) {
        //显示无数据提示
        _zanWuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
        _zanWuView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
        
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, _zanWuView.frame.size.width - 30, 20)];
        if(_isMyPublish){
            numberLabel.text = @"暂无已发布竞拍信息";
        }else{
            numberLabel.text = @"暂无已参加竞拍信息";
        }
        numberLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        numberLabel.textAlignment = NSTextAlignmentCenter;
        numberLabel.font = kFont14;
        [_zanWuView addSubview:numberLabel];
        _zanWuView.hidden = YES;
    }
    return _zanWuView;
}


- (NSMutableArray *)dataSource{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
