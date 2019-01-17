//
//  MokaActivityDetailViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface MokaActivityDetailViewController : McBaseViewController

//标题
@property (nonatomic,copy)NSString *vcTitle;

//活动ID
@property (nonatomic, copy) NSString *eventId;

//活动类型:1通告， 2众筹 3海报
@property (nonatomic,assign)NSInteger typeNum;

@end
