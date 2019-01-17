/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>
#import "EMChatManagerDefs.h"
#import "ChatViewController.h"
#import "McBaseViewController.h"
@protocol ChatViewControllerDelegate <NSObject>

- (NSString *)avatarWithChatter:(NSString *)chatter;
- (NSString *)nickNameWithChatter:(NSString *)chatter;

@end

@interface ChatViewController : McBaseViewController
@property (strong, nonatomic, readonly) NSString *chatter;
@property (copy, nonatomic) NSString *fromHeaderURL;
@property (copy, nonatomic) NSString *toHeaderURL;

//tableView数据源
@property (strong, nonatomic) NSMutableArray *dataSource;
@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic) BOOL isInvisible;
@property (nonatomic, assign) id <ChatViewControllerDelegate> delelgate;

//moka号
@property (nonatomic,copy)NSString *mokaNumber;
@property (nonatomic,strong)ChatViewController *chatVC;

@property (nonatomic,strong)NSDictionary *groupUsersDic;

//预设进入本界面就显示在输入框的文字
@property(nonatomic,strong)NSString *preparedTxt;

- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup;
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type;

- (void)reloadData;

- (void)hideImagePicker;


- (void)showNotificationWindow:(NSDictionary *)diction;

//判断是否可以聊天
- (BOOL)chatIsAviliable;

@end
