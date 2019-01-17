//
//  YuePaiPayViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiPayViewController.h"
#import "payRequsestHandler.h"
#import "YuePaiDetailViewController.h"
#import "time.h"
#import "StartYuePaiViewController.h"
#import "GuideView.h"
@interface YuePaiPayViewController ()
{
    NSString *spkey;
    NSDictionary *ChatDic;
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *qianbaoButton;
@property (weak, nonatomic) IBOutlet UILabel *qianbaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *haixuLabel;

@property (weak, nonatomic) IBOutlet UILabel *riqiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiageLabel;
@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;




@property (copy, nonatomic) NSString *qianBaoMoney;
@property (copy, nonatomic) NSString *money;
@property (copy, nonatomic) NSString *yuepaiId;

@property (assign, nonatomic) BOOL isDayu;


@property (weak, nonatomic) IBOutlet UIView *yuePaiView;

@property (weak, nonatomic) IBOutlet UIView *taoXiView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoxiTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXinameLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoxiPersonLabel;

@end

@implementation YuePaiPayViewController
#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"支付";
    self.qianbaoButton.selected = YES;
    
    //spkey = @"9411af079b3c04e1d41fcfc9763690be";
    //spkey = @"64CC22895ECA02D681557A4A166EAFC7";
    spkey = PARTNER_ID;
    self.money = getSafeString(self.diction[@"money"]);
    self.yuepaiId = getSafeString(self.diction[@"covenant_id"]);

    NSString *headURL = getSafeString(self.diction[@"to_head_pic"]);
    NSString *toName = getSafeString(self.diction[@"to_nickname"]);
    if (headURL.length==0) {
        headURL = getSafeString(self.diction[@"to_headpic"]);
    }
    NSString *riqiString = [NSString stringWithFormat:@"日期：%@",getSafeString(self.diction[@"covenant_time"])];
    NSString *jiageString = [NSString stringWithFormat:@"价格：%@",self.diction[@"money"]];
    NSString *beizhuString = [NSString stringWithFormat:@"备注：%@",self.diction[@"mark"]];

    self.riqiLabel.text = riqiString;
    self.jiageLabel.text = jiageString;
    self.beizhuLabel.text = beizhuString;
    

    
    [self getServiceData];
    
    self.headerImage.layer.cornerRadius = 30;
    self.headerImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headerImage.layer.borderWidth = 0.5;
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:nil];
    self.nameLabel.text = toName;
    [self initTitleLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"WxPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed) name:@"payFailed" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isTaoXi) {
        NSString *riqiString = [NSString stringWithFormat:@"日期：%@",getSafeString(self.diction[@"covenant_time"])];
        NSString *jiageString = [NSString stringWithFormat:@"%@",self.diction[@"money"]];
        self.taoxiTimeLabel.text = riqiString;
        self.priceLabel.text = jiageString;
        self.taoxiPersonLabel.text = self.nameStr;
        self.taoXinameLabel.text = self.taoXiName;
        
        _yuePaiView.hidden = YES;
        _taoXiView.hidden = NO;
    }else{
        _yuePaiView.hidden = NO;
        _taoXiView.hidden = YES;
    }
}

//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WxPaySuccess" object:nil];
}


- (void)initTitleLabel
{
    self.titleLabel.text = CovenantTips;
    self.firstLabel.text = CovenantCreate;
    self.secondLabel.text = CovenantBail;
    self.thirdLabel.text = CovenantJoin;
    self.fourthLabel.text = CovenantOver;
    if (_isTaoXi) {
        self.firstLabel.text = CovenantTaoXiTips;
    }
}

