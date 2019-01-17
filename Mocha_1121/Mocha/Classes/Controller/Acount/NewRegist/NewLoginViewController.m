//
//  NewLoginViewController.m
//  Mocha
//
//  Created by sun on 15/6/17.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewLoginViewController.h"
#import "NewRegistViewController.h"
#import "McForgetPwdViewController.h"
#import "ChoseRoleViewController.h"
#import "ChangeheaderViewController.h"
#import "BangDingPhoneViewController.h"
#import "SinaManager.h"
#import "BangDingPhoneViewController.h"
#import "ChangeheaderViewController.h"
@interface NewLoginViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelBtn;

@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *xinlangButton;

@property (strong, nonatomic) UILabel *yelloLabel;
@property (strong, nonatomic) UIView *alertView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navView;


@end

@implementation NewLoginViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIFont* font = [UIFont systemFontOfSize:15];
    NSDictionary* textAttributes = @{NSFontAttributeName:font};
    [self.cancelBtn setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doNewLoginDoneAction) name:kNewLoginDoneNotification object:nil];
    [USER_DEFAULT setBool:NO forKey:IsBangDingPhone];

    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 34)];
    self.alertView.backgroundColor = [UIColor clearColor];
    
    self.yelloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    self.yelloLabel.backgroundColor = RGB(255,255, 123);
    self.yelloLabel.textColor = RGB(230,62, 70);
    self.yelloLabel.text = @"";
    self.yelloLabel.hidden = NO;
    self.yelloLabel.font = [UIFont systemFontOfSize:15];
    self.yelloLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.alertView addSubview:self.yelloLabel];
    [self.view insertSubview:self.alertView belowSubview:self.navView];
}

- (void)showAlertWithString:(NSString *)string
{
    self.yelloLabel.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 64, kScreenWidth, 34);
    }];
    
    [self performSelector:@selector(hideAlerView) withObject:nil afterDelay:2.0];
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
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    BOOL isAllowThirdLogin = UserDefaultGetBool(ConfigAllowThirdLogin);
    if (isAllowThirdLogin) {
        
    }else
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, _registBtn.bottom +10, kScreenWidth, kDeviceHeight -_registBtn.bottom -10)];
        view.backgroundColor = self.view.backgroundColor;
//        [self.view addSubview:view];

        
    }
    self.navigationController.navigationBarHidden = YES;

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}


- (void)doNewLoginDoneAction
{
    [ChatManager registOrLogin];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}


- (IBAction)backMethod:(id)sender {
    
    [self performSelector:@selector(delayPopThis) withObject:nil afterDelay:0.2];
}


