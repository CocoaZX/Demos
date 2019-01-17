//
//  MemberCenterController.m
//  Mocha
//
//  Created by yfw－iMac on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//
#import "OpenMemberViewController.h"
#import "MemberCenterController.h"
#import "DaShangViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JSONKit.h"

@interface MemberCenterController ()


@property (nonatomic,strong) NSURL *url;

@property (copy, nonatomic) NSString *shareTitle;
@property (copy, nonatomic) NSString *shareDescription;
@property (copy, nonatomic) NSString *shareImageString;
@property (copy, nonatomic) NSString *deadline;
@property (copy, nonatomic) NSString *money;

@property (strong, nonatomic) UIImage *shareImage;


@end

@implementation MemberCenterController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additi onal setup after loading the view from its nib.
    self.title = NSLocalizedString(@"MemberCenter", nil);

    [self setNavigationBarShareButtionItem];
    
    self.hidesBottomBarWhenPushed = YES;
    //    NSString *params = @"";
    //    NSString *testURL = @"http://m.yaofangwang.com/zt/nuandong1212_ios.html";
    //    NSString *testURL = [NSString stringWithFormat:@"http://m.yaofangwang.com/zt/nuandong1212_ios.html%@",params];
    //    NSString *testURL = @"http://m.yaofangwang.com/chat.html?shopid=338999&type=2";
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)self.linkUrl, NULL, NULL,  kCFStringEncodingUTF8 ));
    self.url = [NSURL URLWithString:encodedString];
    //    self.url = [NSURL URLWithString:testURL];
    
   // self.infoWebview.delegate = self;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:self.url];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyMethod) name:@"buyMethodNotification" object:nil];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 }

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
    
}

- (void)dealloc
{
    
}

#pragma mark - UiWebview Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [SVProgressHUD show];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
    //网页加载完成调用此方法
    
    //iOS调用js
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //js调用iOS
    //第一种情况
    //其中test1就是js的方法名称，赋给是一个block 里面是iOS代码
    //此方法最终将打印出所有接收到的参数，js参数是不固定的 我们测试一下就知道
    __weak typeof (self) vc = self;
    context[@"openApp"] = ^() {
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            NSLog(@"%@",obj);
            NSDictionary *jsonDiction = [self dictionWithJsonString:getSafeString(obj)];
            vc.deadline = getSafeString(jsonDiction[@"deadline"]);
            vc.money = [NSString stringWithFormat:@"%d",[getSafeString(jsonDiction[@"money"]) intValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"buyMethodNotification" object:nil];
            });
            
        }
    };
    
    
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [SVProgressHUD dismiss];
}

- (NSDictionary *)dictionWithJsonString:(NSString *)string
{
    NSDictionary *json = [string objectFromJSONString];
    return json;
}

 

- (void)buyMethod {
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    
    DaShangViewController *dashang = [[DaShangViewController alloc] initWithNibName:@"DaShangViewController" bundle:[NSBundle mainBundle]];
    dashang.isBuyMember = YES;
    dashang.photoId = @"";
    dashang.uid = uid;
    dashang.name = userName;
    dashang.money = self.money;
    dashang.days = self.deadline;
    [self.navigationController pushViewController:dashang animated:YES];
    
}


@end
