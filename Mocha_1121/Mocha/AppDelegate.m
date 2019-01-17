 //
//  AppDelegate.m
//  Mocha
//
//  Created by renningning on 14-11-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "AppDelegate.h"
#import "MineViewController.h"

#import "McSeachViewController.h"
#import "McFeedViewController.h"

#import "MokaActivityListViewController.h"
#import "NewLoginViewController.h"
#import "RNBlurModalView.h"
#import "UIImage+ColorToImage.h"
#import "GlogalState.h"
#import "CoreData+MagicalRecord.h"
//#import "iVersion.h"
#import "Harpy.h"
#import "McNavigationViewController.h"
#import "HarpyConstants.h"
#import "BangDingPhoneViewController.h"



#import "JSONKit.h"


@interface AppDelegate () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,RNBlurModalViewDelegate>


@property (nonatomic, strong) McMainController *mainController;


@end

@implementation AppDelegate



+ (void)initialize
{
    //    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    //    [iVersion sharedInstance].applicationBundleID = identifier;//@"com.zhengre.ouser" identifier
    //以下两个是可选的配置，如果不配置，将直接从itunes获取信息
    //    [iVersion sharedInstance].remoteVersionsPlistURL = @"http://10.16.57.99/versions.plist";
    //@"http://image.zhengre.com/versions.plist";//@"http://10.16.57.99/versions.plist";
    //    [iVersion sharedInstance].localVersionsPlistPath = @"versions.plist";
    [Harpy checkVersion];
    
}
//程序处于关闭状态时，收到推送消息，会调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //3D touch配置
    [self threeDTouch:application didFinishLaunchingWithOptions:launchOptions];
    
    //配置信息，接口
    [self configApp:application didFinishLaunchingWithOptions:launchOptions];
    
    //远程推送
    [self notification:application didFinishLaunchingWithOptions:launchOptions];
 
    //第三方sdk 友盟，微信，qq，新浪微博等
    [self registThirdSDK:application didFinishLaunchingWithOptions:launchOptions];
    
    //环信
    [self easemobApplication:application didFinishLaunchingWithOptions:launchOptions];
    
    //分享
    [self share:application didFinishLaunchingWithOptions:launchOptions];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //显示睡眠0.5秒
    [NSThread sleepForTimeInterval:1];
    
    //缓存广告视图
    NSDictionary *guideDic = [USER_DEFAULT objectForKey:@"guides"];
    NSString *jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:kDeviceWidth*2]];
    NSString *completeString =[NSString stringWithFormat:@"%@%@",[guideDic objectForKey:@"p"],jpg];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:completeString];
    if (cachedImage) {
        //已经存在就不再下载图片
    }else{
        //没有缓存过此图片，将广告页图片缓存到本地
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:completeString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //
        }];
 
    }
    
    
    //配置界面
    [self showMainViewController];
    
    //系统皮肤设置
    [self customizeInterface];
    
    //生命周期通知
    [self setNotification];
    
    return YES;
}

- (void)setNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackgroundNotif:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotif:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

}





