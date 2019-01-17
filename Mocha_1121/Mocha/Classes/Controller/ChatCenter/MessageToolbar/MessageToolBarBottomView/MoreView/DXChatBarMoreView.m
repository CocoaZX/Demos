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

#import "DXChatBarMoreView.h"

#define CHAT_BUTTON_SIZE 50
#define INSETS 8

@implementation DXChatBarMoreView

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupSubviewsForType:type];
    }
    return self;
}

- (void)setupSubviewsForType:(ChatMoreType)type
{
    self.backgroundColor = [UIColor clearColor];
    CGFloat insets = (self.frame.size.width - 4 * CHAT_BUTTON_SIZE) / 5;
    
    //图片按钮
    _photoButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_photoButton setFrame:CGRectMake(insets, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +24)];
    [_photoButton setImage:[UIImage imageNamed:@"chatBar_more_photo"] forState:UIControlStateNormal];
    //图片按钮提示
    [_photoButton setTitle:@"图片" forState:UIControlStateNormal];
    [_photoButton setImageEdgeInsets:UIEdgeInsetsMake(-24, 0, 0, 0)];
    [_photoButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -50, 0, 0)];
    _photoButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_photoButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_photoButton];


    //地址按钮
    _locationButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_locationButton setFrame:CGRectMake(insets * 2 + CHAT_BUTTON_SIZE, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +24)];
    [_locationButton setImage:[UIImage imageNamed:@"chatBar_more_location"] forState:UIControlStateNormal];
    //地址按钮提示
    [_locationButton setTitle:@"位置" forState:UIControlStateNormal];
    [_locationButton setImageEdgeInsets:UIEdgeInsetsMake(-24, 0, 0, 0)];
    [_locationButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -50, 0, 0)];
    _locationButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_locationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_locationButton addTarget:self action:@selector(locationAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_locationButton];
    
    
    //拍照按钮
    _takePicButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [_takePicButton setFrame:CGRectMake(insets * 3 + CHAT_BUTTON_SIZE * 2, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +24)];
    [_takePicButton setImage:[UIImage imageNamed:@"chatBar_more_camera"] forState:UIControlStateNormal];
    [_takePicButton setTitle:@"相机" forState:UIControlStateNormal];
    [_takePicButton setImageEdgeInsets:UIEdgeInsetsMake(-24, 0, 0, 0)];
    [_takePicButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -50, 0, 0)];
    //拍照按钮提示
    _takePicButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_takePicButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_takePicButton addTarget:self action:@selector(takePicAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_takePicButton];

    CGRect frame = self.frame;
    if (type == ChatMoreTypeChat) {
        /*
        frame.size.height = 150;
        _audioCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_audioCallButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCall"] forState:UIControlStateNormal];
        [_audioCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_audioCallSelected"] forState:UIControlStateHighlighted];
        [_audioCallButton addTarget:self action:@selector(takeAudioCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_audioCallButton];
        
        _videoCallButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [_videoCallButton setFrame:CGRectMake(insets, 10 * 2 + CHAT_BUTTON_SIZE + 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE)];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCall"] forState:UIControlStateNormal];
        [_videoCallButton setImage:[UIImage imageNamed:@"chatBar_colorMore_videoCallSelected"] forState:UIControlStateHighlighted];
        [_videoCallButton addTarget:self action:@selector(takeVideoCallAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_videoCallButton];
         */
        
        //如果是私聊的话，就增加约拍的按钮
        
        BOOL isAppearYuePai = [USER_DEFAULT boolForKey:@"covenantEnable"];
        if (isAppearYuePai) {
            _yuePaiButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [_yuePaiButton setFrame:CGRectMake(insets * 4 + CHAT_BUTTON_SIZE * 3, 10, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +24)];
            [_yuePaiButton setImage:[UIImage imageNamed:@"chatBar_more_yuepai"] forState:UIControlStateNormal];
            [_yuePaiButton setTitle:@"约拍" forState:UIControlStateNormal];
            [_yuePaiButton setImageEdgeInsets:UIEdgeInsetsMake(-24, 0, 0, 0)];
            [_yuePaiButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -50, 0, 0)];
            //拍照按钮提示
            _yuePaiButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_yuePaiButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_yuePaiButton addTarget:self action:@selector(yuePaiAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_yuePaiButton];
            
            
            //打赏
            _daShangButton =[UIButton buttonWithType:UIButtonTypeCustom];
            [_daShangButton setFrame:CGRectMake(insets * 1 + CHAT_BUTTON_SIZE * 0, 10 +(CHAT_BUTTON_SIZE+ 24 +10) *1, CHAT_BUTTON_SIZE , CHAT_BUTTON_SIZE +24)];
            [_daShangButton setImage:[UIImage imageNamed:@"chatBar_more_yuepai"] forState:UIControlStateNormal];
            [_daShangButton setTitle:@"打赏" forState:UIControlStateNormal];
            [_daShangButton setImageEdgeInsets:UIEdgeInsetsMake(-24, 0, 0, 0)];
            [_daShangButton setTitleEdgeInsets:UIEdgeInsetsMake(50, -50, 0, 0)];
            //拍照按钮提示
            _daShangButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [_daShangButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [_daShangButton addTarget:self action:@selector(daShangAction) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_daShangButton];
        }

    }
    else if (type == ChatMoreTypeGroupChat)
    {
        frame.size.height = 80;
    }
    frame.size.height = 200;
    self.frame = frame;
}

#pragma mark - 按钮的响应事件处理
//获取图片
- (void)takePicAction{
    if(_delegate && [_delegate respondsToSelector:@selector(moreViewTakePicAction:)]){
        [_delegate moreViewTakePicAction:self];
    }
}

//照相机
- (void)photoAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewPhotoAction:)]) {
        [_delegate moreViewPhotoAction:self];
    }
}

//地理位置
- (void)locationAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewLocationAction:)]) {
        [_delegate moreViewLocationAction:self];
    }
}

//
- (void)takeAudioCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewYuePaiAction:)]) {
        [_delegate moreViewYuePaiAction:self];
    }
}

//约拍
- (void)yuePaiAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewYuePaiAction:)]) {
        [_delegate moreViewYuePaiAction:self];
    }
}


//视频
- (void)takeVideoCallAction
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewVideoCallAction:)]) {
        [_delegate moreViewVideoCallAction:self];
    }
}


//打赏
- (void)daShangAction{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewDaShangAction:)]) {
        [_delegate moreViewDaShangAction:self];
    }
}





@end
