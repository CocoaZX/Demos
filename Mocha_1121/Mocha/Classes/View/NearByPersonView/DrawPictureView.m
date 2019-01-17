//
//  DrawPictureView.m
//  Mocha
//
//  Created by zhoushuai on 15/12/14.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "DrawPictureView.h"

@implementation DrawPictureView

#pragma mark 返回一个设置了各种属性的画布

- (id)initWithFrame:(CGRect)frame withImgDic:(NSDictionary *)imgDic{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imgDic = imgDic;
        //新创建一个线程队列，
        _operationQueue = [[NSOperationQueue alloc] init];
        //创建异步线程，请求网络加载图片
        NSInvocationOperation *nsOperaton = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(loadNetImg) object:nil];
        [_operationQueue addOperation:nsOperaton];
    }
    return self;
}



//异步加载图片
- (void)loadNetImg{
    //图片大小
    CGFloat pictureWidth = [[_imgDic objectForKey:@"photoWidth"] floatValue];
    CGFloat pictureHeigth = [[_imgDic objectForKey:@"photoHeight"] floatValue];
    
    //NSLog(@"图片链接:%@,附近图片w-%f, h-%f",_imgDic[@"photo_url"],pictureWidth,pictureHeigth);
    //裁剪使用宽度和高度
    NSNumber *clipWidth  = nil;
    NSNumber *clipHeight = nil;
    NSString *jpg  = @"";
    //图片链接
    NSString *imgUrlString = @"";
    
    if (pictureHeigth == 0 ||pictureWidth ==0){

    }else{
        if (pictureWidth>pictureHeigth) {
        //横长图:以高为标准获取图片
       clipWidth = [NSNumber numberWithInteger:self.width*(pictureHeigth/self.height)];
        clipHeight = [NSNumber numberWithInteger:pictureHeigth];
        jpg = [NSString stringWithFormat:@"@1e_%@h_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureHeigth],clipWidth,clipHeight];

        }else if(pictureWidth == pictureHeigth){
            //方图
            clipWidth = [NSNumber numberWithInteger:pictureWidth];
            clipHeight = [NSNumber numberWithInteger:pictureWidth *(self.height/self.width)];
            jpg = [NSString stringWithFormat:@"@1e_%@w_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureWidth],clipWidth,clipHeight];

        }else if(pictureWidth<pictureHeigth){
        //纵向长图片
            clipWidth = [NSNumber numberWithInteger:pictureWidth];
            clipHeight = [NSNumber numberWithInteger:pictureWidth *(self.height/self.width)];
            jpg = [NSString stringWithFormat:@"@1e_%@w_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureWidth],clipWidth,clipHeight];
         }
        
        
    }
    
    imgUrlString = [NSString stringWithFormat:@"%@%@",_imgDic[@"photo_url"],jpg];
    //对网址的安全处理
     NSString *urlStr = [imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    //请求图片数据
     NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]];
    //注意：所有有关UI的操作必须放在主线程中执行
    //回到主线程,重新刷新UI
    _image = [UIImage imageWithData:data scale:1];
    [self performSelectorOnMainThread:@selector(setNeedsDisplay) withObject:nil waitUntilDone:NO];
}


//设置图片
- (void)setImgDic:(NSDictionary *)imgDic{
    if(_imgDic != imgDic){
        _imgDic = imgDic;
        [self setNeedsLayout];
     }
}




#pragma mark  测试部分：绘制图形
- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self drawImg:nil];
}


//绘制图片
- (void)drawImg:(NSData *)data{
    //画出图片
    [_image drawInRect:self.bounds];
    
    //首先画出背景色
    //UIImage *image = [UIImage imageNamed:@"profile_bannar_bg"];
    //[image drawInRect:CGRectMake(0, 0, self.width, self.width)];
    //绘制图片到视图上
    [_image drawInRect:self.bounds];
    
    /*
    //图片大小
    CGFloat pictureWidth = [[_imgDic objectForKey:@"photoWidth"] floatValue];
    CGFloat pictureHeigth = [[_imgDic objectForKey:@"photoHeight"] floatValue];
    //绘制图片
    //绘制使用的宽度和高度
    CGFloat width = self.width;
    CGFloat height = width *(pictureHeigth/pictureWidth);
    
    [_image drawInRect:CGRectMake(0, 0, width, height)];
    if (pictureHeigth == 0 ||pictureWidth ==0){
        [_image drawInRect:self.bounds];
    }else{
        //横长图
        if (pictureWidth>pictureHeigth) {
            CGFloat width = self.height *(pictureWidth /pictureHeigth);
            [_image drawInRect:CGRectMake(-(width -self.width)/2,0, width, self.width)];
        //方图
        }else if(pictureWidth == pictureHeigth){
            [_image drawInRect:CGRectMake(0, 0, self.width, self.width)];
        //纵向长图片
        }else if(pictureWidth<pictureHeigth){
            NSNumber *clipWidth = [NSNumber numberWithInteger:pictureWidth];
            NSNumber *clipHeight = [NSNumber numberWithInteger:pictureWidth*(self.height/self.width)];
            CGFloat height = pictureWidth *(self.height/self.width);
            [_image drawInRect:CGRectMake(0, 0, self.width, height)];
        }
    }
     */
}


@end
