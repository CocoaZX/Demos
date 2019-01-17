//
//  MokaReleaseActivityViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/1/30.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface MokaReleaseActivityViewController : McBaseViewController

@property (nonatomic,strong)UINavigationController *superNVC;

//底层滑动视图
@property (nonatomic,strong)UIScrollView *mainScrollView;

@end
