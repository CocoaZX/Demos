//
//  EMChatDaShangView.m
//  Mocha
//
//  Created by zhoushuai on 16/1/11.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "EMChatDaShangView.h"
#import "EMChatViewBaseCell.h"
#import "EMChatImageBubbleView.h"

NSString *const kRouterEventDashangBubbleTapEventName = @"kRouterEventDashangBubbleTapEventName";

@implementation EMChatDaShangView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //初始化视图
        [self _initViews];
     }
    return self;
}



- (void)_initViews{
    _backView = [[UIView alloc] initWithFrame:self.frame];
    ;
    [self addSubview:_backView];
    //钱包图片
    _qianImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_qianImgView];
    //箭头
    _arrowImgView  = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self addSubview:_arrowImgView];
    //内容视图
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    _contentView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    [self addSubview:_contentView];

    
    //由于设置了圆角所以需要一个调整视图，使得和钱图片相接的部分不圆角
    _paddingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self addSubview:_paddingLabel];
    _paddingLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _paddingLabel.layer.cornerRadius = 5;
    _paddingLabel.layer.masksToBounds = YES;
    [self addSubview:_paddingLabel];
    
    //内容视图上的组件
    _topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_contentView addSubview:_topLabel];
    _topLabel.textColor  = [UIColor whiteColor];
    
    _downLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _downLabel.textColor = [UIColor whiteColor];
    [_contentView addSubview:_downLabel];
    
 }


//点击的处理
-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventDashangBubbleTapEventName
                     userInfo:@{KMESSAGEKEY:self.model}];
}



//重新布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    //清楚子视图
//    for (UIView *view in self.subviews) {
//        [view removeFromSuperview];
//     }
    //[self _initViews];

    if(_isSender){
        _qianImgView.frame = CGRectMake(0, 0, 30, DASHANGVIEWHEIGHT);
        //减去的宽度有钱包图片宽度、箭头宽度,用于填充颜色的lable宽度
        _contentView.frame = CGRectMake(30, 0, self.width -30-CELLPADDING -CELLPADDING/2, DASHANGVIEWHEIGHT);
        _paddingLabel.frame = CGRectMake(_contentView.right-CELLPADDING/2, 0,CELLPADDING, DASHANGVIEWHEIGHT);
        //箭头
        _arrowImgView.frame = CGRectMake(_paddingLabel.right , 10, CELLPADDING, CELLPADDING);
        
        _topLabel.frame  = CGRectMake(5, 0, _contentView.width -5-CELLPADDING/2, DASHANGVIEWHEIGHT/2);
        _downLabel.frame  = CGRectMake(5, DASHANGVIEWHEIGHT/2, _contentView.width -5-CELLPADDING/2, DASHANGVIEWHEIGHT/2);
        _topLabel.textAlignment = NSTextAlignmentLeft;
        _downLabel.textAlignment = NSTextAlignmentLeft;

        _qianImgView.image = [UIImage imageNamed:@"chat_qian_left"];
        _arrowImgView.image = [UIImage imageNamed:@"chat_qian_rightArrow"];
        
        NSDictionary *dic  = _model.message.ext;
        _topLabel.text= [NSString stringWithFormat:@"%@元",dic[@"money"]];
        _downLabel.text = [self getDownLabelTxt];

    }else{
        
        //箭头
        _arrowImgView.frame = CGRectMake(0 , 10, CELLPADDING, CELLPADDING);
        _paddingLabel.frame = CGRectMake(_arrowImgView.right, 0, CELLPADDING, DASHANGVIEWHEIGHT);
        //减去的宽度有钱包图片宽度、箭头宽度,用于填充颜色的lable宽度
        _contentView.frame = CGRectMake(CELLPADDING +CELLPADDING/2, 0, self.width -30-CELLPADDING -CELLPADDING/2, DASHANGVIEWHEIGHT);
        
        _qianImgView.frame = CGRectMake(_contentView.right, 0, 30, DASHANGVIEWHEIGHT);
        
        _topLabel.frame  = CGRectMake(0, 0, _contentView.width -5-CELLPADDING/2, DASHANGVIEWHEIGHT/2);
        _downLabel.frame  = CGRectMake(0, DASHANGVIEWHEIGHT/2, _contentView.width -5-CELLPADDING/2, DASHANGVIEWHEIGHT/2);
        _topLabel.textAlignment = NSTextAlignmentRight;
        _downLabel.textAlignment = NSTextAlignmentRight;

        _qianImgView.image = [UIImage imageNamed:@"chat_qian_right"];
        _arrowImgView.image = [UIImage imageNamed:@"chat_qian_leftArrow"];
        NSDictionary *dic  = _model.message.ext;
        _topLabel.text= [NSString stringWithFormat:@"%@元",dic[@"money"]];
        _downLabel.text = [self getDownLabelTxt];

    }
    
    _downLabel.font = [UIFont systemFontOfSize:16];

    
}



