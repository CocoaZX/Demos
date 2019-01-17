//
//  JinBiViewController.h
//  Mocha
//
//  Created by yfw－iMac on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface JinBiViewController : McBaseViewController

@property (assign, nonatomic) BOOL isChongZhi;
@property (copy, nonatomic) NSString *currentHeadImage;
@property (copy, nonatomic) NSString *currentName;
@property (copy, nonatomic) NSString *currentMoney;

@end
