//
//  BaseMcMainViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/10.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "BaseMcMainViewController.h"

@interface BaseMcMainViewController ()

@end


@implementation BaseMcMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];

    //图片数组
    _imageURLs= [NSMutableArray array];
    _photoURLs = [NSMutableArray array];
    
    //上次请求数据的标识
    _lastIndex = @"0";
    
    //一次请求数据的个数
    _pageSize = 15;
    
    //滑动视图的高度
    _imageScrollViewHeight = 230;
    
}


@end
