//
//  MokaPayViewContorller.m
//  Mocha
//
//  Created by zhoushuai on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaPayViewContorller.h"
//处理众筹
#import "NewActivityGroupNotSignViewController.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"
#import "time.h"


@interface MokaPayViewContorller ()

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollview;

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UILabel *themeLabel;
@property (weak, nonatomic) IBOutlet UIView *lineOneView;
@property (weak, nonatomic) IBOutlet UILabel *operationDescriptionLabel;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UILabel *needMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *needTotalMoneyLabel;


@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UILabel *walletPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseWalletBtn;


@property (weak, nonatomic) IBOutlet UILabel *anotherNeedMoneyLabel;


@property (weak, nonatomic) IBOutlet UIView *forthView;
@property (weak, nonatomic) IBOutlet UIImageView *weixinImgView;
@property (weak, nonatomic) IBOutlet UILabel *weixinPayLabel;
//选择微信支付按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseWeixinPayBtn;

//支付按钮
@property (weak, nonatomic) IBOutlet UIButton *PayBtn;


//字体
@property(nonatomic,assign)CGFloat fontSize;
//水平间距
@property (nonatomic,assign)CGFloat horizonalDistance;
//垂直间距
@property (nonatomic,assign)CGFloat vertailDistance;
//钱包money
@property (copy, nonatomic) NSString *qianBaoMoney;
@property (copy, nonatomic) NSString *spkey;
@property (assign, nonatomic) BOOL isDayu;


@end

@implementation MokaPayViewContorller

#pragma mark 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置标题
    self.title = _vcTitlte;
    _spkey = PARTNER_ID;
    //字体大小
    _fontSize = 16;
    //默认从钱包支付
    _chooseWalletBtn.selected = YES;
    //钱包的里前不够
    _isDayu = NO;
    //默认钱包里的钱
    _walletMoneyLabel.text = @"0元";
    //视图水平和垂直间隔
    _horizonalDistance = 10;
    _vertailDistance = 10;

    //初始化视图
    [self _initViews];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:@"WxPaySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(payFailed) name:@"payFailed" object:nil];
    [self getServiceData];

    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}


