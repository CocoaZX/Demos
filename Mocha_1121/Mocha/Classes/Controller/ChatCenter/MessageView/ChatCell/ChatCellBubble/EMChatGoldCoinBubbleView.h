//
//  EMChatGoldCoinBubbleView.h
//  Mocha
//
//  Created by zhoushuai on 16/3/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatBaseBubbleView.h"

extern NSString *const kRouterEventGoldCoinBubbleTapEventName;

@interface EMChatGoldCoinBubbleView : EMChatBaseBubbleView

@property (strong, nonatomic) UIView *backView;
@property (assign, nonatomic) BOOL isSender;

//钱包图片
@property (nonatomic,strong)UIImageView *qianImgView;
//箭头
@property (nonatomic,strong)UIImageView *arrowImgView;
//内容视图
@property (nonatomic,strong)UIView *contentView;

//一个填充区域，避免设置圆角带来的影响
@property (nonatomic,strong)UILabel *paddingLabel;
@property (nonatomic,strong)UILabel *topLabel;
@property (nonatomic,strong)UILabel *downLabel;


+(CGFloat)getWidthGoldCoinBubbleView:(MessageModel *)mode;
@end
