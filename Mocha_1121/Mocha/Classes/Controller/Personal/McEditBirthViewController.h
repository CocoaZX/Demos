//
//  McEditBirthViewController.h
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McPersonalData.h"



@interface McEditBirthViewController : McBaseViewController

@property (nonatomic, strong) McPersonalData *personalData;
@property (nonatomic, assign) BOOL isFromYuePai;
@property (nonatomic, copy) NSString *titleString;

@property (nonatomic, copy) ChangeFinishBlock returenBlock;

- (void)setCallBack:(ChangeFinishBlock)block;

- (instancetype)initWithType:(int)type;

@end