- (void)_initViews{
    //获取文案
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    //此界面是众筹的支付界面
    if ([_payType isEqualToString:@"zhongChou"]) {
        NSString *event_pay = [descriptionDic objectForKey:@"event_pay"];
        if(event_pay.length == 0){
            event_pay  = @"支付报名成功，将进入众筹群组";
        }
        _operationDescriptionStr = event_pay;
    }
    
    //firstView==========================
    //标题
    CGFloat themeHeight = [SQCStringUtils getCustomHeightWithText:_themeStr viewWidth:kDeviceWidth -_horizonalDistance*2 textSize:_fontSize];
    if (themeHeight <25) {
        themeHeight = 25;
    }
    _themeLabel.text = _themeStr;
    _themeLabel.font = [UIFont systemFontOfSize:_fontSize];
    _themeLabel.frame = CGRectMake(_horizonalDistance, 15, kDeviceWidth -_horizonalDistance *2, themeHeight);
    _themeLabel.textColor = [UIColor darkGrayColor];
    
    //操作说明
    CGFloat operationDescHeight = [SQCStringUtils getCustomHeightWithText:_operationDescriptionStr viewWidth:kDeviceWidth -_horizonalDistance*2 textSize:_fontSize];
    if (operationDescHeight<25) {
        operationDescHeight = 25;
    }
    _operationDescriptionLabel.text = _operationDescriptionStr;
    _operationDescriptionLabel.font = [UIFont systemFontOfSize:_fontSize];
    _operationDescriptionLabel.textColor = [UIColor darkGrayColor];
    _operationDescriptionLabel.frame = CGRectMake(_horizonalDistance, _themeLabel.bottom, kDeviceWidth -_horizonalDistance *2, operationDescHeight);
    
    //分割线
    _lineOneView.backgroundColor = [UIColor lightGrayColor];
    _lineOneView.frame = CGRectMake(0, _operationDescriptionLabel.bottom+9,kDeviceWidth, 1);
    _firstView.frame =CGRectMake(0, 0, kDeviceWidth,15+themeHeight +operationDescHeight + 10);
    

    //secondView===============
    //需要支付：
    _secondView.backgroundColor = [UIColor whiteColor];
    _needMoneyLabel.frame = CGRectMake(_horizonalDistance, 0, 80, 50);
    _needMoneyLabel.textColor = [UIColor darkGrayColor];
    _needMoneyLabel.font = [UIFont systemFontOfSize:_fontSize];
    //123元
    _needTotalMoneyLabel.frame = CGRectMake(_needMoneyLabel.right, 0, kDeviceWidth-_horizonalDistance *2-_needMoneyLabel.right, 50);
    _needTotalMoneyLabel.textColor = [UIColor darkGrayColor];
    _needTotalMoneyLabel.text = [NSString stringWithFormat:@"%@元",_needAllMoney];
    _needTotalMoneyLabel.font = [UIFont systemFontOfSize:_fontSize];
    _secondView.frame = CGRectMake(0, _firstView.bottom, kDeviceWidth, 50);
    
    //thirdView=====================
    //钱包支付：
    _walletPayLabel.frame = CGRectMake(_horizonalDistance, 5, 100, 40);
    _walletPayLabel.textColor = [UIColor darkGrayColor];
    _walletPayLabel.font =[UIFont systemFontOfSize:_fontSize];
    _walletPayLabel.text = @"钱包支付";

    //123元
    _walletMoneyLabel.frame = CGRectMake(_walletPayLabel.right +5, 5, kDeviceWidth -(_walletPayLabel.right +5) -30-_horizonalDistance*2, 40);
    _walletMoneyLabel.font = [UIFont systemFontOfSize:_fontSize];
    _walletMoneyLabel.textColor = [UIColor darkGrayColor];
    //选择钱包对号
    _chooseWalletBtn.frame = CGRectMake(kDeviceWidth -30 - _horizonalDistance, 10, 30, 30);
    _thirdView.frame = CGRectMake(0, _secondView.bottom +_vertailDistance, kDeviceWidth, 50);
   
    
    //还需要支付：=========
    _anotherNeedMoneyLabel.frame = CGRectMake(_horizonalDistance, _thirdView.bottom +_vertailDistance, kDeviceWidth -_horizonalDistance *2, 20);
    _anotherNeedMoneyLabel.textColor = [UIColor darkGrayColor];
    _anotherNeedMoneyLabel.font = [UIFont systemFontOfSize:_fontSize];

    //forthView======================
    _weixinImgView.frame = CGRectMake(_horizonalDistance, _horizonalDistance, 30, 30);
    _weixinPayLabel.frame = CGRectMake(_weixinImgView.right +5, 5, 100, 40);
    _weixinPayLabel.font =[UIFont systemFontOfSize:_fontSize];
    _weixinPayLabel.textColor = [UIColor darkGrayColor];
    //勾选微信
    _chooseWeixinPayBtn.frame = CGRectMake(kDeviceWidth -30 - _horizonalDistance, 10, 30, 30);
    _forthView.frame = CGRectMake(0, _anotherNeedMoneyLabel.bottom +_vertailDistance, kDeviceWidth, 50);
    
    //点击支付
    _PayBtn.frame = CGRectMake(8, _forthView.bottom +100, kDeviceWidth-8*2, 50);
    //调整滑动视图的内容尺寸
    _mainScrollview.contentSize = CGSizeMake(kDeviceWidth, _PayBtn.bottom +10);
    
}

//获取钱包明细
- (void)getServiceData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    //请求钱包明细数据
    [AFNetwork postRequeatDataParams:params path:PathUserWalletSummary success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = data[@"data"];
            NSString *userMoney = [NSString stringWithFormat:@"%@",dict[@"userMoney"]];
            self.qianBaoMoney = userMoney;
            //需要的钱大于钱包里的钱
            if ([self.needAllMoney floatValue]>[userMoney floatValue]) {
                self.walletMoneyLabel.text = [NSString stringWithFormat:@"%@元",dict[@"userMoney"]];
                self.anotherNeedMoneyLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.needAllMoney floatValue]-[userMoney floatValue]];
                //钱不够，需要从微信中支付
                self.isDayu = YES;
                self.chooseWeixinPayBtn.selected = YES;
                
            }else
            {
                self.walletMoneyLabel.text = [NSString stringWithFormat:@"%@元",self.needAllMoney];
                self.anotherNeedMoneyLabel.text = @"还需支付：0元";
            }
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            //未登陆状态需要登陆
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}



