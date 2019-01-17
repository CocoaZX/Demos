//
//  RenZhengPartThreeTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "RenZhengPartThreeTableViewCell.h"

@implementation RenZhengPartThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _centerImageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.addPhotoImage.layer.cornerRadius = 10.0;
    self.addPhotoImage.layer.masksToBounds = YES;
    
    [self bringSubviewToFront:self.addPhotoButton];
    if (self.renZhengImage) {
        [_addPhotoButton setImage:_renZhengImage forState:UIControlStateNormal];
        _centerImageView.hidden = YES;
        _rightImgView.hidden = YES;
    }else{
        _centerImageView.hidden = NO;
        _centerImageView.hidden = NO;
    }
    
}


- (void)setRenZhengImage:(UIImage *)renZhengImage{
    if(_renZhengImage != renZhengImage){
        _renZhengImage = renZhengImage;
    }
    [self setNeedsLayout];
 }


- (IBAction)addButtonMethod:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseRenzhengImage" object:nil];

}




+ (RenZhengPartThreeTableViewCell *)getRenZhengPartThreeTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RenZhengPartThreeTableViewCell" owner:self options:nil];
    RenZhengPartThreeTableViewCell *cell = array[0];
    return cell;
}


@end
