//
//  UploadPictureCell.m
//  Mocha
//
//  Created by zhoushuai on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "UploadPictureCell.h"

@implementation UploadPictureCell

- (void)awakeFromNib {
    self.contentView.backgroundColor  = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //按照比例铺满
    [_imgView  setContentMode:UIViewContentModeScaleAspectFill];
    //多余部分裁剪掉
    _imgView.layer.cornerRadius = 10;
    _imgView.layer.masksToBounds = YES;
    
    _progressView.layer.cornerRadius = 10;
    _progressView.layer.masksToBounds = YES;
}


- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
    }
    [self setNeedsLayout];
}

- (void)setImgUrlStr:(NSString *)imgUrlStr{
    if (_imgUrlStr != imgUrlStr) {
        _imgUrlStr = imgUrlStr;
    }
    [self setNeedsLayout];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    _imgView.image = nil;
    if ([_cellType isEqualToString:@"netCell"]) {
        NSString *imgJpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
        NSString *imgCompleteurl = [NSString stringWithFormat:@"%@%@",_imgUrlStr,imgJpg];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:imgCompleteurl]];

    }else if ([_cellType isEqualToString:@"localCell"]){
        _imgView.image = _image;
    }

    
    //设置进度图显示
    if(_progressValue == 100){
        _progressView.hidden = YES;
    }else{
        _progressView_top.constant = (_progressValue/100)*self.height;
        
    }
    
}



@end
