//
//  McEditAreaViewController.h
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McPersonalData.h"
#import "McSeachConditions.h"

@interface McEditAreaViewController : McBaseViewController


@property (nonatomic, strong) McPersonalData *personalData;
@property (nonatomic, strong) McSeachConditions *filterData;
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary; //组合参数
@property (nonatomic, assign) NSInteger editOrSearch;//区别：编辑和筛选

@end
