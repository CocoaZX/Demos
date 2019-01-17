//
//  ActivityDataModel.h
//  Mocha
//
//  Created by sun on 15/8/6.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDataModel : NSObject

/*
 0:其他
 1:男
 2:女
 
 1:模特
 2:摄影师
 3:化妆师
 4:经纪人
 5:其他
 
 1:照片面试
 2:现场面试
 
 
 */

@property (copy, nonatomic) NSString *activityTitle;
@property (copy, nonatomic) NSString *startTime;
@property (copy, nonatomic) NSString *endTime;
@property (copy, nonatomic) NSString *cityName;
@property (copy, nonatomic) NSString *province;
@property (copy, nonatomic) NSString *cityCode;
@property (copy, nonatomic) NSString *addressDetail;
@property (copy, nonatomic) NSString *baomingTime;

@property (copy, nonatomic) NSString *activityJobType;
@property (copy, nonatomic) NSString *activityPeopleCount;
@property (copy, nonatomic) NSString *sexType;
@property (copy, nonatomic) NSString *mianshiType;
@property (copy, nonatomic) NSString *money;

@property (copy, nonatomic) NSString *activityDescription;



+ (instancetype)sharedInstance;


- (void)clearData;

- (void)nslogData;

@end
