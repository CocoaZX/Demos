//
//  GuideView.h
//  Mocha
//
//  Created by zhoushuai on 16/6/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, MokaGuideViewType) {
    MokaGuideViewPeronPage = 0,//身价引导视图，工作室
    MokaGuideViewWeiXinPay, //微信支付引导视图
    MokaGuideViewFindActivity,//广场发现同城活动
    MokaGuideViewPhotographer,//摄影师界面
    MokaGuideViewPersionPageYuePai,//个人页约拍，进入别人的界面
    
};


@interface GuideView : UIView

//背景视图
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIColor *backColor;

//引导图片
@property(nonatomic,strong)UIImageView  *firstImgView;
@property(nonatomic,strong)UIImageView *secondImgView;

//当前显示的引导视图类型
@property(nonatomic,assign)MokaGuideViewType currentGuideType;



//特殊情况的处理
//1.首页摄影师界面：摄影师按钮位置变动,引导视图的位置也随之变动
@property(nonatomic,assign)NSInteger photographerIndex;
//2.在不同界面，同一个引导视图，但是位置可能不同：
@property(nonatomic,copy)NSString *pageType;
//3.有可能是连续点击，切换不同的引导视图，记录手势触发的次数
@property(nonatomic,assign)NSInteger tapTimesCount;




//显示导视图
- (void)showGuidViewWithConditionType:(MokaGuideViewType)mokaGuideViewType;

//判断是否需要引导视图
+(BOOL)needShowGuidViewWithGuideViewType:(MokaGuideViewType)mokaGuideViewType;

//获取引导视图类型名称
+ (NSArray *)getEnumGuideViewName;
@end
