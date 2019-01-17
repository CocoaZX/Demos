//
//  MokaActivityListViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaActivityListViewController.h"
#import "MokaReleaseActivityViewController.h"
#import "MokaActivityDetailViewController.h"
#import "ActivityListViewCell.h"
#import "MJRefresh.h"
#import "WJDropdownMenu.h"
#import "ReadPlistFile.h"
#import "GuideView.h"
#import "McWebViewController.h"

@interface MokaActivityListViewController ()<WJMenuDelegate>{
    
}
//请求数据相关============
//数据
@property (nonatomic,strong)NSMutableArray *dataSource;
//上次请求数据
@property (nonatomic,copy)NSString *lastIndex;
//请求活动列表，服务器返回信息
@property (nonatomic,copy)NSString *alertMessage;
//从服务器端获取得status,决定用户是否能够发布活动
@property (nonatomic,assign)NSInteger status;

//视图布局相关============
//集合视图单元格的宽度
@property (nonatomic,assign)CGFloat cellWidth;
//集合视图单元格高度
@property (nonatomic,assign)CGFloat cellHeight;
//顶部视图的高度
@property(nonatomic,assign)CGFloat chooseViewHeight;

@property(nonatomic,strong)NSMutableArray *areaArray;
@property(nonatomic,strong)NSMutableArray *cityArray;
//索引
@property(nonatomic,assign)NSInteger typeIndex;
@property(nonatomic,assign)NSInteger areaIndex;
@property(nonatomic,assign)NSInteger cityIndex;



//顶部按钮
@property (nonatomic,strong)UIButton *rightButton;
//筛选视图
@property(nonatomic,strong)UIView *chooseView;
@property(nonatomic,strong)UIButton *typeBtn;
@property(nonatomic,strong)UIButton *addressBtn;
//信息提醒视图
@property(nonatomic,strong)UILabel *infoLabel;
//顶部选择视图
@property(nonatomic,strong)WJDropdownMenu *dropDownMenu;
@end

@implementation MokaActivityListViewController


#pragma  mark - 视图生命周期及加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.title = NSLocalizedString(@"activities", nil);

    [self _initViews];
    
    self.navigationItem.leftBarButtonItem = nil;
    
}

- (void)dealloc{
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customTabBarController hidesTabBar:NO animated:NO];
    self.navigationController.navigationBarHidden = NO;
    _rightButton.userInteractionEnabled = YES;
    
    //添加功能引导视图_发现活动
    BOOL show = [GuideView needShowGuidViewWithGuideViewType:MokaGuideViewFindActivity];
    if (show) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        [guideView showGuidViewWithConditionType:MokaGuideViewFindActivity];
    }

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
}



