//
//  auctionTips.h
//  Mocha
//
//  Created by TanJian on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHotJingpaiCell.h"

@interface auctionTips : UIView

@property (nonatomic, strong) McHotFeedViewController *superHotVC;
@property (nonatomic, strong) McMyFeedListViewController *superListVC;
@property (nonatomic, strong) McNearFeedViewController *superNearVC;
@property (nonatomic, strong) UIViewController  *superVC;
@property (nonatomic, assign) MCsuperType superVCType;





-(void)setupUI;

@end
