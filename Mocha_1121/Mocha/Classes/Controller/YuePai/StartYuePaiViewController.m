//
//  StartYuePaiViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/13.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "StartYuePaiViewController.h"
#import "McEditBirthViewController.h"
#import "YuePaiPayViewController.h"

@interface StartYuePaiViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *acceptHeaderImage;

@property (weak, nonatomic) IBOutlet UILabel *accecptUserName;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UITextView *beizhuTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *labeltitle;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourLabel;

@property (nonatomic,copy) NSString *beizhuText;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noteTopConstraint;
@property (weak, nonatomic) IBOutlet UIView *beishuSuperView;


@end

@implementation StartYuePaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_isTaoxi) {
        //专题
        self.title = @"专题订单";
        self.moneyTextfield.text = self.price;
        self.priceLabel.text = self.price;
        self.moneyTextfield.userInteractionEnabled = NO;
        _beizhuTextView.text = @"( 选填，如时间，地点，风格类型等 )";
    }else{
        self.title = @"发起约拍";
        self.moneyTextfield.userInteractionEnabled = YES;
        _beizhuTextView.text = @"( 选填，如拍摄时间，拍摄地点，风格类型等 )";
    }
    [self initView];
    
    [self refreshButtonState];

    //监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}


//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    float keyboardH = [self keyboardEndingFrameHeight:notification.userInfo];
    float beizhuBottom = self.beishuSuperView.bottom;
    NSLog(@"%f",beizhuBottom);
    self.view.frame=CGRectMake(currentFrame.origin.x, kDeviceHeight-beizhuBottom-keyboardH, currentFrame.size.width, currentFrame.size.height);
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    NSLog(@"%f",currentFrame.size.height);
    self.view.frame=CGRectMake(currentFrame.origin.x, 64, currentFrame.size.width, currentFrame.size.height);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isTaoxi) {
        self.yuePaiView.hidden = YES;
        self.taoXiView.hidden = NO;
        self.noteTopConstraint.constant = 273;
        
    }else{
        self.yuePaiView.hidden = NO;
        self.taoXiView.hidden = YES;
        self.noteTopConstraint.constant = 333;
    }
}

- (void)initView
{
    NSString *receiveName = getSafeString(self.receiveName);
    NSString * receiveHeader = [NSString stringWithFormat:@"%@%@",getSafeString(self.receiveHeader),[CommonUtils imageStringWithWidth:kDeviceWidth height:kDeviceWidth]];
    self.accecptUserName.text = receiveName;

    self.acceptHeaderImage.layer.cornerRadius = 45;
    self.acceptHeaderImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.acceptHeaderImage.layer.borderWidth = 0.5;
    
    [self.acceptHeaderImage sd_setImageWithURL:[NSURL URLWithString:receiveHeader] placeholderImage:nil];

    if (_isTaoxi) {
        //专题
        self.nameLabel.text = [NSString stringWithFormat:@"发起人: %@",receiveName];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@"摄影师: %@",receiveName];
    }

    self.taoXinameLabel.text = [NSString stringWithFormat:@"专题名称: %@",self.taoXiName];
    //从服务器获取,区分约拍和专题
    self.labeltitle.text = CovenantTips;
    self.firstLabel.text = CovenantCreate;
    self.secondLabel.text = CovenantBail;
    self.thirdLabel.text = CovenantJoin;
    self.fourLabel.text = CovenantOver;
    if (_isTaoxi) {
        //小字
        self.firstLabel.text = CovenantTaoXiTips;
        self.secondLabel.text = CovenantTaoXiBail;
        self.thirdLabel.text = CovenantTaoXiJoin ;
        self.fourLabel.text = CovenantTaoXiOver;
        self.labeltitle.text = CovenantCrearTaoXiTips;
    }
}

- (IBAction)clearkeyboard
{
    [self dismissKeyboard:nil];
//    self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);

}

- (IBAction)choseDate:(id)sender {
    __weak StartYuePaiViewController *weakSelf = self;
 
    McEditBirthViewController *editDataVC = [[McEditBirthViewController alloc] initWithType:McPersonalTypeBirth];
    if (_isTaoxi) {
        //专题
        editDataVC.titleString = @"订单日期";
        //self.beizhuTextView.text = @"( 选填，如时间，地点，风格类型等 )";
     }else{
        editDataVC.titleString = @"拍摄日期";
    }

    
    editDataVC.isFromYuePai = YES;
    [editDataVC setCallBack:^(NSString *string) {
        weakSelf.timeLabel.text = string;
        [weakSelf refreshButtonState];
        NSLog(@"%@",string);
    }];
    
    [self.navigationController pushViewController:editDataVC animated:YES];
    
}

