//
//  McFeedPrivacyAlbumCell.h
//  Mocha
//
//  Created by zhoushuai on 16/6/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McFeedTableViewCell.h"

@interface McFeedPrivacyAlbumCell : UITableViewCell

//视图================
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
//认证视图
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImgView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//身份
@property (weak, nonatomic) IBOutlet UILabel *personTypeLabel;

//会员
@property (weak, nonatomic) IBOutlet UIImageView *memberImgView;

//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

//大图
@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;
//是否私密模糊标识
@property (weak, nonatomic) IBOutlet UIImageView *privacyMarkImgView;


@property (weak, nonatomic) IBOutlet UIView *bottomView;


//图片张数
@property (weak, nonatomic) IBOutlet UILabel *albumPhotoCountLabel;
//相册名称
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;
//相册类型
@property (weak, nonatomic) IBOutlet UILabel *albumTypeLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//相册说明，付费查看
@property (weak, nonatomic) IBOutlet UILabel *albumInfoLabel;

//约束==================
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyMarkImgView_top;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImgView_height;


//数据源===============
@property(nonatomic,strong)NSDictionary *dataDic;


//比例
@property(nonatomic,assign)CGFloat photoSizeScale;

//代理==================
@property (nonatomic, assign) id<McFeedTableViewCellDelegate> cellDelegate;


+ (McFeedPrivacyAlbumCell *)getMcFeedPrivacyAlbumCell;


+ (CGFloat)getMcFeedPrivacyAlbumCelllHeight;

@end
