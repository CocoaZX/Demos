//
//  JingPaiPriceChoseView.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JingPaiPriceChoseView.h"

@implementation JingPaiPriceChoseView


- (void)setupViews
{
    self.backView.layer.cornerRadius = 10.0;
    self.itemBackViewOne.layer.cornerRadius = 10.0;
    self.itemBackViewTwo.layer.cornerRadius = 10.0;
}

- (void)setTheCancelBlock:(PriceJingPaiCancel)block
{
    self.cancelBlock = block;
    
}

- (void)setTheSureBlock:(PriceJingPaiSure)block
{
    self.sureBlock = block;

}

- (IBAction)cancelMethod:(id)sender {
    LOG_METHOD;
    [self resignTextfield];
    self.cancelBlock();
}

- (IBAction)sureMethod:(id)sender {
    LOG_METHOD;
    [self resignTextfield];
    self.sureBlock(@{@"price":getSafeString(self.startPrice.text),@"more":getSafeString(self.addPrice.text)});

}

- (IBAction)dismissKeyboard:(id)sender {
    LOG_METHOD;
    [self resignTextfield];

}

- (void)resignTextfield
{
    [self.startPrice resignFirstResponder];
    [self.addPrice resignFirstResponder];
}

+ (JingPaiPriceChoseView *)getJingPaiPriceChoseView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JingPaiPriceChoseView" owner:self options:nil];
    JingPaiPriceChoseView *cell = array[0];
    [cell setupViews];
    return cell;
    
}



@end
