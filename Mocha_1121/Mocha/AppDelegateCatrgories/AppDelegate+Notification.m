//
//  AppDelegate+Notification.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate+Notification.h"
#import "AFNetworkReachabilityManager.h"

@implementation AppDelegate (Notification)

- (void)notification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // [1]:使用APPID/APPKEY/APPSECRENT创建个推实例
    [self startSdkWith:kAppId appKey:kAppKey appSecret:kAppSecret];
    
    //收到通知时才开始注册通知，发送通知的是首页引导页结束之后
    [[NSNotificationCenter defaultCenter] addObserverForName:@"showTuiSongSetting" object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        // [2]:注册APNS
        [self registerRemoteNotification];
    }];
  
    // [2-EXT]: 获取启动时收到的APN
    /*
     如果launchOptions包含UIApplicationLaunchOptionsRemoteNotificationKey表示用户点击apn 通知导致app被启动运行；如果不含有对应键值则表示 App 不是因点击apn而被启动，可能为直接点击icon被启动或其他。
     */
    NSDictionary* message = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (message) {
        NSString *payloadMsg = [message objectForKey:@"payload"];
        NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
        //NSLog(@"获取启动时收到的APN：message:%@",record);
     }
 }
 


- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret
{
    if (!self.gexinPusher) {
        self.sdkStatus = SdkStatusStoped;
        
        self.appID = appID;
        self.appKey = appKey;
        self.appSecret = appSecret;
        
        
        self.clientId = nil;
        
        NSError *err = nil;
        self.gexinPusher = [GexinSdk createSdkWithAppId:self.appID
                                             appKey:self.appKey
                                          appSecret:self.appSecret
                                         appVersion:@"0.0.0"
                                           delegate:self
                                              error:&err];
        if (!self.gexinPusher) {
            NSLog(@"create_error:%@",[err localizedDescription]);
        } else {
            self.sdkStatus = SdkStatusStarting;
            NSLog(@"create gexin");
        }
        
    }
}

// 注册推送
- (void)registerRemoteNotification{
    UIApplication *application = [UIApplication sharedApplication];
    application.applicationIconBadgeNumber = 0;
    
    if([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    
#if !TARGET_IPHONE_SIMULATOR
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}

 

- (void)stopSdk
{
    if (self.gexinPusher) {
        [self.gexinPusher destroy];
        
        self.gexinPusher = nil;
        
        self.sdkStatus = SdkStatusStoped;
        
        self.clientId = nil;
        
    }
}

- (BOOL)checkSdkInstance
{
    if (!self.gexinPusher) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"错误" message:@"SDK未启动" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertView show];
        
        return NO;
    }
    return YES;
}

- (void)setDeviceToken:(NSString *)aToken
{
    if (![self checkSdkInstance]) {
        return;
    }
    
    [self.gexinPusher registerDeviceToken:aToken];
}

- (BOOL)setTags:(NSArray *)aTags error:(NSError **)error
{
    if (![self checkSdkInstance]) {
        return NO;
    }
    
    return [self.gexinPusher setTags:aTags];
}

- (NSString *)sendMessage:(NSData *)body error:(NSError **)error {
    if (![self checkSdkInstance]) {
        return nil;
    }
    
    return [self.gexinPusher sendMessage:body error:error];
}

- (void)bindAlias:(NSString *)aAlias {
    
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [self.gexinPusher bindAlias:aAlias];
}

- (void)unbindAlias:(NSString *)aAlias {
    if (![self checkSdkInstance]) {
        return;
    }
    
    return [self.gexinPusher unbindAlias:aAlias];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}
#endif


#pragma mark - 个推

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
#ifdef HXRelease
    //环信
    [[EaseMob sharedInstance] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    
#endif
    
    //个推
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    _deviceToken = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"register deviceToken:%@", _deviceToken);
    
    // [3]:向个推服务器注册deviceToken
    if (self.gexinPusher) {
        [self.gexinPusher registerDeviceToken:_deviceToken];
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
#ifdef HXRelease
    //环信
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"apns.failToRegisterApns", Fail to register apns)
                                                    message:error.description
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"ok", @"OK")
                                          otherButtonTitles:nil];
