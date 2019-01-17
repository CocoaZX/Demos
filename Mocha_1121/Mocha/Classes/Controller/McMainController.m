//
//  McMainController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/10.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McMainController.h"

#import "McMainPhotographerViewController.h"
#import "McMainModelViewController.h"
#import "McNearByPersonViewController.h"
#import "MCMainFieryViewController.h"
#import "McMainNewPhotoGraghController.h"
#import "McSeachViewController.h"
#import "McSiXinSettingViewController.h"
#import "TJAdressView.h"
#import "ReadPlistFile.h"
#import "EAIntroPage.h"
#import "EAIntroView.h"
#import "GuideView.h"
//显示广告页的视图
#import "DrawAdView.h"
//网页
#import "McWebViewController.h"


@interface McMainController ()<EAIntroDelegate>

@property (nonatomic, assign) NSInteger seletedIndex;
@property (strong, nonatomic) UISegmentedControl *segControl;
//两个子视图控制器
//显示模特
@property (nonatomic,strong)McMainModelViewController *mainModelVC;
//显示摄影师
@property (nonatomic,strong)McMainPhotographerViewController *mainPhotographerVC;

@property (nonatomic,strong)McMainNewPhotoGraghController *newmainPhotographerVC;
//显示附近
@property (nonatomic,strong)McNearByPersonViewController *mainNearByVC;
//火爆推荐视图
@property (nonatomic,strong)MCMainFieryViewController *mainRecommendVC;
//视图显示顺序的控制数组
@property (nonatomic,strong)NSMutableArray *typeArr;

//显示引导图
@property (nonatomic,strong)UIWindow *guideWindow;
//显示广告图
@property (nonatomic,strong)UIWindow *advertisementWindow;
//定时器,定时让广告页消失
@property (nonatomic,strong)NSTimer *timer;
//定时器，等待广告页加载
@property (nonatomic,strong)NSTimer *waitLoadAdTimer;

//显示服务器提醒
@property (nonatomic,strong)UIWindow *notificationWindow;

@property (nonatomic, strong) EAIntroView *intro;

@property (nonatomic, strong) TJAdressView *adressView;
@property (nonatomic,assign) BOOL hasAdress;


@end

@implementation McMainController
#pragma mark 视图的加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //分段控制器
    BOOL nearHome = UserDefaultGetBool(ConfigNearHome);
    NSDictionary *typeDic = [USER_DEFAULT objectForKey:@"lang_description"];
//    NSString *camStr = @"摄影师";
//    NSString *modelStr = @"模特";
//    NSString *nearStr = @"红榜";
//
//    if (typeDic) {
//        camStr = typeDic[@"tab_camer"];
//        modelStr = typeDic[@"tab_mote"];
//        nearStr = typeDic[@"tab_near"];
//        
//    }
    
    
    NSArray *homeBarArr = typeDic[@"home_bar"];
    NSMutableArray *titleArr = [NSMutableArray array];
    _typeArr = [NSMutableArray array];
    NSLog(@"%@",homeBarArr);
    if (homeBarArr.count>0) {
        for (int i = 0; i<homeBarArr.count; i++) {
            NSDictionary *tempDict = homeBarArr[i];
            
            [titleArr addObject:getSafeString(tempDict[@"name"])];
            [_typeArr addObject:getSafeString(tempDict[@"type"])];
            
        }
        
    }else{
        
        [titleArr addObjectsFromArray:@[@"模特",@"摄影师",@"红人榜"]];
        [_typeArr addObjectsFromArray:@[@"0",@"1",@"2"]];
    }
    
    
    //旧版需要根据地理位置判断是否显示附近