-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if(!url){
        return NO;
    }
    NSString *urlstring = [NSString stringWithFormat:@"%@",url.description];
    if (urlstring.length>4) {
        NSString *symbolWX = [[urlstring substringFromIndex:urlstring.length-4] substringToIndex:4];
        if ([symbolWX isEqualToString:@"moka"]) {
            return  [WXApi handleOpenURL:url delegate:[WeixinMagnager shareWeixinManager]];
            
        }
    }
    if (urlstring.length>7) {
        
        NSString *symbolQQ = [[urlstring substringFromIndex:0] substringToIndex:7];
        if ([symbolQQ isEqualToString:@"tencent"]) {
 
            NSArray *errorArr = [urlstring componentsSeparatedByString:@"error"];
            if (errorArr.count > 1) {
                NSString *errorStr = errorArr [1];
                //                char * errChar = (char)[errorArr characterAtIndex:1];
                NSString *errSuccess = [errorStr substringToIndex:2];
                if ([errSuccess isEqualToString:@"=0"]) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SharedSuccess" object:nil];
                }
            }
            return [TencentOAuth HandleOpenURL:url];
        }

    }
    if (urlstring.length>2) {
        NSString *symbolSina = [[urlstring substringFromIndex:0] substringToIndex:2];
        if ([symbolSina isEqualToString:@"wb"]) {
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"SharedSuccess" object:nil];

            return [WeiboSDK handleOpenURL:url delegate:[SinaManager shareSinaManager]];
            
        }
    }
    if (urlstring.length>3) {
        NSString *symbolSina = [[urlstring substringFromIndex:0] substringToIndex:2];
        if ([symbolSina isEqualToString:@"wx"]) {
            return [WXApi handleOpenURL:url delegate:[WeixinMagnager shareWeixinManager]];
            
        }
    }
    if(![SingleData shareSingleData].isFromeShare && ![SingleData shareSingleData].isFromePay)
    {
        NSString *urlString=[url absoluteString];
        NSString *uidString = @"";
        NSArray *urlArray = [urlString componentsSeparatedByString:@"="];
        if (urlArray.count>1) {
            uidString = urlArray[1];
            
            
            NSString *userName = @"";
            NSString *uid = uidString;
            
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            [self.mainController.customTabBarController hidesTabBar:YES animated:NO];
            [self.mainController.navigationController pushViewController:newMyPage animated:YES];
        }
    }else
    {
        [SingleData shareSingleData].isFromePay = NO;
        [SingleData shareSingleData].isFromeShare = NO;
    }
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    //在沙盒中记录，此时程序终止
    //将广告页的显示记录为没有显示过
    [USER_DEFAULT setBool:NO forKey:@"haveShowAdvertisement"];
    
    //将服务通知记录为没显示过
    [USER_DEFAULT setBool:NO forKey:@"haveShowServiceAlert"];
    //将服务通知的数据清空
    [USER_DEFAULT removeObjectForKey:@"serviceAlertDiction"];
    
    [USER_DEFAULT synchronize];

    

}

-(void)applicationWillResignActive:(UIApplication *)application{
    NSLog(@"sdf");
}

- (void)appDidBecomeActiveNotif:(NSNotification*)notif
{
    [self startSdkWith:_appID appKey:_appKey appSecret:_appSecret];
    
//    [[SingleData shareSingleData] getOnlineTagsData];
    
    [self getShareContent];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideTabbarForDaTu" object:nil];
    
#ifdef HXRelease
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:notif.object];
    
#endif
}

#pragma mark - notifiers
- (void)appDidEnterBackgroundNotif:(NSNotification*)notif{
    // [EXT] 切后台关闭SDK，让SDK第一时间断线，让个推先用APN推送
    [self stopSdk];
#ifdef HXRelease
    //环信设置
    [[EaseMob sharedInstance] applicationDidEnterBackground:notif.object];
#endif
}


