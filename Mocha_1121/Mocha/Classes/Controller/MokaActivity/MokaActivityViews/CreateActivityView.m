//
//  CreateActivityView.m
//  Mocha
//
//  Created by zhoushuai on 15/12/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "CreateActivityView.h"

@implementation CreateActivityView

- (id)initWithFrame:(CGRect)frame title:(NSString *)title DetailTxt:(NSString *)detailTxt bgImage:(NSString *)imageName withBlock:(UICtrlBlock)block{
    self = [self initWithFrame:frame];
    if (self) {
        /*
        //设置背景图片
        UIImage *bgImg = [UIImage imageNamed:imageName];
        //拉伸图片
        UIImage *customImg = [self getImgFromWithImg:bgImg withWidth:self.width withHeight:self.height];
        [self setBackgroundColor:[UIColor colorWithPatternImage:customImg]];
        */
        
        self.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        //名称
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(self.height-60)/2, self.width, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = title;
        titleLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:titleLabel];
        
        //介绍
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.width, 30)];
        detailLabel.text = detailTxt;
        detailLabel.font = [UIFont systemFontOfSize:16];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        detailLabel.textColor =  [CommonUtils colorFromHexString:kLikeBlackColor];
        [self addSubview:detailLabel];

        self.ctrlBlock = block;
        //点击事件
        [self addTarget:self action:@selector(ctrlClick:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}



//点击
- (void)ctrlClick:(UIControl *)control{
    if (self.ctrlBlock) {
        self.ctrlBlock(control);
    }
}



-(UIImage *)getImgFromWithImg:(UIImage *)img withWidth:(CGFloat)width withHeight:(CGFloat)height{
    NSLog(@"%f",width);
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [img  drawInRect:CGRectMake(0, 0, width, height)];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}




@end
