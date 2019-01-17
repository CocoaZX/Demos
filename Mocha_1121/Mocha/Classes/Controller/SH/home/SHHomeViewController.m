//
//  SHHomeViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "SHHomeViewController.h"

#import "McMainPhotographerViewController.h"
#import "McMainModelViewController.h"

#import "McSeachViewController.h"

#import "EAIntroPage.h"
#import "EAIntroView.h"


@interface SHHomeViewController ()<EAIntroDelegate>

@property (nonatomic, assign) NSInteger seletedIndex;
@property (strong, nonatomic) UISegmentedControl *segControl;
//两个子视图控制器
@property (nonatomic,strong)McMainModelViewController *mainModelVC;
@property (nonatomic,strong)McMainPhotographerViewController *mainPhotographerVC;

@end

@implementation SHHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //分段控制器
    _segControl = [[UISegmentedControl alloc] initWithItems:@[@"模特",@"摄影师"]];
    _segControl.frame = CGRectMake((kScreenWidth - 160)/2, 24.0, 160, 30.0);
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
    
}




#pragma mark 切换子视图
- (void)doSelectedControl:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    [self showViewControllerAtIndex:segControl.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSInteger)index
{
    self.seletedIndex = index;
    //如果选择了模特视图
    if (index == 0) {
        if (!_mainModelVC) {
            _mainModelVC = [[McMainModelViewController alloc] init];
            _mainModelVC.superNVC = self.navigationController;
            _mainModelVC.view.frame = self.view.bounds;
            [self.view addSubview:_mainModelVC.view];
        }
        else{
            _mainModelVC.view.frame = self.view.bounds;
            [self.view addSubview:_mainModelVC.view];
        }
    }
    else{
        //选择了摄影师视图
        if (!_mainPhotographerVC) {
            _mainPhotographerVC = [[McMainPhotographerViewController alloc] init];
            _mainPhotographerVC.superNVC = self.navigationController;
            _mainPhotographerVC.view.frame = self.view.bounds;
            [self.view addSubview:_mainPhotographerVC.view];
        }
        else{
            _mainPhotographerVC.view.frame = self.view.bounds;
            [self.view addSubview:_mainPhotographerVC.view];
        }
    }
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

//启动页设置
- (void)addLanuchView
{
    EAIntroPage *page1 = [EAIntroPage page];
    page1.title = @"";
    page1.desc = @"";
    page1.titleImage = [UIImage imageNamed:@"tutorial_background_01"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.title = @"";
    page2.desc = @"";
    page2.titleImage = [UIImage imageNamed:@"tutorial_background_00"];
    
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
            
            EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) andPages:@[page5]];
            
            [intro setDelegate:self];
            [intro showInView:window animateDuration:0.0];
            break;
        }
    }
#else
    if(SVProgressHUDExtensionView){
        [SVProgressHUDExtensionView addSubview:self.overlayView];
    }
#endif
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
    }
    [self.customTabBarController hidesTabBar:NO animated:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    
}

- (void)introDidFinish
{
    
}

@end
