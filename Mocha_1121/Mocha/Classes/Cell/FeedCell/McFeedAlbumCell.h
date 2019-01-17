//
//  McFeedAlbumCell.h
//  Mocha
//
//  Created by zhoushuai on 16/5/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McFeedTableViewCell.h"

@interface McFeedAlbumCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *jiaVImgView;

@property (weak, nonatomic) IBOutlet UIImageView *huangGuanImgView;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;




@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *upView;

@property (weak, nonatomic) IBOutlet UIImageView *contentImgView;


@property (weak, nonatomic) IBOutlet UIImageView *privacyMarkImgView;

@property (weak, nonatomic) IBOutlet UIView *infoView;


//@property (weak, nonatomic) IBOutlet UIView *albumNameBlackBgView;
@property (weak, nonatomic) IBOutlet UILabel *albumNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *albumTypeLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//付费说明
@property (weak, nonatomic) IBOutlet UILabel *feeDescLabel;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentImg_height;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *privacyMarkImgView_top;



@property(nonatomic,strong)NSDictionary *dataDic;


//代理方法
@property (nonatomic, assign) id<McFeedTableViewCellDelegate> cellDelegate;


+ (McFeedAlbumCell *)getMcFeedAlbumCell;


+ (CGFloat)getMcFeedAlbumCellHeight;


@end
