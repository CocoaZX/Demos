//
//  OtherDaShangView.m
//  Mocha
//
//  Created by yfw－iMac on 16/3/2.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "OtherDaShangView.h"

@implementation OtherDaShangView

- (void)setUpviews
{
    //黑色透明选择打赏视图
    UIView *shangView = [[UIView alloc] init];
    shangView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    shangView.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc] initWithFrame:shangView.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    [shangView addSubview:backView];
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = shangView.frame;
    [dismissButton addTarget:self action:@selector(closeAlertView_ds) forControlEvents:UIControlEventTouchUpInside];
    [shangView addSubview:dismissButton];
    //弹出的其他金额的按钮
    self.shangAlert = [ShangAlertView getShangView];
    self.shangAlert.clipsToBounds = YES;
    self.shangAlert.layer.cornerRadius = 10;
    self.shangAlert.frame = CGRectMake(kScreenWidth/2-self.shangAlert.frame.size.width/2, 100, self.shangAlert.frame.size.width, self.shangAlert.frame.size.height);
    [self.shangAlert.closeButton addTarget:self action:@selector(closeAlertView_ds) forControlEvents:UIControlEventTouchUpInside];
    [self.shangAlert.payButton addTarget:self action:@selector(payMethod_ds) forControlEvents:UIControlEventTouchUpInside];
    
    [shangView addSubview:self.shangAlert];
    [self addSubview:shangView];
    self.backgroundColor = [UIColor clearColor];

}

- (void)closeAlertView_ds
{
    [self removeFromSuperview];
}

- (void)payMethod_ds
{
    self.otherViewClickBlock(self.shangAlert.inputTextfield.text);
    
}

- (void)addToWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            
            [window addSubview:self];
            
            break;
        }
    }
}

@end
