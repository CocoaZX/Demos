//
//  YuePaiDetailViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiDetailViewController.h"
#import "YuePaiPayViewController.h"
#import "PingJiaViewController.h"
#import "PingjiaListViewController.h"
#import "McReportViewController.h"

@interface YuePaiDetailViewController ()
{
    NSString *_typeStr;
}

@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *submitButtonTwo;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageView;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;

@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;

@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fourthImageView;

@property (weak, nonatomic) IBOutlet UIView *siLiaoView;

@property (weak, nonatomic) IBOutlet UILabel *stateDesc;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (copy, nonatomic) NSString *opCodestring;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIView *secondLine;
@property (weak, nonatomic) IBOutlet UIView *thirdLine;

@property (weak, nonatomic) IBOutlet UIView *yuepaiView;

@property (weak, nonatomic) IBOutlet UIView *taoxiView;

@property (weak, nonatomic) IBOutlet UILabel *taoXIpriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXiPersonLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXITimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *taoXITextView;

@property (weak, nonatomic) IBOutlet UIButton *chatBtn;

@property (weak, nonatomic) IBOutlet UIView *chatView;

@end

@implementation YuePaiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"约拍详情";
    if (_isTaoXi) {
        self.title = @"专题详情";
    }
    
    self.submitButtonTwo.layer.cornerRadius = 5;
    self.submitButtonTwo.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.submitButtonTwo.layer.borderWidth = 0.5;
    self.submitButton.layer.cornerRadius = 5;
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_isTaoXi) {
        self.taoxiView.hidden = NO;
        self.yuepaiView.hidden = YES;
        self.taoXiNameLabel.text = self.taoxiName;
    }else{
        self.taoxiView.hidden = YES;
        self.yuepaiView.hidden = NO;
    }

    [self getdetailData];
}
- (void)initView
{
    NSDictionary *diction = self.dataDict;
    [self initTextLabel];

    NSString *paiTime = getSafeString(diction[@"covenant_time"]);
    NSString *paiMoney = getSafeString(diction[@"money"]);
    NSString *beizhu = getSafeString(diction[@"mark"]);

    NSString *statusName = getSafeString(diction[@"statusName"]);
    NSString *status = getSafeString(diction[@"status"]);
    
    NSString *covenant_tips = getSafeString(diction[@"covenant_tips"]);

    self.subTitleLabel.text = covenant_tips;
    
    NSString *opCode = getSafeString(diction[@"opCode"]);
    id opname = diction[@"opName"];
    NSString *opName = @"";
    NSString *opNametwo = @"";
    NSString *object_type = getSafeString(diction[@"object_type"]);
    NSString *object_id = getSafeString(diction[@"object_id"]);
    NSString *taoXiName = getSafeString(diction[@"album_content"][@"setname"]);
    
    self.stateDesc.text = statusName;

    NSString *uid = getSafeString(diction[@"uid"]);
    if ([uid isEqualToString:getCurrentUid()]) {
        //本人是发起者
        self.isJieShou = NO;
 
    }else
    {
        self.isJieShou = YES;
    }
    
    self.currentHeaderURL = getSafeString(diction[@"head_pic"]);;
    self.currentTitle = getSafeString(diction[@"nickname"]);
    self.headImage.layer.cornerRadius = 35;
    self.headImage.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.headImage.layer.borderWidth = 0.5;
    
    self.dateLabel.text = [NSString stringWithFormat:@"日期：%@",paiTime];
    self.priceLabel.text = [NSString stringWithFormat:@"价格：%@",paiMoney];
    self.remarkLabel.text = [NSString stringWithFormat:@"备注：%@",beizhu];
    self.remarkTextView.text = [NSString stringWithFormat:@"备注：%@",beizhu];
    
    self.taoXiNameLabel.text = [NSString stringWithFormat:@"专题名称:%@",taoXiName];
    self.taoXITimeLabel.text = [NSString stringWithFormat:@"日期：%@",paiTime];
    self.taoXIpriceLabel.text = getSafeString(paiMoney);
    self.taoXiPersonLabel.text = [NSString stringWithFormat:@"摄影师: %@",getSafeString(diction[@"to_nickname"])];
    self.taoXITextView.text = [NSString stringWithFormat:@"备注：%@",beizhu];

    
    self.remarkTextView.showsVerticalScrollIndicator = NO;
    self.remarkTextView.editable = NO;
    
    if(_isJieShou){
        //本人是接受者，显示发起者的头像和昵称
        NSString *imgStr = getSafeString(diction[@"head_pic"]);
        NSString *name = getSafeString(diction[@"nickname"]);
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
        self.nameLabel.text = name;
        
    }else{
        //本人是发起者，显示接受者的头像和昵称
        NSString *imgStr = getSafeString(diction[@"to_head_pic"]);
        NSString *name = getSafeString(diction[@"to_nickname"]);
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:nil];
        self.nameLabel.text = name;
    }
    
    //self.nameLabel.text = self.currentTitle ;
    
    if ([opname isKindOfClass:[NSDictionary class]]) {
        opName = getSafeString(opname[@"1"]);
        opNametwo = getSafeString(opname[@"2"]);

    }
    
    NSString *covenant_id = getSafeString(diction[@"covenant_id"]);
    self.covenant_id = covenant_id;
    self.opCodestring = opCode;
    [self changeStateWithType:3];
    
    if ([status isEqualToString:@"-1"]) {//取消约拍
        [self resetCancelState];

    }else if ([status isEqualToString:@"-2"]) {//谢绝约拍
        [self resetCancelState];
        
    }else if ([status isEqualToString:@"-3"]) {//确认不参加
        [self resetCancelState];
        
    }else if ([status isEqualToString:@"0"]) {//等待支付
        [self changeStateWithType:1];
        
    }else if ([status isEqualToString:@"1"]) {//已支付保证金
        [self changeStateWithType:1];
        
    }else if ([status isEqualToString:@"2"]) {//已接受
        [self changeStateWithType:2];
        
    }else if ([status isEqualToString:@"3"]) {//已参加
        [self changeStateWithType:2];
        
    }else if ([status isEqualToString:@"4"]) {//已结算
        [self changeStateWithType:3];
        
    }
    
    if ([opCode isEqualToString:@"0"]) {
        self.submitButton.hidden = YES;
        self.submitButtonTwo.hidden = YES;
        self.siLiaoView.hidden = NO;
        self.chatView.hidden = YES;
    }else if([opCode isEqualToString:@"1"])
    {
        self.submitButton.hidden = NO;
        self.submitButtonTwo.hidden = YES;
        self.chatView.hidden = NO;
    }else if([opCode isEqualToString:@"2"])
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = NO;
        [self.submitButtonTwo setTitle:opNametwo forState:UIControlStateNormal];
        self.chatView.hidden = NO;
    }else if([opCode isEqualToString:@"3"])
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = NO;
        [self.submitButtonTwo setTitle:opNametwo forState:UIControlStateNormal];
        self.chatView.hidden = NO;
    }else if([opCode isEqualToString:@"4"])
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = YES;
        self.chatView.hidden = NO;
        
    }else if([opCode isEqualToString:@"5"])
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = NO;
        [self.submitButtonTwo setTitle:@"投诉" forState:UIControlStateNormal];
        self.chatView.hidden = NO;

    }else if([opCode isEqualToString:@"6"])
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = NO;
        [self.submitButtonTwo setTitle:@"投诉" forState:UIControlStateNormal];
        self.chatView.hidden = NO;
        
    }else
    {
        self.submitButton.hidden = NO;
        [self.submitButton setTitle:opName forState:UIControlStateNormal];
        self.submitButtonTwo.hidden = YES;
        self.chatView.hidden = NO;
    }
    
    if ([object_type isEqualToString:@"10"]) {
        self.taoxiView.hidden = NO;
        self.yuepaiView.hidden = YES;
        _isTaoXi = YES;
        //获取套系名称
        
//        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":object_id}];
//        [AFNetwork getMokaDetail:params success:^(id data) {
//            if ([data[@"status"] integerValue] == kRight) {
//                NSLog(@"%@",data);
//                NSDictionary *dic = data[@"data"];
//                NSString *title = getSafeString(dic[@"title"]);
//                self.taoXiNameLabel.text = [NSString stringWithFormat:@"套系名称: %@",title];
//            }
//        } failed:^(NSError *error) {
//            
//        }];
        
    }else{
        self.taoxiView.hidden = YES;
        self.yuepaiView.hidden = NO;
    }
}

