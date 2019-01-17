//
//  NumRedRemindView.h
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NumRedRemindViewDelegate <NSObject>

- (void)doClearInView;

@end

@interface NumRedRemindView : UIView

@property (nonatomic,assign) id<NumRedRemindViewDelegate> delegate;

- (id)initWithColor:(UIColor *)bgColor;

- (id)initWithColor:(UIColor *)bgColor delegate:(id<NumRedRemindViewDelegate>)delegate;

@end
