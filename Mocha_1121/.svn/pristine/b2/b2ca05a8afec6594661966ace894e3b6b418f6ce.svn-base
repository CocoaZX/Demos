//
//  BuyMemberSuccessViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BuyMemberSuccessViewController.h"

@interface BuyMemberSuccessViewController ()


@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *daoqi;



@end

@implementation BuyMemberSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"购买成功";
    NSString *userImage = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:userImage] placeholderImage:nil];
    self.nameLabel.text = userName;

    self.headerImageView.layer.cornerRadius = 25;
    self.daoqi.layer.cornerRadius = 5;
    
    [self.daoqi setTitle:[NSString stringWithFormat:@"%@天后到期",self.days] forState:UIControlStateNormal];
    
}



- (IBAction)finishMethod:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
