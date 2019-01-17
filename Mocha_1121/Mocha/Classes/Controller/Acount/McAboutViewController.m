//
//  McAboutViewController.m
//  Mocha
//
//  Created by renningning on 14-11-28.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McAboutViewController.h"


#define AboutUrl @"http://www.mokacool.com/aboutapp"

@interface McAboutViewController ()

@end

@implementation McAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置视图
    [self _initViews];
    //加载网页
    [self loadWebView];
    
    
}

-(void)_initViews
{
//    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight -64)];
//    _webView.delegate = self;
//    //网页自适应大小
//    _webView.scalesPageToFit = YES;
//    [self.view addSubview:_webView];
    
    
    _activityIndictorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2, 300, 100, 100)];
    //设置样式
    _activityIndictorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [self.view addSubview:_activityIndictorView];
}


//加载网页
- (void)loadWebView{
    NSURL *webUrl = [NSURL URLWithString:_webUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:webUrl];
    [self.webView loadRequest:request];
}

#pragma mark UIWebViewDelegate

#pragma mark -UIView代理：UIWebViewDelegate
//网页刚开始加载的时候
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [_activityIndictorView startAnimating];
}
//网页结束加载的时候
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_activityIndictorView stopAnimating];

    //js操作判断
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self communicateWithJS:context withVC:self];

}

//网页加载失败的时候
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