#pragma mark 支付情况的响应
- (void)paySuccess
{
    [LeafNotification showInController:self withText:@"报名成功"];
    [self performSelector:@selector(pushToChat) withObject:nil afterDelay:1.0];
}


- (void)payFailed
{
    [LeafNotification showInController:self withText:@"支付未成功"];
}

//回到原来的视图控制器
- (void)backToOriginalVC
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshMokaPayViewController" object:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}




//- (void)youhuiquanMethod:(id)sender {
//
//}



#pragma mark 选择钱包或者微信


//选择钱包
- (IBAction)chooseWalletBtnClick:(id)sender {
    BOOL isSelected = self.chooseWalletBtn.selected;
    self.chooseWalletBtn.selected = !isSelected;

    if (self.isDayu) {
        //钱包里的钱不够
        if (self.chooseWalletBtn.selected) {
            self.anotherNeedMoneyLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.needAllMoney floatValue]-[self.qianBaoMoney floatValue]];
        }else
        {
            self.anotherNeedMoneyLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.needAllMoney floatValue]];
        }
    }else
    {
        self.chooseWeixinPayBtn.selected = NO;
        self.anotherNeedMoneyLabel.text = @"还需支付：0元";
    }
}


- (IBAction)chooseWeiXinBtnClick:(id)sender {
    
    BOOL isSelected = self.chooseWeixinPayBtn.selected;
    self.chooseWeixinPayBtn.selected = !isSelected;
    if (self.isDayu) {
        //钱包余额不够的时候

    }else
    {
        //不选择钱包
        self.chooseWalletBtn.selected = NO;
        //还需要支付的金额：用微信支付全额
        self.anotherNeedMoneyLabel.text = [NSString stringWithFormat:@"还需支付：%.2f元",[self.needAllMoney floatValue]];
    }

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
    [contentString appendFormat:@"key=%@", _spkey];
    //得到MD5 sign签名
    NSString *md5Sign =[WXUtil md5:contentString];
    return md5Sign;
}



- (IBAction)payBtnClick:(id)sender {
    if (!self.chooseWalletBtn.selected&&!self.chooseWeixinPayBtn.selected) {
        [LeafNotification showInController:self withText:@"请选择支付方式"];
        return;
    }
    BOOL isWx = NO;
    BOOL isQb = NO;
    BOOL isHeBing = NO;
    
    if (self.isDayu) {
        //不能支付
        if (self.chooseWalletBtn.selected) {
            //选择了钱包但是没有选择微信，提示钱不够
            if (!self.chooseWeixinPayBtn.selected) {
                [LeafNotification showInController:self withText:@"余额不足"];
                return;
            }
        }
        
        //钱包的钱不够
        //1.使用微信支付
        if (self.chooseWeixinPayBtn.selected) {
            isWx = YES;
        }
        
        //2.合并支付
        if (self.chooseWalletBtn.selected&&self.chooseWeixinPayBtn.selected) {
            isWx = NO;
            isQb = NO;
            isHeBing = YES;
        }
    }else
    {   //1.微信支付
        if (self.chooseWeixinPayBtn.selected) {
            isWx = YES;
        }
        //2.钱包支付
        if (self.chooseWalletBtn.selected) {
            isWx = NO;
            isQb = YES;
        }
    }
    
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //?
   // NSString *payWithID = self.activityID;
    //payWithID = @"130006";
    
    
    //一共需要支付的金额
    //NSString *total_fee = [NSString stringWithFormat:@"%.2f",[self.needAllMoney floatValue]];
    
    NSString *qianbao = @"0";
    NSString *weixin = @"0";
    //全微信支付
    weixin = [NSString stringWithFormat:@"%.2f",[self.needAllMoney floatValue]];
    NSString *youhuiquan = @"0";
    
    //全钱包支付
    if (isQb) {
        qianbao = [NSString stringWithFormat:@"%.2f",[self.needAllMoney floatValue]];
        weixin = @"0";
    }
    //合并支付
    if (isHeBing) {
        qianbao = [NSString stringWithFormat:@"%.2f",[self.qianBaoMoney floatValue]];
        weixin = [NSString stringWithFormat:@"%.2f",[self.needAllMoney floatValue]-[self.qianBaoMoney floatValue]];
    }
    
    
    NSDictionary *payArr = @{@"1":qianbao,@"2":weixin,@"3":youhuiquan};
    //json格式
    NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
    
    //打赏的参数格式
    //NSDictionary *params = [AFParamFormat formatPostDaShangParams:payWithID amount:pay_info total_fee:total_fee];
    //报名活动
    if ([_payType isEqualToString:@"zhongChou"]) {
        //众筹活动的支付
        if([weixin isEqualToString:@"0"]){
            [self requesetForBaoMing:pay_info weiXin:NO];
        }else{
            //存在微信支付的部分
            [self requesetForBaoMing:pay_info weiXin:YES];
        }
    }
}

