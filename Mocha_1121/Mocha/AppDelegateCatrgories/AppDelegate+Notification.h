//
//  AppDelegate+Notification.h
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Notification)

- (void)notification:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)startSdkWith:(NSString *)appID appKey:(NSString *)appKey appSecret:(NSString *)appSecret;

- (void)stopSdk;


//个推
- (NSString *)sendMessage:(NSData *)body error:(NSError **)error;

@end