#ifdef HXShowAlert
    //    [alert show];
#endif
    
#endif
    
    
    //个推
    // [3-EXT]:如果APNS注册失败，通知个推服务器
    NSLog(@"FailToRegister");
    if (self.gexinPusher) {
        [self.gexinPusher registerDeviceToken:@""];
    }
}


- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [SingleData shareSingleData].isAppearRedPoint = YES;
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
    
//    NSLog(@"record:%@",record);
    
    completionHandler(UIBackgroundFetchResultNewData);
}


//处于前台后台工作时，若推送消息时正巧点击app图标，那这两种方法都不会调用
//基于iOS 6 及以下的系统版本，如果 App状态为正在前台或者点击通知栏的通知消息，那么此函数将被调用，并且可通过AppDelegate的applicationState是否为UIApplicationStateActive判断程序是否在前台运行。
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userinfo
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userinfo objectForKey:@"payload"];
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@", [NSDate date], payloadMsg];
//    NSLog(@"userinfo:%@，record:%@",userinfo,record);
}


//基于iOS 7 及以上的系统版本，如果是使用 iOS 7 的 Remote Notification 特性那么处理函数需要使用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [SingleData shareSingleData].isAppearRedPoint = YES;
    // [4-EXT]:处理APN
    NSString *payloadMsg = [userInfo objectForKey:@"payload"];
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    NSNumber *contentAvailable = aps == nil ? nil : [aps objectForKeyedSubscript:@"content-available"];
    
    NSString *record = [NSString stringWithFormat:@"[APN]%@, %@, [content-available: %@]", [NSDate date], payloadMsg, contentAvailable];
//    NSLog(@"record－fetch:%@",record);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - GexinSdkDelegate
- (void)GexinSdkDidRegisterClient:(NSString *)clientId
{
    // [4-EXT-1]: 个推SDK已注册
    self.sdkStatus = SdkStatusStarted;
    
    self.clientId = clientId;
    NSLog(@"RegisterClientId:%@",clientId);
    if ([AFNetworkReachabilityManager sharedManager].isReachable) {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (uid) {
            if (self.clientId.length>0) {
                NSMutableDictionary *diction = @{}.mutableCopy;
                [diction setObject:uid forKey:@"uid"];
                [diction setObject:self.clientId forKey:@"cid"];
                NSDictionary *params = [AFParamFormat formatTongBuCidParams:diction];
                [AFNetwork tongBuCid:params success:^(id data){
//                    NSLog(@"clientId_data:%@",data);
                    NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
                    if ([state integerValue]==kReLogin) {
                        [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                        [USER_DEFAULT synchronize];
                    }
                }failed:^(NSError *error){
                    
                }];
            }
            
        }
    }
    
}

- (void)GexinSdkDidReceivePayload:(NSString *)payloadId fromApplication:(NSString *)appId
{
    // [4]: 收到个推消息
    
    self.payloadId = payloadId;
    
    NSData *payload = [self.gexinPusher retrivePayloadById:payloadId];
    NSString *payloadMsg = nil;
    if (payload) {
        payloadMsg = [[NSString alloc] initWithBytes:payload.bytes
                                              length:payload.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSString *record = [NSString stringWithFormat:@"%d, %@, %@", ++self.lastPayloadIndex, [NSDate date], payloadMsg];
    
    NSLog(@"ReceivePayload:%@",record);
}

- (void)GexinSdkDidSendMessage:(NSString *)messageId result:(int)result {
    // [4-EXT]:发送上行消息结果反馈
    //    NSString *record = [NSString stringWithFormat:@"Received sendmessage:%@ result:%d", messageId, result];
    
}

- (void)GexinSdkDidOccurError:(NSError *)error
{
    // [EXT]:个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    
    NSLog(@">>>[GexinSdk error]:%@", [error localizedDescription]);
    
}


@end
