//
//  ChatManager.h
//  Mocha
//
//  Created by sun on 15/7/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatManager : NSObject

+ (instancetype)sharedInstance;

- (NSString *)hxName;

- (NSString *)hxPassword;

+ (void)registOrLogin;

//发送一条约拍成功的消息
+ (void)sendPaySuccessMessage:(NSDictionary *)dic;

//发送一条打赏成功的环信消息
+ (EMMessage *)sendDaShangSuccessMessage:(NSDictionary *)dic;


@end
