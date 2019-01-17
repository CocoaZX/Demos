//
//  NewCropViewController.h
//  Mocha
//
//  Created by sun on 15/9/9.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CropFinished <NSObject>

- (void)finishCropImage:(UIImage *)image;

@end

@interface NewCropViewController : UIViewController

@property (strong, nonatomic) UIImage *originImage;

@property (assign, nonatomic) int cardType;

@property (assign, nonatomic) id<CropFinished>delegate;

@property (copy, nonatomic) ChangeCropFinishBlock callBack;

- (void)setreturnBlock:(ChangeCropFinishBlock)block;

@end
