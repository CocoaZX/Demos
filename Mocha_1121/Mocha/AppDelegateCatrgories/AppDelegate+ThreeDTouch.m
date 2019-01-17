//
//  AppDelegate+ThreeDTouch.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/4.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "AppDelegate+ThreeDTouch.h"

@implementation AppDelegate (ThreeDTouch)

- (void)threeDTouch:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        UIApplicationShortcutItem * shortItem1 = [[UIApplicationShortcutItem alloc]initWithType:@"activity" localizedTitle:@"查看活动"];
        UIApplicationShortcutItem * shortItem2 = [[UIApplicationShortcutItem alloc]initWithType:@"timeline" localizedTitle:@"热门动态"];
        UIApplicationShortcutItem * shortItem3 = [[UIApplicationShortcutItem alloc]initWithType:@"search" localizedTitle:@"搜索"];
        
        NSArray *shortItems = [[NSArray alloc] initWithObjects:shortItem1, shortItem2,shortItem3, nil];
        [[UIApplication sharedApplication] setShortcutItems:shortItems];
    }
    
}

#ifdef IOS_VERSION_9_OR_ABOVE

-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.localizedTitle isEqualToString:@"查看活动"]) {
        
        [self performSelector:@selector(gotoCheckActivity) withObject:nil afterDelay:1.0];
        
    }
    if ([shortcutItem.localizedTitle isEqualToString:@"热门动态"]) {
        
        [self performSelector:@selector(gotoCheckTimeLine) withObject:nil afterDelay:1.0];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpSearchVC" object:nil];
    }
    if ([shortcutItem.localizedTitle isEqualToString:@"搜索"]) {
        
        [self performSelector:@selector(gotoCheckSearch) withObject:nil afterDelay:1.0];
        
    }
}
#endif

- (void)gotoCheckActivity
{
    _customTabBarController.selectedIndex = 1;
    
}

- (void)gotoCheckTimeLine
{
    _customTabBarController.selectedIndex = 2;
    
    
}

- (void)gotoCheckSearch
{
    _customTabBarController.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doJumpSearchVC" object:nil];
    
}


@end
