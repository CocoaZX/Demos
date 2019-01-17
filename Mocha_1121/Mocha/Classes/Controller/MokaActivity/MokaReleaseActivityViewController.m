//
//  MokaReleaseActivityViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/1/30.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaReleaseActivityViewController.h"

#import "MokaCreateActivityViewController.h"
#import "McCallBackViewController.h"

#import "CreateActivityView.h"


@interface MokaReleaseActivityViewController ()

//单个视图的宽度
@property (nonatomic,assign)CGFloat viewWidth;
//单个视图的高度
@property (nonatomic,assign)CGFloat viewHeight;
//左间距
@property (nonatomic,assign)CGFloat leftPadding;
//上间距
@property (nonatomic,assign)CGFloat topPadding;
//底部详情说明距离其上视图的间距
@property (nonatomic,assign)CGFloat bottomPadding;

//是否显示众筹
@property(nonatomic,assign)BOOL showZhongChou;

@end

@implementation MokaReleaseActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布活动";
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    
    _leftPadding = 20;
    _viewWidth = (kDeviceWidth -20*2);
    _viewHeight= 100;
    _topPadding = 50;
    _bottomPadding = 50;
    
    //判别是否显示众筹
    _showZhongChou = [USER_DEFAULT boolForKey:ConfigShang];


    //创建视图
    [self  _initViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //标签栏不显示
    [self.customTabBarController hidesTabBar:YES animated:YES];
}

- (void)_initViews{
    //滑动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScrollView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.view addSubview:_mainScrollView];
    
    
    //======================招募通告
    NSString *zhaoMuTitle = @"招募通告";
    NSString *zhaoMuDetailTxt = @"海量模特摄影师，发布通告更有效";
    __weak typeof(self) vc = self ;
    CreateActivityView *zhaoMuCtrlView = [[CreateActivityView alloc] initWithFrame:CGRectMake(_leftPadding, _topPadding, _viewWidth, _viewHeight) title:zhaoMuTitle DetailTxt:zhaoMuDetailTxt bgImage:@"tongGao" withBlock:^(UIControl *control) {
        //NSLog(zhaoMuDetailTxt);
        MokaCreateActivityViewController *createActivityVC = [[MokaCreateActivityViewController alloc] init];
        createActivityVC.TypeNum = 1;
        [vc.superNVC pushViewController:createActivityVC animated:YES];
    }];
    [self.mainScrollView addSubview:zhaoMuCtrlView];
    
    
    //=======================众筹活动
    NSString *zhongChouTitle = @"众筹活动";
    NSString *zhongChouDetailTxt = @"更好玩的众筹，更方便的组织";
    CreateActivityView *zhongChouCtrlView = [[CreateActivityView alloc] initWithFrame:CGRectMake(_leftPadding, zhaoMuCtrlView.bottom + _topPadding, _viewWidth, _viewHeight) title:zhongChouTitle DetailTxt:zhongChouDetailTxt bgImage:@"zhongChouPic" withBlock:^(UIControl *control) {
        //NSLog(zhongChouDetailTxt);
        MokaCreateActivityViewController *createActivityVC = [[MokaCreateActivityViewController alloc] init];
        createActivityVC.TypeNum = 2;
        [vc.superNVC pushViewController:createActivityVC animated:YES];
    }];
    [self.mainScrollView addSubview:zhongChouCtrlView];
    
    

    //======================活动海报
    NSString *posterTitle = @"活动海报";
    NSString *posterDetailTxt = @"张贴活动海报，新型宣传方式更给力";
    CreateActivityView *posterCtrlView = [[CreateActivityView alloc] initWithFrame:CGRectMake(_leftPadding,zhongChouCtrlView.bottom + _topPadding, _viewWidth, _viewHeight) title:posterTitle DetailTxt:posterDetailTxt bgImage:@"zhongChouPic" withBlock:^(UIControl *control) {
        //NSLog(zhongChouDetailTxt);
        MokaCreateActivityViewController *createActivityVC = [[MokaCreateActivityViewController alloc] init];
        createActivityVC.TypeNum = 3;
        [vc.superNVC pushViewController:createActivityVC animated:YES];
    }];
    [self.mainScrollView addSubview:posterCtrlView];


    //如果不显示众筹的时候，隐藏众筹的视图，调整海报视图的顶部位置
    if (!_showZhongChou) {
        zhongChouCtrlView.hidden = YES;
        posterCtrlView.top = zhaoMuCtrlView.bottom + _topPadding;
    }
    
    //======================底部提示和按钮
    NSString *frontLabelTxt = @"没有适合的活动类型?";
    CGFloat frontLabelTxtWidth  = [SQCStringUtils getCustomWidthWithText:frontLabelTxt viewHeight:20 textSize:15];
    
    NSString *feedBackBtnTitle = @"点击反馈给我们";
    CGFloat feedBackBtnTxtWidth  = [SQCStringUtils getCustomWidthWithText:feedBackBtnTitle   viewHeight:20 textSize:15];
    
    
    UILabel *frontLabel = [[UILabel alloc] initWithFrame: CGRectMake((kDeviceWidth -frontLabelTxtWidth -feedBackBtnTxtWidth)/2,posterCtrlView.bottom+_bottomPadding ,frontLabelTxtWidth,20)];
    frontLabel.text = frontLabelTxt;
    frontLabel.font = [UIFont systemFontOfSize:15];
    frontLabel.textAlignment = NSTextAlignmentRight;
    frontLabel.textColor = [UIColor blackColor];
    [self.mainScrollView addSubview:frontLabel];
    
    //按钮
    UIButton *feedBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(frontLabel.right,posterCtrlView.bottom +_bottomPadding,feedBackBtnTxtWidth,20)];
    [feedBackBtn setTitle:feedBackBtnTitle forState:UIControlStateNormal];
    feedBackBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [feedBackBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
    [feedBackBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [feedBackBtn addTarget:self action:@selector(feedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //下划线
    UILabel *linkLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(frontLabel.right, feedBackBtn.bottom+1, feedBackBtn.width, 1)];
    linkLineLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    [self.mainScrollView addSubview:linkLineLabel];
    [self.mainScrollView addSubview:feedBackBtn];
    
    
    //确定滑动视图的内容尺寸
    CGFloat totalHeight = linkLineLabel.bottom +64;
    if (totalHeight >self.view.height) {
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth,totalHeight +10);
    }else{
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth, self.view.height);
    }
}



#pragma mark 响应事件
//反馈信息
- (void)feedBtnClick:(UIButton *)btn{
    //意见反馈
    McCallBackViewController *setVC = [[McCallBackViewController alloc] init];
    [self.navigationController pushViewController:setVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
}
@end