#pragma mark 众筹
//报名请求
-(void)requesetForBaoMing:(NSString *)payInfo weiXin:(BOOL)isWx{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //活动ID
    NSString *eventId = [NSString stringWithFormat:@"%@",_dataDic[@"id"]];
    [mDic setObject:eventId forKey:@"id"];
    [mDic setObject:payInfo forKey:@"pay_info"];
    [mDic setObject:@"3" forKey:@"optionCode"];
    //完善参数
    NSDictionary *params = [AFParamFormat formatEventSignUpParams:mDic];
    //报名
    [AFNetwork postRequeatDataParams:params path:PathEventSignUp success:^(id data) {
        NSLog(@"报名并且支付：%@",data);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            if (!isWx) {
                //不需要微信支付时，直接跳转聊天界面
                [LeafNotification showInController:self withText:data[@"msg"]];
                [self performSelector:@selector(pushToChat) withObject:nil afterDelay:1.0];
                return ;
            }
            
            //存在微信支付，需要调用微信支付完成最后的支付步骤
            [self payWithWeiXin:data];
            
        }else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }else if([data[@"status"] integerValue] == 6218){
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
        }else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"requesetForBaoMing错误：%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}


- (void)payWithWeiXin:(NSDictionary *)data{
    //使用微信支付：
    //创建支付签名对象
    payRequsestHandler *req = [[payRequsestHandler alloc] init];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    [req setKey:PARTNER_ID];
    
    
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSMutableDictionary *dict = [req sendPay_demo];
    
    if(dict == nil){
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@\n\n",debug);
    }else{
        NSLog(@"%@\n\n",[req getDebugifo]);
        
        dict = [req erciqianmingWithDiction:data[@"data"]].mutableCopy;
        NSLog(@"支付dic：%@",dict);
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
        //调起微信支付
        PayReq* req  = [[PayReq alloc] init];
        req.openID  = [dict objectForKey:@"appid"];
        req.partnerId = [dict objectForKey:@"partnerid"];
        req.prepayId = [dict objectForKey:@"prepayid"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        req.timeStamp = stamp.intValue;
        req.package = [dict objectForKey:@"package"];
        req.sign = [dict objectForKey:@"sign"];
        
        //    dict = data[@"data"];
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




#pragma mark 进入聊天
- (void)pushToChat
{
    NSString *groupId = [NSString stringWithFormat:@"%@",_dataDic[@"chart_id"]];
    NSString *title = [NSString stringWithFormat:@"%@",_dataDic[@"title"]];;
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
    
    [self performSelector:@selector(removeGroup) withObject:nil afterDelay:1.0];
    
}

- (void)removeGroup
{
    NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id viewController = self.navigationController.childViewControllers[i];
        if ([viewController isKindOfClass:[NewActivityGroupNotSignViewController class]]||
            [viewController isKindOfClass:[MokaPayViewContorller class]]) {
            [controllers removeObject:viewController];
        }
    }
    [self.navigationController setViewControllers:controllers];
}



//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payFailed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WxPaySuccess" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
