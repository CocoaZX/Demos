//
//  JingPaiPartThreeTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JingPaiPartThreeTableViewCell.h"

@implementation JingPaiPartThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.choseTypeView.layer.cornerRadius = 12.0f;
    self.startPriceView.layer.cornerRadius = 12.0f;
    
    __weak __typeof(self)weakSelf = self;

    [self.jingpaiChose setTheCancelBlock:^{
        weakSelf.jingpaiChose.hidden = YES;
    }];
    
    [self.jingpaiChose setTheSureBlock:^(NSDictionary *diction) {
        weakSelf.jingpaiChose.hidden = YES;
        weakSelf.startPriceLabel.text = getSafeString(weakSelf.jingpaiChose.startPrice.text);
    }];
}

- (JingPaiPriceChoseView *)jingpaiChose
{
    if (!_jingpaiChose) {
        _jingpaiChose = [JingPaiPriceChoseView getJingPaiPriceChoseView];
        _jingpaiChose.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        
    }
    
    return _jingpaiChose;
}


- (NSString *)getStartPrice
{
    
    return getSafeString(self.jingpaiChose.startPrice.text);;
}

- (NSString *)getAddPrice
{

    return getSafeString(self.jingpaiChose.addPrice.text);;
}


- (IBAction)choseType:(id)sender {
    LOG_METHOD;
    if (!self.jingpai) {
        self.jingpai = [[ChoseJingPaiTypeViewController alloc] initWithNibName:@"ChoseJingPaiTypeViewController" bundle:[NSBundle mainBundle]];
    }
    __weak __typeof(self)weakSelf = self;
    [self.jingpai setTypeBlock:^(NSDictionary *type) {
        weakSelf.diction = type;
        weakSelf.choseTypeLabel.text = getSafeString(type[@"auction_type_name"]);
    }];
    [self.controller.navigationController pushViewController:self.jingpai animated:YES];
    
}



- (IBAction)choseStartPrice:(id)sender {
    LOG_METHOD;
//    if (!self.startPrice) {
//        self.startPrice = [[MCStartPriceViewController alloc] initWithNibName:@"MCStartPriceViewController" bundle:[NSBundle mainBundle]];
//    }
//    __weak __typeof(self)weakSelf = self;
//    [self.startPrice setStartPriceBlock:^(NSDictionary *type) {
//       
//        
//        
//    }];
//    [self.controller.navigationController pushViewController:self.startPrice animated:YES];
//    
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            self.jingpaiChose.hidden = NO;
            [window addSubview:self.jingpaiChose];
            
            break;
        }
    }
    
}




+ (JingPaiPartThreeTableViewCell *)getJingPaiPartThreeTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JingPaiPartThreeTableViewCell" owner:self options:nil];
    JingPaiPartThreeTableViewCell *cell = array[0];
    
    return cell;
}


@end