- (void)delayPopThis
{
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)dismissKeyBoad:(id)sender {
    [self.nameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
    
}

- (IBAction)loginMethod:(id)sender {
   
    if (![self isCheck]) {
        return;
    }
    [self resetTextfield];
    NSString *code = @"";
    NSString *password = @"";
    
    password = self.passwordTextfield.text;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [ThirdLoginManager shareThirdLoginManager].phoneNumber = self.nameTextfield.text;
    [ThirdLoginManager shareThirdLoginManager].password = password;
    NSDictionary *params = [AFParamFormat formatLoginParams:self.nameTextfield.text verify:code password:password loginType:2];
    [AFNetwork newLoginWithUserName:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [UmengCustomManager mokaLoginClick];
        
        NSInteger statusNum = [data[@"status"] integerValue];
        switch (statusNum) {
            case kRight:
            {
                //将null转换“”
                NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
                [USER_DEFAULT setBool:YES forKey:IsBangDingPhone];
                [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
                [USER_DEFAULT synchronize];
#ifdef HXRelease
                [ChatManager registOrLogin];
#endif
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
            case 6216:
            {
                NSLog(@"%@",data);
                NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
                [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
                [USER_DEFAULT synchronize];
                ChoseRoleViewController *chose = [[ChoseRoleViewController alloc] initWithNibName:@"ChoseRoleViewController" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:chose animated:YES];
                break;
            }
                
                
            case 6217:{
                ChangeheaderViewController *changeHeader = [[ChangeheaderViewController alloc] initWithNibName:@"ChangeheaderViewController" bundle:[NSBundle mainBundle]];
                //changeHeader.currentRole = @"";
                [self.navigationController pushViewController:changeHeader animated:YES];
                break;

            }
            case 6218:
            {
                
                NSLog(@"%@",data);
                NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
                [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
                [USER_DEFAULT synchronize];
                //请绑定手机号
                BangDingPhoneViewController *bangding = [[BangDingPhoneViewController alloc] initWithNibName:@"BangDingPhoneViewController" bundle:[NSBundle mainBundle]];
                [self presentViewController:bangding animated:YES completion:nil];
                break;
            }
            default:
                break;
        }
        [self showAlertWithString:data[@"msg"]];
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showAlertWithString:@"网络不太顺畅哟！"];
    }];
    
}




- (IBAction)registMethod:(id)sender {

    NewRegistViewController *regist = [[NewRegistViewController alloc] initWithNibName:@"NewRegistViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:regist animated:YES];
    
}

- (IBAction)forgetMethod:(id)sender {
    McForgetPwdViewController *pwdVC = [[McForgetPwdViewController alloc] init];
    [self.navigationController pushViewController:pwdVC animated:NO];
    
}


- (IBAction)weixinLogin:(id)sender {
    [[WeixinMagnager shareWeixinManager] sendAuthRequestWithController:self success:^(BOOL success, NSDictionary *diction) {
        NSLog(@"%@",diction);
        [UmengCustomManager weiChatLoginClick];
        [self thirdLoginWithDiction:diction];
        
    }];
    
}


- (IBAction)qqLogin:(id)sender {
    [[QQManager shareQQManager] authQQRequestSuccess:^(BOOL success, NSDictionary *diction) {
        NSLog(@"%@",diction);
        [UmengCustomManager QQLoginClick];
        [self thirdLoginWithDiction:diction];

    }];
    
}


- (IBAction)xinlangLogin:(id)sender {
    [[SinaManager shareSinaManager] authSinaRequestSuccess:^(BOOL success, NSDictionary *diction) {
        
        [UmengCustomManager sinaLoginClick];
        [self thirdLoginWithDiction:diction];

    }];
    
}

- (void)thirdLoginWithDiction:(NSDictionary *)diction
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSDictionary *params = [AFParamFormat formatThirdLoginParams:diction[@"openid"]
                                                    access_token:diction[@"access_token"]
                                                      expires_in:diction[@"expires_in"]
                                                       plat_type:[diction[@"plat_type"] integerValue]
                                                            idfa:diction[@"idfa"]];
    
    [AFNetwork getThirdLoginInfo:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([data[@"status"] integerValue] == kRight) {
            NSLog(@"%@",data);
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setBool:YES forKey:IsBangDingPhone];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            
#ifdef HXRelease
            //[ChatManager registOrLogin];
#endif

            [self.navigationController popViewControllerAnimated:YES];

            return;
        }
        
        if ([data[@"status"] integerValue] == 6216) {
            NSLog(@"%@",data);
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            ChoseRoleViewController *chose = [[ChoseRoleViewController alloc] initWithNibName:@"ChoseRoleViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:chose animated:YES];
            return;
        }
        
        if ([data[@"status"] integerValue] == 6217) {
            NSLog(@"%@",data);
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            ChangeheaderViewController *chose = [[ChangeheaderViewController alloc] initWithNibName:@"ChangeheaderViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:chose animated:YES];
            return;
        }
        
        if ([data[@"status"] integerValue] == 6218) {
            NSLog(@"%@",data);
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self showAlertWithString:@"网络错误"];

    }];

    
}


- (BOOL)isCheck{
    
    if (![SQCStringUtils mobileJudging:self.nameTextfield.text]) {
        [self showAlertWithString:@"手机号填写错误"];
        return NO;
    }
    
    if ([self.nameTextfield.text length] <= 0) {
        [self showAlertWithString:@"手机号填写错误"];
        return NO;
    }
    
    
    if ([self.passwordTextfield.text length] <= 0) {
        [self showAlertWithString:@"密码错误"];
        return NO;
    }
    return YES;
}

- (void)resetTextfield
{
    [self.nameTextfield resignFirstResponder];
    [self.passwordTextfield resignFirstResponder];
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField==self.nameTextfield||textField==self.passwordTextfield) {
        if (self.nameTextfield.text.length>2&&self.passwordTextfield.text.length>2) {
            [self.loginButton setBackgroundColor:RGB(230, 62, 70)];
            [self.loginButton setEnabled:YES];
            
        }else
        {
            [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
            [self.loginButton setEnabled:NO];
            
            
        }
    }
    
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self.loginButton setBackgroundColor:[UIColor lightGrayColor]];
    [self.loginButton setEnabled:NO];
    
    return YES;
}



@end
