//
//  JingPaiUploadView.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/21.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingPaiUploadView : UIView

@property (assign, nonatomic) float itemHeight;

@property (assign, nonatomic) int space;

@property (assign, nonatomic) float cellHeight;

@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UIButton *clickButton;
@property (strong, nonatomic) UIButton *deleteButton;


- (void)getTypeOneButtonViewWithIndex:(int)index;

- (void)getTypeTwoButtonViewWithIndex:(int)index;

- (void)getTypeThreeButtonViewWithImage:(NSString *)image WithIndex:(int)index;

- (void)getTypeFourButtonViewWithImage:(NSString *)image WithIndex:(int)index;




@end
