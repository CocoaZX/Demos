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

#import "EMChatBaseBubbleView.h"
#import "ZoomImageView.h"
#define MAX_SIZE [[[NSUserDefaults standardUserDefaults] objectForKey:@"YUEPAIVIEWWIDTH"] floatValue] //　图片最大显示大小

extern NSString *const kRouterEventImageBubbleTapEventName;

@interface EMChatImageBubbleView : EMChatBaseBubbleView

//自定义的视图，可以点击放大
@property (nonatomic, strong) ZoomImageView *imageView;

@end
