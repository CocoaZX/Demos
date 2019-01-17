//
//  McMainModelViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/10.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McMainModelViewController.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "PhotoViewDetailController.h"
#import "MokaActivityDetailViewController.h"
#import "UIImageView+AFNetworking.h"

#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"
#import "MJRefresh.h"
#import "TJAdressView.h"
#import "McModelCollectionViewCell.h"
#import "McWebViewController.h"
#import "BrowseAlbumPhotosController.h"
#import "TaoXiViewController.h"

@interface McMainModelViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,EAIntroDelegate,SGFocusImageFrameDelegate,UIScrollViewDelegate>

//集合视图当前的位置
@property (nonatomic,assign)float lastOffY;

@property (nonatomic,strong) SGFocusImageFrame *bannerView;
@property (nonatomic,strong) TJAdressView *adressView;

@property (assign, nonatomic) BOOL isFirstLoad;

@end


@implementation McMainModelViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];

    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    //设置单元格大小
    flowLayout.itemSize = CGSizeMake((kDeviceWidth - 4)/3,(kDeviceWidth - 4)/3);
    flowLayout.sectionInset = UIEdgeInsetsMake(2,0,0,0);//3
    //是header与cell的间隔
    flowLayout.minimumInteritemSpacing =2;
    flowLayout.minimumLineSpacing = 2;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight -kTabBarHeight) collectionViewLayout:flowLayout];

    //注册单元格和并设置代理
    //单元格标识
    NSString  *McMainCollectionCellIdentifier = @"MainCollectionViewCell";
    //头视图标识
    NSString *McCollectionViewHeaderCellIdentifier = @"HeaderCell";
    
    [_collectionView registerClass:[McModelCollectionViewCell class] forCellWithReuseIdentifier:McMainCollectionCellIdentifier];
    
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:McCollectionViewHeaderCellIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator =NO;
    _collectionView.alwaysBounceVertical = YES;//为了下拉刷新，一定要YES
    _collectionView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_collectionView];
    
    self.isFirstLoad = YES;
    
    //添加刷新视图
    [self performSelector:@selector(addHeader) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(addFooter) withObject:nil afterDelay:0.1];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetModelView) name:@"reloadDataWithPosition" object:nil];

    
    //设置请求的个数
    _pageSize = 30;

    [self addAdressView];
}


-(void)addAdressView{
    
    [self.view addSubview:self.adressView];
    [self.view bringSubviewToFront:self.adressView];
    
}
-(TJAdressView *)adressView{
    if (!_adressView) {
        _adressView = [[TJAdressView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kTabBarHeight-kNavHeight)];
        _adressView.superVC = self;
    }
    return _adressView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [self.bannerView addVideoNotification];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.bannerView stopVideo];
}


#pragma mark 视图刷新
//添加底部刷新视图
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [_collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestHomeUserWithLastIndex:vc.lastIndex];
    }];
}

//添加顶部刷新视图
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [_collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"0";
        [vc requestRecommendIndex];
        
    }];
    
    [_collectionView headerBeginRefreshing];
    
    
}


//加载头部视图
- (void)loadHeaderView
{
    if(_headerView == nil){
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, _imageScrollViewHeight)];
    }
    
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:[_imageURLs count]+2];
    for (int i = 0; i < [_imageURLs count]; i++)
    {
        NSDictionary *dict = [_imageURLs objectAtIndex:i];//zhuyi
        
        NSInteger wid = (NSInteger)CGRectGetWidth(self.view.frame) * 2;
        NSInteger hei = (NSInteger)_imageScrollViewHeight * 2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei postfix:YES];
        NSString *url = [NSString stringWithFormat:@"%@%@",dict[@"pic"],jpg];
        
        SGFocusImageItem *item = [[SGFocusImageItem alloc] initWithTitle:dict[@"title"] image:url tag:i];
        NSString *typeString = getSafeString(dict[@"object_type"]);
        if ([typeString isEqualToString:@"11"]) {
            item.videoURL = getSafeString(dict[@"video_url"]);
        }else
        {
            item.videoURL = @"";
        }
        [itemArray addObject:item];
        
    }
    NSArray *headSubViews = [_headerView subviews];
    for (UIView *view in headSubViews) {
        [view removeFromSuperview];
    }
    
    _bannerView = [[SGFocusImageFrame alloc] initWithFrame:_headerView.bounds delegate:self imageItems:itemArray isFirst:self.isFirstLoad];
    //下拉加载新数据时回到第一个轮滑图片
    [_bannerView scrollToIndex:0];
    [_headerView addSubview:_bannerView];

    self.isFirstLoad = NO;
}