- (void)initTextLabel
{
    NSDictionary *diction = self.dataDict;
    self.firstLabel.text = getSafeString(diction[@"processNames"][@"1"]);
    self.secondLabel.text = getSafeString(diction[@"processNames"][@"2"]);
    self.thirdLabel.text = getSafeString(diction[@"processNames"][@"3"]);
    self.fourthLabel.text = getSafeString(diction[@"processNames"][@"4"]);
}

- (void)backToState
{
    self.firstLabel.textColor = [UIColor lightGrayColor];
    self.firstImageView.image = [UIImage imageNamed:@"yuepaigray"];
    self.secondLabel.textColor = [UIColor lightGrayColor];
    self.secondImageView.image = [UIImage imageNamed:@"yuepaigray"];
    self.thirdLabel.textColor = [UIColor lightGrayColor];
    self.thirdImageView.image = [UIImage imageNamed:@"yuepaigray"];
    self.fourthLabel.textColor = [UIColor lightGrayColor];
    self.fourthImageView.image = [UIImage imageNamed:@"yuepaigray"];
}

- (void)resetCancelState
{
    self.secondLine.hidden = YES;
    self.thirdLine.hidden = YES;
    self.thirdLabel.hidden = YES;
    self.thirdImageView.hidden = YES;
    self.fourthLabel.hidden = YES;
    self.fourthImageView.hidden = YES;
//    self.secondLabel.text = getSafeString(CovenantCancel);
//    self.secondLabel.text = @"取消约拍";
    
    self.secondImageView.image = [UIImage imageNamed:@"yuepaired"];
    self.secondLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
 
}

