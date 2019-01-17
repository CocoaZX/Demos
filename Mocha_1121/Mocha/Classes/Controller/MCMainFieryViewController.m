//
//  MCMainFieryViewController.m
//  Mocha
//
//  Created by TanJian on 16/5/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCMainFieryViewController.h"
#import "MJRefresh.h"
#import "MCMainFieryHeaderView.h"
#import "MCMainFierySectionHeaderView.h"
#import "recommendCell.h"


#define kScaleW    kDeviceWidth/375
#define kScaleH    kDeviceHeight/667

@interface MCMainFieryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray *recommendArr;
@property(nonatomic,strong)NSMutableArray *hotPersonsArr;
@property(nonatomic,strong)MCMainFieryHeaderView *headView;

@end

@implementation MCMainFieryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight - kTabBarHeight) style:UITableViewStyleGrouped];

    _tableView.backgroundColor = [UIColor redColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:_tableView];
    
    //添加刷新视图
    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(addFooter) withObject:nil afterDelay:0.1];
    
    
}


-(void)addTableViewHeader{
    
    float headerH = 79+(kDeviceWidth-65)/3+kDeviceWidth/75*32;
    
    _headView = [[MCMainFieryHeaderView alloc]init];
    _headView.frame = CGRectMake(0, 0, kDeviceWidth, headerH);
    _headView.superVC = self;
    
    self.tableView.tableHeaderView = _headView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark 视图刷新
//添加底部刷新视图
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [_tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestData];
    }];
}

//添加顶部刷新视图
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        [vc requestData];
        
    }];
    
    [_tableView headerBeginRefreshing];
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

#pragma mark  请求网络数据
-(void)requestData{
    
    NSDictionary *dict = @{@"lastindex":_lastIndex};
    NSDictionary *params = [AFParamFormat formatGetRecommendIndexParams:dict];
    
    [AFNetwork getRequeatData:params path:PathHomeFiery success:^(id data){
        
        [self requestDone:data];
    }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];

}

- (void)requestDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        
        NSDictionary *dataArr = data[@"data"];
        NSArray *modelArr = dataArr[@"mota"];
        NSArray *cameramanArr = dataArr[@"cameraman"];
        
        [self.recommendArr removeAllObjects];
        [_recommendArr addObjectsFromArray:modelArr];
        [_recommendArr addObjectsFromArray:cameramanArr];
       
        NSArray *listArr = dataArr[@"hotList"];
        
        if ([listArr count] > 0) {
            
            if ([_lastIndex isEqualToString:@"0"]) {
                
                //添加tableview头视图
                [self addTableViewHeader];
                //头视图数据赋值,第一次加载才有
                [_headView setupUIWithData:self.recommendArr];

                self.hotPersonsArr = [NSMutableArray arrayWithArray:listArr];
            }
            else{
                [self.hotPersonsArr addObjectsFromArray:listArr];
            }
            
            _lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            
            [self.tableView reloadData];
        }else {
            
            [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
        }
        
    }else{
        [LeafNotification showInController:self.customTabBarController withText:data[@"msg"]];
    }
    
    [self endRefreshing];
}


#pragma mark tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.hotPersonsArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib中某些控件是根据宽高比例设置的，计算后如下
    return [recommendCell getHeight];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    recommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"recommendCell" bundle:nil] forCellReuseIdentifier:@"recommendCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"recommendCell"];
    }
    cell.superVC = self;
    
    if (_hotPersonsArr.count>indexPath.row) {
        [cell setupUIWithDict:_hotPersonsArr[indexPath.row]];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //跳转个人主页
    NSDictionary *dict = _hotPersonsArr[indexPath.row];
    
    NSString *uid = getSafeString(dict[@"uid"]);
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentUid = uid;
    
    [self.customTabBarController hidesTabBar:YES animated:NO];
    [self.superNVC pushViewController:newMyPage animated:YES];
    
}


//高人气推荐相关
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_hotPersonsArr.count>0) {
        return 32*kScaleW;
    }else{
        return 0;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MCMainFierySectionHeaderView *headerView = [[MCMainFierySectionHeaderView alloc]init];
    NSDictionary *advdict = [USER_DEFAULT objectForKey:@"hot_adv"];
    headerView.headerLabel.text = getSafeString(advdict[@"title"]);
    
    
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}



#pragma mark 懒加载
-(NSMutableArray *)recommendArr{
    if (!_recommendArr) {
        _recommendArr = [NSMutableArray array];
    }
    return _recommendArr;
}

-(NSMutableArray *)hotPersonsArr{
    if (!_hotPersonsArr) {
        _hotPersonsArr = [NSMutableArray array];
    }
    return _hotPersonsArr;
}


@end

