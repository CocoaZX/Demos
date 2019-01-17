//
//  YuePaiDetailViewController.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface YuePaiDetailViewController : McBaseViewController

@property (assign, nonatomic) BOOL isNeedPay;
@property (assign, nonatomic) BOOL isJieShou;

@property (nonatomic, copy) NSString *receiveUid;
@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receiveHeader;

@property (nonatomic, copy) NSString *startUid;
@property (nonatomic, copy) NSString *startName;
@property (nonatomic, copy) NSString *startHeader;
@property (nonatomic, copy) NSString *covenant_id;

@property (nonatomic, copy) NSString *currentUid;
@property (nonatomic, copy) NSString *currentTitle;
@property (nonatomic, copy) NSString *currentHeaderURL;

@property (nonatomic, copy) NSString *taoxiName;

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, assign) BOOL isTaoXi;

@end