- (void)changeStateWithType:(int)type
{
    [self backToState];
    switch (type) {
        case 0:
        {
            self.firstLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
            self.firstImageView.image = [UIImage imageNamed:@"yuepaired"];
        }
            break;
        case 1:
        {
            self.secondLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
            self.secondImageView.image = [UIImage imageNamed:@"yuepaired"];
        }
            break;
        case 2:
        {
            self.thirdLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
            self.thirdImageView.image = [UIImage imageNamed:@"yuepaired"];
        }
            break;
        case 3:
        {
            self.fourthLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
            self.fourthImageView.image = [UIImage imageNamed:@"yuepaired"];
        }
            break;
            
        default:
            break;
    }
    
}


- (void)getdetailData
{
    [SVProgressHUD show];
    NSString *covenant_id = getSafeString(self.covenant_id);
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id}];
    if (_isTaoXi) {
        NSString *object_type = [NSString stringWithFormat:@"10"];
        params = [AFParamFormat formatTempleteParams:@{@"object_type":object_type,@"covenant_id":covenant_id}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiDetail success:^(id data){
        [SVProgressHUD dismiss];
        //processNames 4个status
        //statusName 大字
        //covenant_tips  小字
        if ([data[@"status"] integerValue] == kRight) {
            self.dataDict = data[@"data"];
            [self initView];
            _typeStr = getSafeString(self.dataDict[@"object_type"]);
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}

- (IBAction)payMethod:(id)sender {
    if ([self.opCodestring isEqualToString:@"1"]) {
        YuePaiPayViewController *pay = [[YuePaiPayViewController alloc] initWithNibName:@"YuePaiPayViewController" bundle:[NSBundle mainBundle]];
        pay.diction = self.dataDict;
        pay.isNeedPay = YES;
        [self.navigationController pushViewController:pay animated:YES];
        
    }else if ([self.opCodestring isEqualToString:@"2"]) {
        if ([_typeStr isEqualToString:@"10"]) {
            [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认接受?" message:@"确认后MOKA将提醒你参加" confirmButtonTitle:@"确定" confirmButtonBlock:^{
                [self jieshouWithType:@"1"];
                
            } cancelButtonTitle:@"取消" cancelButtonBlock:^{
                
            }];
        }else{
            [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认接受?" message:@"确认后MOKA将提醒你参加约拍" confirmButtonTitle:@"确定" confirmButtonBlock:^{
                [self jieshouWithType:@"1"];
                
            } cancelButtonTitle:@"取消" cancelButtonBlock:^{
                
            }];
        }
    }else if ([self.opCodestring isEqualToString:@"3"]) {
        [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认已参加?" message:@"确认后MOKA将提醒对方支付" confirmButtonTitle:@"确定" confirmButtonBlock:^{
            [self canjiaWithType:@"1"];
            
        } cancelButtonTitle:@"取消" cancelButtonBlock:^{
            
        }];
        
    }else if ([self.opCodestring isEqualToString:@"4"]) {
        [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认支付?" message:@"确认后钱将由MOKA支付给对方" confirmButtonTitle:@"确定" confirmButtonBlock:^{
            [self gotoFinish];

        } cancelButtonTitle:@"取消" cancelButtonBlock:^{
            
        }];
    }else if ([self.opCodestring isEqualToString:@"5"]) {//去评价
        PingJiaViewController *detail = [[PingJiaViewController alloc] initWithNibName:@"PingJiaViewController" bundle:[NSBundle mainBundle]];
        detail.diction = self.dataDict;
        detail.isJieShou = self.isJieShou;
        detail.isDingdan = _isTaoXi;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }else if ([self.opCodestring isEqualToString:@"6"]) {//查看评价
        PingjiaListViewController *detail = [[PingjiaListViewController alloc] initWithNibName:@"PingjiaListViewController" bundle:[NSBundle mainBundle]];
        detail.covenant_id = self.dataDict[@"covenant_id"];
        detail.isJieShou = self.isJieShou;
        [self.navigationController pushViewController:detail animated:YES];
        
        
    }
    
}

