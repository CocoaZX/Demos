//
//  McWebViewController.m
//  Test
//
//  Created by zhoushuai on 16/1/5.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "McWebViewController.h"
#import "MokaActivityDetailViewController.h"
#import "PhotoViewDetailController.h"
@interface McWebViewController ()

@property (nonatomic , copy)NSString *appJumpStr;

//顶部导航栏左侧按钮
@property (nonatomic,strong)UIView *leftView;

//用户已经执行过一次返回网页的操作了: 默认是fale
//当用户执行过一次返回操作之后，就在顶部的导航栏显示用于直接返回的close按钮
@property (nonatomic,assign)BOOL haveBackFromWebPage;


@end

@implementation McWebViewController


#pragma mark 视图加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setNavigationBar];
    //首次进入加载加载网页
    [self loadWebView:_webUrlString];
}

+(void)initialize{
    [super initialize];
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectZero];
    NSString *userAgent=[webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *changeUserAgent = [NSString stringWithFormat:@"%@ moka/2.15",userAgent];
    NSDictionary *infoAgentDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",changeUserAgent],@"UserAgent",nil];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:infoAgentDic];
}



 
//加载网页
- (void)loadWebView:(NSString *)webString{
    NSURL *webUrl = [NSURL URLWithString:_webUrlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:webUrl];
    [self.webView loadRequest:request];
    
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:webString]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    
    if (_needAppear) {
    [self.customTabBarController hidesTabBar:YES animated:NO];
     self.webView.scrollView.alwaysBounceHorizontal = NO;
     self.webView.scrollView.alwaysBounceVertical = NO;
    }else{
        [self.customTabBarController setSelectedIndex:0];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [self.customTabBarController hidesTabBar:YES animated:NO];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}



#pragma mark 导航栏设置
//设置导航栏style
-(void)setNavigationBar{
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , 75, 30)];
    //左边箭头button
    UIButton *arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [arrowBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [arrowBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [arrowBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    arrowBtn.tag = 100;
    [_leftView addSubview:arrowBtn];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(45, 0, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
    closeBtn.tag = 101;
    closeBtn.hidden = YES;
    [_leftView addSubview:closeBtn];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_leftView];
    self.navigationItem.leftBarButtonItem = rightItem;
    
    //调用父类方法，增加右侧导航栏，用于分享此页
    [self setNavigationBarShareButtionItem];
    
}



-(void)backAction:(UIButton *)btn{
    if (self.webView.canGoBack) {
        //如果当前网页可以返回，执行网页返回操作
        [self.webView goBack];
        if(_haveBackFromWebPage){
            //已经执行过返回操作
        }else{
            //第一次执行返回操作，调整导航栏，显示直接关闭的按钮
            UIButton *closeBtn = [_leftView viewWithTag:101];
            closeBtn.hidden = NO;
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeAction:(UIButton *)btn{
    //直接关闭网页显示，执行pop
    [self.navigationController popViewControllerAnimated:YES];
    
}





#pragma mark -UIView代理：UIWebViewDelegate
//网页刚开始加载的时候
- (void)webViewDidStartLoad:(UIWebView *)webView{
   //[_activityIndictorView startAnimating];
    
}

//网页结束加载的时候
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    //[_activityIndictorView stopAnimating];
    //获取当前页面的title
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //js操作判断
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [self communicateWithJS:context withVC:self];

    
}

//网页加载失败的时候
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"网页加载失败");
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //获取请求URL
    NSURL *url = [request URL];
    NSString *completeString = [url absoluteString];
    
    //第一种情况
    //寻找匹配字符串
    NSRange jumpRange = [completeString rangeOfString:@"http://www.moka.vc/mokappjump/"];
    if (jumpRange.location != NSNotFound) {
        NSArray *jumpArr = [completeString componentsSeparatedByString:@"http://www.moka.vc/mokappjump/"];
        NSString *jumpStr = [jumpArr lastObject];
        if ([jumpStr hasPrefix:@"u/"]) {
            //主页
            NSString *allStr = [jumpStr substringFromIndex:2];
            NSString *uid = [[allStr componentsSeparatedByString:@"/nickname/"] firstObject];
            NSString *title = [[allStr componentsSeparatedByString:@"/nickname/"] lastObject];
            title = [title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = getSafeString(title);
            newMyPage.currentUid = getSafeString(uid);
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            //[self disBottom];
            [self.navigationController pushViewController:newMyPage animated:YES];             return NO;
        }
        if ([jumpStr hasPrefix:@"a/"]) {
            //活动
            NSString *activeId = [jumpStr substringFromIndex:2];
            //活动ID
            MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
            mokaDetailVC.eventId = activeId;
            
            [self.navigationController pushViewController:mokaDetailVC animated:YES];


            return NO;
        }
        if ([jumpStr hasPrefix:@"T/"]) {
            //tab
            if ([jumpStr hasPrefix:@"T/home/"]) {
                [self.customTabBarController setSelectedIndex:0];
            }
            if ([jumpStr hasPrefix:@"T/show/"]) {
                [self.customTabBarController setSelectedIndex:2];
            }
            if ([jumpStr hasPrefix:@"T/square/"]) {
                [self.customTabBarController setSelectedIndex:1];
            }
            if ([jumpStr hasPrefix:@"T/mine/"]) {
                [self.customTabBarController setSelectedIndex:3];
            }
            self.needAppear = NO;
            //[self disBottom];
            return NO;
        }
        
        if ([jumpStr hasPrefix:@"p/"]) {
            //照片详情
            NSString *pid = [jumpStr substringFromIndex:2];
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
                [detailVc requestWithPhotoId:pid uid:@""];
                
            detailVc.isFromTimeLine = NO;
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            //[self disBottom];
            [self.navigationController pushViewController:detailVc animated:YES];
            return NO;
        }
    }
    
    
    //第二种情况
    NSRange jumpRangeForShare = [completeString rangeOfString:@"http://mokasafari="];
    if (jumpRangeForShare.location != NSNotFound) {
        //存在需要使用safari跳转的链接
        NSArray *jumpArr = [completeString componentsSeparatedByString:@"="];
        NSString *jumpStr = [jumpArr lastObject];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:jumpStr]];
        return NO;
     }

    return YES;
}

#pragma mark scrollView代理：
//设置不可以左右滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//CGPoint point = scrollView.contentOffset;
//    if (point.x > 0 ||point.x<kDeviceWidth) {
//        //这里不要设置为CGPointMake(0, point.y)，
//        //这样我们在文章下面左右滑动的时候，就跳到文章的起始位置，不科学
//        scrollView.contentOffset = CGPointMake(0, point.y);
//    }
}



@end
