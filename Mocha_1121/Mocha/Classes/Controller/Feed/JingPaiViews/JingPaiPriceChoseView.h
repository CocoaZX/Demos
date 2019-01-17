//
//  JingPaiPriceChoseView.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PriceJingPaiCancel)();

typedef void (^PriceJingPaiSure)(NSDictionary *diction);


@interface JingPaiPriceChoseView : UIView


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UIView *itemBackViewOne;

@property (weak, nonatomic) IBOutlet UIView *itemBackViewTwo;

@property (weak, nonatomic) IBOutlet UITextField *startPrice;

@property (weak, nonatomic) IBOutlet UITextField *addPrice;

@property (copy, nonatomic) PriceJingPaiCancel cancelBlock;

@property (copy, nonatomic) PriceJingPaiSure sureBlock;



- (void)setTheCancelBlock:(PriceJingPaiCancel)block;

- (void)setTheSureBlock:(PriceJingPaiSure)block;

- (void)resignTextfield;

- (void)setupViews;



+ (JingPaiPriceChoseView *)getJingPaiPriceChoseView;



@end
