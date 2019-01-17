//
//  YuePaiDataSource.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YuePaiDataSource : NSObject<UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL isNeedPay;
@property (nonatomic, assign) UIViewController *controller;
@property (nonatomic, assign) BOOL isTaoXi;

@end
