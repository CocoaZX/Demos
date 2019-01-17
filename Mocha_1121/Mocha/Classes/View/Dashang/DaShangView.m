//
//  DaShangView.m
//  Mocha
//
//  Created by yfw－iMac on 16/3/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DaShangView.h"
#import "DaShangViewController.h"

@implementation DaShangView

- (void)setUpviews
{

    UIView *shangView = [[UIView alloc] init];
    shangView.frame = self.frame;
    shangView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:shangView.frame];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = shangView.frame;
    [dismissButton addTarget:self action:@selector(closeShangView_ds) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:dismissButton];
    [shangView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, 50, 200, 30)];
    titleLabel.text = @"选择打赏金额";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [shangView addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"photoBrowseCancel"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(kScreenWidth-60, 40, 50, 50)];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeShangView_ds) forControlEvents:UIControlEventTouchUpInside];
    [shangView addSubview:closeButton];
    
    NSArray *moneyArray = MCAPI_Data_Object1(ConfigPrice);
    
    float buttonViewWidth = kScreenWidth-60;
    float buttonSpace = 15;
    float buttonHeight = 40;
    float buttonWidth = (buttonViewWidth-buttonSpace*2)/3;
    
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(30, kScreenHeight/2-90, kScreenWidth-60, 150)];
    buttonView.backgroundColor = [UIColor clearColor];
    
    for (int i=0; i<moneyArray.count; i++) {
        
        UIButton *money = [UIButton buttonWithType:UIButtonTypeCustom];
        float y = 0;
        if (i>2) {
            y = buttonHeight+buttonSpace;
        }
        [money setFrame:CGRectMake(0+buttonSpace*(i%3)+buttonWidth*(i%3), y, buttonWidth, buttonHeight)];
        [money setTitle:[NSString stringWithFormat:@"%@元",moneyArray[i][@"v"]] forState:UIControlStateNormal];
        money.clipsToBounds = YES;
        money.layer.cornerRadius = 2;
        money.tag = i;
        money.layer.borderWidth = 1;
        money.layer.borderColor = [UIColor whiteColor].CGColor;
        [money addTarget:self action:@selector(choseMoney_ds:) forControlEvents:UIControlEventTouchUpInside];
        [buttonView addSubview:money];
    }
    
    [shangView addSubview:buttonView];
    
    UIButton *otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherButton setTitle:@"其他金额" forState:UIControlStateNormal];
    [otherButton setFrame:CGRectMake((buttonViewWidth-100)/2, 110, 100, 40)];
    otherButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [otherButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [otherButton addTarget:self action:@selector(otherButton_ds:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:otherButton];
    
    [self addSubview:shangView];
    self.backgroundColor = [UIColor clearColor];

    __weak __typeof(self)weakSelf = self;

    self.otherView = [[OtherDaShangView alloc] initWithFrame:self.frame];
    self.otherView.superController = self.superController;
    [self.otherView setUpviews];
    self.otherView.otherViewClickBlock = ^(NSString *moneyString){

        NSString *string = moneyString;
        float money = [string floatValue];
        if (money>0.999999&&money<10000) {
            
        }else
        {
            [LeafNotification showInController:weakSelf.otherView.superController withText:@"输入金额应在1和9999之间。"];
            return;
        }
        weakSelf.currentMoney = moneyString;
        [weakSelf jumpToPayController];
        [weakSelf.otherView removeFromSuperview];

    };;
}

- (void)choseMoney_ds:(UIButton *)button
{
    NSArray *moneyArray = MCAPI_Data_Object1(ConfigPrice);
    self.currentMoney = [NSString stringWithFormat:@"%f",[moneyArray[button.tag][@"v"] floatValue]];
    [self jumpToPayController];
}

- (void)otherButton_ds:(UIButton *)button
{
    [self removeFromSuperview];

    [self.otherView addToWindow];
}

- (void)closeShangView_ds
{
    [self removeFromSuperview];
}

#pragma mark -
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

- (void)jumpToPayController
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    
    DaShangViewController *dashang = [[DaShangViewController alloc] initWithNibName:@"DaShangViewController" bundle:[NSBundle mainBundle]];
    dashang.photoId = self.currentPhotoId;
    dashang.uid = uid;
    if([_dashangType isEqualToString:@"payForPicture"]){
        dashang.uid = _targetUid;
    }
    dashang.name = userName;
    dashang.money = [NSString stringWithFormat:@"%.2f",[self.currentMoney floatValue]];
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [self.superController.navigationController pushViewController:dashang animated:YES];
    [self removeFromSuperview];
    self.otherView.shangAlert.inputTextfield.text = @"";
}

@end
