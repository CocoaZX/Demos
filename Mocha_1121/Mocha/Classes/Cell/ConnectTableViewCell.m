//
//  ConnectTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ConnectTableViewCell.h"

@implementation ConnectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+(ConnectTableViewCell *)getConnectTableViewCell{
    ConnectTableViewCell *cell = [[NSBundle mainBundle] loadNibNamed:@"ConnectTableViewCell" owner:self options:nil].lastObject;
    return cell;
}


@end
