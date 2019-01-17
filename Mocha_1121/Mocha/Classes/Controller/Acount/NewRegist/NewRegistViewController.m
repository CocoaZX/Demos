//
//  NewRegistViewController.m
//  Mocha
//
//  Created by sun on 15/6/17.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewRegistViewController.h"
#import "ChoseRoleViewController.h"
#import "BangDingPhoneViewController.h"
#import "ChangeheaderViewController.h"
#import "UserProtocolViewController.h"
#import "QCheckBox.h"

@interface NewRegistViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextfield;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *sinaButton;


@property (weak, nonatomic) IBOutlet UIView *secondRegistView;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UITextField *mokaNumberTextfield;

@property (weak, nonatomic) IBOutlet UIButton *retryButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;


@property (weak, nonatomic) IBOutlet UILabel *retryLabel;
@property (copy, nonatomic) NSString *verifyString;
@property (strong, nonatomic) NSTimer *verifyTimer;
@property (weak, nonatomic) IBOutlet UILabel *yifaLabel;

@property (nonatomic, strong) QCheckBox *_check1;
@property (nonatomic, strong) UserProtocolViewController *userPro;

@property (weak, nonatomic) IBOutlet UILabel *errorAlert;

@property (strong, nonatomic) UILabel *yelloLabel;
@property (strong, nonatomic) UILabel *lineLabel;

@property (strong, nonatomic) UIView *alertView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navView;

@property (weak, nonatomic) IBOutlet UIButton *alertButton;

@property (strong , nonatomic) UIView *whiteView;

@property (weak, nonatomic) IBOutlet UIView *registView;

@property (weak, nonatomic) IBOutlet UIView *registView2;

@property (weak, nonatomic) IBOutlet UILabel *otherWay;

@end

@implementation NewRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self._check1.checked = YES;
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 34)];
    self.alertView.backgroundColor = [UIColor clearColor];
    
    self.yelloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    self.yelloLabel.backgroundColor = RGB(255,255, 123);
    self.yelloLabel.textColor = RGB(230,62, 70);
    self.yelloLabel.text = @"";
    self.yelloLabel.hidden = NO;
    self.yelloLabel.font = [UIFont systemFontOfSize:15];
    self.yelloLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.alertView addSubview:self.alertButton];
    [self.alertView addSubview:self.yelloLabel];
    [self.view insertSubview:self.alertView belowSubview:self.navView];
    
    self.userPro = [[UserProtocolViewController alloc] initWithNibName:@"UserProtocolViewController" bundle:nil];
    self.userPro.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDissmissUserProtocolViewNew:) name:@"addDissmissUserProtocolViewNew" object:nil];

}

- (void)addDissmissUserProtocolViewNew:(id)sender
{
    [UIView animateWithDuration:0.5 animations:^{
        self.userPro.view.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight);

    } completion:^(BOOL finished) {
        self.userPro.view.hidden = YES;

    }];
    
}


- (void)showAlertWithString:(NSString *)string
{
    self.yelloLabel.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        if (!self.secondRegistView.hidden) {
            [self.view insertSubview:self.alertView belowSubview:self.navView];
            [self.view insertSubview:self.alertView aboveSubview:self.secondRegistView];
        }
        self.alertView.frame = CGRectMake(0, 64, kScreenWidth, 34);
    }];
    if (![string isEqualToString:@"手机号已注册请直接登录"]) {
        self.lineLabel.hidden = YES;

        [self performSelector:@selector(hideAlerView) withObject:nil afterDelay:2.0];

    }else
    {
        if (self.lineLabel) {
            self.lineLabel.hidden = NO;
        }else
        {
            UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
            line.backgroundColor = [UIColor clearColor];
            line.center = CGPointMake(kScreenWidth/2+68, 34/2+2);
            line.textColor = RGB(230,62, 70);
            line.text = @"____";
            line.hidden = NO;
            line.font = [UIFont systemFontOfSize:15];
            line.textAlignment = NSTextAlignmentCenter;
            [self.alertView addSubview:line];
            self.lineLabel = line;
        }
        
        
    }
}

