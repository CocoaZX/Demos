//
//  TiXianViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/11/1.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "TiXianViewController.h"

@interface TiXianViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation TiXianViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"提现";
    self.mainWebView.frame = CGRectMake(0,64, kScreenWidth, kScreenHeight-64);
    NSString *urlstring = [NSString stringWithFormat:@"%@/wallet/rebate",DEFAULTURL];
    
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlstring]]];
}

- (void)scrollToTop
{
    [self.mainWebView.scrollView setContentOffset:CGPointMake(0, 0)];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissUserPro:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