//    if (nearHome) {
//        _segControl = [[UISegmentedControl alloc] initWithItems:@[modelStr,camStr,nearStr]];
//    }else{
//        _segControl = [[UISegmentedControl alloc] initWithItems:@[modelStr,camStr]];
//    }
    //新版为火爆推荐
    _segControl = [[UISegmentedControl alloc] initWithItems:titleArr];
    
    _segControl.frame = CGRectMake((kScreenWidth - 240)/2, 24.0, 240, 30.0);
    _segControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [_segControl addTarget:self action:@selector(doSelectedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segControl;
    
    //设置显示视图大小
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = kScreenHeight - kTabBarHeight - kNavHeight;
    self.view.frame = viewFrame;
    //默认显示模特视图
    [self showViewControllerAtIndex:_segControl.selectedSegmentIndex];
    
    //导航栏上的搜索功能
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"tabbar2_h"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(doJumpSearchVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //3dtouch通知的响应
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpSearchVC:) name:@"doJumpSearchVC" object:nil];
    
    //第一次进入应用，不显示广告页
    BOOL nofirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"nofirstLaunch"];
    if (!nofirstLaunch) {
        //第一次登陆不显示广告页和提示界面
    }else{
        //如果服务器不给字段，那么不显示广告页
        NSDictionary *guideDic = [USER_DEFAULT objectForKey:@"guides"];
        if(guideDic){
            NSString *picUrl = [guideDic objectForKey:@"p"];
            if (picUrl == nil ||picUrl.length == 0) {
                
            }else{
                //查看沙盒中记录，是否已经显示过广告页
                BOOL haveShowAdvertisement = [USER_DEFAULT boolForKey:@"haveShowAdvertisement"];
                if (haveShowAdvertisement) {
                    //已经显示过广告页
                }else{
                    //没有显示过，需要显示广告页
                    [self showAdvertisement];
                }
            }
        }else{
        //不存在guidic,不显示广告页
        }
    }
    
}


//视图将要显示的时候判断是否需要显示引导页
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //如果是第一次进入应用
    BOOL nofirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"nofirstLaunch"];
    if (!nofirstLaunch) {
        [self addLanuchView];
        //记录下次进入，不再展示引导页
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nofirstLaunch"];
        
        //第一次安装应用，从登陆状态退出，再次进入此界面
        //此时nofirstLaunch是YES，代码执行将会执行到显示广告页那里
        //所以要设置显示完引导页的同时设置已经显示广告页，就不会退出时显示广告页
        //在沙盒中记录，此时已经显示过广告页了
        [USER_DEFAULT setBool:YES forKey:@"haveShowAdvertisement"];
        [USER_DEFAULT synchronize];
        
    }
    [self.customTabBarController hidesTabBar:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
   
}



- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //本次打开引用是否已经显示过提醒
    BOOL haveShowServiceAlert = [USER_DEFAULT boolForKey:@"haveShowServiceAlert"];
    if (!haveShowServiceAlert) {
        //是否存在服务器要求显示的信息
        NSDictionary *serviceAlertDiction = [USER_DEFAULT objectForKey:@"serviceAlertDiction"];
        if (serviceAlertDiction) {
            //是否服务器要求打开显示
            if ([getSafeString(serviceAlertDiction[@"need"]) isEqualToString:@"1"]) {
                [self showServiceAlertView:serviceAlertDiction];
                //在沙盒中记录已经显示过
                [USER_DEFAULT setBool:YES forKey:@"haveShowServiceAlert"];
                [USER_DEFAULT synchronize];
            }
        }
    }

    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    
    UIApplication *application =[UIApplication sharedApplication];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //显示导航栏
    [self.navigationController setNavigationBarHidden:NO];
    NSLog(@"-----------%@",self.navigationController);
     //tabbar
    //[self.superNVC.customTabBarController hidesTabBar:NO animated:YES];
    //_collectionView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight -kTabBarHeight);
    
}




#pragma mark - 获取三种视图控制器
- (McMainModelViewController *)mainModelVC
{
    if (!_mainModelVC) {
        _mainModelVC = [[McMainModelViewController alloc] init];
        _mainModelVC.superNVC = self.navigationController;
        _mainModelVC.view.frame = self.view.bounds;
    }
    return _mainModelVC;
}

- (McMainPhotographerViewController *)mainPhotographerVC
{
    if (!_mainPhotographerVC) {
        _mainPhotographerVC = [[McMainPhotographerViewController alloc] init];
        _mainPhotographerVC.superNVC = self.navigationController;
        _mainPhotographerVC.view.frame = self.view.bounds;
    }
    return _mainPhotographerVC;
}

-(McMainNewPhotoGraghController *)newmainPhotographerVC{
    if (!_newmainPhotographerVC) {
        _newmainPhotographerVC = [[McMainNewPhotoGraghController alloc] init];
        _newmainPhotographerVC.superNVC = self.navigationController;
        _newmainPhotographerVC.view.frame = self.view.bounds;
    }
    return _newmainPhotographerVC;
}

