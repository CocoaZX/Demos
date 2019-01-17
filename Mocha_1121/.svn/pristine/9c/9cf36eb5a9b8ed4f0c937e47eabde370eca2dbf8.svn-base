//
//  TuijianTableViewCell.m
//  Mocha
//
//  Created by sunqichao on 15/9/13.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "TuijianTableViewCell.h"

@implementation TuijianTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.numberLabel.frame = CGRectMake(kDeviceWidth - 70, 15, 60, 30);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}





- (void)layoutSubviews
{
    [super layoutSubviews];
    if(kDeviceWidth>375){
        _nameLabel_left.constant = 20;
    }else{
        _nameLabel_left.constant = 14;
    }
}




+ (TuijianTableViewCell *)getTuijianTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TuijianTableViewCell" owner:self options:nil];
    TuijianTableViewCell *cell = array[0];
 cell.nameLabel.textColor= [CommonUtils colorFromHexString:kLikeGrayColor];
    cell.numberLabel.frame = CGRectMake(kDeviceWidth - 50, 15, 60, 30);
    return cell;
    
}



@end
