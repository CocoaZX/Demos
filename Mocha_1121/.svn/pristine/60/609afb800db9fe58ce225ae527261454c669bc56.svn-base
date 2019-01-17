//
//  McBaseViewController.m
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface McBaseViewController ()

@end

@implementation McBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)delayToPop
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showMessage:(NSString *)message
{
    [LeafNotification showInController:self withText:[NSString stringWithFormat:@"%@",message]];
}

- (BOOL)isLogin {
    id diction = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if ([diction isKindOfClass:[NSDictionary class]]) {
        NSString *uid = diction[@"id"];
        if (uid) {
            int uidInt = [uid intValue];
            if (uidInt>0) {
                return YES;
            }
        }
    }
    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    return NO;
}

- (BOOL)isBangDing
{
    BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
    if (isBangDing) {
        return YES;
    }
    
    [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
    return NO;
}

#pragma mark action
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


//判断登陆和验证
- (BOOL)isFailForCheckLogInStatus{
     if (getCurrentUid().length != 0) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            //处于登陆状态，并且已经绑定过
            return NO;
         }else
        {   //未绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return YES;
        }
    }else
    {   //未登录
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return YES;
     }
}

@end