- (McNearByPersonViewController *)mainNearByVC
{
    if (!_mainNearByVC) {
        _mainNearByVC = [[McNearByPersonViewController alloc] init];
        _mainNearByVC.superNVC = self.navigationController;
        _mainNearByVC.view.frame = self.view.bounds;
    }
    return _mainNearByVC;
}

- (MCMainFieryViewController *)mainRecommendVC{
    if (!_mainRecommendVC) {
        _mainRecommendVC = [[MCMainFieryViewController alloc]init];
        _mainRecommendVC.superNVC = self.navigationController;
        _mainRecommendVC.view.frame = self.view.bounds;
    }
    return _mainRecommendVC;
}


-(TJAdressView *)adressView{
    if (!_adressView) {
        _adressView = [[TJAdressView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kTabBarHeight-kNavHeight)];
        _adressView.superVC = self;
    }
    return _adressView;
}




#pragma mark - UISegmentedControl切换子视图

- (void)doSelectedControl:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    [self showViewControllerAtIndex:segControl.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSInteger)index
{

    if (_typeArr.count>index) {
        
        NSString *type = _typeArr[index];

        if ([type isEqualToString:@"0"]) {
            
            [self.view addSubview:self.mainModelVC.view];
            
            self.mainModelVC.collectionView.scrollEnabled = YES;
        }else if ([type isEqualToString:@"1"]){
            
            [self.view addSubview:self.mainPhotographerVC.view];
            self.mainPhotographerVC.collectionView.scrollEnabled = YES;
            
            //显示功能引导视图_摄影师
            [self showMokaGuideViewPhotographer:index];
            
            
        }else if ([type isEqualToString:@"2"]){
            
            [self.view addSubview:self.mainRecommendVC.view];

        }else{
            
            [self.view addSubview:self.mainNearByVC.view];

        }
    }
    
    
    self.seletedIndex = index;
    
    
}

#pragma mark
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)//关闭主界面的右滑返回
    {
        return NO;
    }
    else{
        return YES;
        
    }
    
}



#pragma mark 点击搜索
- (void)doJumpSearchVC:(id)sender
{
    McSeachViewController *searchVC = [[McSeachViewController alloc] init];

    [self.navigationController pushViewController:searchVC animated:YES];
    
}

#pragma mark - 设置显示启动页
- (void)addLanuchView
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.titleImage = [UIImage imageNamed:@"tutorial_background_06"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"";
    page2.desc = @"";
    page2.titleImage = [UIImage imageNamed:@"tutorial_background_01"];
    
    EAIntroPage *page3 = [EAIntroPage page];
    page3.title = @"";
    page3.desc = @"";
    page3.titleImage = [UIImage imageNamed:@"tutorial_background_03"];
    
    EAIntroPage *page4 = [EAIntroPage page];
    page4.title = @"";
    page4.desc = @"";
    page4.titleImage = [UIImage imageNamed:@"tutorial_background_02"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page5.title = @"";
    page5.desc = @"";
    page5.titleImage = [UIImage imageNamed:@"tutorial_background_04"];
    
    
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            
            BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
            //显示打赏引导页
            if (isAppearDaShang) {
                self.intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andPages:@[page2,page1,page5,page3]];
                
                
            }else
            {
                self.intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andPages:@[page3]];

                
            }
            [self.intro setDelegate:self];
            [self.intro showInView:window animateDuration:0.0];
            
            break;
        }
    }
#else
    if(SVProgressHUDExtensionView){
        [SVProgressHUDExtensionView addSubview:self.overlayView];
    }
#endif
}


//引导页结束的时候才开始注册通知
- (void)introDidFinish
{
    NSLog(@"这里结束了引导视图");
    [self.intro removeFromSuperview];
    //显示引导视图
    [self showGuideView];
}




#pragma mark - 显示摄影师界面引导
- (void)showMokaGuideViewPhotographer:(NSInteger)index{
    //显示摄影师引导
    BOOL show = [GuideView needShowGuidViewWithGuideViewType:MokaGuideViewPhotographer];
    if (show) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        guideView.photographerIndex = index;
        [guideView showGuidViewWithConditionType:MokaGuideViewPhotographer];
    }
}



