//
//  PhotoViewCell.m
//  ZSTest
//
//  Created by zhoushuai on 16/3/29.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import "PhotoViewCell.h"
#import "UIImage+FEBoxBlur.h"

@implementation PhotoViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //
        [self _initViews];
        
    }
    return self;
}

//初始化视图组件
- (void)_initViews{
    _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
   // _imgView.backgroundColor = [UIColor orangeColor];
    //按照比例铺满
    [_imgView  setContentMode:UIViewContentModeScaleAspectFill];
    
    //多余部分裁剪掉
    _imgView.layer.cornerRadius = 10;
    _imgView.layer.masksToBounds = YES;

    [self.contentView addSubview:_imgView];
    
    //被选中
    _selectedImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _selectedImgView.image = [UIImage imageNamed:@"deleteTemplete"];
    _selectedImgView.hidden = YES;
    [self.contentView addSubview:_selectedImgView];
    
    
}


//数据源

- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
        [self setNeedsLayout];
    }
}


- (void)setImgUrlString:(NSString *)imgUrlString{
    if (_imgUrlString != imgUrlString) {
        _imgUrlString = imgUrlString;
    }
    [self setNeedsLayout];
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    if (_image) {
        _imgView.image = _image;
    }else{
        //使用网络图片
        if ((_useConditionType.length != 0) &&[_useConditionType isEqualToString:@"needBlurry"]) {
            //1.浏览图片，需要设置模糊
            NSString *jpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
            NSString *imgCompleteurlStr = [NSString stringWithFormat:@"%@%@|50-10bl",_imgUrlString,jpg];
            NSString *handleuUlStr = [imgCompleteurlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_imgView sd_setImageWithURL:[NSURL URLWithString:handleuUlStr] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
                _imgView.image = image;
                UIGraphicsBeginImageContextWithOptions(_imgView.size, false, 0);
                   }];
        }else{
            //不需要设置模糊
            NSString *jpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
            NSString *imgCompleteurlStr = [NSString stringWithFormat:@"%@%@",_imgUrlString,jpg];
            [_imgView setImageWithURL:[NSURL URLWithString:imgCompleteurlStr] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        }
    }
}

@end