- (void)showMainViewController{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD setBackgroundColor:RGBA(0, 0, 0, 0.8)];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    UIViewController *firstVC = nil;
    UIViewController *secondVC = nil;
    UIViewController *fourVC = nil;
    UIViewController *mineVC = nil;
    firstVC = [[McMainController alloc] init];
    //secondVC = [[NewActivityListViewController alloc] initWithNibName:@"NewActivityListViewController" bundle:[NSBundle mainBundle]];
    secondVC = [[MokaActivityListViewController alloc] init];
    fourVC = [[McFeedViewController alloc] init];
    mineVC = [[MineViewController alloc] init];
    
    
    self.mainController = firstVC;
    
    McNavigationViewController *homeNav = [[McNavigationViewController alloc] initWithRootViewController:firstVC];
    McNavigationViewController *chatNav = [[McNavigationViewController alloc] initWithRootViewController:secondVC];
    McNavigationViewController *findNav = [[McNavigationViewController alloc] initWithRootViewController:fourVC];
    McNavigationViewController *meNav = [[McNavigationViewController alloc] initWithRootViewController:mineVC];
    
    
    NSMutableDictionary *imgDic = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic setObject:[UIImage imageNamed:@"tab01-home"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"tab01-homeOn"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"tab01-homeOn"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic2 setObject:[UIImage imageNamed:@"tab02-event"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"tab02-eventOn"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"tab02-eventOn"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic4 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic4 setObject:[UIImage imageNamed:@"tab03-find"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"tab03-findOn"] forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"tab03-findOn"] forKey:@"Seleted"];
    
    NSMutableDictionary *imgDic5 = [NSMutableDictionary dictionaryWithCapacity:3];
    [imgDic5 setObject:[UIImage imageNamed:@"tab04-my"] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"tab04-myOn"] forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:@"tab04-myOn"] forKey:@"Seleted"];
    
    
    #ifdef MokaVipRelease
    [imgDic setObject:[UIImage imageNamed:@"tab01-home"] forKey:@"Default"];
    [imgDic setObject:[UIImage imageNamed:@"tabbar_vip_home"] forKey:@"Highlighted"];
    [imgDic setObject:[UIImage imageNamed:@"tabbar_vip_home"] forKey:@"Seleted"];
    
    [imgDic2 setObject:[UIImage imageNamed:@"tab02-event"] forKey:@"Default"];
    [imgDic2 setObject:[UIImage imageNamed:@"tabbar_vip_activity"] forKey:@"Highlighted"];
    [imgDic2 setObject:[UIImage imageNamed:@"tabbar_vip_activity"] forKey:@"Seleted"];
    
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Default"];
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Highlighted"];
    [imgDic3 setObject:[UIImage imageNamed:@"releaseBtn"] forKey:@"Seleted"];
    
    [imgDic4 setObject:[UIImage imageNamed:@"tab03-find"] forKey:@"Default"];
    [imgDic4 setObject:[UIImage imageNamed:@"tabbar_vip_xiu"] forKey:@"Highlighted"];
    [imgDic4 setObject:[UIImage imageNamed:@"tabbar_vip_xiu"] forKey:@"Seleted"];
    
    [imgDic5 setObject:[UIImage imageNamed:@"tab04-my"] forKey:@"Default"];
    [imgDic5 setObject:[UIImage imageNamed:@"tabbar_vip_self"] forKey:@"Highlighted"];
    [imgDic5 setObject:[UIImage imageNamed:@"tabbar_vip_self"] forKey:@"Seleted"];
    
    #endif

    
    
    NSArray *ctrlArr  = [NSArray arrayWithObjects:homeNav,chatNav,homeNav,findNav,meNav,nil];
    NSArray *imgArr   = [NSArray arrayWithObjects:imgDic,imgDic2,imgDic3,imgDic4,imgDic5,nil];
//    NSString *homeStr = @"主页";
    NSString *homeStr = NSLocalizedString(@"home",nil);
//    NSString *activityStr = @"广场";
    NSString *activityStr = NSLocalizedString(@"activities",nil);
//    NSString *showStr = @"秀";
    NSString *showStr = NSLocalizedString(@"show",nil);
//    NSString *mineStr = @"我";
    NSString *mineStr = NSLocalizedString(@"me",nil);
//    NSString *releaseStr = @"发布";
    NSString *releaseStr = NSLocalizedString(@"release",nil);
    
    NSDictionary *tabNameDic = [USER_DEFAULT objectForKey:@"lang_description"];
//    if (!tabNameDic) {
//        homeStr = [tabNameDic objectForKey:@"home"];
//        activityStr = [tabNameDic objectForKey:@"event"];
//        showStr = [tabNameDic objectForKey:@"feed"];
//        mineStr = [tabNameDic objectForKey:@"my"];
//        
//    }
    
    
    NSArray *titleArr = [NSArray arrayWithObjects:homeStr,activityStr,releaseStr,showStr,mineStr,nil];
    
    _customTabBarController = [[CustomTabBarController alloc] initWithViewControllers:ctrlArr imageArray:imgArr titleArray:titleArr];
    McNavigationViewController *tabbarNav = [[McNavigationViewController alloc] initWithRootViewController:_customTabBarController];
    tabbarNav.navigationBarHidden = YES;
    _customTabBarController.delegate = self;
    [_customTabBarController setTabBarTransparent:YES];//YES
    self.window.rootViewController = tabbarNav;
    
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if (userDict) {
        NSInteger count = [userDict[@"messagecount"] integerValue] + [userDict[@"newcommentscount"] integerValue] + [userDict[@"newfanscount"] integerValue] + [userDict[@"sysmsgcount"]integerValue];
        if (count > 0) {
            
            //            [_customTabBarController setBadgeValueHidden:NO atIndex:3];
        }
        else{
            //            [_customTabBarController setBadgeValueHidden:YES atIndex:3];
        }
    }
    
}

