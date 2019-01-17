//
//  McForgetPwdTableViewController.m
//  Mocha
//
//  Created by renningning on 14-12-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McForgetPwdViewController.h"

@interface McForgetPwdViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *phoneTextField;
@property (nonatomic, strong) UITextField *codeTextFiled;
@property (nonatomic, strong) UITextField *passTextFiled;

@property (nonatomic,strong) UIButton *getCodeBtn;

@property (nonatomic,retain) NSString *verifyString;//

@property (strong, nonatomic) NSTimer *verifyTimer;

@end

#define iconOrignX 20
#define iconOrignY 25
#define iconSize 30
#define rowHeight 60

@implementation McForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.title = @"重置密码";
    
    [self layoutSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark SubViews
- (void)layoutSubViews
{
    float pushX = iconOrignX + iconSize;
    float pushY = iconOrignY;
    float viewWidth = kDeviceWidth;
    
    
    
    UIImageView *phoneIconView = [[UIImageView alloc] init];
    [phoneIconView setFrame:CGRectMake(iconOrignX, pushY, iconSize, iconSize)];
    [phoneIconView setImage:[UIImage imageNamed:@"account1"]];
    
    _phoneTextField = [[UITextField alloc]init];
    [_phoneTextField setFrame:CGRectMake(pushX + 10, pushY, viewWidth - (pushX + 10) * 2, 30)];
    [_phoneTextField setTextColor:[CommonUtils colorFromHexString:kLikeBlackColor]];
    _phoneTextField.placeholder = @"请输入正确的手机号";
    _phoneTextField.delegate = self;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_phoneTextField setFont:kFont16];
    
    UIImageView *_signView1 = [[UIImageView alloc] init];
    [_signView1 setFrame:CGRectMake(viewWidth - 50, pushY, 30, 30)];
    
    UIImageView *_lineImageV1 = [[UIImageView alloc] init];
    [_lineImageV1 setFrame:CGRectMake(pushX, CGRectGetMaxY(_phoneTextField.frame) + 10, viewWidth - pushX - 20, 1)];
    [_lineImageV1 setBackgroundColor:[CommonUtils colorFromHexString:kLikeLightGrayColor]];
    
    pushY += rowHeight;
    
    UIImageView *codeIconView = [[UIImageView alloc] init];
    [codeIconView setFrame:CGRectMake(iconOrignX, pushY, iconSize, iconSize)];
    [codeIconView setImage:[UIImage imageNamed:@"account2"]];
    
    _codeTextFiled = [[UITextField alloc]init];
    [_codeTextFiled setFrame:CGRectMake(pushX + 10, pushY, viewWidth - (pushX + 10) * 2 - 80, 30)];
    [_codeTextFiled setTextColor:[CommonUtils colorFromHexString:kLikeBlackColor]];
    _codeTextFiled.placeholder = @"请输入验证码";
    _codeTextFiled.delegate = self;
    _codeTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_codeTextFiled setFont:kFont16];
    
    _getCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getCodeBtn setFrame:CGRectMake(viewWidth - 100, pushY, 80, 30)];
    [_getCodeBtn setTitle:@"接收验证码" forState:UIControlStateNormal];
    [_getCodeBtn setBackgroundColor:[CommonUtils colorFromHexString:kLikeLightGrayColor]];//kLikeGrayColor  kLikeLightRedColor
    [_getCodeBtn.titleLabel setFont:kFont14];
    [_getCodeBtn.layer setCornerRadius:6];
    [_getCodeBtn addTarget:self action:@selector(doRequestGetCode:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *_lineImageV2 = [[UIImageView alloc] init];
    [_lineImageV2 setFrame:CGRectMake(pushX, CGRectGetMaxY(_codeTextFiled.frame) + 10, viewWidth - pushX - 20, 1)];
    [_lineImageV2 setBackgroundColor:[CommonUtils colorFromHexString:kLikeLightGrayColor]];
    
    pushY += rowHeight;
    
    UIImageView *passIconView = [[UIImageView alloc] init];
    [passIconView setFrame:CGRectMake(iconOrignX, pushY, iconSize, iconSize)];
    [passIconView setImage:[UIImage imageNamed:@"account3"]];
    
    _passTextFiled = [[UITextField alloc]init];
    [_passTextFiled setFrame:CGRectMake(pushX + 10, pushY, viewWidth - (pushX + 10) * 2, 30)];
    [_passTextFiled setTextColor:[CommonUtils colorFromHexString:kLikeBlackColor]];
    [_passTextFiled setSecureTextEntry:YES];
    _passTextFiled.placeholder = @"请输入密码";
    _passTextFiled.delegate = self;
    _passTextFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_passTextFiled setFont:kFont16];
    
    UIImageView *_signView2 = [[UIImageView alloc] init];
    [_signView2 setFrame:CGRectMake(viewWidth - 50, pushY, 30, 30)];
    
    UIImageView *_lineImageV3 = [[UIImageView alloc] init];
    [_lineImageV3 setFrame:CGRectMake(pushX, CGRectGetMaxY(_passTextFiled.frame) + 10, viewWidth - pushX - 20, 1)];
    [_lineImageV3 setBackgroundColor:[CommonUtils colorFromHexString:kLikeLightGrayColor]];
    
    pushY += 10 + rowHeight;
    
    UIButton *_submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [_submitBtn setFrame:CGRectMake(60, pushY, viewWidth - 120, 40)];
    [_submitBtn.titleLabel setFont:kFont16];
    [_submitBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[CommonUtils colorFromHexString:kLikeLightRedColor] forState:UIControlStateNormal];
    [_submitBtn.layer setBorderColor:[CommonUtils colorFromHexString:kLikeLightRedColor].CGColor];
    [_submitBtn.layer setBorderWidth:1.0];
    [_submitBtn.layer setCornerRadius:20];
    [_submitBtn addTarget:self action:@selector(doRequestFinish:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:phoneIconView];
    [self.view addSubview:codeIconView];
    [self.view addSubview:passIconView];
    
    [self.view addSubview:_phoneTextField];
    [self.view addSubview:_codeTextFiled];
    [self.view addSubview:_passTextFiled];
    
    [self.view addSubview:_signView1];
    [self.view addSubview:_signView2];
    [self.view addSubview:_lineImageV1];
    [self.view addSubview:_lineImageV2];
    [self.view addSubview:_lineImageV3];
    [self.view addSubview:_getCodeBtn];
    [self.view addSubview:_submitBtn];
}

#pragma mark action
- (void)doRequestFinish:(id)sender
{
    NSDictionary *params = [AFParamFormat formatResetPwdParams:_phoneTextField.text code:_codeTextFiled.text password:_passTextFiled.text];
    [AFNetwork resetPassword:params success:^(id data){
        [self updatePwdDone:data];
    }failed:^(NSError *error){
        
    }];
}

- (void)updatePwdDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        [self.navigationController popViewControllerAnimated:NO];
    }
    else if ([data[@"status"] integerValue] == kReLogin){
        [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT synchronize];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
    
}

