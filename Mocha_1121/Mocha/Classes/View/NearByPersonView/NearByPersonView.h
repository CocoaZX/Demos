//
//  NearByPersonView.h
//  Mocha
//
//  Created by zhoushuai on 15/12/9.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDCSwipeToChoose.h"


@interface NearByPersonView : MDCSwipeToChooseView

//所在视图控制器
@property (nonatomic,strong)UINavigationController *superNVC;
//数据源
@property (nonatomic,strong)NSDictionary *personData;


//用于显示大图的imgVie的高度
@property (nonatomic,assign)CGFloat imgViewHeight;


//展示信息的底部视图
@property (nonatomic, strong) UIView *informationView;
//用户名
@property (nonatomic,strong)UILabel *nameLabel;
//用户身份
@property (nonatomic,strong)UILabel *statusLabel;


//地图图标
@property (nonatomic,strong)UIImageView *mapIconImgView;

//距离
@property (nonatomic,strong)UILabel *distanceLabel;

//赞的图标
@property (nonatomic,strong)UIImageView *likeIconImgView;

//赞的数量
@property (nonatomic,strong)UILabel *likeCountLable;




//设置是否可以点击
//@property (nonatomic,assign)BOOL isFirstView;

//自定义初始化方法
- (instancetype)initWithFrame:(CGRect)frame
                       person:(NSDictionary *)personDic
                      options:(MDCSwipeToChooseViewOptions *)options;
@end
