//
//  McNickNameViewController.m
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditNickNameViewController.h"
#import "SQCStringUtils.h"

@interface McEditNickNameViewController ()

@property (nonatomic, strong) UITextField *textFiled;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, assign) McPersonalType personalType;
@property (nonatomic , strong) NSMutableDictionary *introduceLimMutDic;
@property (nonatomic , strong) NSMutableDictionary *user_studioLimMutDic;
@property (nonatomic , strong) NSMutableDictionary *user_workhistoryLimMutDic;
@property (nonatomic , strong) NSMutableDictionary *nickLimitMutDic;
@end

@implementation McEditNickNameViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.personalType = type;
    }
    return self;
}

#pragma mark - getrule_fontlimit
-(void)getRule_FontLimit{
    _introduceLimMutDic = [NSMutableDictionary dictionary];
    _user_studioLimMutDic = [NSMutableDictionary dictionary];
    _user_workhistoryLimMutDic = [NSMutableDictionary dictionary];
    _nickLimitMutDic = [NSMutableDictionary dictionary];
    NSDictionary *rule_fontLimitDic = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    if (rule_fontLimitDic) {
        if (rule_fontLimitDic[@"nickname"]) {
            _nickLimitMutDic = rule_fontLimitDic[@"nickname"];
        }
        if (rule_fontLimitDic[@"user_introduction"]) {
            _introduceLimMutDic = rule_fontLimitDic[@"user_introduction"];
        }
        if (rule_fontLimitDic[@"user_studio"]) {
            _user_studioLimMutDic = rule_fontLimitDic[@"user_studio"];
        }
        if (rule_fontLimitDic[@"user_workhistory"]) {
            _user_workhistoryLimMutDic = rule_fontLimitDic[@"user_workhistory"];
        }
    }
    if (_nickLimitMutDic[@"max"] == nil) {
        [_nickLimitMutDic setObject:[NSNumber numberWithInt:6] forKey:@"max"];
        [_nickLimitMutDic setObject:[NSNumber numberWithInt:1] forKey:@"min"];
    }
    if (_introduceLimMutDic[@"max"] == nil) {
        [_introduceLimMutDic setObject:[NSNumber numberWithInt:500] forKey:@"max"];
        [_introduceLimMutDic setObject:[NSNumber numberWithInt:0] forKey:@"min"];
    }
    if (_user_studioLimMutDic[@"max"] == nil) {
        [_user_studioLimMutDic setObject:[NSNumber numberWithInt:50] forKey:@"max"];
        [_user_studioLimMutDic setObject:[NSNumber numberWithInt:1] forKey:@"min"];
    }
    if (_user_workhistoryLimMutDic[@"max"] == nil) {
        [_user_workhistoryLimMutDic setObject:[NSNumber numberWithInt:200] forKey:@"max"];
        [_user_workhistoryLimMutDic setObject:[NSNumber numberWithInt:1] forKey:@"min"];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRule_FontLimit];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(editPersonalData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    self.title = @"编辑";
    NSString *titleStr = @"";
    NSString *desicrib = @"";
    NSString *unitLab = @"";
    
    NSString *navTitle = @"";
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    self.textFiled = [[UITextField alloc] initWithFrame:CGRectMake(15, 5, self.view.frame.size.width - 30, 40)];
//    _textFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textFiled.backgroundColor = [UIColor clearColor];
    _textFiled.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    [bgView addSubview:_textFiled];
    
//    UIView *bgTextView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 50)];
//    bgTextView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:bgTextView];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10,10, self.view.frame.size.width - 20, 100)];
    [_textView.layer setBorderColor:[UIColor colorForHex:kLikeLightGrayColor].CGColor];
    [_textView.layer setBorderWidth:0.5];
    [_textView.layer setCornerRadius:10.0];
    [_textView setFont:kFont16];
    _textView.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    [self.view addSubview:_textView];
    
    switch (_personalType) {
        case McpersonalTypeNickName:
        {
            titleStr = @"昵称";
            desicrib = [NSString stringWithFormat:@"%@个字以上 %@个字以内",_nickLimitMutDic[@"min"],_nickLimitMutDic[@"max"]];
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            _textView.hidden = YES;
            _textFiled.text = _personalData.nickName;
            bgView.hidden = NO;
            
        }
            break;
        case McPersonalTypeMark:
        {
            navTitle = @"个人签名";
            titleStr = @"";
            desicrib = @"最多三十字";
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            bgView.hidden = YES;
            _textView.hidden = NO;
            CGRect textViewFrame = _textView.frame;
            textViewFrame.size.height = 100;
            _textView.frame = textViewFrame;
            _textView.text = _personalData.signName;
        }
            break;
        case McPersonalTypeWorkExperience:
        {
            navTitle = @"工作经验";
            titleStr = @"";
            desicrib = [NSString stringWithFormat:@"最多%@字",_user_workhistoryLimMutDic[@"max"]];
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            bgView.hidden = YES;
            _textView.hidden = NO;
            CGRect textViewFrame = _textView.frame;
            textViewFrame.size.height = 200;
            _textView.frame = textViewFrame;
            _textView.text = _personalData.workExperience;
            
        }
            break;
        case McPersonalTypeWorkIntroduction:
        {
            navTitle = @"个人介绍";
            titleStr = @"";
            desicrib = [NSString stringWithFormat:@"最多%@字",_introduceLimMutDic[@"max"]];
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            bgView.hidden = YES;
            _textView.hidden = NO;
            CGRect textViewFrame = _textView.frame;
            textViewFrame.size.height = 200;
            _textView.frame = textViewFrame;
            _textView.text = _personalData.introduction;
            
        }
            break;
        case McPersonalTypeWorkWorkPlace:
        {
            navTitle = @"工作室";
            titleStr = @"";
            desicrib = [NSString stringWithFormat:@"最多%@字",_user_studioLimMutDic[@"max"]];
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            bgView.hidden = YES;
            _textView.hidden = NO;
            CGRect textViewFrame = _textView.frame;
            textViewFrame.size.height = 200;
            _textView.frame = textViewFrame;
            _textView.text = _personalData.workPlace;
            
        }
            break;
        case McPersonalTypeJob:
        {
            titleStr = @"职业";
            desicrib = @"如 学生 ，平面模特";
            _textFiled.keyboardType = UIKeyboardTypeDefault;
            _textView.hidden = YES;
            bgView.hidden = NO;
        }
            break;
        case McPersonalTypeDesiredSalary:
        {
            titleStr = @"期望薪水";
            unitLab = @"元/每天";
            desicrib = @"";
            _textFiled.keyboardType = UIKeyboardTypeNumberPad;
            _textView.hidden = YES;
            bgView.hidden = NO;
            _textFiled.text = _personalData.desiredSalary;
        }
            break;
        case McPersonalTypeHeight:
        {
            titleStr = @"身高";
            unitLab = @"厘米";
            desicrib = @"加V后不能修改，请慎重填写\n参考数字为150–210";
            _textFiled.keyboardType = UIKeyboardTypeNumberPad;
            _textView.hidden = YES;
            bgView.hidden = NO;
            _textFiled.text = _personalData.height;
        }
            break;
        case McPersonalTypeWeight:
        {
            titleStr = @"体重";
            unitLab = @"公斤";
            desicrib = @"加V后不能修改，请慎重填写\n参考数字为35-90";
            _textFiled.keyboardType = UIKeyboardTypeNumberPad;
            _textView.hidden = YES;
            bgView.hidden = NO;
            _textFiled.text = _personalData.weight;
        }
            break;
        case McPersonalTypeLeg:
        {
            titleStr = @"腿长";
            unitLab = @"厘米";
            desicrib = @"参考数字为80-120";
            _textFiled.keyboardType = UIKeyboardTypeNumberPad;
            _textView.hidden = YES;
            bgView.hidden = NO;
            _textFiled.text = _personalData.leg;
        }
            break;
        case McPersonalTypeMajor:
        {
            titleStr = @"专业";
            desicrib = @"如 舞蹈";
            
            _textFiled.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            _textView.hidden = YES;
            bgView.hidden = NO;
        }
            break;
        default:
            break;
    }
    
    self.navigationItem.title = navTitle;
    
    if ([titleStr length] > 0) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 20)];
        titleLabel.text = titleStr;
        titleLabel.font = kFont16;
        titleLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        
        _textFiled.leftView = titleLabel;
        _textFiled.leftViewMode = UITextFieldViewModeAlways;
    }
    
    if ([desicrib length] > 0) {
        float orignY = 75;
        float orignX = 15;
        float width = self.view.frame.size.width - 30;
        if (!_textView.hidden) {
            orignY = _textView.frame.size.height + _textView.frame.origin.y + 5;
            orignX = self.view.frame.size.width - 160;
            width = 140;
        }
        
        UILabel *decriLabel = [[UILabel alloc] initWithFrame:CGRectMake(orignX, orignY, width, 50)];
        decriLabel.text = desicrib;
        decriLabel.font = kFont14;
        decriLabel.numberOfLines = 2;
        decriLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        decriLabel.backgroundColor = [UIColor clearColor];
        
        if (!_textView.hidden) {
            decriLabel.textAlignment = NSTextAlignmentRight;
        }
        [self.view addSubview:decriLabel];
    }
    if ([unitLab length] > 0) {
        
        UILabel *unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width -95, 35, 80, 20)];
        unitLabel.text = unitLab;
        unitLabel.font = kFont16;
        unitLabel.textAlignment = NSTextAlignmentRight;
        unitLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        [self.view addSubview:unitLabel];
        unitLabel.backgroundColor = [UIColor clearColor];
        