#pragma mark - setter
- (void)setModel:(MessageModel *)model{
    [super setModel:model];
    self.isSender = model.isSender;
    [self setNeedsLayout];
    
//    NSString *type = getSafeString(@"14");
//    if ([type isEqualToString:@"14"]) {
//        UIView *imgView = [self getDaShangViewWithData:model.message.ext];
//        
//        [_backView addSubview:imgView];
//    }


}


//获取到打赏的自定义视图
-(UIView *)getDaShangViewWithData:(NSDictionary *)dic{
    
    float Twidth =  DASHANGVIEWWIDTH;
    float Theight = DASHANGVIEWHEIGHT;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
    view.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    UILabel *topLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/2)];
    topLabel.textColor = [UIColor whiteColor];
    topLabel.text = @"10元";
    [view addSubview:topLabel];
    
    UILabel *downLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, Theight/2, Twidth, Theight/2)];
    downLabel.text = @"图片打赏红包";
    downLabel.font = [UIFont systemFontOfSize:15];
    downLabel.textColor = [UIColor whiteColor];
    [view addSubview:downLabel];
    
    view.layer.borderWidth = 1;
    view.layer.borderColor = RGB(210, 210, 210).CGColor;
    view.layer.cornerRadius = 5;
    view.layer.masksToBounds = YES;
    return view;
    
}

//返回高度
+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    CGSize retSize = object.size;
    if (retSize.width == 0 || retSize.height == 0) {
        retSize.width = MAX_SIZE;
        retSize.height = MAX_SIZE;
    }else if (retSize.width > retSize.height) {
        CGFloat height =  MAX_SIZE / retSize.width  *  retSize.height;
        retSize.height = height;
        retSize.width = MAX_SIZE;
    }else {
        CGFloat width = MAX_SIZE / retSize.height * retSize.width;
        retSize.width = width;
        retSize.height = MAX_SIZE;
    }
    return 2 * BUBBLE_VIEW_PADDING + DASHANGVIEWHEIGHT;
}

/*
 //取出文案，设置打赏红包的的提示说明
 //计算文字宽度
 NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
 NSString *descriptionTxt = [descriptionDic objectForKey:@"reward_chat"];
 NSLog(@"%@",descriptionTxt);
 if (descriptionTxt.length == 0) {
 descriptionTxt = @"图片打赏红包";
 Twidth = kDeviceWidth;
 }else{
 //计算文字的宽度
 CGFloat width  = [SQCStringUtils getCustomWidthWithText:descriptionTxt viewHeight:Theight/2 textSize:15];
 if (width > DASHANGVIEWWIDTH) {
 Twidth = width +10;
 }
 }
 
 //添加钱包图片的宽度和箭头的宽度
 Twidth += (30 +CELLPADDING);

 */



- (NSString *)getDownLabelTxt{
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSString *descriptionTxt = [descriptionDic objectForKey:@"reward_chat"];
    NSLog(@"%@",descriptionTxt);
    if (descriptionTxt.length == 0) {
        descriptionTxt = @"图片打赏红包";
    }
    return descriptionTxt;
}



@end
