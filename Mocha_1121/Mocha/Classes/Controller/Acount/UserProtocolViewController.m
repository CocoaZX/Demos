//
//  UserProtocolViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/1/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "UserProtocolViewController.h"

@interface UserProtocolViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@end

@implementation UserProtocolViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"用户协议";
    self.mainWebView.frame = CGRectMake(0,64, kScreenWidth, kScreenHeight-64);
    [self.mainWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.moka.vc/user/protocol"]]];
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"addDissmissUserProtocolViewNew" object:nil];
    
}
 

@end
