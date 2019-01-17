//
//  McEditWorkTagsViewController.h
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McPersonalData.h"

@interface McEditWorkTagsViewController : McBaseViewController

@property (nonatomic, strong) McPersonalData *personalData;

- (instancetype)initWithType:(int)type;

@end
