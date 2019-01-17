//
//  EOCBaseClass.m
//  testDynamic
//
//  Created by 张鑫 on 2018/5/9.
//  Copyright © 2018年 CrowForRui. All rights reserved.
//

#import "EOCBaseClass.h"

@implementation EOCBaseClass
+ (void)initialize {//类第一次加载在内存中。类是单例。
    if (self == [EOCBaseClass class]) {
         NSLog(@"%@ initialize", self);
    }
//    NSLog(@"%@ initialize", self);
}



@end
