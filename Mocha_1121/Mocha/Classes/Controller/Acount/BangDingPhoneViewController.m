//
//  BangDingPhoneViewController.m
//  Mocha
//
//  Created by MagicFox on 15/6/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BangDingPhoneViewController.h"
#import "MBProgressHUD.h"
@interface BangDingPhoneViewController ()


@property (weak, nonatomic) IBOutlet UITextField *inputPhone;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengma;
@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property (strong, nonatomic) NSString *verifyCode;

@property (strong, nonatomic) NSTimer *verifyTimer;

@property (weak, nonatomic) IBOutlet UILabel *verifyLabel;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UILabel *wanshanzhanghaoxinxi;

@property (weak, nonatomic) IBOutlet UIButton *tiaoguoButton;

@property (weak, nonatomic) IBOutlet UIView *wanshanLine;

@property (weak, nonatomic) IBOutlet UILabel *shoujihaoshicanjia;

@property (strong, nonatomic) UILabel *yelloLabel;
@property (strong, nonatomic) UIView *alertView;

@property (weak, nonatomic) IBOutlet UIView *navView;



@end

@implementation BangDingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 34)];
    self.alertView.backgroundColor = [UIColor clearColor];
    
    self.yelloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-20, 34)];
    self.yelloLabel.backgroundColor = RGB(255,255, 123);
    self.yelloLabel.textColor = RGB(230,62, 70);
    self.yelloLabel.text = @"";
    self.yelloLabel.hidden = NO;
    self.yelloLabel.font = [UIFont systemFontOfSize:15];
    self.yelloLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.alertView addSubview:self.yelloLabel];
    [self.mainView insertSubview:self.alertView belowSubview:self.navView];
    
    if (self.isFromSiLiao)
    {
        [self.tiaoguoButton setTitle:@"取消" forState:UIControlStateNormal];
        UserDefaultSetBool(YES, @"bangding");

    }

}

- (void)showAlertWithString:(NSString *)string
{
    self.yelloLabel.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 44, kScreenWidth, 34);
    }];
    
    [self performSelector:@selector(hideAlerView) withObject:nil afterDelay:2.0];
}

- (void)hideAlerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 0, kScreenWidth-20, 34);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissKeyboard:(id)sender {
    [self dismissAllKeyboard];

}

- (void)dismissAllKeyboard
{
    [self.inputPhone resignFirstResponder];
    [self.yanzhengma resignFirstResponder];
    [self.password resignFirstResponder];

}

- (void)resetState
{
    UserDefaultSetBool(NO, @"bangding");

}

- (IBAction)tiaoGuoMethod:(id)sender {
//    [self.customTabBarController hidesTabBar:YES animated:YES];
    if (self.isFromSiLiao)
    {
        [self performSelector:@selector(resetState) withObject:nil afterDelay:1.0];

        
    }
    if (self.isFromSiLiao) {
        [self dismissViewControllerAnimated:YES completion:nil];

    }else
    {
        [self thirdLoginWithDiction_tiaoguo:[ThirdLoginManager shareThirdLoginManager].paraDiction];
        
        [self dismissViewControllerAnimated:NO completion:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];

    }
    
}

- (IBAction)getCode:(id)sender {
    if (![SQCStringUtils mobileJudging:self.inputPhone.text]) {

        [self showAlertWithString:@"请输入正确的手机号"];
        return;
    }
    
    [self setCodeBtnHelight:NO];
    
    [self.yanzhengma becomeFirstResponder];
    NSDictionary *params = [AFParamFormat formatVerifyParams:self.inputPhone.text withType:@"1"];
    [AFNetwork getTheVerificationCode:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            self.verifyCode = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
            NSLog(@"%@",self.verifyCode);
            if (self.verifyTimer==nil) {
                self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeVerifyTime:) userInfo:nil repeats:YES];
                
            }
            
            [self.verifyTimer fire];
        }
        else{
            [self showAlertWithString:data[@"msg"]];

            [self setCodeBtnHelight:YES];
        }
        
        
    }failed:^(NSError *error){
        [self setCodeBtnHelight:YES];
    }];
    
    
    
}
- (void)setCodeBtnHelight:(BOOL)isHelight
{
    if (isHelight) {
        self.codeButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        self.codeButton.enabled = YES;
        self.verifyLabel.backgroundColor = [UIColor colorForHex:kLikeRedColor];

    }
    else{
        self.codeButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        self.codeButton.enabled = NO;
        self.verifyLabel.backgroundColor = [UIColor lightGrayColor];
    }
    self.codeButton.backgroundColor = [UIColor clearColor];
    self.verifyLabel.backgroundColor = [UIColor clearColor];
}

