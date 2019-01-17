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

#import "MessageModel.h"
#import "EMChatBaseBubbleView.h"

#import "UIResponder+Router.h"

#define HEAD_SIZE 40 // 头像大小
//头像到cell的内间距和头像到bubble的间距
#define HEAD_PADDING 5 

// Cell之间间距
#define CELLPADDING 8

#define YUEPAIVIEWHEIGHT [[[NSUserDefaults standardUserDefaults] objectForKey:@"YUEPAIVIEWHEIGHT"] floatValue] // 约拍图片高度
#define YUEPAIVIEWWIDTH [[[NSUserDefaults standardUserDefaults] objectForKey:@"YUEPAIVIEWWIDTH"] floatValue] // 约拍图片高度

//打赏视图的宽度,默认宽度，具体的值还要根据文案的文字的宽度
#define DASHANGVIEWWIDTH 120
//打赏视图的高度
#define DASHANGVIEWHEIGHT 63
//系统消息的宽度
#define SYSTEMVIEWWIDTH kDeviceWidth -CELLPADDING *6



#define NAME_LABEL_WIDTH 180 // nameLabel最大宽度
#define NAME_LABEL_HEIGHT 20 // nameLabel 高度
#define NAME_LABEL_PADDING 5 // nameLabel间距
#define NAME_LABEL_FONT_SIZE 14 // 字体

extern NSString *const kRouterEventChatHeadImageTapEventName;

@interface EMChatViewBaseCell : UITableViewCell
{
    UIImageView *_headImageView;
    UILabel *_nameLabel;
    EMChatBaseBubbleView *_bubbleView;
    CGFloat _nameLabelHeight;
    MessageModel *_messageModel;
}

//头像
@property (nonatomic, strong) UIImageView *headImageView;

//头像Click
//姓名（暂时不支持显示）
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIButton *headButton;

//内容区域
@property (nonatomic, strong) EMChatBaseBubbleView *bubbleView;
//数据模型
@property (nonatomic, strong) MessageModel *messageModel;

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier;

- (void)setupSubviewsForMessageModel:(MessageModel *)model;

+ (NSString *)cellIdentifierForMessageModel:(MessageModel *)model;

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model;

@end