//        CGRect textFieldFrame = _textFiled.frame;
//        textFieldFrame.size.width = self.view.frame.size.width - 100;
//        _textFiled.frame = textFieldFrame;
        
    }
    
    if ([_textFiled.text isEqualToString:@"0"]) {
        _textFiled.text = @"";
    }
    
    if (!_textFiled.hidden) {
        [_textFiled becomeFirstResponder];
    }
    
    if (!_textView.hidden) {
        [_textView becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark action
- (void)doBackAction:(id)sender
{
//    [self isInitPersonalData];
    [_textFiled resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    
//    [self editPersonalData];
    
}

- (void)editPersonalData
{
//    if (![self isCheckRight]) {
//        return;
//    }
    switch (_personalType) {
        case McpersonalTypeNickName:
        {
            if([_textFiled.text length] < [_nickLimitMutDic[@"min"] integerValue] || [_textFiled.text length] > [_nickLimitMutDic[@"max"] integerValue] ){
                [LeafNotification showInController:self withText:@"请输入符合条件的昵称"];
                return;
            }
            
            //判断空格
            NSRange _range = [_textFiled.text rangeOfString:@" "];
            if (_range.location != NSNotFound) {
                //有空格
                [LeafNotification showInController:self withText:@"设置昵称不能含用空格"];
                return;
            }else {
                //没有空格
            }
            
            //判断换行
            if ([_textFiled.text isEqualToString:@"\n"]) {
                [LeafNotification showInController:self withText:@"设置昵称不能含用换行"];
                return;
            }
            
        }
            break;
        default:
            break;
    }
    
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    
    switch (_personalType) {
        case McpersonalTypeNickName:
        {
            NSString *value = _textFiled.text;
            [dict setValue:value forKey:@"nickname"];
        }
            break;
        case McPersonalTypeMark:
        {
            NSString *value = _textView.text;
            [dict setValue:value forKey:@"mark"];
        }
            break;
        case McPersonalTypeWorkExperience:
        {
            
            NSString *value = _textView.text;;
            [dict setValue:value forKey:@"workhistory"];
        }
            break;
        case McPersonalTypeWorkIntroduction:
        {
            
            NSString *value = _textView.text;;
            [dict setValue:value forKey:@"introduction"];
        }
            break;
        case McPersonalTypeWorkWorkPlace:
        {
            
            NSString *value = _textView.text;;
            [dict setValue:value forKey:@"studio"];//待定
        }
            break;
        case McPersonalTypeJob:
        {
            [dict setValue:_textFiled.text forKey:@"job"];
        }
            break;
        case McPersonalTypeDesiredSalary:
        {
            [dict setValue:_textFiled.text forKey:@"payment"];
        }
            break;
        case McPersonalTypeHeight:
        {
            [dict setValue:_textFiled.text forKey:@"height"];
        }
            break;
        case McPersonalTypeWeight:
        {
            [dict setValue:_textFiled.text forKey:@"weight"];
        }
            break;
        case McPersonalTypeLeg:
        {
            [dict setValue:_textFiled.text forKey:@"leg"];
        }
            break;
        case McPersonalTypeMajor:
        {
            [dict setValue:_textFiled.text forKey:@"major"];
        }
            break;
        default:
            break;
    }
    
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){
        [self editDonePersonalData:data];
    }failed:^(NSError *error){
        NSLog(@"error:%@",error);
    }];
}

- (void)editDonePersonalData:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        [self isInitPersonalData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"msg:%@",data[@"msg"]);
    [LeafNotification showInController:self withText:data[@"msg"]];
}

