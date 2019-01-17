//
//  ActivityDataModel.m
//  Mocha
//
//  Created by sun on 15/8/6.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ActivityDataModel.h"

@implementation ActivityDataModel

static ActivityDataModel *dataModel;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataModel = [[ActivityDataModel alloc] init];
        dataModel.activityTitle = @"";
        dataModel.startTime = @"";
        dataModel.endTime = @"";
        dataModel.cityName = @"";
        dataModel.province = @"";
        dataModel.cityCode = @"";
        dataModel.addressDetail = @"";
        dataModel.baomingTime = @"";
        dataModel.activityJobType = @"";
        dataModel.activityPeopleCount = @"";
        dataModel.sexType = @"";
        dataModel.mianshiType = @"";
        dataModel.money = @"";
        dataModel.activityDescription = @"";

    });
    return dataModel;
}



- (void)clearData
{
    self.activityTitle = @"";
    self.startTime = @"";
    self.endTime = @"";
    self.cityName = @"";
    self.province = @"";
    self.cityCode = @"";
    self.addressDetail = @"";
    self.baomingTime = @"";
    self.activityJobType = @"";
    self.activityPeopleCount = @"";
    self.sexType = @"";
    self.mianshiType = @"";
    self.money = @"";
    self.activityDescription = @"";

}

- (void)nslogData
{
    NSLog(@"activityTitle = %@",self.activityTitle);
    NSLog(@"startTime = %@",self.startTime);
    NSLog(@"endTime = %@",self.endTime);
    NSLog(@"cityName = %@",self.cityName);
    NSLog(@"province = %@",self.province);
    NSLog(@"cityCode = %@",self.cityCode);
    NSLog(@"addressDetail = %@",self.addressDetail);
    NSLog(@"baomingTime = %@",self.baomingTime);
    NSLog(@"activityJobType = %@",self.activityJobType);
    NSLog(@"activityPeopleCount = %@",self.activityPeopleCount);
    NSLog(@"sexType = %@",self.sexType);
    NSLog(@"mianshiType = %@",self.mianshiType);
    NSLog(@"money = %@",self.money);
    NSLog(@"activityDescription = %@",self.activityDescription);

}


@end
