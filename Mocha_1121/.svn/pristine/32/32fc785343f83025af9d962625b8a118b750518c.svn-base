//
//  GuideView.m
//  Mocha
//
//  Created by zhoushuai on 16/6/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "GuideView.h"

@implementation GuideView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
    }
    return self;
}

//初始化视图组件
- (void)_initViews{
    _tapTimesCount = 0;
    
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backView];
    
    //增加消失手势
    UIGestureRecognizer *hiddenGuideViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenGuideViewTap:)];
    [self addGestureRecognizer:hiddenGuideViewTap];
}

- (void)showGuidViewWithConditionType:(MokaGuideViewType)mokaGuideViewType{
    
    
    //当前展示的引导视图名称
    self.currentGuideType = mokaGuideViewType;
    
    switch (mokaGuideViewType) {
        case MokaGuideViewPeronPage://身价,工作室
        {
            [self showMokaGuideViewPeronPage];
            break;
        }
        case MokaGuideViewWeiXinPay://微信支付
        {
            [self showMokaGuideViewWeiXinPay];
            break;
        }
        case MokaGuideViewFindActivity://广场发现活动
        {
            [self showMokaGuideViewFindActivity];
            break;
        }
        case MokaGuideViewPhotographer://首页摄影师界面
        {
            [self showMokaGuideViewPhotographer];
            break;
        }
        case MokaGuideViewPersionPageYuePai://约拍
        {
            [self showMokaGuideViewPersionPageYuePai];
            break;
        }


        default:
            break;
    }
}


