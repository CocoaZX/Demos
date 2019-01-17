//
//  YuEViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/20.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuEViewController.h"
#import "YuEMingXiViewController.h"
#import "TiXianViewController.h"
#import "GetingCashViewController.h"
#import "JinBiViewController.h"
#import "DuiHuanViewController.h"


@interface YuEViewController ()

@property (weak, nonatomic) IBOutlet UIView *yueView;

@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UIButton *tixianbutton;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiButton;

@property (weak, nonatomic) IBOutlet UIView *tixianView;

@property (weak, nonatomic) IBOutlet UIButton *nTixianButton;

@property (weak, nonatomic) IBOutlet UIView *jinbiView;

@property (weak, nonatomic) IBOutlet UILabel *danweiLabel;

@end

@implementation YuEViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *titleStr = NSLocalizedString(@"detail", nil);
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"明细" style:UIBarButtonItemStylePlain target:self action:@selector(yuemingxi:)];
    rightBtn.tintColor = [CommonUtils colorFromHexString:kLikeRedColor];
    
//    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 74, 44)];
//    [rightButton setTitle:@"明细" forState:UIControlStateNormal];
//    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
//    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
//    [rightButton addTarget:self action:@selector(yuemingxi:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    
    [self.navigationItem setRightBarButtonItem:rightBtn];
    
    self.yueView.layer.cornerRadius = 110;
//    self.yueView.layer.borderColor = [CommonUtils colorFromHexString:kLikeRedColor].CGColor;
//    self.yueView.layer.borderWidth = 1;

//    self.tixianbutton.layer.borderColor = [CommonUtils colorFromHexString:kLikeRedColor].CGColor;
//    self.tixianbutton.layer.borderWidth = 1;
    
    self.tixianbutton.layer.cornerRadius = 40;
    self.chongzhiButton.layer.cornerRadius = 40;
    self.nTixianButton.layer.cornerRadius = 40;
    
    if (self.isTiXian) {
        self.tixianView.hidden = NO;
        [self.view bringSubviewToFront:self.tixianView];
        self.tixianView.backgroundColor = self.view.backgroundColor;
        self.danweiLabel.text = @"余额（元）";
    }else
    {
        self.jinbiView.hidden = NO;
        [self.view bringSubviewToFront:self.jinbiView];
        self.jinbiView.backgroundColor = self.view.backgroundColor;
        self.danweiLabel.text = @"金币（个）";

    }
    
    self.view.backgroundColor = NewbackgroundColor;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getServiceData];

}

- (void)yuemingxi:(id)sender
{
    YuEMingXiViewController *mingxi = [[YuEMingXiViewController alloc] initWithNibName:@"YuEMingXiViewController" bundle:[NSBundle mainBundle]];
    
    NSString *goldStr = NSLocalizedString(@"MOKAGold", nil);
    NSString *balancesStr = NSLocalizedString(@"Balances", nil);
    
    if ([self.title isEqualToString:goldStr]) {
        mingxi.title = NSLocalizedString(@"goldDetail", nil);
    }else if([self.title isEqualToString:balancesStr]){
        mingxi.title = NSLocalizedString(@"balancesDetail", nil);
    }
    
    [self.navigationController pushViewController:mingxi animated:YES];
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
            if (self.isTiXian) {
                self.money.text = [NSString stringWithFormat:@"%@",dict[@"userMoney"]];

            }else
            {
                self.money.text = [NSString stringWithFormat:@"%@",dict[@"goldCoin"]];
                
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


- (IBAction)tixianMethod:(id)sender {
    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
 
    GetingCashViewController *cash = [[GetingCashViewController alloc] initWithNibName:@"GetingCashViewController" bundle:[NSBundle mainBundle]];
    cash.currentMoney = getSafeString(self.money.text);
    cash.currentName = getSafeString(dic[@"nickname"]);
    cash.currentHeadImage = getSafeString(dic[@"head_pic"]);
    [self.navigationController pushViewController:cash animated:YES];
//    TiXianViewController *tixian = [[TiXianViewController alloc] initWithNibName:@"TiXianViewController" bundle:[NSBundle mainBundle]];
//    [self presentViewController:tixian animated:YES completion:nil];
    
}

- (IBAction)chongZhiMethod:(id)sender {
    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];

    JinBiViewController *cash = [[JinBiViewController alloc] initWithNibName:@"JinBiViewController" bundle:[NSBundle mainBundle]];
    cash.currentMoney = getSafeString(self.money.text);
    cash.currentName = getSafeString(dic[@"nickname"]);
    cash.currentHeadImage = getSafeString(dic[@"head_pic"]);
    cash.isChongZhi = YES;
    [self.navigationController pushViewController:cash animated:YES];
    
}


- (IBAction)duihuanMethod:(id)sender {
    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    
    DuiHuanViewController *cash = [[DuiHuanViewController alloc] initWithNibName:@"DuiHuanViewController" bundle:[NSBundle mainBundle]];
    
    [self.navigationController pushViewController:cash animated:YES];
    
}




@end