//初始化视图
- (void)_initViews{
    //默认不可以发布
    _status = -1;
    //顶部选择视图的高度
    _chooseViewHeight = 40;
    //数据源
    _dataSource = [NSMutableArray array];
    
    //读取配置数据
    [self getLoctionInformation];
    
    //导航栏
     _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    NSString *titleStr = NSLocalizedString(@"release", nil);
    if ([titleStr isEqualToString:@"发布"]) {
        _rightButton.frame = CGRectMake(0, 0, 30, 30);
    }
    [_rightButton setTitle:titleStr forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(publishMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    
    //集合视图
    _cellWidth = (kDeviceWidth -55)/2;
    _cellHeight = _cellWidth +75;
    [self.view addSubview:self.collectionView];
    
    //筛选视图
    //[self.view addSubview:self.chooseView];
    [self.view addSubview:self.dropDownMenu];
    [self createAllMenuData];

    //无数据提醒
    [self.view addSubview:self.infoLabel];
    
    //刷新视图的操作
    [self addHeader];
    [self addFooter];
    
}



#pragma mark - 加载数据
- (void)addHeader
{
    __weak typeof(self) vc = self;
    [_collectionView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        [vc requestGetEventList];
        
    }];
    [self.collectionView headerBeginRefreshing];
}
- (void)addFooter
{
    __weak typeof(self) vc = self;
    [_collectionView addFooterWithCallback:^{
        [vc requestGetEventList];
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

- (void)requestGetEventList
{
    
    if ([self.collectionView isHeaderRefreshing]) {
        [self.collectionView headerEndRefreshing ];
    }
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    //活动类型
    NSString *type;
    if (_typeIndex == 0) {
        type = [NSString stringWithFormat:@"%ld",(long)_typeIndex];
    }else{
        type = [NSString stringWithFormat:@"%@",@(_typeIndex+3)];
    }
    [dict setObject:type forKey:@"type"];

    //活动城市
    if (_areaIndex == 0) {
        [dict setObject:@"0" forKey:@"province"];
        [dict setObject:@"0" forKey:@"city"];
    }else{
        NSDictionary *provinceDic = _areaArray[_areaIndex-1];
        //城市数组
        NSArray *cityNames = _cityArray[_areaIndex -1];
        if (cityNames.count >0) {
            NSDictionary *cityDic = _cityArray[_areaIndex-1][_cityIndex];
            [dict setObject:cityDic[@"id"] forKey:@"city"];

        }else{
            //香港，澳门
            [dict setObject:@"0" forKey:@"city"];
        }
        
        [dict setObject:provinceDic[@"id"] forKey:@"province"];
        
        NSLog(@"省：%@",provinceDic[@"name"]);
        //NSLog(@"市：%@",cityDic[@"name"]);
    }
    
    [dict setObject:@"" forKey:@"sex"];
    [dict setObject:@"" forKey:@"user_type"];
    [dict setObject:@"20" forKey:@"pagesize"];
    [dict setObject:@"" forKey:@"payment"];
    [dict setObject:@"" forKey:@"order"];
    
    [dict setValue:self.lastIndex forKey:@"lastindex"];

    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork eventGetList:param success:^(id data){
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshing];
        });
        if ([data[@"status"] integerValue] == kRight) {
            id diction = data[@"createEnable"];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = data[@"createEnable"];
                _alertMessage = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                _status = [[NSString stringWithFormat:@"%@",dic[@"status"]] integerValue];
            }
            
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if ([self.lastIndex isEqualToString:@"0"]) {
                    _dataSource = [NSMutableArray arrayWithArray:arr];
                 }else
                {
                    [_dataSource addObjectsFromArray:arr];
                }
                
               self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                //_dataSource = @[].mutableCopy;
                [_collectionView reloadData];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView reloadData];
                });
            }else{
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                 }
             }
            
        }else if([data[@"status"] integerValue] == kReLogin){
            
            NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
            if (message.length>0) {
                [LeafNotification showInController:self withText:message];
             }
        }
        
        //[self.view bringSubviewToFront:self.infoLabel];
        if (self.dataSource.count >0) {
            self.infoLabel.hidden = YES;
        }else{
            self.infoLabel.hidden = NO;
            [self.view insertSubview:self.infoLabel belowSubview:self.dropDownMenu];
        }
//        _collectionView.contentInset = UIEdgeInsetsMake(10,20, 10, 20);
      }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self
                                  withText:@"当前网络不太顺畅哟"];

     }];
}



//地区信息
-(void)getLoctionInformation{
     //读取地区信息
    _areaArray = (NSMutableArray *)[ReadPlistFile readAreaArray];
    _cityArray = [NSMutableArray array];
    
    @try {
        for (NSDictionary *dic in _areaArray) {
            NSMutableArray *citysMutArr = [NSMutableArray array];
            //每个省份之后都加上了不限
            NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [mutDic setObject:@"0" forKey:@"id"];
            [mutDic setObject:@"不限" forKey:@"name"];
            [citysMutArr addObject:mutDic];
            
            //去除城市列表中的“其他”
            NSMutableArray *tempCityArr = [NSMutableArray arrayWithArray:dic[@"citys"]];
            for (NSDictionary *cityInfoDic in tempCityArr) {
                if ([cityInfoDic[@"name"] isEqualToString:@"其他"]) {
                    [tempCityArr removeObject:cityInfoDic];
                }
            }
            
            [citysMutArr addObjectsFromArray:tempCityArr
             ];

            
            if ([dic[@"name"] isEqualToString:@"澳门" ]
                ||[dic[@"name"] isEqualToString:@"香港"]){
                //香港和澳门做特殊处理
                citysMutArr = @[].copy;
            }

            [_cityArray addObject:citysMutArr];
        }
     }
    
    @catch (NSException *exception) {
        NSLog(@"%@",exception.name);
    }
    @finally {
        
    }
}



