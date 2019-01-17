//
//  JinBiViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JinBiViewController.h"
#import "payRequsestHandler.h"
#import "CashingDetailViewController.h"
#import "DaShangViewController.h"


@interface JinBiViewController ()

@property (weak, nonatomic) IBOutlet UIButton *weixinpayButton;

@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;

@property (copy, nonatomic) NSString *currMoney;
@property (copy, nonatomic) NSString *currCoin;
@property (copy, nonatomic) NSString *currTotalCoin;

@property (strong, nonatomic) UIImageView *rightImg;

@end

@implementation JinBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"金币充值";
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.navigationController.navigationBarHidden = NO;
//    });
    [self initSubviews];
    
    self.view.backgroundColor = NewbackgroundColor;

    self.weixinpayButton.layer.cornerRadius = 40;
    self.weixinpayButton.userInteractionEnabled = NO;
    self.weixinpayButton.alpha = 0.2;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"onRed"]];
    imageView.frame = CGRectMake(0, 0, 27, 18);
    self.rightImg = imageView;
    
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
            self.jinbiLabel.text = getSafeString([NSString stringWithFormat:@"%@",dict[@"goldCoin"]]);
            
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

- (void)initSubviews
{
    int width = 120;
    int height = 44;
    int space = 40;
    NSArray *moneyArray = MCAPI_Data_Object1(ConfigRechargeSetting);

    for (int i=0; i<moneyArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setClipsToBounds:YES];
        button.layer.cornerRadius = 10;
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        int x = 0;
        int y = i/2*54+90;
        if (i%2) {
            x = kScreenWidth/2+space/2;

        }else
        {
            x = kScreenWidth/2-width-space/2;
        }
        NSDictionary *diction = moneyArray[i];
        [button setFrame:CGRectMake(x, y, width, height)];
        [button setTag:i];
        [button addTarget:self action:@selector(paychoseMethod:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:[NSString stringWithFormat:@"¥ %@ = %@ 个",diction[@"m"],diction[@"c"]] forState:UIControlStateNormal];
        [self.view addSubview:button];
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(20 * (M_PI / 180.0f));

        NSString *songString = getSafeString(diction[@"s"]);
        if (songString.length>0) {

            UILabel *songLabel = [[UILabel alloc] initWithFrame:CGRectMake(x+width-21, y-5, 43, height-20)];
            songLabel.transform = endAngle;

            songLabel.text = [NSString stringWithFormat:@"送%@个",diction[@"s"]];
            songLabel.textColor = [UIColor whiteColor];
            songLabel.font = [UIFont systemFontOfSize:11];
            songLabel.textAlignment = NSTextAlignmentCenter;
            songLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
            songLabel.layer.cornerRadius = 5;
            songLabel.clipsToBounds = YES;
            [self.view addSubview:songLabel];

        }
        
        
    }
    
}

- (void)paychoseMethod:(UIButton *)sender
{
    //有选金额，充值按钮可用
    self.weixinpayButton.userInteractionEnabled = YES;
    self.weixinpayButton.alpha = 1;
    
    self.rightImg.frame = CGRectMake(sender.frame.origin.x+50,sender.frame.origin.y+30,27, 18);
    [self.view addSubview:self.rightImg];
    [self.view bringSubviewToFront:self.rightImg];
    NSArray *moneyArray = MCAPI_Data_Object1(ConfigRechargeSetting);

    NSDictionary *diction = moneyArray[[sender tag]];
    NSString *coin = getSafeString(diction[@"c"]);
    NSString *song = getSafeString(diction[@"s"]);
    int total = [coin intValue]+[song intValue];
    self.currMoney = getSafeString(diction[@"m"]);
    self.currTotalCoin = [NSString stringWithFormat:@"%d",total];
    self.currCoin = coin;

}

- (IBAction)weixinMethod:(id)sender {
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    
    DaShangViewController *dashang = [[DaShangViewController alloc] initWithNibName:@"DaShangViewController" bundle:[NSBundle mainBundle]];
    dashang.isBuyCoin = YES;
    dashang.photoId = @"";
    dashang.uid = uid;
    dashang.name = userName;
    dashang.money = self.currMoney;
    dashang.coin = self.currCoin;
    dashang.descCoin = [NSString stringWithFormat:@"充值%@人民币兑换%@金币",self.currMoney,self.currTotalCoin];
    [self.navigationController pushViewController:dashang animated:YES];
}


@end