- (void)hideAlerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 24, kScreenWidth, 34);
    }];
    
}

- (void)viewWillAppear:(BOOL)animated
{
 
    
    [super viewWillAppear:animated];
    BOOL isAllowTgirdLogin = UserDefaultGetBool(ConfigAllowThirdLogin);
    if (isAllowTgirdLogin) {
        self.qqButton.hidden = NO;
        self.weixinButton.hidden = NO;
        self.sinaButton.hidden = NO;
        self.registView.hidden = NO;
        self.registView2.hidden = NO;
        self.otherWay.hidden = NO;
    }else
    {
        self.qqButton.hidden = YES;
        self.weixinButton.hidden = YES;
        self.sinaButton.hidden = YES;
        self.registView.hidden = YES;
        self.registView2.hidden = YES;
        self.otherWay.hidden = YES;
        
//        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-150, kScreenWidth, 100)];
//        _whiteView.backgroundColor = self.view.backgroundColor;
//        [self.view addSubview:_whiteView];
       
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.navigationController.navigationBar.hidden = YES;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (IBAction)dismissKey:(id)sender {
    [self disappearKeyboard];
    
}

- (void)disappearKeyboard
{
    [self.phoneTextfield resignFirstResponder];
    [self.yanzhengTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    [self.mokaNumberTextfield resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backMethod:(id)sender {
    if (self.secondRegistView.hidden) {
        [self.navigationController popViewControllerAnimated:YES];

    }else
    {
        self.secondRegistView.hidden = YES;
    }
    
}

- (IBAction)getCodeMethod:(id)sender {
    [self.getCodeButton setEnabled:NO];

    if (![SQCStringUtils mobileJudging:self.phoneTextfield.text]) {
        [self showAlertWithString:@"手机号填写错误"];

        return;
    }
    [self setCodeBtnHelight:NO];
    self.alertView.frame = CGRectMake(0, 20, kScreenWidth, 34);
    NSDictionary *params = [AFParamFormat formatVerifyParams:self.phoneTextfield.text withType:@"2"];
    //发短信
    [AFNetwork getTheVerificationCode:params success:^(id data){
        [self performSelector:@selector(setCodeButtonNotEnable) withObject:nil afterDelay:1.0];
        if ([data[@"status"] integerValue] == kRight) {
            self.secondRegistView.hidden = NO;
            self.yifaLabel.text = [NSString stringWithFormat:@"验证码已发送到%@",self.phoneTextfield.text];
            [self.yanzhengTextfield becomeFirstResponder];

            self.verifyString = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
//            self.yanzhengTextfield.text = self.verifyString;
            NSLog(@"%@",self.verifyString);
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
        [self performSelector:@selector(setCodeButtonNotEnable) withObject:nil afterDelay:2.0];
        [self setCodeBtnHelight:YES];
    }];
    
    

}

- (void)setCodeButtonNotEnable
{
    [self.getCodeButton setEnabled:YES];

}

- (void)setCodeBtnHelight:(BOOL)isHelight
{
    if (isHelight) {
        self.retryButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        self.retryButton.enabled = YES;
    }
    else{
        self.retryButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
        self.retryButton.enabled = NO;
    }
    self.retryButton.backgroundColor = [UIColor clearColor];

}

static int registerTimeNumber = 60;

- (void)changeVerifyTime:(id)sender
{
    if (registerTimeNumber == 0) {
        [self resetTimer];
        if ([SQCStringUtils mobileJudging:self.phoneTextfield.text]) {
            [self setCodeBtnHelight:YES];
            
        }else
        {
            [self setCodeBtnHelight:NO];
            
        }
    }else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.retryLabel.text = [NSString stringWithFormat:@"重获验证码(%d)",registerTimeNumber];
            
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
    self.retryLabel.text = @"重获验证码";

}



- (IBAction)reGetCodeMethod:(id)sender {
    [self getCodeMethod:sender];

}

- (IBAction)registMethod:(id)sender {
    [self.registButton setEnabled:NO];

    if (![self isCheck]) {
        [self performSelector:@selector(setRegistButtonNotEnable) withObject:nil afterDelay:2.0];

        return;
    }

    NSDictionary *params = [AFParamFormat formatNewSignUpParams:self.phoneTextfield.text verify:self.yanzhengTextfield.text password:self.passwordTextfield.text type:nil inviteMokaNum:self.mokaNumberTextfield.text];
    //注册
    [AFNetwork signUpWithPhoneNumber:params success:^(id data){
        
        
        [UmengCustomManager mokaRegistClick];
        
        [self performSelector:@selector(setRegistButtonNotEnable) withObject:nil afterDelay:2.0];

        if ([data[@"status"] integerValue] == kRight) {
            [USER_DEFAULT setBool:YES forKey:IsBangDingPhone];
            [USER_DEFAULT synchronize];

            [self doLoginIn];
            
            return;
        }
        if ([data[@"status"] integerValue] == 6202) {
            [self showAlertWithString:@"手机号已注册请直接登录"];

            self.secondRegistView.hidden = YES;
            
            
            return;
        }
        
        if ([data[@"status"] integerValue] == 6219) {
            
            [self showAlertWithString:data[@"msg"]];
            
            return;
        }
        
        [self showAlertWithString:data[@"msg"]];

        
    }failed:^(NSError *error){
        [self performSelector:@selector(setRegistButtonNotEnable) withObject:nil afterDelay:2.0];

    }];
    
}

- (void)setRegistButtonNotEnable
{
    [self.registButton setEnabled:YES];
    
}


- (void)doLoginIn
{
    
    NSString *code = @"";
    NSString *password = @"";
    NSInteger _loginType = 2;
    
    password = self.passwordTextfield.text;
    [ThirdLoginManager shareThirdLoginManager].phoneNumber = self.phoneTextfield.text;
    [ThirdLoginManager shareThirdLoginManager].password = password;
    NSDictionary *params = [AFParamFormat formatLoginParams:self.phoneTextfield.text verify:code password:password loginType:_loginType];
    
    [AFNetwork newLoginWithUserName:params success:^(id data){
        
        
        if ([data[@"status"] integerValue] == kRight) {
            //将null转换“”
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            [[ThirdLoginManager shareThirdLoginManager] clear];
#ifdef HXRelease
//            [ChatManager registOrLogin];
#endif
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];
            return;
        }
        //6217完善资料
        if ([data[@"status"] integerValue] == kComplete) {
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];

            ChoseRoleViewController *role = [[ChoseRoleViewController alloc] initWithNibName:@"ChoseRoleViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:role animated:YES];
            return;

        }
        
        //选择身份
        if ([data[@"status"] integerValue] == 6216) {
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            ChoseRoleViewController *role = [[ChoseRoleViewController alloc] initWithNibName:@"ChoseRoleViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:role animated:YES];
            return;

        }
        
        //绑定
        if ([data[@"status"] integerValue] == 6218) {
            
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            //请绑定手机号
            BangDingPhoneViewController *bangding = [[BangDingPhoneViewController alloc] initWithNibName:@"BangDingPhoneViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:bangding animated:YES];
            return;
        }
        [self showAlertWithString:data[@"msg"]];

    }failed:^(NSError *error){
        [self showAlertWithString:@"网络错误"];

    }];
}


- (BOOL)isCheck{
    
    
    if ([self.yanzhengTextfield.text length]> 0) {
//        if (![self.yanzhengTextfield.text isEqualToString:self.verifyString]) {
//            [self showAlertWithString:@"验证码错误"];
//
//            return NO;
//            
//        }
    }
    else{
        [self showAlertWithString:@"请输入验证码"];

        return NO;
    }
    
    if ([self.passwordTextfield.text length] <= 0) {
        [self showAlertWithString:@"密码格式错误,至少六位"];

        return NO;
        
    }
    
    
    return YES;
}


- (IBAction)weixinLogin:(id)sender {
    [[WeixinMagnager shareWeixinManager] sendAuthRequestWithController:self success:^(BOOL success, NSDictionary *diction) {
        
        [UmengCustomManager weiChatRegistClick];

        [self thirdLoginWithDiction:diction];
        
    }];
    
    
}

- (IBAction)qqLogin:(id)sender {
    [[QQManager shareQQManager] authQQRequestSuccess:^(BOOL success, NSDictionary *diction) {
        
        [UmengCustomManager QQRegistClick];

        [self thirdLoginWithDiction:diction];
        
    }];

    
}


- (IBAction)xinlangLogin:(id)sender {
    [[SinaManager shareSinaManager] authSinaRequestSuccess:^(BOOL success, NSDictionary *diction) {
        [UmengCustomManager sinaRegistClick];

        [self thirdLoginWithDiction:diction];

    }];

    
}

- (void)thirdLoginWithDiction:(NSDictionary *)diction
{
    NSDictionary *params = [AFParamFormat formatThirdLoginParams:diction[@"openid"]
                                                    access_token:diction[@"access_token"]
                                                      expires_in:diction[@"expires_in"]
                                                       plat_type:[diction[@"plat_type"] integerValue]
                                                            idfa:diction[@"idfa"]];
    
    [AFNetwork getThirdLoginInfo:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            
            [USER_DEFAULT setBool:YES forKey:IsBangDingPhone];

            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
#ifdef HXRelease
            //[ChatManager registOrLogin];
#endif
            [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];

            return;
        }
        if ([data[@"status"] integerValue] == 6219) {
            
            [self showAlertWithString:data[@"msg"]];

            return;
        }
        if ([data[@"status"] integerValue] == 6216) {
            
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            ChoseRoleViewController *chose = [[ChoseRoleViewController alloc] initWithNibName:@"ChoseRoleViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:chose animated:YES];
            return;
        }
        
        if ([data[@"status"] integerValue] == 6217) {
            
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            ChangeheaderViewController *chose = [[ChangeheaderViewController alloc] initWithNibName:@"ChangeheaderViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:chose animated:YES];
            return;
        }
        
        if ([data[@"status"] integerValue] == 6218) {
            
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            //请绑定手机号
            BangDingPhoneViewController *bangding = [[BangDingPhoneViewController alloc] initWithNibName:@"BangDingPhoneViewController" bundle:[NSBundle mainBundle]];
            [self presentViewController:bangding animated:YES completion:nil];
            return;
        }
        [ChatManager registOrLogin];
        [self showAlertWithString:data[@"msg"]];

    }failed:^(NSError *error){
        [self showAlertWithString:@"网络错误"];

    }];
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==self.mokaNumberTextfield) {
        self.mokaNumberTextfield.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        self.mokaNumberTextfield.returnKeyType = UIReturnKeyDone;

    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.phoneTextfield) {
        if (self.phoneTextfield.text.length>2) {
            [self.getCodeButton setBackgroundColor:RGB(230, 62, 70)];
            [self.getCodeButton setEnabled:YES];

        }else
        {
            [self.getCodeButton setBackgroundColor:[UIColor lightGrayColor]];
            [self.getCodeButton setEnabled:NO];


        }
        if (self.phoneTextfield.text.length==0) {
            [self performSelector:@selector(reCheckIsCopy) withObject:nil afterDelay:0.2];
        }
    }
    if (textField==self.yanzhengTextfield||textField==self.passwordTextfield||textField==self.mokaNumberTextfield) {
        if (self.yanzhengTextfield.text.length>2&&self.passwordTextfield.text.length>2) {
            [self.registButton setBackgroundColor:RGB(230, 62, 70)];
            [self.registButton setEnabled:YES];

        }else
        {
            [self.registButton setBackgroundColor:[UIColor lightGrayColor]];
            [self.registButton setEnabled:NO];

            
        }
    }
    
    return YES;
}

- (void)reCheckIsCopy
{
    if (self.phoneTextfield.text.length>2) {
        [self.getCodeButton setBackgroundColor:RGB(230, 62, 70)];
        [self.getCodeButton setEnabled:YES];
    }
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.getCodeButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.getCodeButton setEnabled:NO];
    [self.registButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.registButton setEnabled:NO];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self disappearKeyboard];
    
    return YES;
}

- (IBAction)gotoProtocol:(id)sender {
    [self.view addSubview:self.userPro.view];
    self.userPro.view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.userPro.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }];
}





@end