- (IBAction)payMethodTwo:(id)sender {
    if ([self.opCodestring isEqualToString:@"2"]) {
        if (_isTaoXi) {
            [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认拒绝?" message:@"确认后订单将自动取消" confirmButtonTitle:@"确定" confirmButtonBlock:^{
                [self jieshouWithType:@"2"];
                
            } cancelButtonTitle:@"取消" cancelButtonBlock:^{
                
            }];
        }else{
            [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认拒绝?" message:@"确认后约拍将自动取消" confirmButtonTitle:@"确定" confirmButtonBlock:^{
                [self jieshouWithType:@"2"];
                
            } cancelButtonTitle:@"取消" cancelButtonBlock:^{
                
            }];
        }
        
    }else if ([self.opCodestring isEqualToString:@"3"]) {
        [SQCAlertViewManager showAlertViewWithLeftYESTitle_:@"确认未参加?" message:@"确认订单将自动取消" confirmButtonTitle:@"确定" confirmButtonBlock:^{
            [self canjiaWithType:@"2"];
            
        } cancelButtonTitle:@"取消" cancelButtonBlock:^{
            
        }];
    }else if ([self.opCodestring isEqualToString:@"5"]||[self.opCodestring isEqualToString:@"6"]) {
        NSDictionary *diction = self.dataDict;
        NSString *receiveUid = getSafeString(diction[@"to_uid"]);
        
        if ([receiveUid isEqualToString:getCurrentUid()]) {
            receiveUid = getSafeString(diction[@"uid"]);
            
        }
        MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];

//        McReportViewController *report = [[McReportViewController alloc] init];
        report.targetUid = receiveUid;
        [self.navigationController pushViewController:report animated:YES];
    }
    
}


