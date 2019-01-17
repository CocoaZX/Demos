//
//  SystemUrlViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/2/8.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "SystemUrlViewController.h"

@interface SystemUrlViewController ()

@end

@implementation SystemUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.mainWebView.frame = CGRectMake(0,0, kScreenWidth, kScreenHeight);
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
