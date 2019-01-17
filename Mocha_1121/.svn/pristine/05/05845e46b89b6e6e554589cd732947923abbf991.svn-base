//
//  ChatDetailGroupViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatViewController.h"
#import "McBaseListViewController.h"
@interface ChatDetailGroupViewController : McBaseListViewController


//选项
@property (nonatomic,strong)NSArray *chatArr;
//群聊id
@property (nonatomic,copy)NSString *chatter;

//从聊天界面进入，通过其属性，在清空聊天记录时移除消息数组中的消息
@property (nonatomic,strong)ChatViewController *chatVC;

@property (nonatomic,copy)NSString *subject;

//群主id
@property (nonatomic,copy)NSString *owerID;
//群主的信息
@property (nonatomic,strong)NSDictionary *owerDic;

@property (nonatomic,strong)NSMutableArray *members;

//关于活动的数据
@property (nonatomic,strong)NSDictionary *dataDic;

@end
