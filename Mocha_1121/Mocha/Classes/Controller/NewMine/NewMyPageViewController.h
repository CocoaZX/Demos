//
//  NewMyPageViewController.h
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"
#import "ChatViewController.h"
#import "NewPersonalHeaderView.h"
@interface NewMyPageViewController : McBaseViewController

@property (copy, nonatomic) NSString *currentTitle;

@property (copy, nonatomic) NSString *currentUid;
@property (copy, nonatomic) NSString *currentName;

@property (copy, nonatomic) NSString *mokaNumber;

//从哪个视图控制器进入的
@property (copy,nonatomic) NSString *sourceVCName;

//从聊天VC中进入个人主页,区分聊天的类型，是否是群聊
@property (nonatomic,assign)BOOL isGroupChat;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NewPersonalHeaderView *headerView;

//粉丝block
@property (nonatomic , copy)void(^fensiBlock)(NSString *changeStr);

@property (nonatomic , assign)BOOL isAppearShare;

//-(void)downloadMcWithImage:(UIImage *)cellImage width:(CGFloat)width height:(CGFloat)height;
-(void)downloadMcWithImage:(UIImage *)cellImage width:(CGFloat)width height:(CGFloat)height withButton:(UIButton *)btn;

-(void)sharedMcWithImage:(UIImage *)cellImage width:(CGFloat)width height:(CGFloat)mokaHeight;




@end
