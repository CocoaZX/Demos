//
//  MCFieryListController.m
//  Mocha
//
//  Created by TanJian on 16/5/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCFieryListController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MJRefresh.h"
#import "UIScrollView+MJRefresh.h"
#import "McWebViewController.h"
#import "FieryListSectionView.h"
#import "FieryListCell.h"
#import "MokaActivityDetailViewController.h"
#import "PhotoViewDetailController.h"


#define kScale  kDeviceWidth/375

@interface MCFieryListController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)NSMutableArray *listArray;
@property (nonatomic,copy)NSString *lastIndex;
@property (nonatomic,copy)NSString *searchType;
@property (nonatomic,strong)NSDictionary *popularTopDict;

@end

@implementation MCFieryListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.customTabBarController hidesTabBar:NO animated:NO];
    self.tableView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    _lastIndex = @"0";
    _searchType = @"2";
    _listArray = [NSMutableArray arrayWithCapacity:0];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight -kTabBarHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:_tableView];
    
    NSDictionary *popularTop = [USER_DEFAULT objectForKey:@"popularity_top"];
    self.title = getSafeString(popularTop[@"title"])? getSafeString(popularTop[@"title"]) :@"排名榜";
    self.navigationController.navigationBar.titleTextAttributes =@{NSForegroundColorAttributeName:[UIColor colorForHex:kLikeBlackTextColor]};
    
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 45, 30)];
    [setBtn setTitle:@"分享" forState:UIControlStateNormal];
    setBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [setBtn setTitleColor:[UIColor colorForHex:kLikeBlackTextColor] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doShareAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    //若需要分享榜单则打开
//    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self addHeader];
    [self addFooter];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(swapType:) name:@"swapFieryListType" object:nil];
}

-(void)doShareAction{
    NSLog(@"分享红人榜");
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.superVC.customTabBarController hidesTabBar:NO animated:NO];
}


-(void)swapType:(NSNotification *)notifi{
    NSDictionary *dict = notifi.object;
    NSString *type = getSafeString(dict[@"type"]);
    
    if (![type isEqualToString:_searchType]) {
        _searchType = type;
        _lastIndex = @"0";
        [self requestGetList];
    }
    
}



-(void)addTableViewHeader{
    
    UIImageView *headerImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 140*kScale)];
    headerImg.image = [UIImage imageNamed:@"defaultImage"];
    
    NSDictionary *popularTop = [USER_DEFAULT objectForKey:@"popularity_top"];

    if (popularTop) {
        
        _popularTopDict = popularTop;
        NSString *urlStr = getSafeString(popularTop[@"url"]);
        NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,[CommonUtils imageStringWithWidth:headerImg.width * 2 height:headerImg.height * 2]];
        [headerImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        
        UITapGestureRecognizer *recognazer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpForBanner)];
        [headerImg addGestureRecognizer:recognazer];
        headerImg.userInteractionEnabled = YES;
        
        _tableView.tableHeaderView = headerImg;
        
    }
    
}


