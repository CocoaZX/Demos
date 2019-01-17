//
//  GetingCashViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/12/12.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "GetingCashViewController.h"
#import "CashingDetailViewController.h"
#import "payRequsestHandler.h"

@interface GetingCashViewController ()

@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIView *alertView;
@property (weak, nonatomic) IBOutlet UIView *alertDetailView;
@property (weak, nonatomic) IBOutlet UILabel *alert_title;
@property (weak, nonatomic) IBOutlet UIImageView *alert_headerImage;
@property (weak, nonatomic) IBOutlet UILabel *alert_name;


@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (copy, nonatomic) NSString *openIdString;
@property (copy, nonatomic) NSString *weixinName;

@end

@implementation GetingCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"零钱提现";
    
    self.alert_headerImage.layer.cornerRadius = 25;
//    self.currentMoney = @"5";
    self.inputTextfield.placeholder = [NSString stringWithFormat:@"当前余额为%@元",self.currentMoney];
    
    if (self.isChongZhi) {
        self.title = @"零钱充值";
        self.subtitleLabel.text = @"支持通过微信充值";
        self.inputTextfield.placeholder = @"请输入金额";

    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"WxPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed) name:@"payFailed" object:nil];
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WxPaySuccess" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.alertView removeFromSuperview];
    [self.alertDetailView removeFromSuperview];
}

- (void)paySuccess
{
    CashingDetailViewController *cash = [[CashingDetailViewController alloc] initWithNibName:@"CashingDetailViewController" bundle:[NSBundle mainBundle]];
    cash.currentMoney = getSafeString(self.inputTextfield.text);
    cash.isChongZhi = YES;
    [self.navigationController pushViewController:cash animated:YES];
}

- (void)payFailed
{
    [LeafNotification showInController:self withText:@"支付未成功"];
    
}

- (IBAction)nextStep:(id)sender {
    if (self.isChongZhi) {
        [self sendChongzhiService];
    }else
    {
        [self tixianMethod];
    }
}

- (void)tixianMethod
{
    NSString *targetString = self.inputTextfield.text;
    if ([targetString floatValue]<1) {
        if (kScreenHeight==480) {
            [self.inputTextfield resignFirstResponder];
            
        }
        [LeafNotification showInController:self withText:@"提现金额最小为1元"];
        return;
    }
    
    if ([targetString floatValue]>[self.currentMoney floatValue]) {
        if (kScreenHeight==480) {
            [self.inputTextfield resignFirstResponder];

        }
        [LeafNotification showInController:self withText:@"提现不能超过账户余额"];
        return;
    }
    
    [self.inputTextfield resignFirstResponder];
    
    [[WeixinMagnager shareWeixinManager] sendAuthRequestWithController:self success:^(BOOL success, NSDictionary *diction) {
        NSLog(@"%@",diction);
        self.openIdString = getSafeString(diction[@"openid"]);
        
        if (self.openIdString.length>0) {
            self.weixinName = getSafeString(diction[@"nickname"]);
            
            self.alert_title.text = [NSString stringWithFormat:@"确认提现%@元到微信",self.inputTextfield.text];
            self.alert_name.text = self.weixinName;
            [self.alert_headerImage sd_setImageWithURL:[NSURL URLWithString:getSafeString(diction[@"headimgurl"])]];
            [self.view addSubview:self.alertView];
            [self.view bringSubviewToFront:self.alertView];
            self.alertView.hidden = NO;
            self.alertDetailView.hidden = NO;
//            NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
//            for (UIWindow *window in frontToBackWindows){
//                BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
//                BOOL windowIsVisible = !window.hidden && window.alpha > 0;
//                BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
//                
//                if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
//                    [window addSubview:self.alertView];
//                    self.alertView.hidden = NO;
//                    self.alertDetailView.hidden = NO;
//                    
//                    break;
//                }
//            }
            
        }else
        {
            [self hiddenTixianAlert];
        }
        
    }];

    
}


- (void)hiddenTixianAlert
{
    self.alertDetailView.hidden = YES;
    self.alertView.hidden = YES;
    
    

}

