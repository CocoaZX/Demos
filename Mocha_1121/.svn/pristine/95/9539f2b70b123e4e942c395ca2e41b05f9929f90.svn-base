//
//  McEditBirthViewController.m
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditBirthViewController.h"

@interface McEditBirthViewController ()
{
    NSString *selectBirth;
}

@property (nonatomic, retain) UIButton *birthButton;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, assign) McPersonalType personalType;

@end

@implementation McEditBirthViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.personalType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.titleString;

    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(-2, 20, self.view.frame.size.width + 2, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView.layer setBorderColor:[UIColor colorForHex:kLikeLightGrayColor].CGColor];
    [bgView.layer setBorderWidth:0.5];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 100, 20)];
    titleLabel.text = self.titleString;
    titleLabel.font = kFont16;
    titleLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:titleLabel];
    
    self.birthButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_birthButton setFrame:CGRectMake(-2, 20, self.view.frame.size.width + 2, 40)];
    [_birthButton setContentEdgeInsets:UIEdgeInsetsMake(10, 200, 10, 20)];
    [_birthButton.titleLabel setFont:kFont16];
    [_birthButton setTitleColor:[UIColor colorForHex:kLikeBlackColor] forState:UIControlStateNormal];
    [self.view addSubview:_birthButton];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 80, self.view.frame.size.width - 40, 20)];
    label.text = @"加V后，不能修改，请谨慎选择";
    label.font = kFont14;
//    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorForHex:kLikeLightRedColor];
    if (self.personalData) {
        [self.view addSubview:label];

    }
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    

    NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0];
    self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 300, self.view.frame.size.width, 216)];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    if (self.isFromYuePai) {
        NSDate *nowDate = [NSDate date];
        [self.datePicker setMinimumDate:nowDate];
        
    }
    
    if (self.personalData) {
        [self.datePicker setMaximumDate:maxDate];

    }
    
    [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];
    [self.view addSubview:_datePicker];
    
    if (self.personalData) {
        if([_personalData.age length] > 0){
            NSDate *setDate = [dateFormatter dateFromString:_personalData.age];
            [_birthButton setTitle:[dateFormatter stringFromDate:setDate] forState:UIControlStateNormal];
            [self.datePicker setDate:setDate animated:NO];
        }
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

- (void)dateChanged:(id)sender {
    NSDate *select = [_datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateBirth =  [dateFormatter stringFromDate:select];
    [_birthButton setTitle:dateBirth forState:UIControlStateNormal];
//    _personalData.age = dateBirth;
    selectBirth = dateBirth;
}

- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

}


- (void)modifyAction:(id)sender
{
    if (self.personalData) {
        NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
        NSString *uid = [userDict valueForKey:@"id"];
        NSString *mobile = [userDict valueForKey:@"mobile"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
        [dict setValue:selectBirth forKey:@"birth"];
        
        NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
        [AFNetwork editUserInfo:params success:^(id data){
            [self modifyDoneAction:data];
        }failed:^(NSError *error){
            [LeafNotification showInController:self withText:@"网络链接错误"];
        }];
    }else
    {
        if (selectBirth) {
            NSDate *select = [_datePicker date];
            NSTimeInterval time = [select timeIntervalSince1970];

            NSLog(@"%f",time);
            [self setTimeStampWith:[NSString stringWithFormat:@"%.f",time]];

            self.returenBlock(selectBirth);
            
        }else
        {
            NSDate *select = [_datePicker date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSTimeInterval time = [select timeIntervalSince1970];

            NSLog(@"%f",time);
            [self setTimeStampWith:[NSString stringWithFormat:@"%.f",time]];

            NSString *dateBirth =  [dateFormatter stringFromDate:select];
            [_birthButton setTitle:dateBirth forState:UIControlStateNormal];
            self.returenBlock(dateBirth);
            
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
    
}

- (void)setTimeStampWith:(NSString *)string
{
    if ([self.titleString isEqualToString:@"开始时间"]) {
        
        [ActivityDataModel sharedInstance].startTime = getSafeString(string);

    }else if ([self.titleString isEqualToString:@"结束时间"])
    {
        [ActivityDataModel sharedInstance].endTime = getSafeString(string);
        
    }else if ([self.titleString isEqualToString:@"截止时间"])
    {
        [ActivityDataModel sharedInstance].baomingTime = getSafeString(string);
    }
    
}

- (void)modifyDoneAction:(id)result
{
    if ([result[@"status"] integerValue] == kRight) {
        if (self.personalData) {
            _personalData.age = selectBirth;
            
        }
        
        [LeafNotification showInController:self withText:result[@"msg"]];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [LeafNotification showInController:self withText:result[@"msg"]];
}

- (void)setCallBack:(ChangeFinishBlock)block
{
    self.returenBlock = block;
    
}

@end
