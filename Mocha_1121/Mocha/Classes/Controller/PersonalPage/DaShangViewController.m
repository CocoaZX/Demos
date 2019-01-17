//
//  DaShangViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "DaShangViewController.h"
#import "BuyMemberSuccessViewController.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "JinBiSuccessViewController.h"
#import "time.h"
#import "GuideView.h"

@interface DaShangViewController ()
{
    NSString *spkey;
    NSMutableDictionary *ChatMutDic;
}

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMoney;

@property (weak, nonatomic) IBOutlet UILabel *qianbaoMoney;

@property (weak, nonatomic) IBOutlet UILabel *youhuiquantitle;

@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qianbaoButton;

@property (weak, nonatomic) IBOutlet UILabel *haixuzhifuLabel;

//打赏说明Label

@property (weak, nonatomic) IBOutlet UILabel *dashangDescriptionLabel;


@property (assign, nonatomic) BOOL isDayu;

@property (copy, nonatomic) NSString *qianBaoMoney;

@end

@implementation DaShangViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"确认打赏";
    //spkey = @"9411af079b3c04e1d41fcfc9763690be";
    //spkey = @"64CC22895ECA02D681557A4A166EAFC7";
    spkey = PARTNER_ID;
    
    self.qianbaoButton.selected = YES;
    self.isDayu = NO;
    self.qianbaoMoney.text = @"0元";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"WxPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed) name:@"payFailed" object:nil];
    [self getServiceData];
    [self getDeadlineDays];
    
    //不设置颜色，显示金额错误，原因未知
    self.haixuzhifuLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
}

- (void)paySuccess
{
    if (self.isBuyMember) {
        [LeafNotification showInController:self withText:@"购买会员成功"];

    }else if (self.isBuyCoin) {
        [LeafNotification showInController:self withText:@"金币充值成功"];
        
    }else if(self.isCustomPay){
        [LeafNotification showInController:self withText:@"支付成功"];

    }else
    {
        [LeafNotification showInController:self withText:@"打赏成功"];
        [ChatManager sendDaShangSuccessMessage:ChatMutDic];

    }
    [self performSelector:@selector(backToBrowse) withObject:nil afterDelay:2.0];
    
}

- (void)backToBrowse
{
    if (self.isBuyMember) {
        BuyMemberSuccessViewController *open = [[BuyMemberSuccessViewController alloc] initWithNibName:@"BuyMemberSuccessViewController" bundle:[NSBundle mainBundle]];
        open.days = [NSString stringWithFormat:@"%d",[self.days intValue]+[self.totaldays intValue]];
        [self.navigationController pushViewController:open animated:YES];
    }else if (self.isBuyCoin) {
        JinBiSuccessViewController *open = [[JinBiSuccessViewController alloc] initWithNibName:@"JinBiSuccessViewController" bundle:[NSBundle mainBundle]];
        open.titleString = @"金币充值";
        open.descString = @"充值成功";
        [self.navigationController pushViewController:open animated:YES];
    }else if(self.isCustomPay){
        //通用支付，回到原来的网页界面
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDaShangView" object:nil];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)payFailed
{
    [LeafNotification showInController:self withText:@"支付未成功"];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"打赏%@的照片",self.name];
    self.totalMoney.text = [NSString stringWithFormat:@"需支付：%@元",self.money];
    
    //设置打赏的提示说明
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSString *descriptionTxt = [descriptionDic objectForKey:@"reward_tips"];
    
    if (descriptionTxt.length == 0) {
        descriptionTxt = @"支付后, 对方会收到你的打赏消息哦～";
    }
    self.subtitleLabel.text = descriptionTxt;
    if (self.isBuyMember) {
        self.title = @"开通会员";
        self.titleLabel.text = @"开通会员";
        NSString *name = @"天费";
        if ([self.days isEqualToString:@"30"]) {
            name = @"月费";
        }else if ([self.days isEqualToString:@"180"]) {
            name = @"季费";
        }else if ([self.days isEqualToString:@"365"]) {
            name = @"年费";
        }
        self.subtitleLabel.text = [NSString stringWithFormat:@"支付会员费用，%@天（%@）",self.days,self.name];
    }else if (self.isBuyCoin)
    {
        self.title = @"金币充值";
        self.titleLabel.text = @"金币充值";
        self.subtitleLabel.text = self.descCoin;
        
    }else if(self.isCustomPay){
        //通用支付
        self.title = @"支付";
        self.titleLabel.text = self.customTitle;
        self.subtitleLabel.text = self.customDesc;
    }
}


- (IBAction)weixinPay:(id)sender {
    BOOL isSelected = self.weixinButton.selected;
    self.weixinButton.selected = !isSelected;
    if (self.isDayu) {
        
    }else
    {
        self.haixuzhifuLabel.text = @"";
        self.qianbaoButton.selected = NO;
        self.haixuzhifuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]];
    }
}

