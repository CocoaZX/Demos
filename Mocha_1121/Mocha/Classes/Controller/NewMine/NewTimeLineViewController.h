//
//  NewTimeLineViewController.h
//  Mocha
//
//  Created by sunqichao on 15/9/5.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface NewTimeLineViewController : McBaseViewController

@property (copy, nonatomic) NSString *uid;

@property (copy, nonatomic) NSString *lastIndexId;



@property (copy, nonatomic) NSString *lastLastIndexId;

@property (copy, nonatomic) NSString *currentTitle;

@end