- (IBAction)sureMethod:(id)sender {
    self.alertView.hidden = YES;
    self.alertDetailView.hidden = YES;
    
    

    if (self.isChongZhi) {
        [self sendChongzhiService];
    }else
    {
        [self sendTixianService];
    }
 
}

- (void)sendTixianService
{

    NSString *openId = getSafeString(self.openIdString);
    NSString *money = getSafeString(self.inputTextfield.text);
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"openid":openId,@"money":money}];
    
    [AFNetwork postRequeatDataParams:params path:PathCashing success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            
            CashingDetailViewController *cash = [[CashingDetailViewController alloc] initWithNibName:@"CashingDetailViewController" bundle:[NSBundle mainBundle]];
            cash.currentMoney = getSafeString(self.inputTextfield.text);
            cash.currentName = self.weixinName;
            [self.navigationController pushViewController:cash animated:YES];
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
}

- (void)sendChongzhiService
{
    NSString *targetString = self.inputTextfield.text;
    if ([targetString floatValue]<1) {
        if (kScreenHeight==480) {
            [self.inputTextfield resignFirstResponder];
            
        }
        [LeafNotification showInController:self withText:@"提现金额最小为1元"];
        return;
    }
    
    if ([targetString floatValue]>[self.currentMoney floatValue]) {
        if (kScreenHeight==480) {
            [self.inputTextfield resignFirstResponder];
            
        }
        [LeafNotification showInController:self withText:@"提现不能超过账户余额"];
        return;
    }
    
    [self.inputTextfield resignFirstResponder];
    
    [SVProgressHUD show];
    NSString *money = getSafeString(self.inputTextfield.text);
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"money":money}];
    
    [AFNetwork postRequeatDataParams:params path:PathRecharge success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            
            //创建支付签名对象
            payRequsestHandler *req = [[payRequsestHandler alloc] init];
            //初始化支付签名对象
            [req init:APP_ID mch_id:MCH_ID];
            //设置密钥
            [req setKey:PARTNER_ID];
            
            //}}}
            
            //获取到实际调起微信支付的参数后，在app端调起支付
            NSMutableDictionary *dict = [req sendPay_demo];
            
            if(dict == nil){
                //错误提示
                NSString *debug = [req getDebugifo];
                
                
                NSLog(@"%@\n\n",debug);
            }else{
                NSLog(@"%@\n\n",[req getDebugifo]);
                
                dict = [req erciqianmingWithDiction:data[@"data"]].mutableCopy;
                
                NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
                
                //调起微信支付
                PayReq* req             = [[PayReq alloc] init];
                req.openID              = [dict objectForKey:@"appid"];
                req.partnerId           = [dict objectForKey:@"partnerid"];
                req.prepayId            = [dict objectForKey:@"prepayid"];
                req.nonceStr            = [dict objectForKey:@"noncestr"];
                req.timeStamp           = stamp.intValue;
                req.package             = [dict objectForKey:@"package"];
                req.sign                = [dict objectForKey:@"sign"];
                //                dict = data[@"data"];
                //                //调起微信支付
                //                PayReq* req             = [[PayReq alloc] init];
                //                req.openID              = [dict objectForKey:@"appid"];
                //                req.partnerId           = [dict objectForKey:@"mch_id"];
                //                req.prepayId            = [dict objectForKey:@"prepay_id"];
                //                req.nonceStr            = [dict objectForKey:@"nonce_str"];
                //                req.timeStamp           = stamp.intValue;
                //                req.package             = [dict objectForKey:@"package"];
                //                req.sign                = [dict objectForKey:@"sign"];
                
                [WXApi sendReq:req];
            }
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];

        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
}

- (IBAction)cancelMethod:(id)sender {
    
    [self hiddenTixianAlert];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length==0&&textField.text.length==1) {
        self.nextButton.enabled = NO;
        [self.nextButton setBackgroundColor:[UIColor lightGrayColor]];
    }else
    {
        self.nextButton.enabled = YES;
        [self.nextButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    }
    return YES;
}





@end
