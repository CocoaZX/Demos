//
//  NewActivityGroupNotSignViewController.m
//  Mocha
//
//  Created by sun on 15/8/27.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewActivityGroupNotSignViewController.h"
#import "ChatViewController.h"
#import "MokaPayViewContorller.h"
@interface NewActivityGroupNotSignViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

//填写众筹费用的window
@property (strong,nonatomic)UIWindow *zhongChouWindow;

@end

@implementation NewActivityGroupNotSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"活动群聊";
    
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 64, 44)];
//    [rightButton setTitle:@"更多" forState:UIControlStateNormal];
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(moreMethod) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    [self.navigationItem setRightBarButtonItem:rightItem];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden  = NO;
}

- (void)moreMethod
{
    NSLog(@"more");
}


- (IBAction)submit:(id)sender {
    switch (_typeNum) {
        case 1:
        {
            //通告直接发送报名请求
            [self requestForBaoMing:NO];
            break;
        }
        case 2:
        {
            //如果是众筹返回详情界面，先输入金额后报名
            [self showZhongChouWindow];
            break;
        }
        case 3:
        {
            //海报活动发送保名请求
            [self requestForBaoMing:NO];
            break;
        }


        default:
            break;
    }
}



#pragma mark 选择众筹金额
- (void)showZhongChouWindow{
    if(_zhongChouWindow == nil){
        _zhongChouWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
        _zhongChouWindow.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:_zhongChouWindow.bounds];
        backView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        backView.alpha = 0.9;
        [_zhongChouWindow addSubview:backView];
        
        //距离左右边距
        CGFloat horizonalPadding = 20;
        //距离上边的距离
        CGFloat verticalPadding = 0;
        //子视图的距离左右的宽度
        CGFloat leftPadding = 10;
        //子视图距离上面的距离
        CGFloat topPadding = 20;
        //按钮的宽高度
        CGFloat buttonWidth = 80;
        //输入框高度
        CGFloat txtFieldHeight = 50;
        if([CommonUtils getRuntimeClassIsIphone]){
            if(kDeviceWidth<375){
                verticalPadding = 50;
                topPadding = 8;
                buttonWidth = 50;
                txtFieldHeight = 40;

            }else{
                verticalPadding = 200;
                topPadding = 20;
                buttonWidth = 80;
                txtFieldHeight = 50;
            }
         }else{
            verticalPadding = 50;
            topPadding = 8;
            buttonWidth = 50;
            txtFieldHeight = 40;
        }
        //子视图的宽度
        CGFloat subViewWidth = kDeviceWidth -horizonalPadding *2 -leftPadding *2 ;
        
        //提示文字
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
        //此界面是众筹的支付界面
        NSString *event_smoney = [descriptionDic objectForKey:@"event_smoney"];
        if(event_smoney.length == 0){
            event_smoney  =  @"请确定你要支持的众筹金额，你也可以填写其他众筹金额，以获得相应的回报，报名成功之后将进入众筹群组";
        }
        NSString *zhongChouTxt =event_smoney;
        
        //计算文字的高度
        CGFloat txtHeight = [SQCStringUtils getCustomHeightWithText:zhongChouTxt viewWidth:subViewWidth textSize:16];
        UIView *zhongChouView = [[UIView alloc] initWithFrame:CGRectMake(horizonalPadding, verticalPadding, kDeviceWidth -horizonalPadding *2, 400)];
        zhongChouView.backgroundColor = [CommonUtils colorFromHexString:@"#FFFFFF"];
        [_zhongChouWindow addSubview:zhongChouView];
        //1.标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding,subViewWidth, 30)];
        titleLabel.text = @"选择众筹金额";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
        [zhongChouView addSubview:titleLabel];
        //2.提示文字
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, titleLabel.bottom + topPadding,subViewWidth,txtHeight)];
        detailLabel.text = zhongChouTxt;
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:16];
        [zhongChouView addSubview:detailLabel];
        //3.输入金额
        UITextField *zhongChoufeeTxtField = [[UITextField alloc] initWithFrame:CGRectMake(leftPadding, detailLabel.bottom +topPadding, subViewWidth, txtFieldHeight)];
        zhongChoufeeTxtField.tag = 103;
        zhongChoufeeTxtField.delegate = self;
        zhongChoufeeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        zhongChoufeeTxtField.textAlignment = NSTextAlignmentCenter;
        zhongChoufeeTxtField.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        zhongChoufeeTxtField.text = _dataDic[@"paymentNumber"];
        //zhongChoufeeTxtField.layer.cornerRadius = 5;
        //zhongChoufeeTxtField.layer.masksToBounds = YES;
        [zhongChouView addSubview:zhongChoufeeTxtField];
        //"元"
        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(zhongChoufeeTxtField.right-txtFieldHeight, 0 , txtFieldHeight, txtFieldHeight)];
        yuanLabel.text = @"元";
        yuanLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
        yuanLabel.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        yuanLabel.textAlignment = NSTextAlignmentCenter;
        [zhongChoufeeTxtField addSubview:yuanLabel];
        
        //4.取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftPadding +20, zhongChoufeeTxtField.bottom +topPadding, buttonWidth, buttonWidth)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.tag = 100;
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancleBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackTextColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(zhongChouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [zhongChouView addSubview:cancleBtn];
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(subViewWidth -leftPadding -20 -buttonWidth, zhongChoufeeTxtField.bottom +topPadding, buttonWidth, buttonWidth)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.tag = 101;
        sureBtn.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        sureBtn.layer.cornerRadius = buttonWidth/2;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn addTarget:self action:@selector(zhongChouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [zhongChouView addSubview:sureBtn];
        
        //重新制定viewframe
        CGFloat height = sureBtn.bottom +topPadding;
        zhongChouView.frame = CGRectMake(horizonalPadding,verticalPadding, subViewWidth +leftPadding *2, height);
        
        //点击其他地方消失键盘
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissZhongChouKeyBoard)];
        [_zhongChouWindow addGestureRecognizer: singleTap];

    }
    
    //显示视图
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _zhongChouWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        _zhongChouWindow.hidden = NO;
    } completion:^(BOOL finished) {
    }];
    
}



