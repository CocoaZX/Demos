//
//  MokaActivityDetailHeadView.h
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

#import "MokaActivityDetailViewController.h"

@interface MokaActivityDetailHeadView : UIView<SGFocusImageFrameDelegate>

//第一行:发布人的信息
@property (nonatomic,strong)UIView *publisherInfoView;
@property (nonatomic,strong)UILabel *faqiLabel;
@property (nonatomic,strong)UIButton *publisherHeaderBtn;
@property (nonatomic,strong)UILabel *publisherNameLabel;
@property (nonatomic,strong)UIControl *contactView;
@property (nonatomic,strong)UIImageView *contactImgView;
@property (nonatomic,strong)UILabel *contactTxtLabel;
@property (nonatomic,strong)UILabel *lineLabelOne;

//第二行：活动信息
@property (nonatomic,strong)UILabel *activityInfoLabel;



//第三行：众筹信息
@property (nonatomic,strong)UIView *zhongChouView;
@property (nonatomic,strong)UIImageView *zhongchouImgView;
@property (nonatomic,strong)UILabel *zhongChouTxtLabel;
@property (nonatomic,strong)UILabel *zhongChouFeeLabel;

//第四行:活动简介
@property (nonatomic,strong)UILabel *activityDeatialLabel;

//第五行：扩展信息
@property (nonatomic,strong)UIView *extendInfoView;
@property (nonatomic,strong)UILabel *timeLabel;
@property (nonatomic,strong)UILabel *addressLabel;

/*
//第五行：活动图片展示
//@property (nonatomic,strong)UIView *showImageView;
 */


//布局相关============
//数据源
@property (nonatomic,strong)NSDictionary *dataDic;
//视图左边距
@property (nonatomic,assign)CGFloat leftPadding;
//活动类型:1通告， 2众筹 3海报
@property (nonatomic,assign)NSInteger typeNum;



@property (nonatomic,assign)CGFloat headHeight;
//导航控制器
@property (nonatomic,weak) MokaActivityDetailViewController *superVC;



@end