-(void)jumpForBanner{
    
    NSInteger jumpType = [getSafeString(_popularTopDict[@"type"]) integerValue];
    
    switch (jumpType) {
        case 1://个人
            if (jumpType == 1) {
                
                NSString *uid = getSafeString(_popularTopDict[@"jump"]);
                
                NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
                
                newMyPage.currentUid = uid;
                UserDefaultSetBool(NO, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];
                [self.navigationController pushViewController:newMyPage animated:YES];
            }
            
            break;
        case 2://活动
        {
            //活动ID
            MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
            mokaDetailVC.eventId = getSafeString(_popularTopDict[@"jump"]);
            
            [self.navigationController pushViewController:mokaDetailVC animated:YES];
        }
            
            break;
        case 3://网页
        {
            NSString *uid = @"";
            NSString *tempUid =[[USER_DEFAULT valueForKey:MOKA_USER_VALUE]valueForKey:@"id"];
            uid = tempUid ? tempUid : @"";
            NSString *webURL = getSafeString(_popularTopDict[@"jump"]);
            NSRange webRange = [webURL rangeOfString:@"?"];
            if (uid) {
                if (webRange.length != 0) {
                    webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"&uid/%@",uid]];
                }else{
                    
                    if (uid.length) {
                        webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"?uid/%@",uid]];
                    }
                }
            }

            if (webURL.length) {
                McWebViewController *webVC = [[McWebViewController alloc] init];
                webVC.webUrlString = webURL;
                
                webVC.needAppear = YES;
                UserDefaultSetBool(NO, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];
                //进入网页
                [self.navigationController pushViewController:webVC animated:YES];
            }
        }
            break;
        case 4://照片详情
        {
            NSString *photoId = getSafeString(_popularTopDict[@"jump"]);
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:photoId uid:@""];
            [self.navigationController pushViewController:detailVc animated:YES];
            
        }
            //跳视频详情
            //            - (void)requestWithVideoId:(NSString *)vid uid:(NSString *)uid
            break;
            
        case 5://调用Safari打开网页
        {
            NSString *webURL = getSafeString(_popularTopDict[@"jump"]);
            if (webURL.length != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
        }
            break;
            
        default:
            break;
    }
    
    //跳转信息在字典中
        
        
    

    
    
}


#pragma mark 视图刷新
//添加底部刷新视图
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [_tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestGetList];
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
        [vc requestGetList];
        
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




#pragma mark 请求数据
//请求轮滑图片数据
- (void)requestGetList
{
    //pagesize lastindex - int
    NSDictionary *params = [AFParamFormat formatGetRecommendIndexParams:@{@"currentPage":_lastIndex,@"pageSize":@"15",@"searchtype":_searchType,@"userType":_listType}];
    
   [AFNetwork getRequeatData:params path:PathFieryFeeds success:^(id data){
       
        [self requestDone:data];
    }failed:^(NSError *error){
        [self endRefreshing];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

- (void)requestDone:(id)data
{
    [self addTableViewHeader];
    if ([data[@"status"] integerValue] == kRight) {
        
        NSArray *dataArr = data[@"data"];
        if ([dataArr count] > 0) {
            
            if ([_lastIndex isEqualToString:@"0"]) {
                _listArray = [NSMutableArray arrayWithArray:dataArr];
            }
            else{
                [_listArray addObjectsFromArray:dataArr];
            }
            
            _lastIndex = [NSString stringWithFormat:@"%@",getSafeString(data[@"nextPage"])];
            
            [self.tableView reloadData];
        }
        else {
            [LeafNotification showInController:self.customTabBarController withText:@"已无更多"];
        }
    }
    
    [self endRefreshing];
}


#pragma mark tableview代理
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _listArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib中某些控件是根据宽高比例设置的，计算后如下
    return 80*kScale;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    FieryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FieryListCell"];
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FieryListCell" bundle:nil] forCellReuseIdentifier:@"FieryListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FieryListCell"];
    }

    if (_listArray.count > indexPath.row) {
        [cell setupUIWithDict:_listArray[indexPath.row] withTypeStr:_searchType];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转个人主页
    NSDictionary *dict = _listArray[indexPath.row];
    
    NSString *uid = getSafeString(dict[@"uid"]);
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentUid = uid;
    
    [self.customTabBarController hidesTabBar:YES animated:NO];
    [self.navigationController pushViewController:newMyPage animated:YES];
    
}

//sectionHeader相关
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_listArray.count > 0) {
        return 44*kScale;
    }else{
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    FieryListSectionView *sectionView = [[FieryListSectionView alloc]init];
    
    NSString *title = getSafeString(_popularTopDict[@"title"]);
    if (title.length > 0) {
        
    }
    
    [sectionView diselectedWithType:_searchType];
    
    return sectionView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    return view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
