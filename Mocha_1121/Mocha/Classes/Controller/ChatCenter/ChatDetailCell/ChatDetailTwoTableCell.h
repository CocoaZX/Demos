//
//  ChatDetailTwoTableCell.h
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailGroupViewController.h"
@interface ChatDetailTwoTableCell : UITableViewCell

//选择开关群消息免打扰
@property (nonatomic,)UISwitch *switchView;

//群聊的id
@property (nonatomic,copy)NSString *groupID;

//所在视图控制器
@property (nonatomic,strong)ChatDetailGroupViewController *chatGropupVC;

////是否是群主
//@property (nonatomic,assign)NSInteger isOwer;
//
////是否开启了群消消息免打扰
//@property (nonatomic,copy)NSString * noturb;

@end
