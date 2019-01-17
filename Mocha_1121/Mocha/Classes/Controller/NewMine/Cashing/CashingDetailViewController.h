//
//  CashingDetailViewController.h
//  Mocha
//
//  Created by 小猪猪 on 15/12/12.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface CashingDetailViewController : McBaseViewController

@property (copy, nonatomic) NSString *currentName;
@property (copy, nonatomic) NSString *currentMoney;

@property (assign, nonatomic) BOOL isChongZhi;

@end
