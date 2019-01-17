//
//  ChatDetailViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "McBaseListViewController.h"

@interface ChatDetailViewController : McBaseListViewController




@property (nonatomic,strong)NSArray *chatArr;

//对方的头像
@property (nonatomic,copy)NSString *headerPic;

//对方的模卡号
@property (nonatomic,copy)NSString *mokaNumber;
//对方的uid
@property (nonatomic,copy)NSString *mokaID;
//对方的名字
@property (nonatomic,copy)NSString *name;

@property (nonatomic,strong)ChatViewController *chatVC;

//是否已经将对方拉黑
@property (nonatomic,assign)BOOL isBlack;

@end
