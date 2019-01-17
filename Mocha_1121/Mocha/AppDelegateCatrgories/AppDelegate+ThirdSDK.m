//
//  AppDelegate+ThirdSDK.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate+ThirdSDK.h"
#ifdef BugtagsRelease

#import <Bugtags/Bugtags.h>

#endif
#import "MobClick.h"
#import "WXApi.h"

#ifdef TusdkRelease

#import <TuSDK/TuSDK.h>

#endif

// appid
#define kTCCloudPlayerSDKTestAppId @"1251132611"

// logid
#define kTCCloudPlayerSDKTestLogId @"100043"
#import "TCPlayerBottomView.h"
#import "TCPlayerBaseControlView.h"
#import "TCCloudPlayerControlView.h"


@implementation AppDelegate (ThirdSDK)

- (void)registThirdSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
#ifdef TusdkRelease
    
    /**
     * ！！！！！！！！！！！！！！！！！！！！！！！！！特别提示信息要长！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！！
     * 关于TuSDK体积（SDK编译后仅为1.9MB）：
     * 1,如果您不需要使用本地贴纸功能，或仅需要使用在线贴纸功能，请删除/app/TuSDK.bundle/stickers文件夹
     * 2,如果您仅需要几款滤镜，您可以删除/app/TuSDK.bundle/textures下的*.gsce文件
     * 3,如果您不需要使用滤镜功能，请删除/app/TuSDK.bundle/textures文件夹
     * 4,TuSDK在线管理功能请访问：http://tusdk.com/
     *
     * IOS编译Framework知识：
     * Framework包含armv7,arm64等不同CPU的编译结果的集合；
     * 其中每种CPU编译结果还包含Debug以及Realse两种子结果；
     * 当集成某个Framework（假如TuSDK.Framework物理文件大小为30MB），编译成APP发布后，实际大小约为不到2MB
     *
     * 开发文档:http://tusdk.com/docs/ios/api/
     */
    // 可选: 设置日志输出级别 (默认不输出)
    [TuSDK setLogLevel:lsqLogLevelDEBUG];
    
    [TuSDK initSdkWithAppKey:TUSDKKEY];
    
#endif
   
#ifdef BugtagsRelease
    //bug 管理
    [Bugtags startWithAppKey:@"f1421136ba205bd529b39c7ecfa5c49f" invocationEvent:BTGInvocationEventShake];
#endif
    
    //友盟
    [MobClick startWithAppkey:umengAppkey reportPolicy:BATCH  channelId:@""];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    [MobClick setBackgroundTaskEnabled:YES];
    
    //向微信注册
    NSString *str = @"wx50fdd5562cfe068a";
    [WXApi registerApp:str];
    
    
    //新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kSinaAppKey];

    //腾讯云 视频播放器
    // 设置默认控件类
    [TCPlayerView setPlayerBottomViewClass:[TCPlayerBottomView class]];
    [TCPlayerView setPlayerCtrlViewClass:[TCCloudPlayerControlView class]];
    
    // Override point for customization after application launch.
    // 配置上报
    [[TCReportEngine sharedEngine] configAppId:kTCCloudPlayerSDKTestAppId];
    
    
#if DEBUG
    [[TCReportEngine sharedEngine] setEnv:YES];
#else
    [[TCReportEngine sharedEngine] setEnv:NO];
#endif
    
}


















@end
