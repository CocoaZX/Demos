//
//  MyWalletViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "MyWalletViewController.h"
#import "YouHuiQuanViewController.h"
#import "YuEViewController.h"
#import "MyDaShangListViewController.h"

@interface MyWalletViewController ()

@property (weak, nonatomic) IBOutlet UILabel *youhuiquanLabel;

@property (weak, nonatomic) IBOutlet UILabel *yuELabel;
@property (weak, nonatomic) IBOutlet UILabel *jinbiLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *goldLabel;
@property (weak, nonatomic) IBOutlet UILabel *giftLabel;


//显示优惠券的view
@property (weak, nonatomic) IBOutlet UIView *youHuiJuanView;


@end

@implementation MyWalletViewController

-(void)awakeFromNib{
    
    _moneyLabel.text = NSLocalizedString(@"MyChange", nil);
    _goldLabel.text = NSLocalizedString(@"MOKAGold", nil);
    _giftLabel.text = NSLocalizedString(@"MyGift", nil);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"wallet", nil);

    _moneyLabel.text = NSLocalizedString(@"MyChange", nil);
    _goldLabel.text = NSLocalizedString(@"MOKAGold", nil);
    _giftLabel.text = NSLocalizedString(@"MyGift", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
            self.youhuiquanLabel.text = [NSString stringWithFormat:@"%@",dict[@"cardNumber"]];
            NSLog(@"%@",dict);
            self.yuELabel.text = [NSString stringWithFormat:@"%@元",dict[@"userMoney"]];
            self.jinbiLabel.text = [NSString stringWithFormat:@"%@个",dict[@"goldCoin"]];

        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}


- (IBAction)myYouHuiQuan:(id)sender {
    YouHuiQuanViewController *youhui = [[YouHuiQuanViewController alloc] initWithNibName:@"YouHuiQuanViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:youhui animated:YES];
    
}

- (IBAction)myYuE:(id)sender {
    YuEViewController *yue = [[YuEViewController alloc] initWithNibName:@"YuEViewController" bundle:[NSBundle mainBundle]];
    yue.isTiXian = YES;
    yue.title = NSLocalizedString(@"Balances", nil);
    [self.navigationController pushViewController:yue animated:YES];
    
}

- (IBAction)jinbi:(id)sender {
    YuEViewController *yue = [[YuEViewController alloc] initWithNibName:@"YuEViewController" bundle:[NSBundle mainBundle]];
    yue.isTiXian = NO;
    yue.title = NSLocalizedString(@"MOKAGold", nil);
    [self.navigationController pushViewController:yue animated:YES];
    
}


//我收到的礼物详情
- (IBAction)myDaShangList:(id)sender {
    MyDaShangListViewController *dashang = [[MyDaShangListViewController alloc] initWithNibName:@"MyDaShangListViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:dashang animated:YES];
    
}


@end
