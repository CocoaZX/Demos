//
//  EMChatSystemMsgView.m
//  Mocha
//
//  Created by zhoushuai on 16/1/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "EMChatSystemMsgView.h"
#import "EMChatViewBaseCell.h"

@implementation EMChatSystemMsgView


- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化视图
        self.backgroundColor = [CommonUtils colorFromHexString:@"d9d9d9"];
        [self _initViews];
    }
    return self;
}



- (void)_initViews{
//    _backView = [[UIView alloc] initWithFrame:self.frame];
//    ;
//    [self addSubview:_backView];
    
    //显示系统消息
    _systemMsgLabel  = [[UILabel alloc] initWithFrame:CGRectZero];
    //_systemMsgLabel.backgroundColor = [CommonUtils colorFromHexString:@"e7e7e7"];
    [self addSubview:_systemMsgLabel];
}


//点击的处理
-(void)bubbleViewPressed:(id)sender
{
//    [self routerEventWithName:kRouterEventDashangBubbleTapEventName
//                     userInfo:@{KMESSAGEKEY:self.model}];
}



//重新布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    NSString *systemMsg = self.model.content;
    systemMsg  = _model.content;
    //计算高度
    CGFloat height  = [SQCStringUtils getCustomHeightWithText:systemMsg viewWidth:SYSTEMVIEWWIDTH -CELLPADDING *2 textSize:14];
    self.height = height+2*CELLPADDING;
    _systemMsgLabel.textColor = [UIColor whiteColor];
    _systemMsgLabel.font = [UIFont systemFontOfSize:14];
    //自动换行
    _systemMsgLabel.numberOfLines = 0;
    //_systemMsgLabel.textAlignment = NSTextAlignmentCenter;
    _systemMsgLabel.frame = CGRectMake(CELLPADDING, CELLPADDING,SYSTEMVIEWWIDTH -CELLPADDING *2, height);
    _systemMsgLabel.text = systemMsg;
    
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;

}



#pragma mark - setter
- (void)setModel:(MessageModel *)model{
    [super setModel:model];
    [self setNeedsLayout];
}

//返回高度
+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
//    CGSize retSize = object.size;
//    if (retSize.width == 0 || retSize.height == 0) {
//        retSize.width = MAX_SIZE;
//        retSize.height = MAX_SIZE;
//    }else if (retSize.width > retSize.height) {
//        CGFloat height =  MAX_SIZE / retSize.width  *  retSize.height;
//        retSize.height = height;
//        retSize.width = MAX_SIZE;
//    }else {
//        CGFloat width = MAX_SIZE / retSize.height * retSize.width;
//        retSize.width = width;
//        retSize.height = MAX_SIZE;
//    }
//    return 2 * BUBBLE_VIEW_PADDING + DASHANGVIEWHEIGHT;
    NSString *systemMsg  = object.content;
    CGFloat height = [SQCStringUtils getCustomHeightWithText:systemMsg viewWidth:SYSTEMVIEWWIDTH -CELLPADDING *2 textSize:14];
    
    //上下留有空隙
    return height +CELLPADDING *2;
}



@end
