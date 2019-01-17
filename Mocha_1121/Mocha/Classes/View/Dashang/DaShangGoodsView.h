//
//  DaShangGoodsView.h
//  Mocha
//
//  Created by TanJian on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OtherDaShangView.h"


@interface DaShangGoodsView : UIView

- (void)setUpviews;

- (void)addToWindow;



@property (strong, nonatomic) OtherDaShangView *otherView;

@property (copy, nonatomic) NSString *currentPhotoId;
@property (copy, nonatomic) NSString *currentMoney;

@property (weak, nonatomic) UIViewController *superController;
@property (nonatomic,strong)UINavigationController *superNVC;

//打赏类型
@property (copy,nonatomic)NSString *dashangType;
//打赏对象的id
@property (copy,nonatomic)NSString *targetUid;

@property (nonatomic,copy)NSString *currentUid;

@property (nonatomic,strong)NSString *giftBtn;

//动画类型
@property (nonatomic,copy) NSString *animationType;


@end