static int registerTimeNumber = 60;

- (void)changeVerifyTime:(id)sender
{
    if (registerTimeNumber == 0) {
        [self resetTimer];
        if ([SQCStringUtils mobileJudging:self.inputPhone.text]) {
            [self setCodeBtnHelight:YES];
            
        }else
        {
            [self setCodeBtnHelight:NO];
            
        }
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.verifyLabel.text = [NSString stringWithFormat:@"重获验证码(%d)",registerTimeNumber];
            
            registerTimeNumber--;
        });
        
    }
    
}

- (void)resetTimer
{
    registerTimeNumber = 60;
    [self.verifyTimer invalidate];
    self.verifyTimer = nil;
    
    [self setCodeBtnHelight:NO];
    self.verifyLabel.text = @"重获验证码";
    
}


- (IBAction)submitMethod:(id)sender {
    if (![self isCheck]) {
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (self.isFromSiLiao) {
        [self bangDing];

    }else
    {
        [self thirdLoginWithDiction:[ThirdLoginManager shareThirdLoginManager].paraDiction];

    }
}

- (void)bangDing
{
    NSDictionary *params = [AFParamFormat formatBangdingPhoneParams:self.inputPhone.text password:self.password.text code:self.yanzhengma.text];
    
    [AFNetwork getBangDingPhoneInfo:params success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([data[@"status"] integerValue] == kRight) {
//            NSLog(@"%@",data);
            [[ThirdLoginManager shareThirdLoginManager] clear];
            [USER_DEFAULT setBool:YES forKey:IsBangDingPhone];
            [USER_DEFAULT synchronize];

            [self dismissViewControllerAnimated:NO completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];
            
            return;
        }
        
        if ([data[@"status"] integerValue] == 6202) {
//            NSLog(@"%@",data);
            [self showAlertWithString:data[@"msg"]];

            return;
        }
        
    } failed:^(NSError *error) {
        NSLog(@"123 error");
        
    }];
}

- (BOOL)isCheck{
    
    if (![SQCStringUtils mobileJudging:self.inputPhone.text]) {
        [self showAlertWithString:@"手机号填写错误"];

        return NO;
    }
    
//    if (![self.verifyCode isEqualToString:self.yanzhengma.text]) {
//        [self showAlertWithString:@"验证码不正确"];
//
//        return NO;
//    }
    
    if ([self.password.text length] <= 0) {
        [self showAlertWithString:@"密码格式错误,至少六位"];

        return NO;
    }
    
    return YES;
}

- (void)thirdLoginWithDiction:(NSDictionary *)diction
{
    NSDictionary *params = [AFParamFormat formatThirdLoginParams:diction[@"openid"]
                                                    access_token:diction[@"access_token"]
                                                      expires_in:diction[@"expires_in"]
                                                       plat_type:[diction[@"plat_type"] integerValue]
                                                            idfa:diction[@"idfa"]];
    
    [AFNetwork getThirdLoginInfo:params success:^(id data){
        
        NSLog(@"%@",data);
        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
        [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        [self bangDing];
        
        
    }failed:^(NSError *error){
        [self showAlertWithString:@"网络请求失败"];

    }];
    
    
}

- (void)thirdLoginWithDiction_tiaoguo:(NSDictionary *)diction
{
    NSDictionary *params = [AFParamFormat formatThirdLoginParams:diction[@"openid"]
                                                    access_token:diction[@"access_token"]
                                                      expires_in:diction[@"expires_in"]
                                                       plat_type:[diction[@"plat_type"] integerValue]
                                                            idfa:diction[@"idfa"]];
    
    [AFNetwork getThirdLoginInfo:params success:^(id data){
        [[ThirdLoginManager shareThirdLoginManager] clear];

        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
        [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        
    }failed:^(NSError *error){
        [self showAlertWithString:@"网络请求失败"];

    }];
    
    
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField==self.password) {
        [self submitMethod:nil];
        [self dismissAllKeyboard];

    }else if(textField==self.yanzhengma)
    {
        [self.password becomeFirstResponder];

    }else if(textField==self.inputPhone)
    {
        [self.yanzhengma becomeFirstResponder];
        
    }
    return YES;
}


@end
