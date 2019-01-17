//
//  CustomLabelView.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "CustomLabelView.h"

@implementation CustomLabelView


- (void)setupViews
{
    self.backView.layer.cornerRadius = 10.0;
    self.itemBackView.layer.cornerRadius = 10.0;
    self.shurukuang.layer.cornerRadius = 10.0;
}

- (void)setTheCancelBlock:(PriceJingPaiCancel)block
{
    self.cancelBlock = block;
    
}

- (void)setTheSureBlock:(PriceJingPaiSure)block
{
    self.sureBlock = block;
    
}


- (IBAction)dismissKeyword:(id)sender {
    LOG_METHOD;
    [self resignTextfield];

    
}

- (IBAction)cancelMethod:(id)sender {
    LOG_METHOD;

    [self resignTextfield];
    self.cancelBlock();
}

- (IBAction)sureMethod:(id)sender {
    LOG_METHOD;

    [self resignTextfield];
    self.sureBlock(@{@"title":getSafeString(self.customTextfield.text)});
    
}

- (void)resignTextfield
{
    [self.customTextfield resignFirstResponder];

}


+ (CustomLabelView *)getCustomLabelView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"CustomLabelView" owner:self options:nil];
    CustomLabelView *cell = array[0];
    [cell setupViews];
    return cell;
}

@end