- (void)showBangDingViewController
{
    
#if !defined(SV_APP_EXTENSIONS)
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
            if (isBangDing) {
                
            }
            BangDingPhoneViewController *bangding = [[BangDingPhoneViewController alloc] initWithNibName:@"BangDingPhoneViewController" bundle:[NSBundle mainBundle]];
            bangding.isFromSiLiao = YES;
            [window.rootViewController presentViewController:bangding animated:YES completion:nil];
            
            break;
        }
    }
#else
    if(SVProgressHUDExtensionView){
        [SVProgressHUDExtensionView addSubview:self.overlayView];
    }
#endif
}

- (void)showAccountViewController{
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
    [USER_DEFAULT synchronize];
    
    
    NewLoginViewController *login = [[NewLoginViewController alloc] initWithNibName:@"NewLoginViewController" bundle:[NSBundle mainBundle]];
    
    [_customTabBarController.navigationController pushViewController:login animated:YES];
    
}


- (void)showAccountViewControllerWithCon:(UIViewController *)controller{
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
    [USER_DEFAULT synchronize];
    
    
    NewLoginViewController *login = [[NewLoginViewController alloc] initWithNibName:@"NewLoginViewController" bundle:[NSBundle mainBundle]];
    
    [controller.navigationController pushViewController:login animated:YES];
    
}

- (void)customizeInterface {
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    UINavigationBar *navigationBarAppearance = [UINavigationBar appearance];
    
    UIImage *backgroundImage = nil;
    NSDictionary *textAttributes = nil;
    
    UIColor *color = [CommonUtils colorFromHexString:kLikeRedColor];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        backgroundImage = [SQCImageUtils createImageWithColor:[UIColor whiteColor]];
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
                           NSForegroundColorAttributeName: color
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        backgroundImage = [SQCImageUtils createImageWithColor:[UIColor whiteColor]];
        
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:18],
                           UITextAttributeTextColor: color,
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    
    [navigationBarAppearance setBackgroundImage:backgroundImage
                                  forBarMetrics:UIBarMetricsDefault];//
    [navigationBarAppearance setTitleTextAttributes:textAttributes];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.360.Mocha" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Mocha" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    
    
    NSDictionary *optionsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],
                                       NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES],
                                       NSInferMappingModelAutomaticallyOption, nil];

    
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Mocha.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:optionsDictionary error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark-
#pragma mark- CustomTabBarControllerDelegate
- (BOOL)tabBarController:(CustomTabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController selectedIndex:(NSUInteger)index{
    
    if(4 == tabBarController.clickIndex){
        if(![GlogalState isLogin]){
            [self showAccountViewController];
            return NO;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTitle" object:nil];
        
    }
    
    
    return YES;
}

- (void)tabBarController:(CustomTabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    if (4==tabBarController.clickIndex){
        [viewController viewWillAppear:YES];//没有实现
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshLoadDataChatView" object:nil];
    }
    
}




BOOL isLogin() {
    id diction = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if ([diction isKindOfClass:[NSDictionary class]]) {
        NSString *uid = diction[@"id"];
        if (uid) {
            int uidInt = [uid intValue];
            if (uidInt>0) {
                return YES;
            }
        }
    }
    return NO;
}

NSString *currentUID(){
    id diction = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if ([diction isKindOfClass:[NSDictionary class]]) {
        return getSafeString(diction[@"id"]);
    }
    return @"";
}



@end