#pragma mark - 设置显示通知
//注册通知之后会显示用户引导视图
- (void)showGuideView{
    //创建window
    _guideWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _guideWindow.backgroundColor = [UIColor clearColor];
    _guideWindow.hidden = NO;
    _guideWindow.windowLevel = UIWindowLevelStatusBar;
    //设置黑色背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    [_guideWindow addSubview:backView];

    //左边距
    CGFloat leftPadding = 70;
    //中间视图1094 × 659
    CGFloat centerImgWidth = kDeviceWidth -leftPadding *2;
    CGFloat centerImgheight = centerImgWidth *(659.f/1094.f);
    UIImageView *centerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding,(kDeviceHeight -centerImgheight)/2, centerImgWidth,centerImgheight )];
     centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    centerImgView.image = [UIImage imageNamed:@"guide_notification"];
    [_guideWindow addSubview:centerImgView];
    
    //上视图747*176
    UIImageView *topImgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, centerImgView.top -centerImgWidth *(176.f/747.f) -10, centerImgWidth, centerImgWidth *(176.f/747.f))];
    topImgView.contentMode = UIViewContentModeScaleAspectFit;
    topImgView.image = [UIImage imageNamed:@"guideImage01"];
    [_guideWindow addSubview:topImgView];

    //下视图747*451
    UIImageView *downImgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding,centerImgView.bottom+10, centerImgWidth, centerImgWidth*(451.f/747.f))];
     downImgView.contentMode = UIViewContentModeScaleAspectFit;
    downImgView.image = [UIImage imageNamed:@"guideImage02"];
    downImgView.userInteractionEnabled = YES;
    [_guideWindow addSubview:downImgView];

    //设置手势属性
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
    [downImgView addGestureRecognizer: singleTap];

}

//手势关闭"打开通知"的引导视图
- (void)viewTapAction{
    //隐藏window并且清除
    [UIView animateWithDuration:0.5 animations:^{
        _guideWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _guideWindow.hidden = NO;
        _guideWindow =nil;
        //发出通知显示设置打开环信和本地接收的通知
       [[NSNotificationCenter defaultCenter] postNotificationName:@"showTuiSongSetting" object:nil];
    }];
}



#pragma mark - 设置显示广告页
//显示广告图
- (void)showAdvertisement{
    //确定要显示广告页,就首先创建一个广告页视图
    //这是一个window,显示广告图
    _advertisementWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _advertisementWindow.hidden = NO;
    _advertisementWindow.windowLevel = UIWindowLevelStatusBar;
    
    //设置一个imageView,给定默认图片是启动页图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:_advertisementWindow.bounds];
    //寻找适配的图片
    NSDictionary * dic = @{@"320x480" : @"LaunchImage-700", @"320x568" : @"LaunchImage-700-568h", @"375x667" : @"LaunchImage-800-667h", @"414x736" : @"LaunchImage-800-Portrait-736h"};
    NSString * key = [NSString stringWithFormat:@"%dx%d", (int)[UIScreen mainScreen].bounds.size.width, (int)[UIScreen mainScreen].bounds.size.height];
    UIImage * launchImage = [UIImage imageNamed:[dic objectForKey:key]];
    //UIImage *launchImage = [UIImage imageNamed:@"LaunchImage"];
    imageView.image = launchImage;
    imageView.tag = 6;
    //imageView.contentMode = UIViewContentModeScaleToFill;
    [_advertisementWindow addSubview:imageView];
    //绘制图片
    //    DrawAdView  *imageView = [[DrawAdView alloc] initWithFrame:_advertisementWindow.bounds];
    //    imageView.image = [UIImage imageNamed:@"LaunchImage"];
    //    imageView.tag = 6;
    //    [_advertisementWindow addSubview:imageView];
    
    //同时开启一个定时器，如果三秒钟之后还没有找到下载好的图片
    //就直接隐藏广告页
    if(_waitLoadAdTimer == nil){
        _waitLoadAdTimer  = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadAdTimerAction:) userInfo:nil repeats:YES];
        //开始定时器
        [_waitLoadAdTimer fire];
    }
}

//加载等待定时器
- (void)loadAdTimerAction:(NSTimer *)timer{
    static int waitLoadTime = 0;
    waitLoadTime ++;
    UIImage *image = [self getAdImageFromCache];
    //判断图片是否存在
    if(image){
        //如果得到了图片，就更换window上的图片，同时停止加载定时器
        UIImageView *imageView = [_advertisementWindow viewWithTag:6];
        //DrawAdView *imageView = [_advertisementWindow viewWithTag:6];
        imageView.image = image;
        [_waitLoadAdTimer invalidate];
        _waitLoadAdTimer  = nil;
        //开始新的定时器，显示服务器设置的图片
        [self startShowAdVertisementPicture];
        
    }else{
        //没有图片，而且此时的已经过了3秒钟
        if(waitLoadTime >3){
            //跳过广告页的展示，直接进入应用
            [self hiddeAdvertisementWindow:NO];
        }
        
    }
    
}

