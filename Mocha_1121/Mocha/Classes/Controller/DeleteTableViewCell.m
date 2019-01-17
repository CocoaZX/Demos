//
//  DeleteTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 16/3/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DeleteTableViewCell.h"

@implementation DeleteTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _deleteBtn.layer.cornerRadius = 5;
    _deleteBtn.layer.masksToBounds = YES;
    self.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(DeleteTableViewCell *)getDeleteCell{
    DeleteTableViewCell *deleteCell = [[NSBundle mainBundle] loadNibNamed:@"DeleteTableViewCell" owner:self options:nil].lastObject;
    deleteCell.deleteBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    deleteCell.deleteBtn.userInteractionEnabled = NO;
    return deleteCell;
}

@end
