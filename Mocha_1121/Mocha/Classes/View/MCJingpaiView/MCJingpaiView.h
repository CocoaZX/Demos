//
//  MCJingpaiView.h
//  Mocha
//
//  Created by TanJian on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiContentView.h"
#import "McHotFeedViewController.h"
#import "MCHotJingpaiModel.h"
#import "MCHotJingpaiCell.h"

@interface MCJingpaiView : UIView

@property (nonatomic,assign) BOOL isHotFeedVC;

@property (nonatomic,strong) MCJingpaiContentView *contentView;
@property (nonatomic,strong) NSString *auctionID;
@property (nonatomic,strong) NSString *lastPrice;
@property (nonatomic,strong) UIImage *shareImg;
@property (nonatomic,copy) NSString *up_range;
@property (nonatomic,copy) NSString *auction_des;

@property (nonatomic, strong) McHotFeedViewController *superHotVC;
@property (nonatomic, strong) McMyFeedListViewController *superListVC;
@property (nonatomic, strong) McNearFeedViewController *superNearVC;
@property (nonatomic, assign) MCsuperType superVCType;
@property(nonatomic,strong)UIViewController *superVC;



-(void)setupUI;

@end
