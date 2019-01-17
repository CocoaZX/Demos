//
//  McBaseViewController.h
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface McBaseViewController : UIViewController

- (void)delayToPop;

- (void)doBackAction:(id)sender;

- (void)showMessage:(NSString *)message;
//验证登陆和绑定
- (BOOL)isFailForCheckLogInStatus;

- (BOOL)isLogin;
- (BOOL)isBangDing;



@end