- (BOOL)isCheckRight
{
    
    switch (_personalType) {
        case McpersonalTypeNickName:
        {
            if([_textFiled.text length] < 2 || [_textFiled.text length] >= 6 ){
                [LeafNotification showInController:self withText:@"请输入符合条件的昵称"];
                return NO;
            }
        }
            break;
        case McPersonalTypeMark:
        {
            if([_textView.text length] > 30){
                [LeafNotification showInController:self withText:@"签名不能超过30字"];
                return NO;
            }
        }
            break;
        case McPersonalTypeWorkExperience:
        {
            if([_textView.text length] > 500){
                [LeafNotification showInController:self withText:@"个人简历不能超过500字"];
                return NO;
            }
        }
            break;
        
        case McPersonalTypeDesiredSalary:
        {
            if ([_textFiled.text length] > 0) {
                if (![self isPure]) {
                    return NO;
                }
            }
            
        }
            break;
        case McPersonalTypeHeight:
        {
            if ([_textFiled.text length] > 0) {
                if (![self isPure]) {
                    return NO;
                }
                if([_textFiled.text floatValue] < 150 || [_textFiled.text floatValue] > 210){
                    [LeafNotification showInController:self withText:@"请符合实际情况"];
                    return NO;
                }
            }
            
        }
            break;
        case McPersonalTypeWeight:
        {
            if ([_textFiled.text length] > 0) {
                if (![self isPure]) {
                    return NO;
                }
                if([_textFiled.text floatValue] < 35 || [_textFiled.text floatValue] > 90){
                    [LeafNotification showInController:self withText:@"请符合实际情况"];
                    return NO;
                }
            }
        }
            break;
        case McPersonalTypeLeg:
        {
            if ([_textFiled.text length] > 0) {
                if (![self isPure]) {
                    return NO;
                }
                if([_textFiled.text floatValue] < 80 || [_textFiled.text floatValue] > 120){
                    [LeafNotification showInController:self withText:@"请符合实际情况"];
                    return NO;
                }
            }
            
        }
            break;
        
        default:
            break;
    }
    return YES;
}

