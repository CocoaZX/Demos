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

#import "EMChatViewCell.h"
#import "EMChatVideoBubbleView.h"
#import "UIResponder+Router.h"

#import "EMChatDaShangView.h"
#import "EMChatGoldCoinBubbleView.h"

#import "EMChatSystemMsgView.h"

NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";

@implementation EMChatViewCell

- (id)initWithMessageModel:(MessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //self.backgroundColor = [UIColor yellowColor];
        //系统消息不需要继续设置
        if(model.type == eMessageBodyType_system){
            return self;
        }
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = 3.0;
    }
    return self;
}




#pragma mark - 布局
-(void)layoutSubviews
{
    [super layoutSubviews];
    CGRect bubbleFrame = _bubbleView.frame;
    //系统消息的设置
    if (self.messageModel.type == eMessageBodyType_system) {
        bubbleFrame.origin.x = CELLPADDING*3;
        _bubbleView.frame = bubbleFrame;
        return;
    }
    //金币打赏
    if (self.messageModel.type == eMessageBodyType_GoldCoin) {
        CGFloat width = [EMChatGoldCoinBubbleView getWidthGoldCoinBubbleView:_messageModel];
        bubbleFrame = CGRectMake(bubbleFrame.origin.x, bubbleFrame.origin.y , width, bubbleFrame.size.height);
    }

    //气泡的坐标
    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
    
    //本人发送
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        _hasRead.hidden = YES;
        switch (self.messageModel.status) {
            case eMessageDeliveryState_Delivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case eMessageDeliveryState_Delivered:
            {
                [_activtiy stopAnimating];
                [_retryButton setHidden:YES];
                if (self.messageModel.message.isReadAcked)
                {
                    _activityView.hidden = NO;
                    _hasRead.hidden = NO;
                }
                else
                {
                    [_activityView setHidden:YES];
                }
            }
                break;
            case eMessageDeliveryState_Pending:
            case eMessageDeliveryState_Failure:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        if (_hasRead.hidden)
        {
            frame.size.width = SEND_STATUS_SIZE;
        }
        else
        {
            frame.size.width = _hasRead.frame.size.width;
        }
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }
    //对方发送
    else{
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
        //群聊
        if (self.messageModel.messageType != eMessageTypeChat) {
            bubbleFrame.origin.y = NAME_LABEL_HEIGHT + NAME_LABEL_PADDING;
        }
        _bubbleView.frame = bubbleFrame;
    }
}


#pragma mark - set方法
- (void)setMessageModel:(MessageModel *)model
{
    [super setMessageModel:model];
    
    //系统消息，无需设置头像等组件
    if (model.type == eMessageBodyType_system) {
        _bubbleView.model = self.messageModel;
        [_bubbleView sizeToFit];
        return;
    }
    
    //群聊显示昵称
    if (model.messageType != eMessageTypeChat) {
        _nameLabel.text = model.nickName;
        _nameLabel.hidden = model.isSender;
        //_nameLabel.hidden = NO;

    }
    //消息气泡
    _bubbleView.model = self.messageModel;
    [_bubbleView sizeToFit];
    
    [self.headButton addTarget:self action:@selector(gotoPersonalPage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.headButton];
    
    [self setNeedsLayout];
}


#pragma mark - action
//点击头像进入个人主页
- (void)gotoPersonalPage
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (self.messageModel.messageType == eMessageTypeChat) {
        if (!self.messageModel.isSender) {
            uid  = self.messageModel.message.from;
        }
    }else
    {
        if (!self.messageModel.isSender) {
            uid  = self.messageModel.username;
        }
    }
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = @"";
    newMyPage.currentUid = uid;
    newMyPage.sourceVCName = @"chatVC";
    if (self.messageModel.messageType != eMessageTypeChat) {
        //设置个人主页点击私信的跳转需要注意，此为群聊的跳转
        newMyPage.isGroupChat = YES;
    }
    
    
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
}



// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender
{
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}

