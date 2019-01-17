//
//  MCMainFierySectionHeaderView.m
//  Mocha
//
//  Created by TanJian on 16/5/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCMainFierySectionHeaderView.h"

@implementation MCMainFierySectionHeaderView


-(instancetype)init{
    
    return [[NSBundle mainBundle]loadNibNamed:@"MCMainFierySectionHeaderView" owner:self options:nil].lastObject;
}


-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    _headerLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _leftLine.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    _rightLine.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
}

@end
