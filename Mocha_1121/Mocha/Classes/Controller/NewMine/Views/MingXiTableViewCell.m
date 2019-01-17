//
//  MingXiTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/20.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "MingXiTableViewCell.h"

@implementation MingXiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}













+ (MingXiTableViewCell *)getMingXiTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MingXiTableViewCell" owner:self options:nil];
    MingXiTableViewCell *cell = array[0];
    return cell;
}









@end
