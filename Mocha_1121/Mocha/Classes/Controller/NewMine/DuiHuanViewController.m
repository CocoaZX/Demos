//
//  DuiHuanViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DuiHuanViewController.h"

@interface DuiHuanViewController ()

@property (weak, nonatomic) IBOutlet UIView *inputView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;

@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;

@property (weak, nonatomic) IBOutlet UILabel *duihuanLabel;
@property (weak, nonatomic) IBOutlet UILabel *inputLabel;

@property (weak, nonatomic) IBOutlet UIButton *duihuanButton;

@property (assign, nonatomic) int numberOfYuan;
@property (assign, nonatomic) int oneYuanToJinBi;
@property (assign, nonatomic) int minDuiHuan;
@property (assign, nonatomic) float servicePercent;

@property (copy, nonatomic) NSString *sendMoney;

@end

@implementation DuiHuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金币兑换";
    self.inputView.layer.borderColor = [UIColor clearColor].CGColor;
    self.inputView.layer.borderWidth = 1;
    self.inputView.layer.cornerRadius = 12;
    
    self.duihuanButton.layer.cornerRadius = 40;
    
    self.view.backgroundColor = NewbackgroundColor;

    NSDictionary *exchangeDiction = MCAPI_Data_Object1(ConfigExchangeSetting);
    
    self.numberOfYuan = 1;
    self.oneYuanToJinBi = 8;
    self.servicePercent = 0.2;
    self.minDuiHuan = 16;
    
    NSString *m = getSafeString(exchangeDiction[@"m"]);
    NSString *c = getSafeString(exchangeDiction[@"c"]);
    NSString *s = getSafeString(exchangeDiction[@"s"]);
    NSString *min = getSafeString(exchangeDiction[@"min"]);
    
    if (m.length>0) {
        self.numberOfYuan = [m intValue];
        
    }

    if (c.length>0) {
        self.oneYuanToJinBi = [c intValue];
        
    }
    
    if (s.length>0) {
        self.servicePercent = [s floatValue]/100;
        
    }
    
    if (min.length>0) {
        self.minDuiHuan = [min intValue];
        
    }

    [self getServiceData];
}

- (void)getServiceData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    [AFNetwork postRequeatDataParams:params path:PathUserWalletSummary success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = data[@"data"];
            self.jinbiLabel.text = [NSString stringWithFormat:@"%@",dict[@"goldCoin"]];

            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}


- (IBAction)duihuanMethod:(id)sender {
    NSString *money = getSafeString(self.inputTextfield.text);
    if (money.length==0) {
        [LeafNotification showInController:self withText:@"请输入金币"];
        return;
    }
    
    if (money.intValue<self.minDuiHuan) {
        [LeafNotification showInController:self withText:[NSString stringWithFormat:@"兑换至少需要%d个金币",self.minDuiHuan] withTime:1];
        return;
    }
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"coin":getSafeString(money)}];
    
    [SVProgressHUD show];
    
    [AFNetwork postRequeatDataParams:params path:PathGetCoinToMoney success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];
            
            [self performSelector:@selector(delayToBack) withObject:nil afterDelay:1.0];
        }
       
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}

- (void)delayToBack
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)changjianMethod:(id)sender {
    
    
    
}


- (IBAction)dismissKeyboard:(id)sender {
    [self.inputTextfield resignFirstResponder];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *oldstring = getSafeString(textField.text);
    NSString *newstring = getSafeString(string);
    if ([newstring isEqualToString:@"0"]||[newstring isEqualToString:@"1"]
        ||[newstring isEqualToString:@"2"]||[newstring isEqualToString:@"3"]
        ||[newstring isEqualToString:@"4"]||[newstring isEqualToString:@"5"]
        ||[newstring isEqualToString:@"6"]||[newstring isEqualToString:@"7"]
        ||[newstring isEqualToString:@"8"]||[newstring isEqualToString:@"9"]
        ||[newstring isEqualToString:@""]) {
        
    }else
    {
        return NO;

    }
    NSString *allString = [NSString stringWithFormat:@"%@%@",oldstring,newstring];
    if (allString.length>6) {
        return NO;
    }
    NSString *currentCoin = getSafeString(self.jinbiLabel.text);
    if ([allString intValue]>[currentCoin intValue]) {
        [self.view endEditing:YES];
        textField.text = @"0";
        [LeafNotification showInController:self withText:@"您的金币不足"];
        return NO;
    }
    NSLog(@"%lu",(unsigned long)newstring.length);
    if (newstring.length==0) {
        //此方法在用户多点击删除按钮时，会发生崩溃
        if (oldstring.length==0) {
            
        }else
        {
            oldstring = [oldstring stringByReplacingCharactersInRange:NSMakeRange(oldstring.length-1, 1) withString:@""];
        }
//        oldstring = [oldstring stringByAppendingString:@""];
    }
    NSLog(@"%@-%@",oldstring,newstring);
    
    NSString *totalMoney = [NSString stringWithFormat:@"%@%@",oldstring,newstring];
    float total = [totalMoney floatValue];
    
    float finalMoney = (total/self.oneYuanToJinBi) - (total/self.oneYuanToJinBi*self.servicePercent);
    
    NSString *finalString = [NSString stringWithFormat:@"%.2f",finalMoney];
    
    NSLog(@"%@",finalString);
    
    self.inputLabel.text = finalString;
    self.sendMoney = finalString;
    return YES;
}


@end
