//
//  MokaMyActivityListViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/2/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaMyActivityListViewController.h"
#import "MokaActivityDetailViewController.h"
#import "ActivityListViewCell.h"
#import "McWebViewController.h"
#import "MJRefresh.h"


@interface MokaMyActivityListViewController ()

//视图布局相关=================
//集合视图单元格的宽度
@property (nonatomic,assign)CGFloat cellWidth;
//集合视图单元格高度
@property (nonatomic,assign)CGFloat cellHeight;

//请求数据相关================
//上次请求数据
@property (nonatomic,copy)NSString *lastIndex;
//数据
@property (nonatomic,strong)NSMutableArray *dataSource;
//一次请求数据的个数
@property (nonatomic,copy)NSString *pageSize;
//弹出的信息
@property (nonatomic,copy)NSString *alertMessage;

//无数据提示视图==============
@property (strong, nonatomic) UILabel *numberLabel;
@property (strong, nonatomic) UIView *zanwuView;

@end

@implementation MokaMyActivityListViewController


#pragma  mark - 视图的设置
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    if([_activityType isEqualToString:@"myPublishActivityListVc"]){
        _isMyPublishAT = YES;
    }else{
        _isMyPublishAT = NO;
    }
    _pageSize = @"10";
    _dataSource = [NSMutableArray array];
    
    //初始化视图
    [self _initViews];
    
}



//初始化视图
- (void)_initViews{
    //集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _cellWidth = (kDeviceWidth -55)/2;
    _cellHeight = _cellWidth +75;
    flowLayout.itemSize = CGSizeMake(_cellWidth,_cellHeight );
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -kNavHeight) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.alwaysBounceVertical = YES;
    
    //注册单元格
    NSString  *cellIdentifier = @"collectionViewCellID";
    [_collectionView registerClass:[ActivityListViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    //显示无数据提示
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, view.frame.size.width - 30, 20)];
    self.numberLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = kFont14;
    [view addSubview:self.numberLabel];
    self.zanwuView = view;
    self.zanwuView.hidden = YES;
    [self.view addSubview:self.zanwuView];

    //刷新视图的操作
    [self addHeader];
    [self addFooter];
    
}


#pragma mark - 数据下拉刷新设置
- (void)addHeader
{
    __weak typeof(self) vc = self;
    [_collectionView addHeaderWithCallback:^{
        //下拉重新加载数据
        vc.lastIndex = @"0";
         if ([vc.activityType isEqualToString:@"myPublishActivityListVc"]) {
            [vc requestPublishedActivity];
        }else{
            [vc requestBaoMingActivity];
        }
        
    }];
    [self.collectionView headerBeginRefreshing];
}


- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.collectionView addFooterWithCallback:^{
        //vc.lastIndex = @"0";
        if ([vc.activityType isEqualToString:@"myPublishActivityListVc"]) {
            [vc requestPublishedActivity];
        }else{
            [vc requestBaoMingActivity];
        }
    }];
}


- (void)endRefreshing
{
    if ([self.collectionView isHeaderRefreshing]) {
        [self.collectionView headerEndRefreshing];
    }
    if ([self.collectionView isFooterRefreshing]) {
        [self.collectionView footerEndRefreshing];
    }
}

#pragma mark - 请求数据
//自己发布活动
- (void)requestPublishedActivity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:_pageSize forKey:@"pagesize"];
    [dict setValue:_lastIndex forKey:@"lastindex"];
    NSDictionary *param = [AFParamFormat formatEventListParams_own:dict];
    [AFNetwork eventMyRelease:param success:^(id data){
        [self endRefreshing];
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                //已经存在数据，先清空再保存
                if([_lastIndex isEqualToString:@"0"]){
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:arr];
                }else{
                    [_dataSource addObjectsFromArray:arr];
                }
                //
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            }else{
                if ([_dataSource count] >0) {
                    self.zanwuView.hidden = YES;
                }else{
                    self.zanwuView.hidden = NO;
                    self.numberLabel.text = @"暂无已发布活动";
                }
                
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                }
            }
            [self.collectionView reloadData];
            
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}

//自己参加的活动
- (void)requestBaoMingActivity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    [dict setValue:_pageSize forKey:@"pagesize"];
    [dict setValue:_lastIndex forKey:@"lastindex"];

    NSDictionary *param = [AFParamFormat formatEventListParams_own:dict];
    [AFNetwork eventUserSignUp:param success:^(id data){
        [self endRefreshing];
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if([_lastIndex isEqualToString:@"0"]){
                    [_dataSource removeAllObjects];
                    [_dataSource addObjectsFromArray:arr];
                }else{
                    [_dataSource addObjectsFromArray:arr];
                }
                //
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            }else{
                if ([_dataSource count] >0) {
                    self.zanwuView.hidden = YES;
                }else{
                    self.zanwuView.hidden = NO;
                    self.numberLabel.text = @"暂无已发布活动";
                }
                
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                }
            }
            [self.collectionView reloadData];
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}



