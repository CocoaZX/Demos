//
//  MCAnimForVideo.m
//  Mocha
//
//  Created by TanJian on 16/3/30.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCAnimForVideo.h"

#pragma mark tips
//自写视频缓冲提醒，调用时新建view的size规定为（40.40）
@interface MCAnimForVideo ()

@property (nonatomic,strong,readwrite) CALayer *circleLayer;

@end

@implementation MCAnimForVideo

-(CALayer *)circleLayer{
    if (!_circleLayer) {
        _circleLayer = [[CALayer alloc]init];
    }
    return _circleLayer;
}

-(void)drawRect:(CGRect)rect{
    
    self.layer.cornerRadius = 7;
    self.clipsToBounds = YES;
    // 上下文(顺时针和逆时针是反过来的)
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 路径
    CGContextAddArc(ctx, 23, 23, 15, 0, M_PI*2, 1);
    CGContextSetLineWidth(ctx, 5);
    [[UIColor darkGrayColor] set];
    // 渲染
    CGContextStrokePath(ctx);
    
//    CALayer *layer = [[CALayer alloc]init];
    
    self.circleLayer.position = CGPointMake(23, 38);
    _circleLayer.bounds = CGRectMake(0 , 0, 10, 10);
    _circleLayer.cornerRadius = 5;
    
    _circleLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    
    // 添加到控制器的view的layer上
    [self.layer addSublayer:_circleLayer];
    
    // 1.创建基本动画的对象
    CABasicAnimation* anim = [[CABasicAnimation alloc] init];
    // 2.基本动画的操作
    anim.keyPath = @"transform.scale"; // 修改哪一个属性
    // 缩放倍数
    anim.fromValue = [NSNumber numberWithFloat:0.9]; // 开始时的倍率
    anim.toValue = [NSNumber numberWithFloat:1.6]; // 结束时的倍率
    anim.autoreverses = YES;
    anim.duration = 0.7;
    anim.repeatCount = 1000;
    [_circleLayer addAnimation:anim forKey:nil];
    
    //第二个动画
    CAKeyframeAnimation* anim1 = [[CAKeyframeAnimation alloc] init];
    // 2.动画的操作
    anim1.keyPath = @"position";
    // path
    UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(23, 23) radius:15 startAngle:M_PI * 0.5 endAngle:2.5 * M_PI clockwise:1];
    anim1.path = path.CGPath;
    anim1.duration = 1.5;
    anim1.repeatCount = 1000;
    [_circleLayer addAnimation:anim1 forKey:nil];
    
}


@end
