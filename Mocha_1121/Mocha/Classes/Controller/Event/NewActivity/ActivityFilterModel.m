//
//  ActivityFilterModel.m
//  Mocha
//
//  Created by sun on 15/8/20.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ActivityFilterModel.h"

@implementation ActivityFilterModel

static ActivityFilterModel *dataModel;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataModel = [[ActivityFilterModel alloc] init];
        dataModel.filterCity = @"";
        dataModel.filterPaiXu = @"";
        dataModel.filterFeiYong = @"";
        dataModel.filterShenFen = @"";
        dataModel.filterSex = @"";

    });
    return dataModel;
}


- (void)clearData
{
    self.filterCity = @"";
    self.filterPaiXu = @"";
    self.filterFeiYong = @"";
    self.filterShenFen = @"";
    self.filterSex = @"";
    
}

- (void)nslogData
{
    NSLog(@"filterCity = %@",self.filterCity);
    NSLog(@"filterPaiXu = %@",self.filterPaiXu);
    NSLog(@"filterFeiYong = %@",self.filterFeiYong);
    NSLog(@"filterShenFen = %@",self.filterShenFen);
    NSLog(@"filterSex = %@",self.filterSex);
    
}

- (BOOL)isFilter
{
    if (self.filterProvince.length>0||self.filterCity.length>0||self.filterPaiXu.length>0||self.filterFeiYong.length>0||self.filterShenFen.length>0||self.filterSex.length>0) {
        return YES;
    }
    return NO;
}


@end