- (IBAction)youhuiquanMethod:(id)sender {
    
    
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
            NSString *userMoney = [NSString stringWithFormat:@"%@",dict[@"userMoney"]];
            self.qianBaoMoney = userMoney;
            
            if ([self.money floatValue]>[userMoney floatValue]) {
                self.qianbaoMoney.text = [NSString stringWithFormat:@"%@元",dict[@"userMoney"]];
                self.haixuzhifuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]-[userMoney floatValue]];
                self.isDayu = YES;
                self.weixinButton.selected = YES;

            }else
            {
                self.qianbaoMoney.text = [NSString stringWithFormat:@"%@元",self.money];
                self.haixuzhifuLabel.text = @"还需支付：0元";
            }
            

        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (IBAction)choseQIanBao:(id)sender {
    BOOL isSelected = self.qianbaoButton.selected;

    if (self.isDayu) {
        if (isSelected) {
            self.haixuzhifuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]];

        }else
        {
            self.haixuzhifuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]-[self.qianBaoMoney floatValue]];

        }
    }else
    {
        self.weixinButton.selected = NO;
        self.haixuzhifuLabel.text = @"还需支付：0元";

    }
    
    self.qianbaoButton.selected = !isSelected;
}


- (IBAction)payMethod:(id)sender {

    if (!self.weixinButton.selected&&!self.qianbaoButton.selected) {
        [LeafNotification showInController:self withText:@"请选择支付方式"];
        
        return;
    }
    BOOL isWx = NO;
    BOOL isQb = NO;
    BOOL isHeBing = NO;
    
    if (self.isDayu) {
        
        if (self.weixinButton.selected) {
            isWx = YES;
            [SingleData shareSingleData].isFromePay = YES;
        }
        if (self.qianbaoButton.selected) {
            
            if (!self.weixinButton.selected) {
                [LeafNotification showInController:self withText:@"余额不足"];
                
                return;

            }
        }
        if (self.qianbaoButton.selected&&self.weixinButton.selected) {
            isWx = NO;
            isQb = NO;
            isHeBing = YES;
            
        }
    }else
    {
        if (self.weixinButton.selected) {
            isWx = YES;
            [SingleData shareSingleData].isFromePay = YES;
        }
        if (self.qianbaoButton.selected) {
            isWx = NO;
            isQb = YES;
        }
        
        
    }
    
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *photoId = self.photoId;

    NSString *total_fee = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
    
    NSString *qianbao = @"0";
    NSString *weixin = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
    NSString *youhuiquan = @"0";
    
    if (isQb) {
        qianbao = [NSString stringWithFormat:@"%.2f",[self.money floatValue]];
        weixin = @"0";
    }
    if (isHeBing) {
        qianbao = [NSString stringWithFormat:@"%.2f",[self.qianBaoMoney floatValue]];
        weixin = [NSString stringWithFormat:@"%.2f",[self.money floatValue]-[self.qianBaoMoney floatValue]];
    }
    
    
    NSDictionary *payArr = @{@"1":qianbao,@"2":weixin,@"3":youhuiquan};
    
    NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
    
    NSString *interfacePath = PathUserReward;

    NSDictionary *params = [AFParamFormat formatPostDaShangParams:photoId amount:pay_info total_fee:total_fee];
    
    
    if (self.isBuyMember) {
        interfacePath = PathMemberBuy;
        params = [AFParamFormat formatPostMemberBuyParams:self.days pay_info:pay_info];
    }else if (self.isBuyCoin) {
        interfacePath = PathRecharge;
        params = [AFParamFormat formatPostCoinRechargeParams:self.money pay_info:pay_info coin:self.coin];

    }else if(self.isCustomPay){
        interfacePath = PathCustomPay;
        //通用支付设置参数
        NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:self.customPayTargetType forKey:@"object_type"];
        [mdic setObject:self.photoId forKey:@"object_id"];
        [mdic setObject:self.customDesc forKey:@"description"];
        [mdic setObject:pay_info forKey:@"pay_info"];
        params = [AFParamFormat formatTempleteParams:mdic];
     }
    
    [AFNetwork postRequeatDataParams:params path:interfacePath success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dic = (NSDictionary *)data;
            if (self.isCustomPay) {
                
            }else{
                //构建一个data字典，放在环信中
                ChatMutDic = [NSMutableDictionary dictionary];
                //扩展字典
                NSMutableDictionary *extdic = [NSMutableDictionary dictionary];
                [extdic setObject:photoId forKey:@"photoId"];
                [extdic setObject:@(2) forKey:@"objectType"];
                [extdic setObject:pay_info forKey:@"payInfo"];
                [extdic setObject:total_fee forKey:@"money"];
                [extdic setObject:_name forKey:@"username"];
                [ChatMutDic setObject:extdic forKey:@"ext"];
                
                [ChatMutDic setObject:@"图片打赏红包" forKey:@"msg"];
                
                NSString *fromUid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
                [ChatMutDic setObject:fromUid forKey:@"from"];
                [ChatMutDic setObject:_uid forKey:@"target"];
            }
            
            //如果没有微信支付，不会返回预订单等相关属性
            //也不必执行微信支付
            if (dic.allKeys.count==2) {
             [self performSelector:@selector(paySuccess) withObject:nil afterDelay:1.0];
                //发送一条打赏的消息
                
                 return;
            }
            
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
                NSLog(@"debug:%@\n\n",debug);
            }else{
                NSLog(@"getDebugifo:%@\n\n",[req getDebugifo]);
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
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
    
}


//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", spkey];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    
    
    return md5Sign;
}

- (void)getDeadlineDays
{
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:cuid];
    [AFNetwork getUserInfo:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            
            self.totaldays = getSafeString(data[@"data"][@"remain"]);
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
}




@end
