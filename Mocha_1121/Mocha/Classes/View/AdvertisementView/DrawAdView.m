//
//  DrawAdView.m
//  Mocha
//
//  Created by zhoushuai on 16/1/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DrawAdView.h"

@implementation DrawAdView



//数据设置
//添加图片时会自动的重绘视图
- (void)setImage:(UIImage *)image{
    if (_image != image) {
        _image = image;
        [self setNeedsLayout];
    }
}


- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawImg:nil];
}



//绘制图片
- (void)drawImg:(NSData *)data{
    //画出图片
    NSLog(@"图片的宽度%f: |高度:%f",_image.size.width,_image.size.height);
    [_image drawInRect:self.bounds];
}




@end
