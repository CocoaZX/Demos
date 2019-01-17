//
//  MCJingpaiContentView.m
//  Mocha
//
//  Created by TanJian on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiContentView.h"

@implementation MCJingpaiContentView

-(instancetype)init{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MCJingpaiContentView" owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    
    //减少竞拍阻力，去掉评论
    
    self.cancelButton.layer.cornerRadius = 8;
    self.cancelButton.clipsToBounds = YES;
    self.cancelButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
    self.confirmButton.layer.cornerRadius = 8;
    self.confirmButton.clipsToBounds = YES;
    self.confirmButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
//    self.priceTextField.adjustsFontSizeToFitWidth = YES;
//    [self.priceTextField setValue:[UIFont boldSystemFontOfSize:13*kDeviceWidth/375] forKeyPath:@"_placeholderLabel.font"];
}


@end
