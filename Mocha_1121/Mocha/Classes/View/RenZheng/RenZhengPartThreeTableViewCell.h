//
//  RenZhengPartThreeTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenZhengPartThreeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *addPhotoImage;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;


@property (weak, nonatomic) IBOutlet UIImageView *centerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightImgView;


@property(nonatomic,strong)UIImage *renZhengImage;


+ (RenZhengPartThreeTableViewCell *)getRenZhengPartThreeTableViewCell;




@end