//开始显示广告页图片
- (void)startShowAdVertisementPicture{
    //开启一个定时器，广告页最多显示3秒
    if(_timer == nil){
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    }
    [_timer fire];
    
    NSDictionary *guideDic = [USER_DEFAULT objectForKey:@"guides"];
    //一个延迟调用如果不操作，3秒钟就显示广告页
    //[self performSelector:@selector(hiddeAdvertisementWindow) withObject:nil afterDelay:3];
    
    //跳过提示
    UIView *skipView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth -120, 20, 100, 40)];
    skipView.tag = 5;
    skipView.backgroundColor = [UIColor blackColor];
    skipView.alpha = 0.3;
    [_advertisementWindow addSubview:skipView];
    //    UIView *backView = [[UIView alloc] initWithFrame:skipView.bounds];
    //    backView.backgroundColor = [UIColor blackColor];
    //    backView.alpha = 0.2;
    //    [skipView addSubview:backView];
    
    //关闭广告图的按钮
    UIButton *skipBtn  =[[UIButton alloc] initWithFrame:CGRectMake(0,0, 100, 40)];
    [skipBtn setTitle:@"跳过 3秒" forState:UIControlStateNormal];
    [skipBtn addTarget:self action:@selector(hiddeAdvertisementWindow:) forControlEvents:UIControlEventTouchUpInside];
    skipBtn.tag = 100;
    [skipView addSubview:skipBtn];
    skipView.layer.cornerRadius = 3;
    skipView.layer.masksToBounds = YES;
    
    //添加广告图跳转
    NSString *linkUrlStr = [guideDic objectForKey:@"u"];
    if (linkUrlStr.length>0) {
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterAdvertisementWeb:)];
        [_advertisementWindow addGestureRecognizer: singleTap];
    }
}



//返回是否广告页图片已经被缓存到本地
- (UIImage *)getAdImageFromCache{
    //获取需要的图片链接
    NSDictionary *guideDic = [USER_DEFAULT objectForKey:@"guides"];
    NSString *jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:kDeviceWidth*2]];
    NSString *completeString =[NSString stringWithFormat:@"%@%@",[guideDic objectForKey:@"p"],jpg];
    //从缓存中获取图片，如果存在则返回图片
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:completeString];
    //image = [UIImage imageNamed:@"tutorial_background_00"];
    if (image) {
        return image;
    }else{
        return nil;
    }
}


//点击广告图
- (void)enterAdvertisementWeb:(UIGestureRecognizer *)tap{
    _advertisementWindow.userInteractionEnabled = NO;
    NSDictionary *guideDic = [USER_DEFAULT objectForKey:@"guides"];
    NSString *linkUrlStr = [guideDic objectForKey:@"u"];
    McWebViewController *webVC = [[McWebViewController alloc] init];
    webVC.mainVC = self;
    webVC.webUrlString = linkUrlStr;
    webVC.needAppear = YES;
    [self.navigationController pushViewController:webVC animated:YES];
    [self performSelector:@selector(hiddeAdvertisementWindow:) withObject:nil afterDelay:0.5];
}


//定时器执行
- (void)timerAction:(NSTimer *)timer{
    static int count  = 4;
    count--;
    UIView *skipView = [_advertisementWindow viewWithTag:5];
    UIButton *skipBtn = [skipView viewWithTag:100];
    NSString *btnText = [NSString stringWithFormat:@"跳过 %d秒",count];
    [skipBtn setTitle:btnText forState:UIControlStateNormal];
    if(count ==0){
        [self hiddeAdvertisementWindow:NO];
    }
}

//广告图消失
- (void)hiddeAdvertisementWindow:(BOOL)enterAdvertisement{
    [_timer invalidate];
    _timer = nil;
    //在沙盒中记录，此时已经显示过广告页了
    [USER_DEFAULT setBool:YES forKey:@"haveShowAdvertisement"];
    [USER_DEFAULT synchronize];
    //执行消失动画
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _advertisementWindow.transform = CGAffineTransformMakeScale(2, 2);
        _advertisementWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _advertisementWindow = nil;
    }];
}


