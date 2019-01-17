//
//  JingPaiPartThreeTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseJingPaiViewController.h"
#import "ChoseJingPaiTypeViewController.h"
#import "JingPaiPriceChoseView.h"

@interface JingPaiPartThreeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *choseTypeView;
@property (weak, nonatomic) IBOutlet UILabel *choseTypeLabel;

@property (strong, nonatomic) NSDictionary *diction;

@property (weak, nonatomic) IBOutlet UIView *startPriceView;
@property (weak, nonatomic) IBOutlet UILabel *startPriceLabel;

@property (weak, nonatomic) ReleaseJingPaiViewController *controller;

@property (strong, nonatomic) ChoseJingPaiTypeViewController *jingpai;
//@property (strong, nonatomic) MCStartPriceViewController *startPrice;

@property (strong, nonatomic) JingPaiPriceChoseView *jingpaiChose;

- (NSString *)getStartPrice;

- (NSString *)getAddPrice;

+ (JingPaiPartThreeTableViewCell *)getJingPaiPartThreeTableViewCell;




@end
