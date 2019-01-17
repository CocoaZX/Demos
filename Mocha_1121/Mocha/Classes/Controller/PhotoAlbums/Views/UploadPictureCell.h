//
//  UploadPictureCell.h
//  Mocha
//
//  Created by zhoushuai on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadPictureCell : UICollectionViewCell


//图片
@property (weak, nonatomic) IBOutlet UIImageView *imgView;

//进度图
@property (weak, nonatomic) IBOutlet UIView *progressView;
//显示进度值
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;




//进度图的距离顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressView_top;
//进度值
@property(nonatomic,assign)CGFloat progressValue;


@property(nonatomic,copy)NSString *cellType;
//图片
@property(nonatomic,strong)UIImage *image;
//图片链接
@property(nonatomic,copy)NSString *imgUrlStr;


@end