- (void)refreshButtonState
{
    if (self.timeLabel.text.length==0||self.moneyTextfield.text.length==0) {
        self.submitButton.enabled = NO;
        [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];
    }else
    {
        self.submitButton.enabled = YES;
        [self.submitButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    }
    
}

- (IBAction)submitMethod:(id)sender {
    
    
    NSString *to_uid = getSafeString(self.receiveUid);
    NSString *covenant_day = getSafeString(self.timeLabel.text);
    NSString *money = getSafeString(self.moneyTextfield.text);
    NSString *remark = getSafeString(self.beizhuTextView.text);
    NSString *object_type = getSafeString(@"10");
    NSString *object_id = getSafeString(self.taoXiID);
    if ([remark isEqualToString:@"( 选填，如拍摄时间，拍摄地点，风格类型等 )"]) {
        remark = @"";
    }else if([remark isEqualToString:@"( 选填，如时间，地点，风格类型等 )"]){
        remark = @"";
    }
    float mon = [money floatValue];
    if (mon>0.0999999&&mon<10000) {
        
    }else
    {
        [LeafNotification showInController:self withText:@"输入金额应在0.1和9999之间。"];
        return;
    }
    NSMutableDictionary *params = (NSMutableDictionary *)[AFParamFormat formatTempleteParams:@{@"to_uid":to_uid,@"covenant_day":covenant_day,@"money":money,@"remark":remark}];
    
    if (self.isTaoxi) {
        params = (NSMutableDictionary *)[AFParamFormat formatTempleteParams:@{@"to_uid":to_uid,@"covenant_day":covenant_day,@"money":money,@"remark":remark,@"object_type":object_type,@"object_id":object_id}];
    }
    
    [SVProgressHUD showInfoWithStatus:@"订单生成中"];

    [AFNetwork postRequeatDataParams:params path:PathUserYuePai success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {

            
            [self gotoPayView:data[@"data"]];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
       [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];        
    }];
    
}

- (void)gotoPayView:(NSDictionary *)diction
{
    NSString *receiveName = getSafeString(self.receiveName);

    YuePaiPayViewController *pay = [[YuePaiPayViewController alloc] initWithNibName:@"YuePaiPayViewController" bundle:[NSBundle mainBundle]];
    pay.diction = diction;
    pay.isNeedPay = YES;
    pay.isFrowStart = YES;
    pay.isTaoXi = self.isTaoxi;
    pay.nameStr = [NSString stringWithFormat:@"摄影师: %@",receiveName];
    if (_isTaoxi) {
        pay.nameStr = [NSString stringWithFormat:@"发起人: %@",receiveName];
    }
    pay.taoXiName = [NSString stringWithFormat:@"专题名称: %@",self.taoXiName];
    
    [self.navigationController pushViewController:pay animated:YES];

}

- (IBAction)dismissKeyboard:(id)sender {
    [self.moneyTextfield resignFirstResponder];
    [self.beizhuTextView resignFirstResponder];
    [self refreshButtonState];

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length==0&&self.moneyTextfield.text.length==1) {
        self.submitButton.enabled = NO;
        [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];
    }else
    {
        self.submitButton.enabled = YES;
        [self.submitButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *titleString = @"";
    if (_isTaoxi) {
        //专题
        titleString = @"( 选填，如时间，地点，风格类型等 )";
    }else{
        titleString = @"( 选填，如拍摄时间，拍摄地点，风格类型等 )";
    }

    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];

    }
    if (kScreenWidth==320) {
//        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight);

    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSString *titleString = @"";
    if (_isTaoxi) {
        //专题
        titleString = @"( 选填，如时间，地点，风格类型等 )";
    }else{
        titleString = @"( 选填，如拍摄时间，拍摄地点，风格类型等 )";
    }
    
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    self.beizhuText = text;
    if ([@"\n" isEqualToString:text] == YES) {
        if (kScreenWidth==320) {
//            self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight);
            
        }
        [self.beizhuTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
}
@end
