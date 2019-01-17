//
//  NewActivityGroupNotSignViewController.h
//  Mocha
//
//  Created by sun on 15/8/27.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface NewActivityGroupNotSignViewController : McBaseViewController

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *chatId;
@property (nonatomic, copy) NSString *chatTitle;

//活动类型
@property (nonatomic,assign)NSInteger typeNum;
//活动信息
@property (nonatomic,strong)NSDictionary *dataDic;

@end
