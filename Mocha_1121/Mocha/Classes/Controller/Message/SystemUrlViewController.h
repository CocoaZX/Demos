//
//  SystemUrlViewController.h
//  Mocha
//
//  Created by 小猪猪 on 15/2/8.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface SystemUrlViewController : McBaseViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@property (strong, nonatomic) NSString *urlString;


@end
