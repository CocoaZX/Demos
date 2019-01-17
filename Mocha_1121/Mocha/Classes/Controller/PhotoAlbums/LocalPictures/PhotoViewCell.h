//
//  PhotoViewCell.h
//  ZSTest
//
//  Created by zhoushuai on 16/3/29.
//  Copyright © 2016年 zhoushuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewCell : UICollectionViewCell

//需要显示的图片
@property(nonatomic,strong)UIImageView *imgView;

//显示被选中
@property(nonatomic,strong)UIImageView *selectedImgView;

@property(nonatomic,strong)UIImage *image;
//属性字典
@property(nonatomic,copy)NSString *imgUrlString;


//使用情况分类
@property(nonatomic,copy)NSString *useConditionType;

@end