-(void)resetModelView{
    
    [self requestRecommendIndex];
    _lastIndex = @"0";
    
}

#pragma mark SGFocusImageFrameDelegate
- (void)foucusImageFrame:(SGFocusImageFrame *)imageFrame didSelectItem:(SGFocusImageItem *)item
{
    //NSLog(@"FocusImageFrame:%@",[_imageURLs objectAtIndex:item.tag]);
    NSDictionary *dataDict = [_imageURLs objectAtIndex:item.tag];
    NSInteger jumpType = [dataDict[@"category"] integerValue];
    
    switch (jumpType) {
        case 1://个人
            if ([dataDict[@"category"] integerValue] == 1) {
                NSDictionary *imageDict = dataDict[@"user"];
                NSString *userName = getSafeString(imageDict[@"nickname"]);
                NSString *uid = getSafeString(imageDict[@"id"]);
                
                NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
                newMyPage.currentTitle = userName;
                newMyPage.currentUid = uid;
                
                UserDefaultSetBool(NO, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];
                [self.superNVC pushViewController:newMyPage animated:YES];
            }

            break;
        case 2://活动
        {
             //活动ID
            MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
            mokaDetailVC.eventId = getSafeString(dataDict[@"jump"]);
            
            [self.superNVC pushViewController:mokaDetailVC animated:YES];
        }
            
            break;
        case 3://网页
        {
            NSString *webURL = [dataDict objectForKey:@"jump"];
            if (webURL.length == 0) {
                return;
            }
            NSString *uid = @"";
            NSString *tempUid =[[USER_DEFAULT valueForKey:MOKA_USER_VALUE]valueForKey:@"id"];
            uid = tempUid ? tempUid : @"";
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
                [self.superNVC pushViewController:webVC animated:YES];
            }
        }
            break;
        case 4://照片详情
        {
            NSString *photoId = getSafeString(dataDict[@"jump"]);
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:photoId uid:@""];
            [self.superNVC pushViewController:detailVc animated:YES];

        }
            //跳视频详情
//            - (void)requestWithVideoId:(NSString *)vid uid:(NSString *)uid
            break;
            
        case 5://调用Safari打开网页
        {
            NSString *webURL = [dataDict objectForKey:@"jump"];
            if (webURL.length != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
        }
            break;
        case 6://相册
        {
            NSString *albumID = getSafeString(dataDict[@"jump"]);
            BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
            browsePhotoVC.albumID = albumID;
            [self.superNVC  pushViewController:browsePhotoVC animated:YES];
        }
            break;
        case 7://专题
        {
            NSString *albumID = getSafeString(dataDict[@"jump"]);
            TaoXiViewController *taoxiVC = [[TaoXiViewController alloc]init];
            taoxiVC.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            NSDictionary *dict = @{@"albumId":albumID};
            taoxiVC.isHomePage = YES;
            taoxiVC.dic = dict;
            //处理数据
            [self.superNVC pushViewController:taoxiVC animated:YES];
        }
            break;
        default:
            break;
    }

}




#pragma mark 请求数据
//请求轮滑图片数据
- (void)requestRecommendIndex
{
    
    NSDictionary *params = [AFParamFormat formatGetRecommendIndexParams:@{}];
    [AFNetwork recommentIndex:params success:^(id data){
        
        
        [self getImageURLs:data];
        
    }failed:^(NSError *error){
        // 加载数据失败，1秒后调用
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 结束刷新
            [_collectionView headerEndRefreshing];
        });
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
}


