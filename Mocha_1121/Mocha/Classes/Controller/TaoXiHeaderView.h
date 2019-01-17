//
//  TaoXiHeaderView.h
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaoXiViewController.h"
@interface TaoXiHeaderView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *firstImage;

@property (weak, nonatomic) IBOutlet UIImageView *secondImage;

@property (weak, nonatomic) IBOutlet UIImageView *thiredImage;

@property (weak, nonatomic) IBOutlet UIImageView *fourthImage;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLaft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thiredLaft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fourthLaft;

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bigWid;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoLaft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jingxiuLaft;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLaft;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (weak, nonatomic) IBOutlet UILabel *photosLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodPhotosLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic , assign)TaoXiViewController *supCon;

-(void)initWithDictionary:(NSDictionary *)dictionary;

+(TaoXiHeaderView *)getTaoXiHeaderView;
@end