- (BOOL)isPure
{
    if( ![SQCStringUtils isPureInt:_textFiled.text] || ![SQCStringUtils isPureFloat:_textFiled.text])
    {
        [LeafNotification showInController:self withText:@"警告:含非法字符，请输入纯数字！"];
        return NO;
    }

    return YES;
}

- (void)isInitPersonalData
{
    switch (_personalType) {
        case McpersonalTypeNickName:
        {
            _personalData.nickName = _textFiled.text;
        }
            break;
        case McPersonalTypeMark:
        {
            NSString *value = _textView.text;

            _personalData.signName = value;
        }
            break;
        case McPersonalTypeWorkExperience:
        {
            NSString *value = _textView.text;
            _personalData.workExperience = value;
        }
            break;
        case McPersonalTypeWorkIntroduction:
        {
            NSString *value = _textView.text;
            _personalData.introduction = value;
        }
            break;
        case McPersonalTypeWorkWorkPlace:
        {
            NSString *value = _textView.text;
            _personalData.workPlace = value;
        }
            break;
        case McPersonalTypeJob:
        {
            _personalData.job = _textFiled.text;
        }
            break;
        case McPersonalTypeDesiredSalary:
        {
            _personalData.desiredSalary = _textFiled.text;
        }
            break;
        case McPersonalTypeHeight:
        {
            _personalData.height = _textFiled.text;
        }
            break;
        case McPersonalTypeWeight:
        {
            _personalData.weight = _textFiled.text;
        }
            break;
        case McPersonalTypeLeg:
        {
            _personalData.leg = _textFiled.text;
        }
            break;
        case McPersonalTypeMajor:
        {
            _personalData.major = _textFiled.text;
        }
            break;
        default:
            break;
    }
}

@end
