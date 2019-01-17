//
//  MyMokaCardViewController.h
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface MyMokaCardViewController : McBaseViewController

@property (copy, nonatomic) NSString *currentUid;

@property (copy, nonatomic) NSString *currentTitle;

@property (strong, nonatomic) NSMutableArray *dataArray;


@end
