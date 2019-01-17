//
//  CustomLabelView.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JingPaiPriceChoseView.h"
@interface CustomLabelView : UIView

@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextField *customTextfield;

@property (weak, nonatomic) IBOutlet UIView *itemBackView;
@property (weak, nonatomic) IBOutlet UIView *shurukuang;

@property (copy, nonatomic) PriceJingPaiCancel cancelBlock;

@property (copy, nonatomic) PriceJingPaiSure sureBlock;

- (void)setTheCancelBlock:(PriceJingPaiCancel)block;

- (void)setTheSureBlock:(PriceJingPaiSure)block;

- (void)resignTextfield;

+ (CustomLabelView *)getCustomLabelView;


@end
