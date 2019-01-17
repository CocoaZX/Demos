//
//  DaShangView.h
//  Mocha
//
//  Created by yfw－iMac on 16/3/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherDaShangView.h"


@interface DaShangView : UIView

- (void)setUpviews;

- (void)addToWindow;

@property (strong, nonatomic) OtherDaShangView *otherView;

@property (copy, nonatomic) NSString *currentPhotoId;
@property (copy, nonatomic) NSString *currentMoney;

@property (weak, nonatomic) UIViewController *superController;

//打赏类型
@property (copy,nonatomic)NSString *dashangType;
//打赏对象的id
@property (copy,nonatomic)NSString *targetUid;

@end
