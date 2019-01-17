//
//  MCAuctionTipsController.m
//  Mocha
//
//  Created by TanJian on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCAuctionTipsController.h"

@interface MCAuctionTipsController ()<UIWebViewDelegate>

@property (strong, nonatomic)UIButton *agreeBtn;

@property (nonatomic,strong)NSURL *url;
@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,assign)int startCount;

@end

@implementation MCAuctionTipsController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -64 -44);
    
    self.title = @"出价竞拍提示";
    self.hidesBottomBarWhenPushed = YES;
    
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self.linkUrl, NULL, NULL,  kCFStringEncodingUTF8 ));
    self.url = [NSURL URLWithString:encodedString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    [self.view addSubview:self.agreeBtn];
    [self.view bringSubviewToFront:self.agreeBtn];
    self.agreeBtn.backgroundColor = [UIColor colorForHex:kLikeGrayColor];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerForTipsVC) userInfo:nil repeats:YES];
    self.agreeBtn.userInteractionEnabled = NO;
    self.startCount = 5;
    
}

-(void)timerForTipsVC{
    if (_startCount>=0) {
        [self.agreeBtn setTitle:[NSString stringWithFormat:@"同意(%d)",_startCount] forState:UIControlStateNormal];
        self.agreeBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        _startCount--;
    }else{
        [self.timer invalidate];
        self.agreeBtn.userInteractionEnabled = YES;
        self.agreeBtn.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    }
    
}


- (void)didClickBtn:(UIButton *)sender {
    //[self.navigationController popoverPresentationController];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UiWebview Delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - set/get方法
- (UIButton *)agreeBtn{
    if (_agreeBtn == nil) {
        _agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, kDeviceHeight -64 - 44, kDeviceWidth, 44)];
        _agreeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_agreeBtn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _agreeBtn;
}


@end
