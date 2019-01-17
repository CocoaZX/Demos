//
//  ActivityListViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityListViewCell : UICollectionViewCell

//===============视图组件
//背景图片
@property (nonatomic,strong)UIImageView *bgImgView;
//类型图片
@property (nonatomic,strong)UILabel *typeLabel;

//底部视图
@property (nonatomic,strong)UIView *bottomView;
//back背景
@property (nonatomic,strong)UIView *backView;

//时间
//@property (nonatomic,strong)UILabel *timeLabel;
//活动名称
@property (nonatomic,strong)UILabel *themeNameLabel;
//费用
@property (nonatomic,strong)UILabel *feeLabel;
//浏览量
@property (nonatomic,strong)UILabel *liuLanLabel;

//头像
@property (nonatomic,strong)UIImageView *headImgView;
//认证
@property (nonatomic,strong)UIImageView *renZhengImgView;

//说明
@property (nonatomic,strong)UILabel *descLabel;
//发起人名字
@property (nonatomic,strong)UILabel *nameLabel;



//数据相关==================
@property (nonatomic,strong)NSDictionary *dataDic;


@property (nonatomic,strong)UINavigationController *superNVC;

@end
