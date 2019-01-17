//
//  EMChatYuePaiView.m
//  Mocha
//
//  Created by yfw－iMac on 15/12/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "EMChatYuePaiView.h"
#import "EMChatViewBaseCell.h"
#import "EMChatImageBubbleView.h"
NSString *const kRouterEventYuepaiBubbleTapEventName = @"kRouterEventYuepaiBubbleTapEventName";

@implementation EMChatYuePaiView
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        [self addSubview:_backView];
        //_backView.backgroundColor = [UIColor redColor];
        //self.backgroundColor = [UIColor purpleColor];
    }
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //如果是约拍第二步的单元格，重新调整高度
    NSString *type = getSafeString(self.model.message.ext[@"objectType"]);
    if ([type isEqualToString:@"4"]) {
        NSString *typeStep = getSafeString(self.model.message.ext[@"step"]);
        if ([typeStep isEqualToString:@"2"]) {
            CGSize size = [[self class] getYuePaiStepTwoBubbleHeight:self.model];
            self.width = size.width;
            self.height = size.height;
            _backView.frame = self.bounds;
        }
    }

    
//    CGRect frame = self.bounds;
//    frame.size.width -= BUBBLE_ARROW_WIDTH;
//    frame = CGRectInset(frame, BUBBLE_VIEW_PADDING, BUBBLE_VIEW_PADDING);
//    if (self.model.isSender) {
//        frame.origin.x = BUBBLE_VIEW_PADDING;
//    }else{
//        frame.origin.x = BUBBLE_VIEW_PADDING + BUBBLE_ARROW_WIDTH;
//    }
//    
//    frame.origin.y = BUBBLE_VIEW_PADDING;
//    [self.backView setFrame:frame];
}

#pragma mark - public

-(void)bubbleViewPressed:(id)sender
{
    [self routerEventWithName:kRouterEventYuepaiBubbleTapEventName
                     userInfo:@{KMESSAGEKEY:self.model}];
}

#pragma mark - setter

- (void)setModel:(MessageModel *)model
{
    [super setModel:model];
     self.isSender = model.isSender;

    //清空所有控件
    for (UIView *view in _backView.subviews) {
        [view removeFromSuperview];
    }
    
    NSString *type = getSafeString(model.message.ext[@"objectType"]);
    if ([type isEqualToString:@"4"]) {
        NSString *typeStep = getSafeString(model.message.ext[@"step"]);
        if ([typeStep isEqualToString:@"1"]) {
            self.paiView = [self getYuepaiViewWithData:model.message.ext title:model.content isTaoXi:NO];

        }else if ([typeStep isEqualToString:@"2"])
        {
            //我接受了约拍
            self.paiView = [self getYuepaiAcceptViewWithData:model.message.ext title:model.content];
        }
    }
    if ([type isEqualToString:@"10"]) {
        NSString *typeStep = getSafeString(model.message.ext[@"step"]);
        if ([typeStep isEqualToString:@"1"]) {
            self.paiView = [self getYuepaiViewWithData:model.message.ext title:model.content isTaoXi:YES];
            
        }else if ([typeStep isEqualToString:@"2"])
        {
            //我接受了约拍
            self.paiView = [self getYuepaiAcceptViewWithData:model.message.ext title:model.content];
        }
    }

    
//    CGRect frame = self.paiView.frame;
//    if (self.isSender) {
//        frame.origin.x = -15;
//    }
//    [self.paiView setFrame:frame];
    [_backView addSubview:self.paiView];
    
    [self setNeedsLayout];

}

