//
//  MCShareJingpaiView.h
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McHotFeedViewController.h"

@interface MCShareJingpaiView : UIView

-(void)animationForView;

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,strong) UIImage *firstImg;
@property (nonatomic,copy) NSString *auctionID;
@property (nonatomic,copy) NSString *shareDes;

@end
