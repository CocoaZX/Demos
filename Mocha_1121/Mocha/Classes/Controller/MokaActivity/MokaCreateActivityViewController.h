//
//  MokaCreateActivityViewController.h
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseViewController.h"

@interface MokaCreateActivityViewController : McBaseViewController

//自定义的类型区分 活动类型：通告1,众筹2，海报3
@property (nonatomic,assign)NSInteger TypeNum;


//滑动视图
@property (nonatomic,strong)UIScrollView *mainScrollView;

@end
