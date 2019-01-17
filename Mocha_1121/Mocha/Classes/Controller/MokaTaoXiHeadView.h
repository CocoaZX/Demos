//
//  MokaTaoXiHeadView.h
//  Mocha
//
//  Created by zhoushuai on 16/3/31.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MokaTaoXiHeadView : UIView
//====视图
//大图
@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;
//类型
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

//专题name
@property (weak, nonatomic) IBOutlet UILabel *themeNameLabel;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodPhotoNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *firstImg;
@property (weak, nonatomic) IBOutlet UIImageView *secondImg;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImg;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImg;
@property (weak, nonatomic) IBOutlet UIView *seprateLine;



//=====约束
//大图高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigImgView_height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *themeLabel_width;


//所在视图控制器
@property (weak, nonatomic) UIViewController *supVC;
//数据
@property(nonatomic,strong)NSDictionary *dict;



+ (MokaTaoXiHeadView *)getMokaTaoXiHeaderView;

-(void)initWithDictionary:(NSDictionary *)dictionary;


@end
