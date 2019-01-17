//
//  WatchedTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "WatchedTableViewCell.h"

@implementation WatchedTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (WatchedTableViewCell *)getWatchedCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WatchedTableViewCell" owner:self options:nil];
    WatchedTableViewCell *cell = array[0];
    cell.linemageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
    
    return cell;
}


@end
