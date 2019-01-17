//
//  McAboutViewController.h
//  Mocha
//
//  Created by renningning on 14-11-28.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "McBaseWebViewController.h"

@interface McAboutViewController : McBaseWebViewController<UIWebViewDelegate>

{
     //加载提示
    UIActivityIndicatorView *_activityIndictorView;
    
}

//网站链接
@property (nonatomic,copy)NSString *webUrlString;

@end
