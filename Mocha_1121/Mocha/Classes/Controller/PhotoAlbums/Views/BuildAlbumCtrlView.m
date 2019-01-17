//
//  BuildAlbumCtrlView.m
//  Mocha
//
//  Created by zhoushuai on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BuildAlbumCtrlView.h"

@implementation BuildAlbumCtrlView

- (void)awakeFromNib{
    //调整圆角
    _circleView.layer.cornerRadius = 5;
    _circleView.layer.masksToBounds = YES;
    _detailLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
}


//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

+(BuildAlbumCtrlView *)getBuildAlbumCtrlView{
    return [[[NSBundle mainBundle] loadNibNamed:@"BuildAlbumCtrlView" owner:nil options:nil] lastObject];
}


@end
