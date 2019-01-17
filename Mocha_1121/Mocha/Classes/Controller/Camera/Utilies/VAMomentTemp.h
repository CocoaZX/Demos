//
//  VAMomentTemp.h
//  WXBBuilder
//
//  Created by zhanglang on 14-6-24.
//  Copyright (c) 2014年 上海上蓓网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VAMomentTemp : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *body;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@property (nonatomic, assign) int uploadType;

@property (nonatomic, retain) NSMutableArray *photoArray;

@property (nonatomic, retain) NSMutableArray *filerIconArray;

@property (nonatomic, retain) NSMutableArray *defaultLabelArray;

+ (VAMomentTemp *)sharedSingleton;

- (void)clear;

@end
