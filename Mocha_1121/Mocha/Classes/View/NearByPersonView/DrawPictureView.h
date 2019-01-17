//
//  DrawPictureView.h
//  Mocha
//
//  Created by zhoushuai on 15/12/14.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawPictureView : UIView

@property (nonatomic,strong)NSDictionary *imgDic;

@property (nonatomic,strong)NSOperationQueue *operationQueue;

@property (nonatomic,strong)UIImage *image;

- (id)initWithFrame:(CGRect)frame withImgDic:(NSDictionary *)imgDic;
@end
