//
//  ChatManager.m
//  Mocha
//
//  Created by sun on 15/7/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ChatManager.h"
#import "ChatSendHelper.h"

@implementation ChatManager


static ChatManager *manager = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ChatManager alloc] init];
    });
    return manager;
}



- (NSString *)hxName
{
    NSString *mokaNum = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    return getSafeString(mokaNum);
}

- (NSString *)hxPassword
{

    return @"123456";
}

bool isLogining = NO;

+ (void)registOrLogin
{
//    if (!isLogining) {
//        isLogining = YES;
//        [self loginWithUsername:[ChatManager sharedInstance].hxName password:[ChatManager sharedInstance].hxPassword ];
//        
//    }
    [self loginWithUsername:[ChatManager sharedInstance].hxName password:[ChatManager sharedInstance].hxPassword ];

//    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:[ChatManager sharedInstance].hxName password:[ChatManager sharedInstance].hxPassword withCompletion:^(NSString *username, NSString *password, EMError *error) {
////        BKUserObjectSetForKey(username, BKKeyForHuanXinName);
//        NSLog(@"%@",error);
//        
//        [self loginWithUsername:username password:password ];
//        
//    } onQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
//    
    
}

//点击登陆后的操作
+ (void)loginWithUsername:(NSString *)username password:(NSString *)password
{
    
    //异步登陆账号
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:username
                                                        password:password
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         isLogining = NO;
         if (loginInfo && !error) {
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             //将2.1.0版本旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
             
         }
         else
         {
             
             
         }
     } onQueue:nil];
}

+ (void)loginOut
{
    [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
    
}

+ (void)sendPaySuccessMessage:(NSDictionary *)dic
{
    id target = dic[@"target"];
    NSString *toUser = getSafeString(dic[@"target"][0]);
    NSString *textMessage = getSafeString(dic[@"msg"][@"msg"]);
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    
    NSMutableDictionary *mdic = [dic[@"ext"] mutableCopy];
    [mdic setObject:@{@"em_push_title":[NSString stringWithFormat:@"%@:%@",getSafeString(name),textMessage]} forKey:@"em_apns_ext"];
    [mdic setObject:getSafeString(name) forKey:@"userName"];
    [mdic setObject:getSafeString(headerURL) forKey:@"headerURL"];
    NSDictionary *diction = mdic.copy;
    
    [ChatSendHelper sendTextMessageWithString:textMessage
                                                            toUsername:toUser
                                                           messageType:eMessageTypeChat
                                                     requireEncryption:NO
                                                                   ext:diction];
    
}


//打赏之后发送打赏消息
+ (EMMessage *)sendDaShangSuccessMessage:(NSDictionary *)dic
{
    //接受赏的人
    NSString *toUser = getSafeString(dic[@"target"]);
    NSString *textMessage = getSafeString(dic[@"msg"]);
    //自己
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];

    NSMutableDictionary *mdic = [dic[@"ext"] mutableCopy];

    [mdic setObject:@{@"em_push_title":[NSString stringWithFormat:@"%@:%@",getSafeString(name),textMessage]} forKey:@"em_apns_ext"];
    [mdic setObject:getSafeString(name) forKey:@"userName"];
    [mdic setObject:getSafeString(headerURL) forKey:@"headerURL"];
    NSDictionary *diction = mdic.copy;
    
   //发送一条打赏的消息
   EMMessage *message =  [ChatSendHelper sendTextMessageWithString:textMessage
                                   toUsername:toUser
                                  messageType:eMessageTypeChat
                            requireEncryption:NO
                                                                 ext:diction];
    return message;
}

@end
