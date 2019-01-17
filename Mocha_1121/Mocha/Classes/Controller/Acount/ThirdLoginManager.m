//
//  ThirdLoginManager.m
//  Mocha
//
//  Created by sun on 15/6/24.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ThirdLoginManager.h"

@implementation ThirdLoginManager

static ThirdLoginManager *thirdM;
+ (ThirdLoginManager *)shareThirdLoginManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thirdM = [[ThirdLoginManager alloc] init];
    });
    return thirdM;
}


- (void)clear
{
    self.thirdUserName = nil;
    self.thirdHeaderImageURL = nil;
    self.paraDiction = nil;
    self.lastThirdType = 0;
    self.isThirdLogin = NO;
}

@end