- (void)jieshouWithType:(NSString *)type
{
    NSString *covenant_id = getSafeString(self.covenant_id);
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"action":type}];
    if (_isTaoXi) {
        NSString *object_type = [NSString stringWithFormat:@"10"];
        params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"action":type,@"object_type":object_type}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiJieShou success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            //接受了约拍，将会发送一条消息
            [ChatManager sendPaySuccessMessage:data[@"data"]];
            [LeafNotification showInController:self withText:data[@"msg"]];

            [self getdetailData];
            
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (void)canjiaWithType:(NSString *)type
{
    NSString *covenant_id = getSafeString(self.covenant_id);
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"action":type}];
    if (_isTaoXi) {
        NSString *object_type = [NSString stringWithFormat:@"10"];
        params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"action":type,@"object_type":object_type}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiCanJia success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];

            [self getdetailData];
        
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
       [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (void)gotoFinish
{
    NSString *covenant_id = getSafeString(self.covenant_id);
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id}];
    if (_isTaoXi) {
        NSString *object_type = [NSString stringWithFormat:@"10"];
        params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"object_type":object_type}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiJieShu success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];
            
            [self getdetailData];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
            
        }
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (IBAction)gotoPersonalPage
{
    NSString *uid = getSafeString(self.dataDict[@"uid"]);
    NSString *userName = getSafeString(self.dataDict[@"nickname"]);
    
    if(_isJieShou){
    //本人是接受者，点击进入发起者的主页
    }else{
        uid = getSafeString(self.dataDict[@"to_uid"]);
        userName = getSafeString(self.dataDict[@"to_nickname"]);
    }

    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.navigationController pushViewController:newMyPage animated:YES];
    
}
- (IBAction)chatTwo:(id)sender {
    
    //如果此详情界面的导航控制器的子视图控制器的数组中有liao聊天界面
    //返回聊天界面
    NSArray *viewcontrollers = self.navigationController.childViewControllers;
    ChatViewController *chatVC = nil;
    for (int i = 0; i<viewcontrollers.count; i++) {
        UIViewController *vc = viewcontrollers[i];
        if ([vc isKindOfClass:[ChatViewController class]]) {
            chatVC =(ChatViewController *)vc;
        }
    }
    if (chatVC) {
        [self.navigationController popToViewController:chatVC animated:YES];
        return;
    }
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             //将2.1.0版本旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }
         else
         {
         }
     } onQueue:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *diction = self.dataDict;
        NSString *receiveUid = getSafeString(diction[@"to_uid"]);
        NSString *receiveTitle = getSafeString(diction[@"to_nickname"]);
        NSString *fromHeaderURL = getSafeString(diction[@"to_head_pic"]);
        NSString *toHeaderURL = getSafeString(diction[@"head_pic"]);
        
        if ([receiveUid isEqualToString:getCurrentUid()]) {
            receiveUid = getSafeString(diction[@"uid"]);
            receiveTitle = getSafeString(diction[@"nickname"]);
            fromHeaderURL = getSafeString(diction[@"head_pic"]);
            toHeaderURL = getSafeString(diction[@"to_head_pic"]);
            
        }
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:receiveUid conversationType:eConversationTypeChat];
        chatController.title = getSafeString(receiveTitle);
        
        chatController.fromHeaderURL = fromHeaderURL;
        chatController.toHeaderURL = toHeaderURL;
        [self.navigationController pushViewController:chatController animated:YES];
        
    });
    

}

- (IBAction)chatMethod:(id)sender {
    //如果此详情界面的导航控制器的子视图控制器的数组中有liao聊天界面
    //返回聊天界面
    NSArray *viewcontrollers = self.navigationController.childViewControllers;
    ChatViewController *chatVC = nil;
    for (int i = 0; i<viewcontrollers.count; i++) {
        UIViewController *vc = viewcontrollers[i];
        if ([vc isKindOfClass:[ChatViewController class]]) {
            chatVC =(ChatViewController *)vc;
         }
     }
    if (chatVC) {
        [self.navigationController popToViewController:chatVC animated:YES];
        return;
    }
    
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             //将2.1.0版本旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }
         else
         {
         }
     } onQueue:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *diction = self.dataDict;
        NSString *receiveUid = getSafeString(diction[@"to_uid"]);
        NSString *receiveTitle = getSafeString(diction[@"to_nickname"]);
        NSString *fromHeaderURL = getSafeString(diction[@"to_head_pic"]);
        NSString *toHeaderURL = getSafeString(diction[@"head_pic"]);

        if ([receiveUid isEqualToString:getCurrentUid()]) {
            receiveUid = getSafeString(diction[@"uid"]);
            receiveTitle = getSafeString(diction[@"nickname"]);
            fromHeaderURL = getSafeString(diction[@"head_pic"]);
            toHeaderURL = getSafeString(diction[@"to_head_pic"]);

        }
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:receiveUid conversationType:eConversationTypeChat];
        chatController.title = getSafeString(receiveTitle);
        
        chatController.fromHeaderURL = fromHeaderURL;
        chatController.toHeaderURL = toHeaderURL;
        [self.navigationController pushViewController:chatController animated:YES];
        
    });
    
}


@end
