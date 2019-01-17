//
//  McWebViewController.h
//  Test
//
//  Created by zhoushuai on 16/1/5.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"
#import "McMainController.h"
#import "McBaseWebViewController.h"
@interface McWebViewController : McBaseWebViewController
{
    //加载提示
    //UIActivityIndicatorView *_activityIndictorView;
}


@property (assign,nonatomic)BOOL needAppear;
//网站链接
@property (nonatomic,copy)NSString *webUrlString;

@property (nonatomic,strong)McMainController *mainVC;


@end