#pragma mark - 显示引导图
//身价、工作室
- (void)showMokaGuideViewPeronPage{
    //身价
    self.firstImgView.image = [UIImage imageNamed:@"guideView_personValue"];
    CGFloat imgW = kDeviceWidth/2;
    CGFloat imgH = 328.f/860.f *imgW;
    self.firstImgView.frame = CGRectMake(kDeviceWidth/4, 64,imgW, imgH);
    [self addSubview:self.firstImgView];
    [self addToWindow];
    [self.firstImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_personValue"];
}

//微信支付
- (void)showMokaGuideViewWeiXinPay{
    self.firstImgView.image = [UIImage imageNamed:@"guideView_weixinPay"];
    CGFloat imgW = kDeviceWidth/2;
    CGFloat imgH = 507.f/727.f * imgW;
    CGFloat top = 390;
    self.firstImgView.frame = CGRectMake(kDeviceWidth/4, top,imgW, imgH);
    [self addSubview:self.firstImgView];
    [self addToWindow];
    [self.firstImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_weixinPay"];


}

//广场:发现活动
- (void)showMokaGuideViewFindActivity{
    self.firstImgView.image = [UIImage imageNamed:@"guideView_findActivity"];
    self.firstImgView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imgW = kDeviceWidth/2;
    CGFloat imgH = 444.f/557.f *imgW;
    self.firstImgView.frame = CGRectMake(kDeviceWidth/4, 64,imgW, imgH);
    [self addSubview:self.firstImgView];
    [self addToWindow];
    [self.firstImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_findActivity"];

}

//摄影师界面
- (void)showMokaGuideViewPhotographer{
    self.firstImgView.image = [UIImage imageNamed:@"guideView_photographer"];
    self.firstImgView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat imgW = kDeviceWidth/2;
    CGFloat imgH = 482.f/638.f *imgW;
    CGFloat leftPadding = 0;
    switch (self.photographerIndex) {
        case 0:{
            leftPadding = 0;
            break;
        }
        case 1:{
            leftPadding = kDeviceWidth/4;
            break;
        }
        case 2:{
            leftPadding = kDeviceWidth/2;
            break;
        }
        default:
            break;
    }
    self.firstImgView.frame = CGRectMake(leftPadding, 64,imgW, imgH);
    [self addSubview:self.firstImgView];
    [self addToWindow];
    [self.firstImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_photographer"];
}

//约拍
- (void)showMokaGuideViewPersionPageYuePai{
    self.firstImgView.image = [UIImage imageNamed:@"guideView_enterYuePai"];
    CGFloat imgW = kDeviceWidth/2;
    CGFloat imgH = 553.f/698.f *imgW;
    self.firstImgView.frame = CGRectMake(kDeviceWidth/3, kDeviceHeight -imgW, kDeviceWidth/2, imgH);
    [self addSubview:self.firstImgView];
    [self addToWindow];
    [self.firstImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_enterYuePai"];
}



- (void)addToWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
}


#pragma mark - 辅助方法
//在身价视图之后，显示工作室视图
- (void)showZhuanTiGuideView{
    //工作室
    self.secondImgView.image = [UIImage imageNamed:@"guideView_zhuanti"];
    CGFloat imgW = kDeviceWidth/2;
    CGFloat secondImgH = 480.f/595.f *imgW;
    self.secondImgView.frame = CGRectMake(kDeviceWidth/4, 64+190+10+50 -secondImgH, imgW, secondImgH);
    [self addSubview:self.secondImgView];
    [self.secondImgView.layer addAnimation:[self getCABasicAnimation] forKey:@"guideView_enterYuePai"];
}


-  (CABasicAnimation *)getCABasicAnimation{
    //执行动画
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration =0.5;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    return forwardAnimation;
}





#pragma mark - UIGestureRecognizer
- (void)hiddenGuideViewTap:(UIGestureRecognizer *)tap{
    
    switch (self.currentGuideType) {
        case MokaGuideViewPeronPage:
        {
            //个人主页：身价和工作室
            if (_tapTimesCount == 0) {
                //第一次点击隐藏，身价视图,然后显示工作室
                [self.firstImgView removeFromSuperview];
                [self showZhuanTiGuideView];
                _tapTimesCount ++;;
                return;
            }
            break;
        }
            
        default:
            break;
    }
    
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if (_firstImgView) {
            self.firstImgView.alpha = 0;
        }
        if (_secondImgView) {
            self.secondImgView.alpha = 0;
        }
        
        self.alpha = 0;
     } completion:^(BOOL finished) {
         [self removeFromSuperview];
         //保存显示记录到沙盒中，下次不再显示
         NSArray *guidViewNames = [GuideView getEnumGuideViewName];
         NSString *haveShowGuideViewKey = guidViewNames[self.currentGuideType];
         [USER_DEFAULT setBool:YES forKey:haveShowGuideViewKey];
    }];
    
}


#pragma mark - 类方法
//是否需要显示引导视图
+(BOOL)needShowGuidViewWithGuideViewType:(MokaGuideViewType)mokaGuideViewType{
    //在审核时，不显示引导视图，防止携带有支付信息
    BOOL isAppearGuide = [USER_DEFAULT boolForKey:ConfigShang];
    if (!isAppearGuide) {
        return NO;
    }

    //取出在沙盒中的引导视图的key，查看是否已经显示过引导视图
    NSArray *guidViewNames = [GuideView getEnumGuideViewName];
    NSString *haveShowGuideViewKey = guidViewNames[mokaGuideViewType];
    
    BOOL isHaveShowGuideView = [USER_DEFAULT boolForKey:haveShowGuideViewKey];
    if (isHaveShowGuideView) {
        //不需要展示引导图
        return NO;
    }else {
        return YES;
    }
}

+ (NSArray *)getEnumGuideViewName{
//    MokaGuideViewPeronPage = 0,//身价引导视图
//    MokaGuideViewWeiXinPay, //约拍界面的引导视图
//    MokaGuideViewFindActivity,//广场发现同城活动
//    MokaGuideViewPhotographer,//摄影师界面
//    MokaGuideViewPersionPageYuePai,约拍
    NSArray *enumGuideViewName= @[@"MokaGuideViewPeronPage",@"MokaGuideViewWeiXinPay",@"MokaGuideViewFindActivity",@"MokaGuideViewPhotographer",@"MokaGuideViewPersionPageYuePai"];
    return enumGuideViewName;
}


  



#pragma mark - set/get方法
- (UIView *)backView{
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        _backView.backgroundColor = self.backColor ? self.backColor :[UIColor blackColor];
        _backView.alpha = 0.7;
    }
    return _backView;
}


- (UIImageView *)firstImgView{
    if (_firstImgView == nil) {
        _firstImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _firstImgView.contentMode = UIViewContentModeScaleAspectFit;

    }
    return _firstImgView;
}


- (UIImageView *)secondImgView{
    if (_secondImgView == nil) {
        _secondImgView =[[UIImageView alloc] initWithFrame:CGRectZero];
        _secondImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _secondImgView;
}




@end
