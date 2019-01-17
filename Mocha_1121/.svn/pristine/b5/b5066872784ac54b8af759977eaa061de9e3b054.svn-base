//
//  LocalPhotoCell.m
//  AlbumTest
//
//  Created by ejiang on 14-7-28.
//  Copyright (c) 2014年 daijier. All rights reserved.
//

#import "LocalPhotoCell.h"

@implementation LocalPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
    }
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    self.img.image = _image;
    //按照比例铺满
    [self.img  setContentMode:UIViewContentModeScaleAspectFill];
    //多余部分裁剪掉
    self.img.layer.masksToBounds = YES;
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
