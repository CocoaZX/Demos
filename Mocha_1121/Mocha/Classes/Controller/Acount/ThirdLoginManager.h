//
//  ThirdLoginManager.h
//  Mocha
//
//  Created by sun on 15/6/24.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThirdLoginManager : NSObject

@property (copy, nonatomic) NSString *phoneNumber;
@property (copy, nonatomic) NSString *password;

@property (strong, nonatomic) NSString *thirdUserName;
@property (strong, nonatomic) NSString *thirdHeaderImageURL;

@property (strong, nonatomic) NSDictionary *paraDiction;

@property (assign, nonatomic) int lastThirdType;

@property (assign, nonatomic) BOOL isThirdLogin;

+ (ThirdLoginManager *)shareThirdLoginManager;

- (void)clear;

@end