- (void)doBackAction:(id)sender
{
    //Animated:不为YES，为了避免视觉偏差
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)doRequestGetCode:(id)sender
{
    if (![SQCStringUtils mobileJudging:_phoneTextField.text]) {
        [LeafNotification showInController:self withText:@"请输入正确的手机号"];
        return;
    }
    [self setCodeBtnHelight:NO];
    NSDictionary *params = [AFParamFormat formatVerifyParams:_phoneTextField.text withType:@"3"];
    [AFNetwork getTheVerificationCode:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight){
            self.verifyString = [NSString stringWithFormat:@"%@",data[@"data"][@"code"]];
        }
        
        
    }failed:^(NSError *error){
        [self setCodeBtnHelight:YES];
    }];
    
    if (self.verifyTimer==nil) {
        self.verifyTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeVerifyTime:) userInfo:nil repeats:YES];
        
    }
    
    [self.verifyTimer fire];
}


- (BOOL)isCheck{
    
    
    if ([_codeTextFiled.text length]> 0) {
//        if (![_codeTextFiled.text isEqualToString:self.verifyString]) {
//            [LeafNotification showInController:self withText:@"验证码不一致"];
//            return NO;
//            
//        }
    }
    else{
        [LeafNotification showInController:self withText:@"请输入验证码"];
        return NO;
    }
    
    if ([_passTextFiled.text length] <= 0) {
        [LeafNotification showInController:self withText:@"密码不能为空"];
        return NO;
        
    }
    
    return YES;
}

static int registerTimeNumber = 60;

- (void)changeVerifyTime:(id)sender
{
    if (registerTimeNumber == 0) {
        [self resetTimer];
        if ([SQCStringUtils mobileJudging:self.phoneTextField.text]) {
            [self setCodeBtnHelight:YES];
            
        }else
        {
            [self setCodeBtnHelight:NO];
            
        }
    }else
    {
        
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"重发(%d)",registerTimeNumber] forState:UIControlStateNormal];
        registerTimeNumber--;
    }
    
}

- (void)resetTimer
{
    registerTimeNumber = 60;
    [self.verifyTimer invalidate];
    self.verifyTimer = nil;
    
    [self setCodeBtnHelight:NO];
    [self.getCodeBtn setTitle:@"接收验证码" forState:UIControlStateNormal];
}



- (void)resetTextfield
{
    [self.phoneTextField resignFirstResponder];
    [self.codeTextFiled resignFirstResponder];
    [self.passTextFiled resignFirstResponder];
}

- (void)setCodeBtnHelight:(BOOL)isHelight
{
    if (isHelight) {
        self.getCodeBtn.backgroundColor = [UIColor colorForHex:kLikeLightRedColor];
        self.getCodeBtn.enabled = YES;
    }
    else{
        self.getCodeBtn.backgroundColor = [UIColor colorForHex:kLikeGrayColor];
        self.getCodeBtn.enabled = NO;
    }
}

#pragma mark - UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self resetTextfield];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString *lastPhone = self.phoneTextField.text.mutableCopy;
    [lastPhone appendString:string];
    if ([SQCStringUtils mobileJudging:lastPhone]) {
        
        [self setCodeBtnHelight:YES];
        
    }else
    {
        [self setCodeBtnHelight:NO];
        
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == _codeTextFiled || textField == _phoneTextField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
        textField.returnKeyType = UIReturnKeyNext;
    }
    else {
        textField.keyboardType = UIKeyboardTypeDefault;
        textField.returnKeyType = UIReturnKeyDone;
    }
    
}

@end
