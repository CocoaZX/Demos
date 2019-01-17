//
//  TaoXiDescriptionCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiDescriptionCell.h"

@implementation TaoXiDescriptionCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    [self bringSubviewToFront:_detailTextView];
    
}



+(TaoXiDescriptionCell *)getTaoXiDescriptionCell{
    TaoXiDescriptionCell *cell = [[NSBundle mainBundle] loadNibNamed:@"TaoXiDescriptionCell" owner:self options:nil].lastObject;
    cell.descriptionTextField.returnKeyType = UIReturnKeyDone;
    return cell;
}



@end