- (void)getServiceData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *object_type = getSafeString(@"10");
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    if (_isTaoXi) {
        params = [AFParamFormat formatTempleteParams:@{@"id":cuid,@"object_type":object_type}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserWalletSummary success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = data[@"data"];
            NSString *userMoney = [NSString stringWithFormat:@"%@",dict[@"userMoney"]];
            self.qianBaoMoney = userMoney;
            
            if ([self.money floatValue]>[userMoney floatValue]) {
                NSString *qianBao =getSafeString(dict[@"userMoney"]);
                self.qianbaoLabel.text = [NSString stringWithFormat:@"%@元",qianBao];
                self.haixuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]-[userMoney floatValue]];
                self.isDayu = YES;
                self.weixinButton.selected = YES;
                if ([qianBao floatValue]==0) {
                    self.qianbaoButton.selected = NO;
                }
            }else
            {
                self.qianbaoLabel.text = [NSString stringWithFormat:@"%@元",self.money];
                self.haixuLabel.text = @"还需支付：0元";
            }
            
            //显示功能引导视图_支付
            [self showMokaGuideViewWeiXinPay];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (void)doBackAction:(id)sender
{
    NSLog(@"doBackAction");
    if (self.isFrowStart) {
        YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
        detail.covenant_id = getSafeString(self.diction[@"covenant_id"]);
        detail.isNeedPay = NO;
        detail.isTaoXi = self.isTaoXi;
        detail.taoxiName = self.taoXiName;
        [self.navigationController pushViewController:detail animated:YES];
        NSMutableArray *removeArr = @[].mutableCopy;
        for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
            id controller = self.navigationController.childViewControllers[i];
            if ([controller isKindOfClass:[YuePaiPayViewController class]]) {
                [removeArr addObject:controller];
                
            }
            if ([controller isKindOfClass:[StartYuePaiViewController class]]) {
                [removeArr addObject:controller];
                
            }
        }
        NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
        
        for (int i=0; i<removeArr.count; i++) {
            id controller = removeArr[i];
            [tempArr removeObject:controller];
            
        }
        [self.navigationController setViewControllers:tempArr];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    

}

- (IBAction)choseWeiXin:(id)sender {
    BOOL isSelected = self.weixinButton.selected;
    self.weixinButton.selected = !isSelected;
    if (self.isDayu) {
        
    }else
    {
        self.qianbaoButton.selected = NO;
        self.haixuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]];
        
    }
    
}

- (IBAction)choseQianBao:(id)sender {
    BOOL isSelected = self.qianbaoButton.selected;
    
    if (self.isDayu) {
        if (isSelected) {
            self.haixuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]];
            
        }else
        {
            self.haixuLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.money floatValue]-[self.qianBaoMoney floatValue]];
            
        }
    }else
    {
        self.weixinButton.selected = NO;
        self.haixuLabel.text = @"还需支付：0元";
        
    }
    
    self.qianbaoButton.selected = !isSelected;
    
}

- (IBAction)payMoney:(id)sender {
    if (!self.weixinButton.selected&&!self.qianbaoButton.selected) {
        [LeafNotification showInController:self withText:@"请选择支付方式"];
        
        return;
    }
    __block BOOL isWx = NO;
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
    
    NSString *photoId = self.yuepaiId;
    
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
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":photoId,@"pay_info":pay_info}];
    if (_isTaoXi) {
        NSString *object_type = getSafeString(@"10");
        params = [AFParamFormat formatTempleteParams:@{@"covenant_id":photoId,@"pay_info":pay_info,@"object_type":object_type}];
    }
    
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiPay success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            if ([data[@"easeData"] isKindOfClass:[NSDictionary class]]) {
                ChatDic = [NSDictionary dictionaryWithDictionary:data[@"easeData"]];
            }
            if (!isWx&&!isHeBing) {
                [LeafNotification showInController:self withText:data[@"msg"]];
                [self performSelector:@selector(paySuccess) withObject:nil afterDelay:1.0];
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

- (void)paySuccess
{
    //[LeafNotification showInController:self withText:@"约拍成功"];
    if (ChatDic.count) {
        [ChatManager sendPaySuccessMessage:ChatDic];
    }
    [self performSelector:@selector(backToBrowse) withObject:nil afterDelay:1.0];
    
}

- (void)backToBrowse
{
    YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
    detail.covenant_id = getSafeString(self.diction[@"covenant_id"]);
    detail.isNeedPay = NO;
    detail.isTaoXi = self.isTaoXi;
    [self.navigationController pushViewController:detail animated:YES];
    NSMutableArray *removeArr = @[].mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[YuePaiPayViewController class]]) {
            [removeArr addObject:controller];
            
        }
        if ([controller isKindOfClass:[StartYuePaiViewController class]]) {
            [removeArr addObject:controller];
            
        }
    }
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;

    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];

    }
    [self.navigationController setViewControllers:tempArr];

     
    
}

- (void)payFailed
{
    [LeafNotification showInController:self withText:@"支付未成功"];
    
}






#pragma mark - 显示支付引导
- (void)showMokaGuideViewWeiXinPay{
    BOOL show = [GuideView needShowGuidViewWithGuideViewType:MokaGuideViewWeiXinPay];
    if (show) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        [guideView showGuidViewWithConditionType:MokaGuideViewWeiXinPay];
    }
}


@end