#pragma mark - private
//继承父类的方法，在初始化视图时即调用
- (void)setupSubviewsForMessageModel:(MessageModel *)messageModel
{
    [super setupSubviewsForMessageModel:messageModel];
    
    if (messageModel.type == eMessageBodyType_system) {
        //系统消息的消息气泡
        _bubbleView = [self bubbleViewForMessageModel:messageModel];
        [self.contentView addSubview:_bubbleView];
        return;
    }
    
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //        [_retryButton setImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        //[_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        //_hasRead.text = @"已读";
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
    }
    //消息气泡
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
    
    
}

//创建消息气泡
- (EMChatBaseBubbleView *)bubbleViewForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [[EMChatTextBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Image:
        {
            EMChatImageBubbleView *tempView =  [[EMChatImageBubbleView alloc] init];
             return tempView;
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [[EMChatAudioBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [[EMChatLocationBubbleView alloc] init];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [[EMChatVideoBubbleView alloc] init];
        }
            break;
        //新增约拍类型
        case eMessageBodyType_YuePai:
        {
            float Twidth =  YUEPAIVIEWWIDTH;
            float Theight = YUEPAIVIEWHEIGHT;

            NSString *type = getSafeString(messageModel.message.ext[@"objectType"]);
            if ([type isEqualToString:@"4"]) {
                NSString *typeStep = getSafeString(messageModel.message.ext[@"step"]);
                if ([typeStep isEqualToString:@"2"]) {
                    CGSize size = [EMChatYuePaiView getYuePaiStepTwoBubbleHeight:messageModel];
                    return [[EMChatYuePaiView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                 }
            }
            
            return [[EMChatYuePaiView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
        }
            break;
        //旧版：打赏类型
        case eMessageBodyType_DaShang:
        {
            float Twidth =  DASHANGVIEWWIDTH;
            float Theight = DASHANGVIEWHEIGHT;
            
            //取出文案，设置打赏红包的的提示说明
            //计算文字宽度
            NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
            NSString *descriptionTxt = [descriptionDic objectForKey:@"reward_chat"];
            //测试
            //descriptionTxt = @"图片打赏红包图片图片";
            NSLog(@"%@",descriptionTxt);
            if (descriptionTxt.length == 0) {
                descriptionTxt = @"图片打赏红包";
                Twidth = DASHANGVIEWWIDTH;
            }else{
                //计算文字的宽度
                CGFloat width  = [SQCStringUtils getCustomWidthWithText:descriptionTxt viewHeight:Theight/2 textSize:16];
                if (width > DASHANGVIEWWIDTH) {
                    Twidth = width +5+CELLPADDING/2;
                }else{
                    Twidth = DASHANGVIEWWIDTH;
                }
            }
            
            //添加钱包图片的宽度和箭头的宽度
            Twidth += (30 +CELLPADDING) +CELLPADDING/2;
            //返回一个显示打赏的视图
            return [[EMChatDaShangView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
        }
            break;
        //新版本打赏：打赏金币类型
        case eMessageBodyType_GoldCoin:
        {
            float Twidth =  DASHANGVIEWWIDTH;
            float Theight = DASHANGVIEWHEIGHT;
            //取出文案，设置打赏红包的的提示说明
            /*
            //计算文字宽度
            NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
            NSString *descriptionTxt = [descriptionDic objectForKey:@"reward_chat"];
            //测试
            //descriptionTxt = @"图片打赏红包图片图片";
            NSLog(@"%@",descriptionTxt);
            if (descriptionTxt.length == 0) {
                descriptionTxt = @"图片打赏红包";
                Twidth = DASHANGVIEWWIDTH;
            }else{
                //计算文字的宽度
                CGFloat width  = [SQCStringUtils getCustomWidthWithText:descriptionTxt viewHeight:Theight/2 textSize:16];
                if (width > DASHANGVIEWWIDTH) {
                    Twidth = width +5+CELLPADDING/2;
                }else{
                    Twidth = DASHANGVIEWWIDTH;
                }
            }
            */
            //添加钱包图片的宽度和箭头的宽度
            //Twidth += (30 +CELLPADDING) +CELLPADDING/2;
            
            //返回一个显示打赏的视图
            return [[EMChatGoldCoinBubbleView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
        }
            break;

        //新增系统消息类型
        case eMessageBodyType_system:
        {
            return [[EMChatSystemMsgView alloc] initWithFrame:CGRectMake(CELLPADDING *3, 0, SYSTEMVIEWWIDTH, 0)];
        }
            break;
        //套系
        case eMessageBodyType_TaoXi:
        {
            float Twidth =  YUEPAIVIEWWIDTH;
            float Theight = YUEPAIVIEWHEIGHT;
            
            NSString *type = getSafeString(messageModel.message.ext[@"objectType"]);
            if ([type isEqualToString:@"10"]) {
                NSString *typeStep = getSafeString(messageModel.message.ext[@"step"]);
                if ([typeStep isEqualToString:@"2"]) {
                    CGSize size = [EMChatYuePaiView getYuePaiStepTwoBubbleHeight:messageModel];
                    return [[EMChatYuePaiView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
                }
            }
            return [[EMChatYuePaiView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];

        }
        default:
            break;
    }
    
    return nil;
}

//返回消息气泡的高度
+ (CGFloat)bubbleViewHeightForMessageModel:(MessageModel *)messageModel
{
    switch (messageModel.type) {
        case eMessageBodyType_Text:
        {
            return [EMChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Image:
        {
            return [EMChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Voice:
        {
            return [EMChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Location:
        {
            return [EMChatLocationBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case eMessageBodyType_Video:
        {
            return [EMChatVideoBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        //新增约拍类型
        case eMessageBodyType_YuePai:
        {
            return [EMChatYuePaiView heightForBubbleWithObject:messageModel];
        }
            break;
        //新增打赏
        case eMessageBodyType_DaShang:
        {
            return [EMChatDaShangView heightForBubbleWithObject:messageModel];
        }
            break;
        //新增打赏金币
        case eMessageBodyType_GoldCoin:
        {
            return [EMChatGoldCoinBubbleView heightForBubbleWithObject:messageModel];
        }
            break;

        //新增系统消息
        case eMessageBodyType_system:
        {
            return [EMChatSystemMsgView heightForBubbleWithObject:messageModel];
        }
            break;
        //套系
        case eMessageBodyType_TaoXi:
        {
            return [EMChatYuePaiView heightForBubbleWithObject:messageModel];
        }
        default:
            break;
    }
    
    return HEAD_SIZE;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(MessageModel *)model
{
    NSDictionary *dic = model.message.ext;
    if (dic.allKeys.count>0) {
        NSString *type = getSafeString(dic[@"objectType"]);
        //约拍单元格高度
        if ([type isEqualToString:@"4"]) {
            //约拍step
            NSString *typeStep = getSafeString(dic[@"step"]);
            if([typeStep isEqualToString:@"1"]){
                return YUEPAIVIEWHEIGHT*1.2;
            }
        }
        //旧版本：打赏图片单元格的高度
        if([type isEqualToString:@"2"]){
            if (model.isSender) {
                return DASHANGVIEWHEIGHT +CELLPADDING *2;
            }else{
                //对方发送，显示了昵称
                return DASHANGVIEWHEIGHT +CELLPADDING *2 +CELLPADDING;
            }
        }
        //新版本：打赏金币
        if([type isEqualToString:@"3"]){
            if (model.isSender) {
                return DASHANGVIEWHEIGHT +CELLPADDING *2;
            }else{
                //对方发送，显示了昵称
                return DASHANGVIEWHEIGHT +CELLPADDING *2 +CELLPADDING;
            }
        }

        //系统消息单元格
        if([type isEqualToString:@"0"]){
            return [self bubbleViewHeightForMessageModel:model]+CELLPADDING;
        }
        //套系单元格高度
        if ([type isEqualToString:@"10"]) {
            //套系step
            NSString *typeStep = getSafeString(dic[@"step"]);
            if([typeStep isEqualToString:@"1"]){
                return YUEPAIVIEWHEIGHT*1.2;
            }
        }

    }
    
    NSInteger bubbleHeight = [self bubbleViewHeightForMessageModel:model];
    NSInteger headHeight = HEAD_PADDING * 2 + HEAD_SIZE;
    if ((model.messageType != eMessageTypeChat) && !model.isSender) {
        headHeight += NAME_LABEL_HEIGHT;
    }
    return MAX(headHeight, bubbleHeight + NAME_LABEL_HEIGHT + NAME_LABEL_PADDING) + CELLPADDING;
}



- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}




@end
