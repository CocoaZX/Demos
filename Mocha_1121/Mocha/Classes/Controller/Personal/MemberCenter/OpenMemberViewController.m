//
//  OpenMemberViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "OpenMemberViewController.h"
#import "BuyMemberSuccessViewController.h"
@interface OpenMemberViewController ()

@end

@implementation OpenMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开通会员";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}








- (IBAction)payMethod:(id)sender {
    
    BuyMemberSuccessViewController *open = [[BuyMemberSuccessViewController alloc] initWithNibName:@"BuyMemberSuccessViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:open animated:YES];
}









@end
