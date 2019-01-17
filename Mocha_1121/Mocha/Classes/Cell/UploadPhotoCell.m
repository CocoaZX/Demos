//
//  UploadPhotoCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "UploadPhotoCell.h"

@implementation UploadPhotoCell

- (void)awakeFromNib {
    // Initialization code
    _btn.layer.cornerRadius = 5;
    _btn.layer.masksToBounds = YES;
    self.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(id)getUploadPhotoCell{
    UploadPhotoCell *cell = [[NSBundle mainBundle] loadNibNamed:@"UploadPhotoCell" owner:self options:nil].lastObject;
    cell.btn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    return cell;
}

@end
