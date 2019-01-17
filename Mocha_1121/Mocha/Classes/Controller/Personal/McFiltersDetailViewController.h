//
//  McFiltersDetailViewController.h
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McSeachConditions.h"

@interface McFiltersDetailViewController : McBaseViewController

@property (nonatomic, strong) McSeachConditions *filterData;
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;

- (instancetype)initWithType:(int)type;

@end
