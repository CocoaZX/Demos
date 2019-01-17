//
//  McNearByPersonViewController.h
//  Mocha
//
//  Created by zhoushuai on 15/12/9.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "NearByPersonView.h"
#import "MDCSwipeToChooseDelegate.h"


static const CGFloat ChoosePersonButtonHorizontalPadding = 80.f;
static const CGFloat ChoosePersonButtonVerticalPadding = 20.f;



@interface McNearByPersonViewController : UIViewController<MDCSwipeToChooseDelegate>

//视图控制器
@property(nonatomic,strong)UINavigationController *superNVC;
//上次请求数据的标识，参数默认""，已经无用
@property (nonatomic,copy)NSString *lastIndex;
//每次请求的个数
@property (nonatomic,copy)NSString *pageSize;



//数据源
@property (nonatomic, strong) NSMutableArray *peoples;


//显示加载视图
@property (nonatomic,strong)UIView *loadingView;
@property (nonatomic,strong)UIImageView *loadingImgView;
@property (nonatomic,strong)UILabel *loadingLabel;

//按钮
@property (nonatomic,strong)UIButton *cancelBtn;
@property (nonatomic,strong)UIButton *daShangBtn;
@property (nonatomic,strong)UIButton *dianzanBtn;



//引入第三方需要的属性
@property (nonatomic, strong) NSDictionary *currentPersonData;
//上
@property (nonatomic, strong)  NearByPersonView *frontCardView;
//中
@property (nonatomic, strong) NearByPersonView *centerCardView;
//下
@property (nonatomic,strong) NearByPersonView *backCardView;
//最底层
@property (nonatomic,strong)NearByPersonView *bottomCardView;


//用于检测网络的定时器
@property (nonatomic,strong)NSTimer *netTimer;
//用于显示加载的定时器
@property (nonatomic,strong)NSTimer *loadTimer;



@property (nonatomic,strong)UIAlertView *alertView;

- (void)LoadNearbyPersonsDataWithIndex:(NSString *)lastIndex;

- (void)showLoadingView:(BOOL)show;

@end


