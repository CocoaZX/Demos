//
//  YuePaiPayViewController.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface YuePaiPayViewController : McBaseViewController

@property (strong, nonatomic) NSDictionary *diction;

@property (assign, nonatomic) BOOL isNeedPay;

@property (assign, nonatomic) BOOL isFrowStart;
@property (assign, nonatomic) BOOL isTaoXi;
@property (copy, nonatomic) NSString *nameStr;
@property (copy, nonatomic) NSString *taoXiName;

@end