#pragma mark - 集合视图：UICollectionViewDelegate
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
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *activityDic = self.dataSource[indexPath.row];
//    
//    NSString *jumpType = getSafeString(activityDic[@"type"]);
//    NSInteger jumpTypeNum = [jumpType integerValue];
//    switch (jumpTypeNum) {
//        case 3:
//        {//web
//            McWebViewController *webVC = [[McWebViewController alloc] init];
//            webVC.webUrlString = getSafeString(activityDic[@"url"]);
//             webVC.needAppear = YES;
//            UserDefaultSetBool(NO, @"isHiddenTabbar");
//            [USER_DEFAULT synchronize];
//            //进入网页
//            [self.navigationController pushViewController:webVC animated:YES];
//            break;
//        }
//        case 7:
//        {//safari
//            NSString *webURL =getSafeString([activityDic objectForKey:@"url"]) ;
//            if (webURL.length != 0) {
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
//            }
//            break;
//        }
//
//        default:{
//            MokaActivityDetailViewController *activityDetailVC = [[MokaActivityDetailViewController alloc] init];
//            
//            activityDetailVC.eventId = getSafeString(self.dataSource[indexPath.row][@"id"]);
//            
//            //判断当前活动类型
//            NSString *type = getSafeString(self.dataSource[indexPath.row][@"type"]);
//            if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
//                activityDetailVC.vcTitle = @"通告详情";
//            }else if([type isEqualToString:@"5"]){
//                activityDetailVC.vcTitle = @"众筹活动";
//            }else if([type isEqualToString:@"6"]){
//                activityDetailVC.vcTitle = @"活动海报";
//            }
//            [self.navigationController pushViewController:activityDetailVC animated:YES];
//            break;
//        }
//    }
//    
//
//
//}
//
//- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
//    if (_dataSource.count == indexPath.row + 12) {
//        [self requestGetEventList];
//    }
//}


#pragma mark - 得到索引
- (void)menuCellDidSelected:(NSInteger)MenuTitleIndex firstIndex:(NSInteger)firstIndex andSecondIndex:(NSInteger)secondIndex{
    if (MenuTitleIndex == 0) {
        //选择了类型
        _typeIndex = firstIndex;
        
    }else{
        //选择了地址
        _areaIndex = firstIndex;
        _cityIndex = secondIndex;
    }
    //选择之后，使用筛选的信息请求新数据
     //NSLog(@"广场搜索条件_类型:%ld",(long)_typeIndex);
     //NSLog(@"广场搜索条件_地区:%ld_%ld",(long)_areaIndex,(long)_cityIndex);
    //清空数据重新请求数据
     self.lastIndex = @"0";
    [self requestGetEventList];
}



#pragma mark - 事件处理
//发布活动
- (void)publishMethod
{
    if ([self isFailForCheckLogInStatus]) {
        return;
    }
    
    MokaReleaseActivityViewController *releaseActivityVC = [[MokaReleaseActivityViewController alloc] init];
    releaseActivityVC.superNVC = self.navigationController;
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    [self.navigationController pushViewController:releaseActivityVC animated:YES];
}



//跳转登陆界面
- (void)appearLoginView
{
    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
}


//顶部视图选择
- (void)chooseActivityBtnClick:(UIButton *)btn{
    if (btn.tag == 101) {
        _typeBtn.selected = YES;
        _addressBtn.selected = NO;
    }else{
        _typeBtn.selected = NO;
        _addressBtn.selected = YES;
    }
}






#pragma mark - set/get方法
- (WJDropdownMenu *)dropDownMenu{
    if (_dropDownMenu == nil) {
        _dropDownMenu = [[WJDropdownMenu alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, _chooseViewHeight)];
        //设置代理
        _dropDownMenu.delegate = self;
        
        //增加了遮盖层动画时间设置   不设置默认是  0.15
         _dropDownMenu.caverAnimationTime = 0.5;
        
        //设置menuTitle字体大小    不设置默认是  11
        _dropDownMenu.menuTitleFont = 15;
        
        //设置tableTitle字体大小   不设置默认是  10
        _dropDownMenu.tableTitleFont = 15;
        
        //设置tableViewcell高度   不设置默认是  40
        _dropDownMenu.cellHeight = 50;
        
        //旋转箭头的样式(空心箭头 or 实心箭头)
        _dropDownMenu.menuArrowStyle = menuArrowStyleSolid;
        
        //tableView的最大高度(超过此高度就可以滑动显示)
        _dropDownMenu.tableViewMaxHeight = kDeviceHeight -kNavHeight - _chooseViewHeight -150;
        
        //menu定义了一个tag值如果与本页面的其他button的值有冲突重合可以自定义设置
        _dropDownMenu.menuButtonTag = 100;
        
        //设置遮罩层颜色
        _dropDownMenu.CarverViewColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
    }
    return _dropDownMenu;
}