- (void)getImageURLs:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        
        NSArray * values = data[@"data"];
        if ([values count] > 0) {
            [_imageURLs removeAllObjects];
            NSMutableArray *arr = [NSMutableArray arrayWithCapacity:[values count] + 2];
            [arr addObject:[values lastObject]];
            [arr addObjectsFromArray:values];
            [arr addObject:[values firstObject]];
            _imageURLs = arr;

            
            [self loadHeaderView];
            [_collectionView reloadData];
            
        }
    }
    
    [self requestHomeUserWithLastIndex:_lastIndex];
    
    // 结束刷新
    if ([_collectionView isHeaderRefreshing]) {
        [_collectionView headerEndRefreshing];
    }
    
}


//请求集合视图的图片资料
- (void)requestHomeUserWithLastIndex:(NSString *)lastIndex
{
    
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"currentPosition.plist"];
    NSDictionary *positionDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
    //    uid  longitude latitude  lastindex  pagesize
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    if (uid) {
        [dict setValue:uid forKey:@"uid"];
    }
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lng = Longitude;
    [dict setValue:[NSNumber numberWithDouble:lat] forKey:@"latitude"];
    [dict setValue:[NSNumber numberWithDouble:lng]  forKey:@"longitude"];
    [dict setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"pagesize"];
    [dict setValue:getSafeString(lastIndex)  forKey:@"lastindex"];
    
    [dict setValue:getSafeString(positionDict[@"provinceID"]) forKey:@"province"];
    [dict setValue:getSafeString(positionDict[@"cityID"]) forKey:@"city"];

    NSLog(@"%@",positionDict);
    //增加参数：区分请求数据：全部，模特，摄影师
    [dict setValue:[NSNumber numberWithInt:1] forKey:@"type"];
    NSDictionary *params = [AFParamFormat formatGetMainUserIndexParams:dict];
    [AFNetwork mainUserIndex:params success:^(id data){
        [self getPhotoUserUrlArray:data];
    }failed:^(NSError *error){
        
    }];
    
}

- (void)getPhotoUserUrlArray:(id)data
{
    
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *arr = data[@"data"];
        if ([arr count] > 0) {
            
            if([_lastIndex isEqualToString:@"0"]){
                [_photoURLs removeAllObjects];
                [_photoURLs addObjectsFromArray:arr];
                
            }else{
                [_photoURLs addObjectsFromArray:arr];
                
            }

            self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            NSDictionary *dict = @{@"cityname":getSafeString(data[@"selectedCity"])};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"resetAdrBtnString" object:dict];
            
            if (IOS7) {
                [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
                
            }else
            {
               [_collectionView reloadData];
            }
        }else{

            

        }
        
       
    }
    // 结束刷新
    if ([_collectionView isFooterRefreshing]) {
        [_collectionView footerEndRefreshing];
    }
}




#pragma mark UICollectionViewDelegate UICollectionViewDataSource
//返回单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_photoURLs count];
}

//返回单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString  *McMainCollectionCellIdentifier = @"MainCollectionViewCell";
    McModelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:McMainCollectionCellIdentifier forIndexPath:indexPath];
     if (_photoURLs.count > indexPath.row) {
        NSDictionary *imageDict = [_photoURLs objectAtIndex:indexPath.row];
        NSInteger wid = (NSInteger)(CGRectGetWidth(self.view.frame)/3)*2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:wid];
        NSString *url = [NSString stringWithFormat:@"%@%@",imageDict[@"head_pic"],jpg];
        cell.imageUrlString = url;
         
         [cell initWithDictionaryForMainModel:imageDict];
//        cell.superNVC = self.superNVC;
         
    }
     return cell;
}


//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {kDeviceWidth,_imageScrollViewHeight};//+5
    return size;
}


//返回头视图，类似headerView和FootView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *McCollectionViewHeaderCellIdentifier = @"HeaderCell";
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:McCollectionViewHeaderCellIdentifier forIndexPath:indexPath];
    
    [reusableView addSubview:_headerView];
    return reusableView;
}


