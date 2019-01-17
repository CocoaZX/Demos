//
//  GlogalState.m
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "GlogalState.h"

@implementation GlogalState

+ (BOOL)isLogin
{
    if ([USER_DEFAULT valueForKey:MOKA_USER_VALUE] != nil && [[USER_DEFAULT valueForKey:MOKA_USER_OVERDUE] integerValue] == 0) {
        return YES;
    }
    
    return NO;
}

@end