//- (void)requestGetEventList
//{
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
//    [dict setObject:@"" forKey:@"city"];
//    [dict setObject:@"" forKey:@"sex"];
//    [dict setObject:@"" forKey:@"province"];
//    [dict setObject:@"" forKey:@"user_type"];
//    [dict setObject:@"20" forKey:@"pagesize"];
//    [dict setObject:@"" forKey:@"payment"];
//    [dict setObject:@"" forKey:@"order"];
//    
//    if (self.isSendOrderIndex) {
//        [dict setValue:self.lastIndex forKey:@"orderindex"];
//        
//    }else
//    {
//        [dict setValue:self.lastIndex forKey:@"lastindex"];
//        
//    }
//    
//    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
//    [AFNetwork eventGetList:param success:^(id data){
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self endRefreshing];
//        });
//        if ([data[@"status"] integerValue] == kRight) {
//            id diction = data[@"createEnable"];
//            if ([diction isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *dic = data[@"createEnable"];
//                _alertMessage = [NSString stringWithFormat:@"%@",dic[@"msg"]];
//             }
//            
//            NSArray *arr = data[@"data"];
//            //            for(int i = 0;i<arr.count;i++){
//            //                NSDictionary *dic = arr[i];
//            //                NSLog(@"@%@-->%@",dic[@"id"], dic[@"img"]);
//            //            }
//            if ([arr count] > 0) {
//                if ([self.lastIndex isEqualToString:@"0"]) {
//                    _dataSource = [NSMutableArray arrayWithArray:arr];
//                }else
//                {
//                    [_dataSource addObjectsFromArray:arr];
//                }
//                
//                if (data[@"lastindex"]) {
//                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
//                    // self.isSendOrderIndex = NO;
//                    
//                }else
//                {
//                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"orderindex"]];
//                    //self.isSendOrderIndex = YES;
//                }
//                [_collectionView reloadData];
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self.collectionView reloadData];
//                });
//            }else{
//                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
//                if (message.length>0) {
//                    [LeafNotification showInController:self withText:message];
//                }
//            }
//            
//        }else if([data[@"status"] integerValue] == kReLogin){
//            
//            NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
//            if (message.length>0) {
//                [LeafNotification showInController:self withText:message];
//            }
//        }
//    }failed:^(NSError *error){
//        [self endRefreshing];
//        [LeafNotification showInController:self
//                                  withText:@"当前网络不太顺畅哟"];
//    }];
//}



#pragma mark 集合视图：UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString  *cellIdentifier = @"collectionViewCellID";
    ActivityListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.superNVC = self.navigationController;
    NSDictionary *dic = _dataSource[indexPath.row];
    cell.dataDic = dic;
    return cell;
}


//返回单元格大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return  CGSizeMake(_cellWidth, _cellHeight);
}


//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10,20, 10, 20);
}

//活动详情界面
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *activityDic = self.dataSource[indexPath.row];
    
    NSString *jumpType = getSafeString(activityDic[@"type"]);
    NSInteger jumpTypeNum = [jumpType integerValue];
    switch (jumpTypeNum) {
        case 3:
        {//web
            McWebViewController *webVC = [[McWebViewController alloc] init];
            webVC.webUrlString = getSafeString(activityDic[@"url"]);
            webVC.needAppear = YES;
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            //进入网页
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 7:
        {//safari
            NSString *webURL =getSafeString([activityDic objectForKey:@"url"]) ;
            if (webURL.length != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
            break;
        }
            
        default:{
            MokaActivityDetailViewController *activityDetailVC = [[MokaActivityDetailViewController alloc] init];
            
            activityDetailVC.eventId = getSafeString(self.dataSource[indexPath.row][@"id"]);
            
            //判断当前活动类型
            NSString *type = getSafeString(self.dataSource[indexPath.row][@"type"]);
            if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
                activityDetailVC.vcTitle = @"通告详情";
                activityDetailVC.typeNum  = 1;

            }else if([type isEqualToString:@"5"]){
                activityDetailVC.vcTitle = @"众筹活动";
                activityDetailVC.typeNum = 2;

            }else if([type isEqualToString:@"6"]){
                activityDetailVC.vcTitle = @"活动海报";
                activityDetailVC.typeNum = 3;

            }
            [self.superNVC pushViewController:activityDetailVC animated:YES];
            break;
        }
    }
}


@end