//选中单元格
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //安全判断
    if (_photoURLs.count > indexPath.row) {
        NSDictionary *imageDict = [_photoURLs objectAtIndex:indexPath.row];
        NSString *object_type = getSafeString(imageDict[@"object_type"]);
        //视频跳转
        if ([object_type isEqualToString:@"11"]) {
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithVideoId:imageDict[@"photoid"] uid:imageDict[@"id"]];
            detailVc.isFromTimeLine = YES;
           [self.superNVC pushViewController:detailVc animated:YES];
            return;
        }
        [self handClickWith:imageDict];
      }
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_photoURLs.count == indexPath.row + 12) {
        [self requestHomeUserWithLastIndex:_lastIndex];
    }
}




#pragma mark - 各类型点击处理
- (void)handClickWith:(NSDictionary *)dataDic{
    NSInteger categoryNum = [getSafeString(dataDic[@"category"]) integerValue];
    if (categoryNum == 0) {
        categoryNum = 1;
    }
    switch (categoryNum) {
        case 1://个人主页
        {
            NSString *userName = getSafeString(dataDic[@"nickname"]);
            NSString *uid = getSafeString(dataDic[@"id"]);
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            [self.superNVC  pushViewController:newMyPage animated:YES];
            break;
        }
        case 2://活动
        {
            MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
            mokaDetailVC.eventId = getSafeString(dataDic[@"jump"]);
            [self.superNVC pushViewController:mokaDetailVC animated:YES];
            break;
        }
        case 3://网页跳转
        {
            NSString *webURL = [dataDic objectForKey:@"jump"];
            if (webURL.length == 0) {
                return;
            }
            NSRange webRange = [webURL rangeOfString:@"?"];
            if (getCurrentUid()) {
                if (webRange.length != 0) {
                    webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"&uid/%@",getCurrentUid()]];
                }else{
                    if (getCurrentUid().length) {
                        webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"?uid/%@",getCurrentUid()]];
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
                [self.superNVC pushViewController:webVC animated:YES];
            }
            break;
        }
        case 4: //图片详情跳转
        {
            NSString *photoId = getSafeString(dataDic[@"jump"]);
            if(photoId.length == 0){
                photoId = getSafeString(dataDic[@"photoid"]);
            }
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:photoId uid:@""];
            [self.superNVC pushViewController:detailVc animated:YES];
            break;
        }
        case 5://浏览器跳转
        {
            NSString *webURL = getSafeString([dataDic objectForKey:@"jump"]) ;
            if (webURL.length != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
            break;
        }
        case 6:
        {
            NSString *albumID = getSafeString(dataDic[@"jump"]);
            BrowseAlbumPhotosController *browsePhotoVC = [[BrowseAlbumPhotosController alloc] init];
            browsePhotoVC.albumID = albumID;
            [self.superNVC  pushViewController:browsePhotoVC animated:YES];
            break;
        }
        case 7:
        {
            NSString *albumID = getSafeString(dataDic[@"jump"]);
            TaoXiViewController *taoxiVC = [[TaoXiViewController alloc]init];
            taoxiVC.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            NSDictionary *dict = @{@"albumId":albumID};
            taoxiVC.isHomePage = YES;
            taoxiVC.dic = dict;
            //处理数据
            [self.superNVC pushViewController:taoxiVC animated:YES];
            break;
        }
        default:{
 
        }
            break;
    }

}





#pragma mark scrollViewDelegate


//滑动隐藏导航栏和状态栏
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if(velocity.y>0)
    {
        //隐藏状态栏
        UIApplication *application =[UIApplication sharedApplication];
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
        //隐藏导航栏
        [self.superNVC setNavigationBarHidden:YES animated:YES];
        //隐藏tabbar
        //[self.superNVC.customTabBarController hidesTabBar:YES animated:YES];
        _collectionView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -kTabBarHeight);
    }else
    {
        UIApplication *application =[UIApplication sharedApplication];
        [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        //显示导航栏
        [self.superNVC setNavigationBarHidden:NO animated:YES];
        //tabbar
        //[self.superNVC.customTabBarController hidesTabBar:NO animated:YES];
        _collectionView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight -kTabBarHeight);
    }
}
 


-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}



@end