- (UIView *)getYuepaiViewWithData:(NSDictionary *)diction title:(NSString *)titleString isTaoXi:(BOOL)isTaoXi
{
    float Twidth =  YUEPAIVIEWWIDTH;
    float Theight = YUEPAIVIEWHEIGHT;
    float TFont = 14;
    if (kScreenWidth==320) {
        
    }else if(kScreenWidth==375)
    {
        TFont = 16;
    }else
    {
        TFont = 18;
        
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *partOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/4*3)];
    partOne.backgroundColor = [UIColor whiteColor];
    partOne.layer.borderColor = RGB(210, 210, 210).CGColor;
    partOne.layer.borderWidth = 1;
    partOne.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Twidth-20, Theight/4)];
    titleLabel.text = getSafeString(titleString);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Theight/4, Twidth, 1)];
    lineView.backgroundColor = RGB(210, 210, 210);
    
    UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, Theight/4, 100, Theight/4)];
    if(isTaoXi){
        dateTitle.text = @"专题日期";
    }else{
        dateTitle.text = @"拍摄日期";
    }
    
    dateTitle.textColor = [UIColor darkGrayColor];
    dateTitle.textAlignment = NSTextAlignmentLeft;
    dateTitle.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:dateTitle];
    
    UILabel *dateDesc = [[UILabel alloc] initWithFrame:CGRectMake(Twidth-150-10, Theight/4, 150, Theight/4)];
    dateDesc.text = getSafeString(diction[@"covenantDay"]);
    dateDesc.textColor = [UIColor darkGrayColor];
    dateDesc.textAlignment = NSTextAlignmentRight;
    dateDesc.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:dateDesc];
    
    UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, Theight/4*2, 100, Theight/4)];
    if (isTaoXi) {
        moneyTitle.text = @"专题价格";
    }else{
        moneyTitle.text = @"拍摄价格";
    }
    
    moneyTitle.textColor = [UIColor darkGrayColor];
    moneyTitle.textAlignment = NSTextAlignmentLeft;
    moneyTitle.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:moneyTitle];
    
    UILabel *moneyDesc = [[UILabel alloc] initWithFrame:CGRectMake(Twidth-150-10, Theight/4*2, 150, Theight/4)];
    moneyDesc.text = getSafeString(diction[@"money"]);
    moneyDesc.textColor = [UIColor darkGrayColor];
    moneyDesc.textAlignment = NSTextAlignmentRight;
    moneyDesc.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:moneyDesc];
    
    UIView *partTwo = [[UIView alloc] initWithFrame:CGRectMake(0, Theight/4*3, Twidth, Theight/4)];
    partTwo.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    
    UILabel *mokaTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, Theight/4)];
    mokaTitle.text = @"MOKA约拍";
    if (isTaoXi) {
        mokaTitle.text = @"专题订单";
    }
    mokaTitle.textColor = [UIColor whiteColor];
    mokaTitle.textAlignment = NSTextAlignmentLeft;
    mokaTitle.font = [UIFont systemFontOfSize:TFont];
    [partTwo addSubview:mokaTitle];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Twidth-Theight/4, 8, Theight/4-16, Theight/4-16)];
    imageView.image = [UIImage imageNamed:@"Icon-60.png"];
    [partTwo addSubview:imageView];
    

    [view addSubview:partOne];
    [view addSubview:partTwo];
     
    return view;
}

- (UIView *)getYuepaiAcceptViewWithData:(NSDictionary *)diction title:(NSString *)titleString
{
    //获取buddle的高度
    CGSize size = [[self class] getYuePaiStepTwoBubbleHeight:self.model];
    CGFloat viewWidth = size.width;
    CGFloat viewHeight = size.height;
    //获取文字大小
    float TFont = [[self class] getTxtFont];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0,0 , viewWidth, viewHeight)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *partOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    partOne.backgroundColor = RGB(122, 180, 28);
    partOne.layer.borderColor = RGB(210, 210, 210).CGColor;
    partOne.layer.borderWidth = 1;
    partOne.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CELLPADDING, viewWidth-20, viewHeight-CELLPADDING*2)];
    //titleLabel.backgroundColor = [UIColor grayColor];
    //titleString  = @"测试文字长度";

    titleLabel.text = getSafeString(titleString);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:TFont];
    [partOne addSubview:titleLabel];
    
    //[view addSubview:partOne];
    
    
    return partOne;
    
}

+(CGFloat)heightForBubbleWithObject:(MessageModel *)object
{
    //如果是step2类型的约拍，则使用的此方法返回bubble的高度
    NSString *type = getSafeString(object.message.ext[@"objectType"]);
    if ([type isEqualToString:@"4"]) {
        NSString *typeStep = getSafeString(object.message.ext[@"step"]);
        if ([typeStep isEqualToString:@"2"]) {
            CGSize size = [[self class] getYuePaiStepTwoBubbleHeight:object];
            return size.height;
         }
    }
    
    
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
    return 2 * BUBBLE_VIEW_PADDING + retSize.height;
}


//获取文字大小
+(float)getTxtFont{
    float TFont = 14;
    if (kScreenWidth==320) {
        
    }else if(kScreenWidth==375)
    {
        TFont = 16;
    }else
    {
        TFont = 18;
    }
    return TFont;
}

//获取bubble的高度
+(CGSize)getYuePaiStepTwoBubbleHeight:(MessageModel *)model
{
    //显示的文字
    NSString *titleString = model.content;
    //titleString  = @"测试文字长度";
    float Twidth =  YUEPAIVIEWWIDTH;
    float Theight = 30;
    float TFont = [[self class] getTxtFont];
    
    CGFloat viewWidth = 0;
    //默认使用4分之一的高度
    CGFloat viewHeight = 0;
    //计算文字的长度
    viewWidth = [SQCStringUtils getCustomWidthWithText:titleString viewHeight:Theight textSize:TFont];
    if (viewWidth>Twidth -20) {
        viewWidth = Twidth;
        viewHeight = [SQCStringUtils getCustomHeightWithText:titleString viewWidth:Twidth -20 textSize:TFont];
    }else{
        viewWidth += 20;
        viewHeight = Theight;
    }
    viewHeight += CELLPADDING*2;
    return CGSizeMake(viewWidth, viewHeight);
}



@end
