//
//  ActivityFilterModel.h
//  Mocha
//
//  Created by sun on 15/8/20.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityFilterModel : NSObject


@property (copy, nonatomic) NSString *filterCity;
@property (copy, nonatomic) NSString *filterProvince;
@property (copy, nonatomic) NSString *filterPaiXu;
@property (copy, nonatomic) NSString *filterFeiYong;
@property (copy, nonatomic) NSString *filterShenFen;
@property (copy, nonatomic) NSString *filterSex;



+ (instancetype)sharedInstance;

- (void)clearData;


- (void)nslogData;

- (BOOL)isFilter;

@end
