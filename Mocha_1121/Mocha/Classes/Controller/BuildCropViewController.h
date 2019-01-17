//
//  BuildCropViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/11/11.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KICropImageView.h"

//代理:当图片处理完毕之后，会将图片替换掉
@protocol changeMokaPictureDelegate<NSObject>

- (void)finishCropImage:(UIImage *)image;


@end



@interface BuildCropViewController : UIViewController
{
    KICropImageView *_cropImageView;
    UIImage *_originImage;
}

@property (nonatomic , copy) NSString *phoneModel;
@property (assign, nonatomic) int cardType;
@property (nonatomic,strong) UIImage *originImage;

@property (nonatomic,assign)id<changeMokaPictureDelegate> delegate;


@property (nonatomic,strong)NSData *imgData;


- (id)initWithImageData:(NSData *)data;

@end