#pragma mark - 设置服务提示视图
//接受服务器端提醒
- (void)showServiceAlertView:(NSDictionary *)diction{
    if (_notificationWindow ==  nil) {
        //创建window
        _notificationWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _notificationWindow.backgroundColor = [UIColor clearColor];
        _notificationWindow.hidden = YES;
        _notificationWindow.alpha = 0;
        _notificationWindow.windowLevel = UIWindowLevelStatusBar;
        
        //设置黑色背景
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.7;
        [_notificationWindow addSubview:backView];
        
        //布局相关宽高度
        CGFloat lefttingPadding = 30;
        CGFloat topPadding = 50;
        CGFloat bottomPadding = 100;
        CGFloat centerImageWidth = kDeviceWidth - lefttingPadding*2;
        CGFloat centerImageHeight = kDeviceHeight - topPadding - bottomPadding - 40 -20;
        
        //中间图片
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(lefttingPadding, topPadding, centerImageWidth, centerImageHeight)];
        imageView.tag = 3000;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        NSString *jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.png",[NSNumber numberWithInteger:kDeviceWidth*2]];
        NSString *completeString =[NSString stringWithFormat:@"%@%@",diction[@"value"],jpg];
       [imageView sd_setImageWithURL:[NSURL URLWithString:completeString]];
        imageView.userInteractionEnabled  = YES;
        imageView.alpha = 0;
        [_notificationWindow addSubview:imageView];
        //设置UIimage的手势属性
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleNotificationAlert)];
        [imageView addGestureRecognizer:singleTap];
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/2 -20, kDeviceHeight -bottomPadding -40, 40, 40)];
        cancleBtn.tag = 3001;
        [cancleBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(closeServiceNotification) forControlEvents:UIControlEventTouchUpInside];
        [_notificationWindow addSubview:cancleBtn];
        
    }
    
    //连接线
    //UILabel *linkLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.right -20, imageView.top, 2, 0)];
    //linkLabel.backgroundColor = [UIColor whiteColor];
    //[_notificationWindow addSubview:linkLabel];

    UIImageView *imageView = [_notificationWindow viewWithTag:3000];
    UIButton *cancleBtn = [_notificationWindow viewWithTag:3001];
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //线条拉伸
        //linkLabel.frame = CGRectMake(imageView.right - 20,cancleBtn.bottom +1, 2, imageView.top -cancleBtn.bottom -1);
        _notificationWindow.hidden = NO;
        _notificationWindow.alpha = 1;
        imageView.alpha = 1;
        
    } completion:^(BOOL finished) {
        [UIView beginAnimations:@"exchangeView" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        [UIView setAnimationDuration:0.5];
        //动画
        //使用uview中的切换方式
        //UIViewAnimationTransitionFlipFromLeft
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:cancleBtn cache:YES];
        [UIView commitAnimations];
    }];
    
}

//手势关闭"打开通知"的引导视图
- (void)closeServiceNotification{
    //隐藏window并且清除
    [UIView animateWithDuration:0.5 animations:^{
       _notificationWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _notificationWindow.hidden = NO;
        _notificationWindow =nil;
     }];
}

- (void)handleNotificationAlert{
    //关闭通知视图
    [self closeServiceNotification];
    
    NSDictionary *serviceAlertDiction = [USER_DEFAULT objectForKey:@"serviceAlertDiction"];
    //NSString *webUrlStr = serviceAlertDiction[@"value"];
    NSString *actionStr = serviceAlertDiction[@"action"];
    //if(webUrlStr.length == 0){
    //    return;
    //}

    NSInteger type = [serviceAlertDiction[@"type"] integerValue];
    switch (type) {
        case 1:
        {   //直接消失
            break;
        }
        case 2:
        {   //进入网页
            McWebViewController *webVC = [[McWebViewController alloc] init];
            webVC.webUrlString = actionStr;
            webVC.needAppear = YES;
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            //进入网页
            [self.navigationController pushViewController:webVC animated:YES];
            break;
        }
        case 3:
        {
            //safari打开
            NSString *webURL = actionStr;
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            break;
        }
        case 4:
        {
            //进入私信打赏限制
            McSiXinSettingViewController *siXinDashangSettingVc = [[McSiXinSettingViewController alloc] initWithNibName:@"McSiXinSettingViewController" bundle:nil];
            [self.navigationController pushViewController:siXinDashangSettingVc animated:YES];
            break;
        }
        default:
            break;
    }
}



@end
