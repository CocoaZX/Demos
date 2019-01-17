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

typedef enum{
    ChatMoreTypeChat,
    ChatMoreTypeGroupChat,
}ChatMoreType;

@protocol DXChatBarMoreViewDelegate;
@interface DXChatBarMoreView : UIView

@property (nonatomic,assign) id<DXChatBarMoreViewDelegate> delegate;

//点击发送图片
@property (nonatomic, strong) UIButton *photoButton;
//点击地址
@property (nonatomic, strong) UIButton *locationButton;
//点击相机
@property (nonatomic, strong) UIButton *takePicButton;
//点击视频
@property (nonatomic, strong) UIButton *videoButton;
//点击约拍
@property(nonatomic,strong)UIButton *yuePaiButton;

//打赏按钮
@property(nonatomic,strong)UIButton *daShangButton;


//点击发送语音
@property (nonatomic, strong) UIButton *audioCallButton;
@property (nonatomic, strong) UIButton *videoCallButton;

- (instancetype)initWithFrame:(CGRect)frame typw:(ChatMoreType)type;

- (void)setupSubviewsForType:(ChatMoreType)type;

- (void)photoAction;
- (void)takePicAction;
@end




@protocol DXChatBarMoreViewDelegate <NSObject>
@required
- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView;
- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView;
- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView;
- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView;
- (void)moreViewVideoCallAction:(DXChatBarMoreView *)moreView;

//代理方法发送约拍
- (void)moreViewYuePaiAction:(DXChatBarMoreView *)moreView;
//打赏
- (void)moreViewDaShangAction:(DXChatBarMoreView *)moreView;

@end
