//
//  McFeedZhuanTiCell.h
//  Mocha
//
//  Created by TanJian on 16/5/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McFeedTableViewCell.h"

@interface McFeedZhuanTiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *seprateline;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UIButton *headerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberImg;
@property (weak, nonatomic) IBOutlet UILabel *adressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *contentImg;
@property (weak, nonatomic) IBOutlet UIButton *zhuantiType;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bgVeiw;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgH;

+ (McFeedZhuanTiCell *)getFeedZhuanTiCell;

+(float)getHeightWithDict:(NSDictionary *)dict;
-(void)initWithDict:(NSDictionary *)dict;


//代理方法
@property (nonatomic, assign) id<McFeedTableViewCellDelegate> cellDelegate;

@end
