//
//  CashingDetailViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/12/12.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "CashingDetailViewController.h"
#import "YuEViewController.h"

@interface CashingDetailViewController ()


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation CashingDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"零钱提现";
    if (self.isChongZhi) {
        self.title = @"零钱充值";
        self.detailLabel.text = @"充值申请已提交";
        self.titleLabel.text = @"充值金额";
        self.nameLabel.text = @"";
        self.hiddenView.hidden = NO;
    }else
    {
        self.nameLabel.text = self.currentName;
        self.hiddenView.hidden = YES;
    }
    self.moneyLabel.text = [NSString stringWithFormat:@"￥%@",self.currentMoney];
    
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.hidesBackButton = YES;
    
}


- (IBAction)finishMethod:(id)sender {
    for (int i=0;i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[YuEViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];

        }
    }
    
}







@end