- (void)createAllMenuData{
    
    NSString *typeStr = NSLocalizedString(@"activity.type", nil);
    NSString *locationStr = NSLocalizedString(@"activity.location", nil);
    
    NSArray *twoMenuTitleArray =  @[typeStr,locationStr];
    //创建第一个菜单的数据
    NSString *allType = NSLocalizedString(@"allType", nil);
    NSString *announcement = NSLocalizedString(@"announcement", nil);
    NSString *crowdfunding = NSLocalizedString(@"Crowdfunding", nil);
    NSString *poster = NSLocalizedString(@"Poster", nil);
    
    NSArray *firstArrOne = [NSArray arrayWithObjects:allType,announcement,crowdfunding,poster,nil];
    NSArray *firstMenu = [NSArray arrayWithObject:firstArrOne];

    //创建第二个菜单的第一组数据
    NSMutableArray *firstArrTwo = [NSMutableArray array];
    [firstArrTwo addObject:@"不限"];
    for (int i = 0; i<_areaArray.count; i++) {
        [firstArrTwo  addObject:_areaArray[i][@"name"]];
    }
    
    //创建第二个菜单的第二组数据
    NSMutableArray *secondArrTwo = [NSMutableArray array];
    //省份选择是不限时，对应空数组
    [secondArrTwo addObject:@[]];
    
    for (int i = 0; i<_cityArray.count; i++) {
        NSMutableArray *cityNames = [NSMutableArray array];
        NSArray *currentCityArr = _cityArray[i];
        for ( int j = 0; j<currentCityArr.count; j++) {
            [cityNames addObject:currentCityArr[j][@"name"]];
        }
        [secondArrTwo addObject:cityNames];
    }
    
    
   // NSArray *secondArrTwo = @[@[@"C二级菜单11",@"C二级菜单12"],@[@"C二级菜单21",@"C二级菜单22",@"C二级菜单23",@"C二级菜单24"]];
    NSArray *SecondMenu = [NSArray arrayWithObjects:firstArrTwo,secondArrTwo, nil];
    //创建具有两个选项的菜单
    [self.dropDownMenu createTwoMenuTitleArray:twoMenuTitleArray FirstArr:firstMenu SecondArr:SecondMenu];
}



- (UIView *)chooseView{
    //顶部视图高度
     if (_chooseView == nil) {
        _chooseView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, kDeviceWidth, _chooseViewHeight)];
         //选择类型
        _typeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth/2-1,_chooseViewHeight)];
         _typeBtn.tag = 101;
         [_typeBtn setTitle:@"类型" forState:UIControlStateNormal];
         [_typeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [_typeBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateSelected];
         [_typeBtn addTarget:self action:@selector(chooseActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_chooseView addSubview:_typeBtn];
         
         //中间线
         UIView *centerLineView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth/2, 10, 1, _chooseViewHeight -10*2)];
         centerLineView.backgroundColor = [UIColor lightGrayColor];
         [_chooseView addSubview:centerLineView];
         
         //选择地址
         _addressBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/2+1, 0, kDeviceWidth/2,_chooseViewHeight)];
         _addressBtn.tag = 102;
         [_addressBtn setTitle:@"位置" forState:UIControlStateNormal];
         [_addressBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
         [_addressBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateSelected];
         [_addressBtn addTarget:self action:@selector(chooseActivityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
         [_chooseView addSubview:_addressBtn];
         
         //底部线条
         UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _chooseViewHeight -1,kDeviceWidth,1)];
         bottomView.backgroundColor = [UIColor lightGrayColor];
         [_chooseView addSubview:bottomView];
    }
    
    return _chooseView;
}



//集合视图
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(_cellWidth,_cellHeight );
        flowLayout.minimumInteritemSpacing = 10;
        flowLayout.minimumLineSpacing = 10;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _chooseViewHeight, kDeviceWidth, kDeviceHeight -kNavHeight -kTabBarHeight -_chooseViewHeight) collectionViewLayout:flowLayout];
        _collectionView.alwaysBounceVertical = YES;
        //注册单元格
        NSString  *cellIdentifier = @"collectionViewCellID";
        [_collectionView registerClass:[ActivityListViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        //设置代理
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //滑动
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


- (UILabel *)infoLabel{
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kDeviceHeight/2, kDeviceWidth, 50)];
        _infoLabel.text = @"没有任何活动哦!";
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
        _infoLabel.hidden = YES;
        
    }
    return _infoLabel;
}



@end