- (void)dismissZhongChouKeyBoard{
    UITextField *zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
    [zhongChoufeeTxtField resignFirstResponder];
}


- (void)zhongChouBtnClick:(UIButton *)btn{
    UITextField *zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
    [zhongChoufeeTxtField resignFirstResponder];
    if (btn.tag == 100) {
        //点击取消，隐藏金额视图的显示
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _zhongChouWindow.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
        } completion:^(BOOL finished) {
            _zhongChouWindow = nil;
            
        }];
    }else if(btn.tag == 101){
        //判断金额是否符合要求
         zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
        //填入的金额
        CGFloat feeTxtNum = [zhongChoufeeTxtField.text floatValue];
        //需要的金额
        CGFloat zhongChouMoney = [_dataDic[@"paymentNumber"] floatValue];
        
        if(zhongChouMoney == 0){
            _zhongChouWindow.alpha = 0;
            _zhongChouWindow = nil;
            if(feeTxtNum == 0){
                //众筹的要求金额是0，填入的金额为0,不需要跳转到支付界面
                //直接报名活动
                [self requestForBaoMing:YES];
            }else{
                //使用填入的金额支付
                [self enterToMokaPayVC:zhongChoufeeTxtField.text];
            }
        }else{
            //需要的金额大于0
            if (feeTxtNum>zhongChouMoney ||feeTxtNum ==zhongChouMoney) {
                _zhongChouWindow.alpha = 0;
                _zhongChouWindow = nil;
                //支付大于或等于众筹的金额
                [self enterToMokaPayVC:zhongChoufeeTxtField.text];
            }else{
                //金额不够
                //[LeafNotification showInController:self withText:@"不能小于众筹金额"];
                NSString *alertTxt = [NSString stringWithFormat:@"不能小于众筹金额%@元",_dataDic[@"paymentNumber"]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertTxt delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定", nil];
                alertView.tag = 666;
                [alertView  show];

            }
        }
    }
}



#pragma mark - uialertview delegate
//点击报名之后弹出的提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (alertView.tag == 666) {
        //填写众筹金额不够
    }
}




#pragma mark - 直接报名和支付报名，之后群聊

- (void)enterToMokaPayVC:(NSString *)needMoney{
    _zhongChouWindow.alpha = 0;
    _zhongChouWindow = nil;
    //跳转到支付界面
    MokaPayViewContorller *mokaPayVC = [[MokaPayViewContorller alloc] init];
    mokaPayVC.payType = @"zhongChou";
    mokaPayVC.vcTitlte = @"确认报名";
    mokaPayVC.needAllMoney = needMoney;
    mokaPayVC.themeStr =[NSString stringWithFormat:@"%@",_dataDic[@"title"]];
    mokaPayVC.dataDic = _dataDic;
    [self.navigationController pushViewController:mokaPayVC animated:YES];
}




#pragma mark - 直接报名和支付报名
//普通报名不需要传入pay_ingo参数，
//若众筹的最低金额为0，用户输入为0,不需要进入支付界面，但是此时必须传入支付参数
//但是此时的参数是NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":@"0"};
//报名请求
-(void)requestForBaoMing:(BOOL)needPayInfo{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //活动ID
    NSString *eventId = [NSString stringWithFormat:@"%@",_dataDic[@"id"]];
    [mDic setObject:eventId forKey:@"id"];
    //众筹无金额的情况下，构建支付信息
    if(needPayInfo){
        NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":@"0"};
        //json格式
        NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
        [mDic setObject:pay_info forKey:@"pay_info"];
    }else{
        
    }
    [mDic setObject:@"3" forKey:@"optionCode"];
    //完善参数
    NSDictionary *params = [AFParamFormat formatEventSignUpParams:mDic];
    //报名
    [AFNetwork postRequeatDataParams:params path:PathEventSignUp success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"报名并且支付：%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            //报名成功
            [LeafNotification showInController:self withText:data[@"msg"]];
            [self pushToChat];
            
        }else if([data[@"status"] integerValue] == kReLogin){
            //登陆
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }else if([data[@"status"] integerValue] == 6218){
            //绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
        }else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"requesetForBaoMing错误：%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        
    }];
}



#pragma mark 进入群聊
- (void)pushToChat
{
    NSString *groupId = self.chatId;
    NSString *title = self.chatTitle;
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
    //减去中间跳转的视图控制器
    [self performSelector:@selector(removeGroup) withObject:nil afterDelay:1.0];

}

- (void)removeGroup
{
    NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id viewController = self.navigationController.childViewControllers[i];
        if ([viewController isKindOfClass:[NewActivityGroupNotSignViewController class]]) {
            [controllers removeObject:viewController];
        }
    }
    [self.navigationController setViewControllers:controllers];
}



@end
