//
//  PhotoBrowseViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PhotoBrowseViewController.h"
#import "KTPhotoView.h"
#import "ActionViewController.h"
#import "CommentView.h"
#import "PhotoViewDetailController.h"
#import "ReadPlistFile.h"
#import "McReportViewController.h"
#import "ShangAlertView.h"
#import "McFooterView.h"
#import "DaShangViewController.h"
#import "JSONKit.h"
#import "DaShangView.h"
#import "DaShangGoodsView.h"
#import "jinBiViewController.h"

//图片模糊
#import "UIImage+FEBoxBlur.h"

typedef enum {
    Moka,
    TimeLine,
    Collection,
    Feed,
    NewDaTu,
    NewDaTuArray,
    YingJi
}CurrentRequestType;

@interface PhotoBrowseViewController ()<ActionDelegate,UIActionSheetDelegate,McFooterViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSInteger currentIndex_;
    NSInteger photoCount_;
    NSMutableArray *photoViews_;
    
    BOOL isRefresh;
}


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *contentTitle;

@property (strong, nonatomic) NSMutableArray *contentTagsArray;

@property (strong, nonatomic) ActionViewController *actionView;

@property (strong, nonatomic) CommentView *commentView;

@property (assign, nonatomic) BOOL isSelf;

@property (strong, nonatomic) NSMutableArray *photoArrays;

@property (strong, nonatomic) NSMutableArray *photoArrays_id;

@property (strong, nonatomic) UIActionSheet *moreSheet;

@property (strong, nonatomic) UIActionSheet *shareSheet;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (assign, nonatomic) BOOL currentHiddenType;

@property (nonatomic, assign) BOOL isRequesting;

@property (assign, nonatomic) CurrentRequestType currentType;

@property (nonatomic ,copy) NSString *photoUid;

@property (nonatomic ,copy) NSString *currentPhotoId;


@property (nonatomic, retain) McFooterView *footerView;

//@property (strong, nonatomic) DaShangView *shangView;//打赏现金红包
@property (nonatomic,strong) DaShangGoodsView *shangView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *liulanNumberLabel;

@property (weak, nonatomic) IBOutlet UILabel *dashangDescription;

@property (copy , nonatomic) NSString *commentStr;

@property (nonatomic,copy) NSString *vgoodsNumber;

//显示打赏提示的window
@property (nonatomic,strong)UIWindow *daShangAlertWindow;
@property(nonatomic,strong)UIWindow *privacyGuideWindow;

@end

@implementation PhotoBrowseViewController

#pragma mark - 界面设置

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    //[self initLocalData];
    //添加通知
    [self addNotifications];
    
    //添加底部的按钮赞，浏览量，打赏
    [self loadFooterView];
    
    //添加打赏的view
//  [self addShangViewToThisView];
    
    //添加打赏虚拟物品的view
    [self addShangGoodsViewToThisView];
    
    [self getUserName];

    //是否刚开进入界面就显示打赏的视图
    if (_firstShowDaShang) {
        [self footerView:nil didSelectIndex:2];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
   
}


//判断是否判断打赏引导
- (void)judgeShowDashangGuideView{
    //对于打赏图片的提示:
    //1.服务器配置中允许出现打赏
    //2.第一次进入图片浏览
    //3.非本人的图片浏览
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (!([self.currentUid isEqualToString:uid])) {
            //对方的界面
            //如果没有显示过，就给出一个提示
            BOOL notFirstShowDaShangAlert = [USER_DEFAULT boolForKey:@"notFirstShowDaShangAlert"];
            if (!notFirstShowDaShangAlert) {
                [self showDashangWindow];
            }
        }
    }
    //[self showDashangWindow];

}





//viewDidLoad时初始化视图
- (void)initViews
{
    [self.view setFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    self.tagsLabel.textColor = [UIColor colorWithRed:239/255.0 green:59/255.0 blue:77/255.0 alpha:1.0];

    [self.photoScrollView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    self.photoScrollView.delegate = self;
    [self.photoScrollView setBackgroundColor:[UIColor clearColor]];
    [self.photoScrollView setAutoresizesSubviews:YES];
    [self.photoScrollView setPagingEnabled:YES];
    [self.photoScrollView setShowsVerticalScrollIndicator:NO];
    [self.photoScrollView setShowsHorizontalScrollIndicator:NO];
    
    
    self.actionView = [[ActionViewController alloc] initWithNibName:@"ActionViewController" bundle:[NSBundle mainBundle]];
    self.actionView.delegate = self;
    [self.view addSubview:self.actionView.view];
    self.actionView.view.hidden = YES;
    
    //评论视图
    self.commentView = [[CommentView alloc] initWithNibName:@"CommentView" bundle:[NSBundle mainBundle]];
    self.commentView.view.frame = CGRectMake(0, 1000, kScreenWidth, kScreenHeight);
    self.commentView.view.hidden = NO;
    [self.view addSubview:self.commentView.view];
    
    self.shareSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"朋友圈", @"微信好友", nil];
    

}



//添加 footerView
- (void)loadFooterView
{
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {
        if (self.currentType==YingJi) {
            NSDictionary *favorDict = @{@"Default":[UIImage imageNamed:@"zannew"],@"Highlighted":[UIImage imageNamed:@"zannew2"],@"Seleted":[UIImage imageNamed:@"zannew2"]};
            NSDictionary *saveDict = @{@"Default":[UIImage imageNamed:@"dashang"],@"Highlighted":[UIImage imageNamed:@"dashang"],@"Seleted":[UIImage imageNamed:@"dashang"]};
            NSDictionary *commitDict = @{@"Default":[UIImage imageNamed:@"liuyan"],@"Highlighted":[UIImage imageNamed:@"liuyan"],@"Seleted":[UIImage imageNamed:@"liuyan"]};
            NSArray *images = @[favorDict,commitDict,saveDict];
            NSArray *titles = @[@" 赞",@" 评论",@" 礼物"];
            
            McFooterView *footer = [[McFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) buttonTitles:titles buttonImages:images];
            self.footerView = footer;
            _footerView.delegate = self;
            //默认隐藏
            _footerView.hidden = NO;
            [_footerView setBackgroundImage:nil color:[UIColor clearColor]];
            [_bottomView addSubview:_footerView];
        }else
        {
            NSDictionary *favorDict = @{@"Default":[UIImage imageNamed:@"zannew"],@"Highlighted":[UIImage imageNamed:@"zannew2"],@"Seleted":[UIImage imageNamed:@"zannew2"]};
            NSDictionary *saveDict = @{@"Default":[UIImage imageNamed:@"dashang"],@"Highlighted":[UIImage imageNamed:@"dashang"],@"Seleted":[UIImage imageNamed:@"dashang"]};
            NSDictionary *commitDict = @{@"Default":[UIImage imageNamed:@"liuyan"],@"Highlighted":[UIImage imageNamed:@"liuyan"],@"Seleted":[UIImage imageNamed:@"liuyan"]};
            NSArray *images = @[favorDict,commitDict,saveDict];
            NSArray *titles = @[@" 赞",@" 评论",@" 礼物"];
            
            McFooterView *footer = [[McFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) buttonTitles:titles buttonImages:images];
            self.footerView = footer;
            _footerView.delegate = self;
            _footerView.hidden = NO;
            [_footerView setBackgroundImage:nil color:[UIColor clearColor]];
            [_bottomView addSubview:_footerView];
            [_footerView setStatus:YES atIndex:2];
            
        }
        
    }else
    {
        NSDictionary *favorDict = @{@"Default":[UIImage imageNamed:@"zannew"],@"Highlighted":[UIImage imageNamed:@"zannew2"],@"Seleted":[UIImage imageNamed:@"zannew2"]};
        NSDictionary *saveDict = @{@"Default":[UIImage imageNamed:@"clearImage"],@"Highlighted":[UIImage imageNamed:@"clearImage"],@"Seleted":[UIImage imageNamed:@"clearImage"]};
        NSDictionary *commitDict = @{@"Default":[UIImage imageNamed:@"liuyan"],@"Highlighted":[UIImage imageNamed:@"liuyan"],@"Seleted":[UIImage imageNamed:@"liuyan"]};
        NSArray *images = @[favorDict,commitDict,saveDict];
        NSArray *titles = @[@" 赞",@" 评论",@"   "];
        
        McFooterView *footer = [[McFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50) buttonTitles:titles buttonImages:images];
        self.footerView = footer;
        _footerView.delegate = self;
        _footerView.hidden = NO;
        [_footerView setBackgroundImage:nil color:[UIColor clearColor]];
        [_bottomView addSubview:_footerView];
    }
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
    //头部视图
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, self.topView.frame.size.height);
    self.titleLabel.center = CGPointMake(kScreenWidth/2, 30);
    self.backBtn.frame = CGRectMake(-21, 2, 88, 65);
    self.moreButton.frame = CGRectMake(kScreenWidth-80, -2, 88, 65);
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x, self.contentView.frame.origin.y, kScreenWidth,50);
    
    if (IOS7) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
    
    if (kScreenWidth==320) {
        self.iconImageView.frame = CGRectMake(20, 24, 18, 18);
        self.liulanNumberLabel.frame = CGRectMake(45, 23, 104, 21);
    }else if(kScreenWidth==375)
    {
        self.iconImageView.frame = CGRectMake(24, 24, 18, 18);
        self.liulanNumberLabel.frame = CGRectMake(49, 23, 104, 21);
        
    }else
    {
        
    }
    
    //是否显示第三方登陆
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        self.moreButton.hidden = NO;
    }else
    {
        self.moreButton.hidden = YES;
    }
    
    //是否显示打赏
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (!isAppearShang) {
        self.dashangDescription.hidden = YES;
    }
    
    //返回和更多按钮
    [self.view bringSubviewToFront:self.backBtn];
    [self.view bringSubviewToFront:self.moreButton];
    
    //此处逻辑顺序要注意
    //只有客人从相册里进入本界面，传入了相册设置字典，才会判断是否模糊
    if (self.albumSettingDic) {
        [self resetPrivacy];
        //是否需要模糊处理
        if(self.needBlurry){
            //需要模糊处理，此时如果显示了打赏引导，用户也看不到
            //而且用户再次进入也不会显示打赏引导
            //所以此情况下，不做是否显示打赏引导的判断处理
            [self showPrivacyGuideWindow];
        }else{
            //没有设置模糊，按照正常情况判断是否显示打赏引导
            [self judgeShowDashangGuideView];
        }
    }else{
        //没有模糊判断，按照正常情况判断是否显示打赏
        [self judgeShowDashangGuideView];
    }
}



//添加通知
- (void)addNotifications{
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissCommentView) name:@"DismissCommentView" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissActionView) name:@"dismissActionView" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateInfoDict:) name:@"updateInfoDict" object:nil];
    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDaShangView) name:@"refreshDaShangView" object:nil];

    //
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertSuccess) name:@"SharedSuccess" object:nil];

    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    //移除通知
    
}



#pragma mark - 支付金币查看私密相册的引导图
- (void)showPrivacyGuideWindow{
    if (_privacyGuideWindow  == nil) {
        //window承载所有控件
        _privacyGuideWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
        _privacyGuideWindow.hidden  = NO;
        _privacyGuideWindow.backgroundColor = [UIColor clearColor];
        
        //背景视图
        UIView *bgView = [[UIView alloc] initWithFrame:_privacyGuideWindow.bounds];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.5;
        [_privacyGuideWindow addSubview:bgView];
        
        
        //点击返回
        UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 60, 30)];
        [backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        backBtn.backgroundColor = [UIColor clearColor];
        [backBtn addTarget:self action:@selector(backForPriVacyGuidWindow) forControlEvents:UIControlEventTouchUpInside];
        [_privacyGuideWindow addSubview:backBtn];
        
        //白色视图
        UIView *whitekView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth -30 *2,200)];
        whitekView.backgroundColor = [UIColor whiteColor];
        whitekView.alpha = 1;
        whitekView.layer.cornerRadius = 5;
        whitekView.layer.masksToBounds = YES;
       [_privacyGuideWindow addSubview:whitekView];
        
        //title
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, whitekView.width, 70)];
        titleLabel.text = @"这是一套私密相册，送礼后可以";
        titleLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [whitekView addSubview:titleLabel];
        //条目
        NSArray *infoArr = @[@"查看相册所有的大图",@"下载图片原图到相册",@"拥有图片使用权"];
        
        for (int i = 0 ; i < infoArr.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.height +30 *i, whitekView.width, 30)];
            label.textColor = [UIColor blackColor];
            label.text = infoArr[i];
            label.textAlignment  = NSTextAlignmentCenter;
            [whitekView addSubview:label];
        }
        
        //按钮
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(30, titleLabel.bottom +30 *infoArr.count +20, whitekView.width - 30*2, 50)];
        
        NSDictionary *openDic = self.albumSettingDic [@"open"];
        NSString *goldCoin = openDic[@"visit_coin"];

        [btn setTitle:[NSString stringWithFormat:@"支付%@金币开启相册",goldCoin] forState:UIControlStateNormal];
        btn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(requestDaShangForAlbum) forControlEvents:UIControlEventTouchUpInside];
        [whitekView addSubview:btn];
        
        CGFloat viewHeight = btn.bottom +20;
        whitekView.frame = CGRectMake(30, (kDeviceHeight -viewHeight)/2, kDeviceWidth - 30*2, viewHeight);
        //手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backForPriVacyGuidWindow)];
        [_privacyGuideWindow addGestureRecognizer: singleTap];
    }
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _privacyGuideWindow.alpha = 1;
    } completion:^(BOOL finished) {
        //
    }];
}

//用户没有打赏相册，点击屏幕直接返回
- (void)backForPriVacyGuidWindow{
    _privacyGuideWindow.alpha = 0;
    _privacyGuideWindow = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

//关闭打赏提示视图
//情况：
- (void)hiddenPrivacyGuideWindow:(UIGestureRecognizer *)tap{
     _privacyGuideWindow.alpha = 0;
    _privacyGuideWindow = nil;

    /*
    UIView *whiteView = [_privacyGuideWindow viewWithTag:333];
     [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
         whiteView.alpha = 0;
        _privacyGuideWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _privacyGuideWindow = nil;
        [self.navigationController popViewControllerAnimated:YES];
      }];
     */
}




//进入打赏金币的界面
- (void)requestDaShangForAlbum{
    if ([self isFailForCheckLogInStatus]) {
        [self hiddenPrivacyGuideWindow:nil];
        return;
    }
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //对方uid
    [mDic setObject:self.albumID forKey:@"object_id"];
    //类型
    [mDic setObject:@"16" forKey:@"object_type"];
    //支付的金额
    NSString *goldCoin = _albumSettingDic[@"open"][@"visit_coin"];
    goldCoin = goldCoin;
    NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":goldCoin};
    NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
    [mDic setObject:pay_info forKey:@"pay_info"];
    NSDictionary *params = [AFParamFormat formatTempleteParams:mDic];
    
    [AFNetwork postRequeatDataParams:params path:PathUserReward success:^(id data) {
        NSLog(@"data:%@",data);
        NSString *msg = data[@"msg"];
        NSString *status = data[@"status"];
        NSInteger statusNum = [status integerValue];
        //statusNum = 2;
        //[self hiddenPrivacyGuideWindow:nil];
        switch (statusNum) {
            case 0:
            {   //可以查看发送一条打赏消息
                self.albumSettingDic = data[@"data"];
                //首先获取messageEnable
                [self resetPrivacy];
                //关闭打赏视图
                [self hiddenPrivacyGuideWindow:nil];
                [LeafNotification showInController:self withText:@"打赏成功"];
                //获取当前图片，更新图片状态，不再显示模糊
                CGFloat pageWidth = self.photoScrollView.frame.size.width;
                float fractionalPage = self.photoScrollView.contentOffset.x / pageWidth;
                NSInteger page = floor(fractionalPage);
                if (page != currentIndex_) {
                    [self setCurrentIndex:page];
                }
                [self setCurrentIndex:page];
                break;
            }
            case 2:
            {   //金币不够
                [self hiddenPrivacyGuideWindow:nil];
                //提示是否购买
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"金币打赏" message:@"您的账户金币不足,快去充值吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                [alertView show];
                break;
            }
            case 1:
            {
                //其他原因不能查看
                [LeafNotification showInController:self withText:msg];
                break;
            }
            default:
                break;
        }
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [self hiddenPrivacyGuideWindow:nil];
    }];
}

#pragma mark - UIAlertDelegate(金币不够是否跳转兑换)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
    }else{
        //跳转到充值界面
        [self skipPageForBuyMemberCenter ];
    }
}

//金币不够，购买会员
- (void)skipPageForBuyMemberCenter{
    JinBiViewController *jinBiVC = [[JinBiViewController alloc] init];
    [self.navigationController pushViewController:jinBiVC animated:YES];
    
}

//使用更新后的相册信息设置当前用户对浏览照片的模糊设置
- (void)resetPrivacy{
    //相册所有人的id
    NSString *albumPersonId = getSafeString(self.albumDic[@"authorId"]);
    if ([getCurrentUid() isEqualToString:albumPersonId]) {
        _needBlurry = NO;
        return;
    }
    //获取私密性数据
    NSDictionary *openDic = self.albumSettingDic[@"open"];
    NSString *isPrivate = [openDic objectForKey:@"is_private"];
    if ([isPrivate isEqualToString:@"0"]) {
        _needBlurry = NO;
    }else{
        //有私密设置
        NSArray *is_forever_uids_list = openDic[@"is_forever_uids_list"];
        _needBlurry = YES;
        for (int i = 0; i<is_forever_uids_list.count;i++){
            NSString *tempStr = getSafeString(is_forever_uids_list[i]);
            if ([tempStr isEqualToString:getCurrentUid()]) {
                _needBlurry = NO;
                break;
            }
        }
    }
}



#pragma mark - 打赏图片引导视图
- (void)showDashangWindow{
    if (_daShangAlertWindow  == nil) {
        //window承载所有控件
        _daShangAlertWindow = [[UIWindow alloc] initWithFrame:self.view.bounds];
        _daShangAlertWindow.hidden  = NO;
        _daShangAlertWindow.backgroundColor = [UIColor clearColor];
        
        //遮盖视图：上部分和下部分
        UIView *topBackView = [[UIView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth,kDeviceHeight -50)];
        topBackView.backgroundColor = [UIColor blackColor];
        topBackView.alpha = 0.7;
        [_daShangAlertWindow addSubview:topBackView];
        UIView *bottomBackView = [[UIView alloc] initWithFrame:CGRectMake(0,topBackView.bottom,kDeviceWidth/3*2,50)];
        bottomBackView.backgroundColor = [UIColor blackColor];
        bottomBackView.alpha = 0.7;
        [_daShangAlertWindow addSubview:bottomBackView];
        
        
        //计算位置和大小
        //所有视图计算，距离两边30,红包图片和文字距离20
        CGFloat totalWidth = kDeviceWidth -30*2 -20 -30;
        //红包图片
        CGFloat hongbaoWidth = totalWidth *(113.f/(113.f+235.f));
        CGFloat hongbaoHeight= 162.f/113.f*hongbaoWidth;
        UIImageView *hongbaoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(30, kDeviceHeight/2, hongbaoWidth , hongbaoHeight)];
        hongbaoImgView.tag = 111;
        [_daShangAlertWindow addSubview:hongbaoImgView];
        hongbaoImgView.image = [UIImage imageNamed:@"hongbao"];
        hongbaoImgView.alpha = 0;
        [_daShangAlertWindow addSubview:hongbaoImgView];
        
        
        //红包提示文字图片
        CGFloat hongbaoTxtWidth = totalWidth *(235.f/(113.f+235.f));
        CGFloat hongbaoTxtHeight= 131.f/235.f*hongbaoTxtWidth;
        UIImageView *hongbaoTxtImgView = [[UIImageView alloc] initWithFrame:CGRectMake(hongbaoImgView.right +20,hongbaoImgView.top +((hongbaoImgView.height- hongbaoTxtHeight)/2), hongbaoTxtWidth,hongbaoTxtHeight)];
        hongbaoTxtImgView.tag = 222;
        hongbaoTxtImgView.image = [UIImage imageNamed:@"hongbaoDescripton"];
        hongbaoTxtImgView.alpha = 0;
        [_daShangAlertWindow addSubview:hongbaoTxtImgView];
        [UIView animateWithDuration:0.8 animations:^{
            hongbaoImgView.alpha = 1;
            hongbaoTxtImgView.alpha =1;
        } completion:^(BOOL finished) {
            //
        }];
        
        
        //打赏按钮区域图片:白色圈划定区域
        CGFloat dashangCircleImgWidth = kDeviceWidth/3;
        CGFloat dashangCircleImgheight = 50;
        UIImageView *dashangCircleImgView= [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth/3*2, kDeviceHeight -50, dashangCircleImgWidth, dashangCircleImgheight)];
        dashangCircleImgView.image = [UIImage imageNamed:@"hongbaoDashangCircle"];
        [_daShangAlertWindow addSubview:dashangCircleImgView];
        
        //线条高度
        CGFloat lineTop = hongbaoTxtImgView.center.y -10;
        //水平线
        UILabel *horizonalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-30, lineTop, 2, 1)];
        horizonalLabel.backgroundColor = [UIColor whiteColor];
        [_daShangAlertWindow addSubview:horizonalLabel];
        //水平点
        UILabel *horizonalPoint  = [[UILabel alloc] initWithFrame:CGRectZero];
        horizonalPoint.backgroundColor = [UIColor whiteColor];
        horizonalPoint.hidden =YES;
        horizonalPoint.layer.cornerRadius = 3;
        horizonalPoint.layer.masksToBounds = YES;
        [_daShangAlertWindow addSubview:horizonalPoint];
        
        //线条：竖直
        UILabel *verticalLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-30, lineTop, 2, 1)];
        verticalLabel.backgroundColor = [UIColor whiteColor];
        
        [_daShangAlertWindow addSubview:verticalLabel];
        //竖直点
        UILabel *verticalPoint  = [[UILabel alloc] initWithFrame:CGRectZero];
        verticalPoint.backgroundColor = [UIColor whiteColor];
        verticalPoint.hidden =YES;
        verticalPoint .layer.cornerRadius = 3;
        verticalPoint.layer.masksToBounds = YES;
        [_daShangAlertWindow addSubview:verticalPoint];
        
        //线条动画
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            horizonalLabel.frame = CGRectMake(kDeviceWidth -60, lineTop, 30, 2);
            verticalLabel.height = kDeviceHeight/2-60 -hongbaoTxtImgView.height/2 -10;
        } completion:^(BOOL finished) {
            //显示原点
            //[UIView animateWithDuration:1 animations:^{
            horizonalPoint.frame = CGRectMake(horizonalLabel.left-6, horizonalLabel.center.y-3, 6, 6);
            verticalPoint.frame = CGRectMake(verticalLabel.center.x-3,verticalLabel.bottom, 6, 6);
            horizonalPoint.hidden = NO;
            verticalPoint.hidden = NO;
            //}];
        }];
        
        //手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddeDashangWindow:)];
        [_daShangAlertWindow addGestureRecognizer: singleTap];
    }
}



//关闭打赏提示视图
- (void)hiddeDashangWindow:(UIGestureRecognizer *)tap{
    UIImageView *hongbaoImgView = [_daShangAlertWindow viewWithTag:111];
    UIImageView *hongbaoTxtimgView = [_daShangAlertWindow viewWithTag:222];
    [UIView animateWithDuration:0.6 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        hongbaoImgView.top = kDeviceHeight;
        hongbaoTxtimgView.top = kDeviceHeight;
       // _daShangAlertWindow.transform = CGAffineTransformMakeScale(2, 2);
        _daShangAlertWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _daShangAlertWindow = nil;
        //记录已经有过提示，以后不再显示
        [USER_DEFAULT setBool:YES forKey:@"notFirstShowDaShangAlert"];
    }];
}




#pragma mark 网络操作

#pragma mark - 网络请求
//- (void)getAlbumDetail{
//    //判断当前显示是否是相册的照片
//    if (self.albumID) {
//        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":self.albumID}];
//        [AFNetwork getMokaDetail:params success:^(id data) {
//            //[self endRefreshing];
//            NSLog(@"得到相册内的数据：%@",data);
//            /*
//             "setting": {
//             "open": {
//             "is_private": "0",
//             "visit_coin": "0",
//             "is_forever_uids_list": []
//             }
//             },
//             */
//            self.albumSettingDic = data[@"data"][@"setting"];
//            
//         } failed:^(NSError *error) {
//            //[self endRefreshing];
//            [LeafNotification showInController:self withText:@"网络不太顺畅哦"];
//        }];
//    }
//}



//请求网络显示用户信息
- (void)getUserName
{
    NSString *theUid = self.currentUid?:@"";
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:theUid];
    NSString *pathAll = [NSString stringWithFormat:@"%@%@%@",DEFAULTURL,PathGetUserInfo,[AFNetwork getCompleteURLWithParams:params]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSMutableURLRequest *request=[NSMutableURLRequest  requestWithURL:[NSURL URLWithString:pathAll]];
        [request setHTTPMethod:@"POST"];
        NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *diction = nil;
        @try {
            diction=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        @catch (NSException *exception) {
            return ;
        }
        @finally {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *cellName = [NSString stringWithFormat:@"%@",diction[@"data"][@"nickname"]];

            self.currentName = cellName;
            self.titleLabel.text = self.currentName;
            
        });
        
    });
}





- (void)showAlertSuccess
{
    [LeafNotification showInController:self withText:@"分享成功"];
}


- (void)hideTabbarForDaTu
{
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.1];
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.2];
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(hideTabbarView) withObject:nil afterDelay:0.6];
    
    
    
}

- (void)hideTabbarView
{
    [self.customTabBarController hidesTabBar:YES animated:NO];
}

- (void)refreshDaShangView
{
    [self refreshItem];
}



//添加打赏视图
- (void)addShangViewToThisView
{
    self.shangView = [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.shangView.superController = self;
//    self.shangView.dashangType = @"payForPicture";
    self.shangView.targetUid = _currentUid;
    [self.shangView setUpviews];
 
}

//添加打赏虚拟物品视图
- (void)addShangGoodsViewToThisView{
    
    NSString *photoId = @"";
    if (self.currentType==YingJi) {
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else if (self.currentType==NewDaTu) {
        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
    }else if (self.currentType==NewDaTuArray) {
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else
    {
        photoId = self.photoArrays[currentIndex_][@"id"];
    }

    self.shangView = [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.shangView.superController = self;
    self.shangView.animationType = @"dashangWithAnimation";
    self.shangView.targetUid = self.currentUid;
    self.shangView.currentPhotoId = photoId;
    self.shangView.dashangType = @"6";
    
    [self.shangView setUpviews];
}


#pragma mark notifition
- (void)dismissCommentView
{
    [UIView animateWithDuration:0.8 animations:^{
        self.commentView.view.frame = CGRectMake(0, 1000, kScreenWidth, kScreenHeight);
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismissActionView
{
    self.actionView.view.hidden = YES;
    
}

- (void)updateInfoDict:(id)notify
{
    [self refreshItem];
}



#pragma mark - 网络请求   模卡的   动态的   收藏的
//统一方法进入本界面
//传入图片Id,用户Id，图片数组
- (void)setDataFromPhotoId:(NSString *)photoId uid:(NSString *)uid withArray:(NSArray *)array
{
    self.isCurrentUser = NO;
    //获取相册数组
    self.photoArrays_id = array.mutableCopy;
    //判断当前是否是自己
    NSString *defaultUser = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (defaultUser) {
        if ([defaultUser isEqualToString:uid]) {
            self.isCurrentUser = YES;
        }
    }
    self.currentUid = uid;
    self.currentType = NewDaTuArray;
    self.photoArrays = array.mutableCopy;
    
    [self performSelector:@selector(initViewFormTimeLine) withObject:nil afterDelay:0.5];

}


- (void)setDataFromPhotoId:(NSString *)photoId uid:(NSString *)uid
{
    self.isCurrentUser = NO;

    NSString *defaultUser = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (defaultUser) {
        if ([defaultUser isEqualToString:uid]) {
            self.isCurrentUser = YES;
        }
    }
    self.currentUid = uid;
    self.currentType = NewDaTu;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在加载...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setValue:photoId?:@"" forKey:@"id"];
    
    NSDictionary *params = [AFParamFormat formatGetUserCenterParams:dict];
    [AFNetwork getPhotoInfo:params success:^(id data){
        NSDictionary *dic = data[@"data"];
        if (dic) {
            NSArray *dataArray = [NSArray arrayWithObject:dic];
            if (dataArray.count>0) {
                self.photoArrays = dataArray.mutableCopy;
                [self initLocalData];
                [self reSetViews];
                [self.hud hide:YES];
            
            }
        }else
        {
            self.hud.detailsLabelText = @"没有数据";
            [self.hud hide:YES afterDelay:2.0];
        }
        
    }failed:^(NSError *error){
        self.hud.detailsLabelText = @"网络错误";
        [self.hud hide:YES afterDelay:2.0];
    }];

    
}


- (void)setDataFromMokaWithUid:(NSString *)uid
{
    self.currentUid = uid;
    self.currentType = Moka;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在加载...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    [dict setValue:uid forKey:@"uid"];
    [dict setValue:[NSNumber numberWithInt:2] forKey:@"type"];
    
    NSDictionary *params = [AFParamFormat formatGetUserCenterParams:dict];
    
    [AFNetwork getUserCenter:params success:^(id data){
        
        NSArray *dataArray = (NSArray *)data[@"data"];
        if (dataArray.count>0) {
            self.photoArrays = dataArray.mutableCopy;
            [self initLocalData];
            [self reSetViews];
            [self.hud hide:YES];
            
        }else
        {
            //            self.hud.detailsLabelText = @"没有数据";
            //            [self.hud hide:YES afterDelay:2.0];
        }
        
    }failed:^(NSError *error){
        self.hud.detailsLabelText = @"网络错误";
        [self.hud hide:YES afterDelay:2.0];
    }];
    
    
}


//动态
- (void)setDataFromTimeLineWithUid:(NSString *)uid andArray:(NSMutableArray *)array
{
    self.currentUid = uid;
    self.currentType = TimeLine;
    currentIndex_ = self.startWithIndex;
    //判断是否为本人
    self.isCurrentUser = NO;
    NSString *defaultUser = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (defaultUser) {
        if ([defaultUser isEqualToString:uid]) {
            self.isCurrentUser = YES;
        }
    }
    
    if (self.photoArrays.count==0) {
        self.photoArrays = array.mutableCopy;
        [self performSelector:@selector(initViewFormTimeLine) withObject:nil afterDelay:0.2];
        
    }else
    {
        if (!self.isRequesting) {
            self.isRequesting = YES;
            
            //            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            //            self.hud.mode = MBProgressHUDModeText;
            //            self.hud.detailsLabelText = @"正在加载...";
            //            self.hud.removeFromSuperViewOnHide = YES;
            
            NSDictionary *params = [AFParamFormat formatGetPhotoListParams:uid lastindex:self.lastIndexId];
            [AFNetwork getPhotoList:params success:^(id data){
                self.isRequesting = NO;
                
                if ([data[@"status"] integerValue] == kRight) {
                    NSArray *array = data[@"data"];
                    
                    if (array.count>0) {
                        for (int i=0; i<array.count; i++) {
                            NSLog(@"%@",array[i]);
                            NSString *type = getSafeString(array[i][@"object_type"]);
                            if ([type isEqualToString:@"6"]) {
                                [self.photoArrays addObject:array[i]];
                            }
                            
                        }
                        if (array.count>0) {
                            NSString *pid = [NSString stringWithFormat:@"%@",self.photoArrays[self.photoArrays.count-1][@"id"]];
                            self.lastIndexId = pid;
                        }
                        [self initViewFormTimeLine];
                        //                        [self.hud hide:YES];
                        
                    }else
                    {
                        //                        self.hud.detailsLabelText = @"已经是最后一张了";
                        //                        [self.hud hide:YES afterDelay:2.0];
                    }
                }
                else if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }
                
            }failed:^(NSError *error){
                self.isRequesting = NO;
                //                self.hud.detailsLabelText = @"网络错误";
                //                [self.hud hide:YES afterDelay:2.0];
            }];
            
        }
        
    }
    
    
    
}


//影集
- (void)setDataFromYingJiWithUid:(NSString *)uid andArray:(NSMutableArray *)array
{
    self.currentUid = uid;
    self.currentType = YingJi;
    //当前索引位置
    currentIndex_ = self.startWithIndex;
    [self changeToPhotoId];
    self.photoArrays = array.mutableCopy;
    [self performSelector:@selector(initViewFormTimeLine) withObject:nil afterDelay:0.2];
    
}






//收藏 关注
- (void)setDataFromCollectionWithUid:(NSString *)uid
{
    self.currentUid = uid;
    self.currentType = Collection;
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在加载...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    
    NSDictionary *params = [AFParamFormat formatGetFavoriteListParams:dict];
    [AFNetwork getFavoriteList:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *array = data[@"data"];
            if (array.count>0) {
                self.photoArrays = array.mutableCopy;
                [self initLocalData];
                [self reSetViews];
                [self.hud hide:YES];
                
            }else
            {
                //                self.hud.detailsLabelText = @"没有数据";
                //                [self.hud hide:YES afterDelay:2.0];
            }
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        self.hud.detailsLabelText = @"网络错误";
        [self.hud hide:YES afterDelay:2.0];
    }];
}

//热门动态
- (void)setDataFromFeedArray:(NSArray *)array
{
    self.currentType = Feed;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在加载...";
    self.hud.removeFromSuperViewOnHide = YES;
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [newArray addObject:dict[@"info"]];
    }
    self.photoArrays = newArray.mutableCopy;
    [self initLocalData];
    [self reSetViews];
    [self.hud hide:YES];
}


//热门动态
- (void)setDataFromFeedArray_person:(NSArray *)array
{
    self.currentType = Feed;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在加载...";
    self.hud.removeFromSuperViewOnHide = YES;
    NSMutableArray *newArray = [NSMutableArray array];
    for (NSDictionary *dict in array) {
        [newArray addObject:dict];
    }
    self.photoArrays = newArray.mutableCopy;
    [self initLocalData];
    [self reSetViews];
    [self.hud hide:YES];
}






#pragma mark - 初始化数据设置
- (void)initViewFormTimeLine
{
    [self initLocalData];
    [self reSetViews];
}


- (void)initLocalData
{
    photoViews_ = @[].mutableCopy;
    self.contentTagsArray = @[].mutableCopy;
    NSMutableArray *temoArr = @[].mutableCopy;
    
    for (int i=0; i<self.photoArrays.count; i++) {
        id dict = self.photoArrays[i];
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [photoViews_ addObject:[NSNull null]];
            NSMutableDictionary *mubDict = [NSMutableDictionary dictionaryWithDictionary:dict];
            [temoArr addObject:mubDict];
        }
        
    }
    //图片资源数组转化为可变数组
    self.photoArrays = temoArr;
    //图片总计数量
    photoCount_ = self.photoArrays.count;
    
    //设置图片当前位置
    if (self.startWithIndex!=99999) {
        currentIndex_ = self.startWithIndex;
        [self changeToPhotoId];
        self.startWithIndex = 99999;
    }
}


//确定当前首先应该显示的图片ID
- (void)changeToPhotoId
{
    //获取当前应该显示的图片的id
    NSString *photoId = @"";
    if (self.currentType==YingJi) {
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else if (self.currentType==NewDaTu) {
        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
    }else if (self.currentType==NewDaTuArray) {
        
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else
    {
        photoId = self.photoArrays[currentIndex_][@"id"];
    }
    //打赏视图的图片id
    self.shangView.currentPhotoId = photoId;
}

//- (void)addShangViewDelay
//{
//   [self.shangView addToWindow];
//}

- (void)reSetViews
{
    [self setScrollViewContentSize];
    [self setCurrentIndex:currentIndex_];
    [self scrollToIndex:currentIndex_];
    [self setPhotoDescription:currentIndex_];
    [self changeView];
}

- (void)changeView
{
    if (currentIndex_ < 0) {
        currentIndex_ = 0;
    }
    else if (currentIndex_ >= [_photoArrays count]){
        currentIndex_ = [_photoArrays count] -1;
        [self changeToPhotoId];
    }
    if ([_photoArrays count] <= 0) {
        return;
    }
    NSDictionary *dict = [_photoArrays objectAtIndex:currentIndex_];
    NSString *photoId = @"";
    if (self.currentType==YingJi) {
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else if (self.currentType==NewDaTu) {
        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
    }else if (self.currentType==NewDaTuArray) {
        photoId = self.photoArrays[currentIndex_][@"photoId"];
    }else
    {
        photoId = self.photoArrays[currentIndex_][@"id"];
    }
    self.photoUid = photoId;
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (_moreSheet) {
        [_moreSheet removeFromSuperview];
    }
    
    if ([self.currentUid isEqualToString:uid]) {
        [self appearMyView];
        //去掉了删除
        self.actionView.namesArray = @[@"推荐给QQ好友",@"推荐到微信",@"保存图片"].mutableCopy;
        self.isSelf = YES;
        //去掉了删除
        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"推荐给QQ好友",@"推荐到微信", @"保存图片", nil];//发送给好友
        //                self.moreSheet.destructiveButtonIndex = 1;
    }
    else{
        [self appearOthersView];
        self.actionView.namesArray = @[@"推荐给QQ好友",@"推荐到微信",@"保存图片",@"举报"].mutableCopy;
        self.isSelf = NO;
        
        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"推荐给QQ好友",@"推荐到微信", @"保存图片", @"举报",nil];//发送给好友
    }
    
}

- (void)appearMyView
{
    [_footerView setHidden:NO atIndex:2];
}




#pragma mark - 事件点击
- (void)appearOthersView
{
    [_footerView setHidden:NO atIndex:2];
}

- (IBAction)backMethod:(id)sender {
    UserDefaultSetBool(NO, @"isHiddenTabbar");

    [USER_DEFAULT synchronize];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"DismissCommentView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dismissActionView" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    if (isRefresh) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTimeLineView" object:nil];
    }
    
}

- (IBAction)moreMethod:(id)sender {

    if (self.photoArrays.count==0) {
        return;
    }
    
    [self.moreSheet showInView:self.view];
}


- (IBAction)dismissTopAndBottom:(id)sender {
    NSLog(@"1");
    if (self.topView.hidden) {
        self.currentHiddenType = NO;
        self.topView.hidden = NO;
        self.bottomView.hidden = NO;
        self.contentView.hidden = NO;
        self.backBtn.hidden = NO;
        BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
        if (isAppearThirdLogin) {
            self.moreButton.hidden = NO;
            
        }else
        {
            self.moreButton.hidden = YES;
            
        }
    }else
    {
        self.moreButton.hidden = YES;
        self.backBtn.hidden = YES;
        self.currentHiddenType = YES;
        self.topView.hidden = YES;
        self.bottomView.hidden = YES;
        self.contentView.hidden = YES;
    }
}



- (void)commentMethod:(id)sender {
    
    
    if (self.photoArrays.count>currentIndex_) {
        NSString *photoId = @"";
        if (self.currentType==YingJi) {
            photoId = self.photoArrays[currentIndex_][@"photoId"];
        }else if (self.currentType==NewDaTu) {
            photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
        }else if (self.currentType==NewDaTuArray) {
            photoId = self.photoArrays[currentIndex_][@"photoId"];
        }else
        {
            photoId = self.photoArrays[currentIndex_][@"id"];
        }
        PhotoViewDetailController *detail = [[PhotoViewDetailController alloc] initWithNibName:@"PhotoViewDetailController" bundle:[NSBundle mainBundle]];
        [detail requestWithPhotoId:photoId uid:self.currentUid];
        detail.infoDict = self.photoArrays[currentIndex_];
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT synchronize];
        
        [self.navigationController pushViewController:detail animated:YES];
    }
    
}

#pragma mark - action delegate
- (void)actionViewClickWithTag:(int)index
{
    switch (index) {
        case 0:
        {
            self.actionView.view.hidden = YES;
            UIActionSheet *choosePhotoActionSheet;
            choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"朋友圈", @"微信好友", nil];
            [choosePhotoActionSheet showInView:self.view];
            
        }
            break;
        case 1:
        {
            KTPhotoView *photoView  = [photoViews_ objectAtIndex:currentIndex_];
            UIImage *image = photoView.imageView.image;
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
            self.actionView.view.hidden = YES;
            
        }
            break;
        case 3:
        {
            if (self.isSelf) {
                NSLog(@"delete");
                NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
                NSString *photoId = @"";
                if (self.currentType==YingJi) {
                    photoId = self.photoArrays[currentIndex_][@"photoId"];
                }else if (self.currentType==NewDaTu) {
                    photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
                }else if (self.currentType==NewDaTuArray) {
                    photoId = self.photoArrays[currentIndex_][@"photoId"];
                }else
                {
                    photoId = self.photoArrays[currentIndex_][@"id"];
                }
                NSDictionary *dict = [AFParamFormat formatDeleteActionParams:photoId userId:uid];
                [AFNetwork deletePicture:dict success:^(id data){
                    NSLog(@"data:%@",data);
                    if([data[@"status"] integerValue] == kRight){
                        isRefresh = YES;
                        [PhotoEngine deletePhotoWithPid:photoId];
                        [LeafNotification showInController:self withText:@"删除成功"];
                    }
                    else{
                        isRefresh = NO;
                        [LeafNotification showInController:self withText:@"删除失败"];
                    }
                    
                }failed:^(NSError *error){
                    
                    [LeafNotification showInController:self withText:@"删除失败"];
                    
                }];
                self.actionView.view.hidden = YES;
                
            }else
            {
                self.actionView.view.hidden = YES;
                
            }
        }
            break;
        case 2:
        {
            if (self.isSelf) {
                self.actionView.view.hidden = YES;
                
            }else
            {
                
            }
        }
            break;
            
        default:
            break;
    }
    
    
}
// 指定回调方法

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功" ;
        
    }
    
    self.hud.detailsLabelText = msg;
    [self.hud hide:YES afterDelay:1.0];
}

#pragma mark - actionSheet 微信分享

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet==self.moreSheet) {
        switch (buttonIndex) {
            case 0:
            {
                KTPhotoView *photoView  = [photoViews_ objectAtIndex:currentIndex_];
                UIImage *image = photoView.imageView.image;
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQWithImageData:photoView.imageData previewImage:image title:@"分享" description:nil];
            
            }
                break;
            case 1:
            {
                [self.shareSheet showInView:self.view];
                
            }
                break;
            case 2:
            {   //保存图片
                [self savePhotoToPhone];
            }
                break;
            case 3:
            {
                if (self.isSelf) {
//                    [self deletePhoto];
                }else{
                    MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
                    report.photoid = self.currentPhotoId;
                    report.reportuid = self.currentUid;
//                    McReportViewController *report = [[McReportViewController alloc] init];
                    report.photoUid = self.photoUid;
                    NSLog(@"%@",self.photoUid);
                    [self.navigationController pushViewController:report animated:YES];
                    
                }
            }
                break;
                
            default:
                break;
        }
        
    }else if(actionSheet==self.shareSheet)
    {
        if (buttonIndex==0) {
            KTPhotoView *photoView  = [photoViews_ objectAtIndex:currentIndex_];
            UIImage *image = photoView.imageView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];//rnadd shareURL:nil
            
        }else if (buttonIndex==1)
        {
            KTPhotoView *photoView  = [photoViews_ objectAtIndex:currentIndex_];
            UIImage *image = photoView.imageView.image;
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"分享"];
            
        }
    }
}


- (void)deletePhoto
{
    if (self.photoArrays.count==0) {
        return;
    }
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在删除...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *photoId = [self getSafeStr:[NSString stringWithFormat:@"%@",self.photoArrays[currentIndex_][@"id"]]];
    
    NSDictionary *dict = [AFParamFormat formatDeleteActionParams:photoId userId:uid];
    [AFNetwork deletePicture:dict success:^(id data){
        NSLog(@"data:%@",data);
        if([data[@"status"] integerValue] == kRight){
            isRefresh = YES;
            [PhotoEngine deletePhotoWithPid:photoId];
            self.hud.detailsLabelText = @"删除成功";
            [self.hud hide:YES afterDelay:2.5];
            [self reSetDataAfterDeleteFinish];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPhotoView" object:nil];
            
            self.superVC.isNeedReload = YES;
        }
        else{
            isRefresh = NO;
            self.hud.detailsLabelText = @"删除失败";
            [self.hud hide:YES afterDelay:2.0];
        }
        
    }failed:^(NSError *error){
        
        self.hud.detailsLabelText = @"删除失败";
        [self.hud hide:YES afterDelay:1.0];
        
    }];
    
    
}

- (void)reSetDataAfterDeleteFinish
{
    
    for (int i=0; i<self.photoArrays.count; i++) {
        if (photoViews_.count<=i) {
            return;
        }
        id photoView = [photoViews_ objectAtIndex:i];
        NSLog(@"******  reSetDataAfterDeleteFinish  **********");
        if ([photoView isKindOfClass:[KTPhotoView class]]) {
            [photoView removeFromSuperview];
        }
    }
    if (self.photoArrays.count<=currentIndex_) {
        return;
    }
    
    [self.photoArrays removeObjectAtIndex:currentIndex_];
    photoCount_ = self.photoArrays.count;
    currentIndex_ = currentIndex_-1;

    if (currentIndex_<0) {
        currentIndex_ = 0;
    }
    
    if (photoViews_.count<=currentIndex_) {
        return;
    }
    [photoViews_ removeObjectAtIndex:currentIndex_];
    [self changeToPhotoId];

    [photoViews_ removeAllObjects];
    for (int i=0; i<self.photoArrays.count; i++) {
        [photoViews_ addObject:[NSNull null]];
    }
    if (self.photoArrays.count==0) {
        [self performSelector:@selector(noPicturehere) withObject:nil afterDelay:1.0];
        
    }else
    {
        [self reSetViews];
        
    }
    
}

- (void)noPicturehere
{
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"没有照片";
    self.hud.removeFromSuperViewOnHide = YES;
    [self.hud hide:YES afterDelay:2.0];
}

- (void)savePhotoToPhone
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeText;
    self.hud.detailsLabelText = @"正在保存...";
    self.hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        KTPhotoView *photoView  = [photoViews_ objectAtIndex:currentIndex_];
        UIImage *image = photoView.imageView.image;
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
        });
        
    });
    
}

#pragma mark - scrollview relate

- (void)setScrollViewContentSize {
    NSInteger pageCount = photoCount_;
    if (pageCount == 0) {
        pageCount = 1;
    }
    
    CGSize size = CGSizeMake(self.photoScrollView.frame.size.width * pageCount,
                             self.photoScrollView.frame.size.height / 2);   // Cut in half to prevent horizontal scrolling.
    [self.photoScrollView setContentSize:size];
}

- (void)setCurrentIndex:(NSInteger)newIndex {
    currentIndex_ = newIndex;
    if (currentIndex_ < 0) {
        currentIndex_ = 0;
    }
    [self changeToPhotoId];

    [self loadPhoto:currentIndex_];
    [self loadPhoto:currentIndex_ + 1];
    [self loadPhoto:currentIndex_ - 1];
    [self unloadPhoto:currentIndex_ + 2];
    [self unloadPhoto:currentIndex_ - 2];
}

- (void)scrollToIndex:(NSInteger)index {
    CGRect frame = self.photoScrollView.frame;
    frame.origin.x = frame.size.width * index;
    //	frame.origin.y = 0;
    [self.photoScrollView scrollRectToVisible:frame animated:NO];
    
}

- (void)setPhotoDescription:(NSInteger)index {
    if (currentIndex_ >= 0) {
        
        if (self.photoArrays.count>currentIndex_) {
            NSMutableDictionary *diction = self.photoArrays[currentIndex_];
            [diction setValue:diction[@"CommentCount"] forKey:@"commentcount"];
            [self changeStateViewWith:diction];
        }
        
        if (self.currentType==TimeLine) {
            if (currentIndex_==(self.photoArrays.count-2)) {
                [self setDataFromTimeLineWithUid:self.currentUid andArray:self.photoArrays];
                
            }else if(currentIndex_==(self.photoArrays.count-1))
            {
                [self setDataFromTimeLineWithUid:self.currentUid andArray:self.photoArrays];
                
            }
        }else if (self.currentType == NewDaTuArray)
        {
            [self refreshItem];

        }
        
    }
}

/**
 *  
 
 1.首页(模特,摄影师两个页面 ，搜索页)，活动(列表，详情，筛选，发布活动的页面)
 2.详情页(大图页，照片详情页，个人主页，这三个页面的逻辑复杂)
 3.动态(热门动态，关注动态，个人主页中的动态)
 4.我(设置，评论列表，通知列表，私信列表，活动列表，认证页面等，都是小页面)
 5.环信sdk
 6.登录注册(包括选角色完善信息页面)，第三方登录
 7.网络请求，数据模型，参数封装
 
 */

- (void)refreshItem
{

    NSString *photoId = @"";
    if (self.currentType==NewDaTu) {
        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];

    }else if (self.currentType==NewDaTuArray) {
        photoId = self.photoArrays_id[currentIndex_][@"photoId"];
        
    }else if (self.currentType == TimeLine){
        photoId = self.photoArrays[currentIndex_][@"id"];
    }
    
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [dict setValue:photoId?:@"" forKey:@"id"];
    
    NSDictionary *params = [AFParamFormat formatGetUserCenterParams:dict];
    
    [AFNetwork getPhotoInfo:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
        NSDictionary *dic = data[@"data"];
        
        NSArray *dataArray = [NSArray arrayWithObject:dic];
        if (dataArray.count>0) {
            NSString *liulabCount = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"view_number"]];
            NSString *isRewarded = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"isRewarded"]];
            NSString *rewardAmount = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"rewardAmount"]];
            NSString *goodsCount = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"goodsCount"]];
            NSString *likecount = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"likecount"]];
            NSString *isLike = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"islike"]];
            NSString *commentcount = [NSString stringWithFormat:@"%@",dataArray[0][@"info"][@"commentcount"]];
            
            
            
            [_footerView setNum:commentcount atIndex:1];
            [_footerView setNum:likecount atIndex:0];
            [_footerView setStatus:[isLike boolValue] atIndex:0];

            if ([isRewarded isEqualToString:@"1"]) {
                self.dashangDescription.text = [NSString stringWithFormat:@"＊你打赏了%@元",rewardAmount];
                self.dashangDescription.hidden = YES; //原先为no
                self.dashangDescription.textColor = [UIColor colorForHex:kLikeRedColor];
                [self resetDashangLabel];
            }else
            {
                self.dashangDescription.hidden = YES;
            }
            BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
            if (isAppearShang) {
                [_footerView setNum:goodsCount atIndex:2];
            }else
            {
                self.dashangDescription.hidden = YES;
                
            }

            self.liulanNumberLabel.text = [NSString stringWithFormat:@"浏览(%@)",liulabCount];
            
            
            [self.hud hide:YES];
            
        }else{
            //            self.hud.detailsLabelText = @"没有数据";
            //            [self.hud hide:YES afterDelay:2.0];
        }
        }else{
            [LeafNotification showInController:self withText:data
             [@"msg"]];
        }
    }failed:^(NSError *error){
        self.hud.detailsLabelText = @"网络错误";
        [self.hud hide:YES afterDelay:2.0];
    }];
}

- (void)resetDashangLabel
{
    self.dashangDescription.frame = CGRectMake(kScreenWidth-247, 22, 225, 21);
    if (kScreenWidth==320) {
        self.dashangDescription.frame = CGRectMake(kScreenWidth-233, 22, 225, 21);

    }else if(kScreenWidth==375)
    {
        
        
    }else
    {
        self.dashangDescription.frame = CGRectMake(kScreenWidth-253, 22, 225, 21);

        
    }
}




- (void)changeStateViewWith:(NSDictionary *)diction
{

    
    
    if (self.currentType==YingJi) {

    }else if (self.currentType==NewDaTu) {
        diction = diction[@"info"];
    }else
    {

    }
    NSString *title = [NSString stringWithFormat:@"%@",diction[@"title"]];
    NSString *detail = [NSString stringWithFormat:@"%@",diction[@"detail"]];
    NSString *isLike = [NSString stringWithFormat:@"%@",diction[@"islike"]];
    NSString *likecount = [NSString stringWithFormat:@"%@",diction[@"likecount"]];
    NSString *isfavorite = [NSString stringWithFormat:@"%@",diction[@"isfavorite"]];
    NSString *favoritecount = [NSString stringWithFormat:@"%@",diction[@"favoritecount"]];
    NSArray *commentArr = diction[@"comments"];
    NSString *commentcount = [NSString stringWithFormat:@"%lu", (unsigned long)commentArr.count];
    NSString *liulabCount = [NSString stringWithFormat:@"%@",diction[@"view_number"]];
    NSString *goodsCount = [NSString stringWithFormat:@"%@",diction[@"goodsCount"]];
    NSString *isRewarded = [NSString stringWithFormat:@"%@",diction[@"isRewarded"]];
    NSString *rewardAmount = [NSString stringWithFormat:@"%@",diction[@"rewardAmount"]];
    
    
    if (self.currentType==YingJi) {
        commentcount = [NSString stringWithFormat:@"%@",diction[@"commentCount"]];
        favoritecount = [NSString stringWithFormat:@"%@",diction[@"favoriteCount"]];
        likecount = [NSString stringWithFormat:@"%@",diction[@"likeCount"]];
    }
    self.liulanNumberLabel.text = [NSString stringWithFormat:@"浏览(%@)",liulabCount];

    if (self.currentType==NewDaTuArray) {
        commentcount = [NSString stringWithFormat:@"%@",diction[@"commentCount"]];
        if (diction[@"commentcount"]) {
        commentcount = [NSString stringWithFormat:@"%@",diction[@"commentcount"]];
        }
        favoritecount = [NSString stringWithFormat:@"%@",diction[@"favoriteCount"]];
        likecount = [NSString stringWithFormat:@"%@",diction[@"likeCount"]];

        self.liulanNumberLabel.text = @"";

        liulabCount = [NSString stringWithFormat:@"%d",[liulabCount intValue]+1];
    }
    
    if ([isRewarded isEqualToString:@"1"]) {
        self.dashangDescription.text = [NSString stringWithFormat:@"＊你打赏了%@元",rewardAmount];
        self.dashangDescription.hidden = YES;//原先为no
        self.dashangDescription.textColor = [UIColor colorForHex:kLikeRedColor];
        [self resetDashangLabel];
    }else
    {
        self.dashangDescription.hidden = YES;
    }
    
    [_footerView setNum:likecount atIndex:0];
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {
        [_footerView setNum:goodsCount atIndex:2];
    }else
    {
        self.dashangDescription.hidden = YES;
        
    }
    [_footerView setNum:commentcount atIndex:1];
    
    [_footerView setStatus:[isLike boolValue] atIndex:0];
    
//    [self addTagsViewToContent];

    
}

- (void)addTagsViewToContent
{
    NSLog(@"******  addTagsViewToContent  **********");
    
    NSMutableString *tagstring = @"".mutableCopy;
    
    if (self.photoArrays.count>currentIndex_) {
        NSString *tags = self.photoArrays[currentIndex_][@"tags"];
        if (tags.length>0) {
            if (!self.currentHiddenType) {
                self.contentView.hidden = NO;
                
            }
            
            NSArray *tagsArr = [tags componentsSeparatedByString:@","];
            
            NSMutableArray *tagResults = @[].mutableCopy;
            
            NSDictionary *workTagDict = [ReadPlistFile readWorkTags];
            for (int i=0; i<tagsArr.count; i++) {
                NSString *styleKey = tagsArr[i];
                if (!styleKey) {
                    styleKey = @"0";
                }
                NSString *value = workTagDict[styleKey];
                if (!value) {
                    value = styleKey;
                }
                [tagResults addObject:value];
            }
            
            for (int i=0; i<tagResults.count; i++) {
                NSString *tag = tagResults[i];
                if (i==0) {
                    [tagstring appendFormat:@"%@",tag];
                }else
                {
                    [tagstring appendFormat:@" | %@",tag];
                }
            }
            
            self.tagsLabel.text = tagstring.copy;
            
        }else
        {
            
            
        }
        
    }
    
}

- (id)getRightDataWithIndex:(int)index
{
    id data = nil;
    for (int i=0; i<self.photoArrays.count; i++) {
        NSDictionary *diction = self.photoArrays[i];
        NSString *squec = [NSString stringWithFormat:@"%@",diction[@"sequence"]];
        int dicIndex = [squec intValue];
        if (index==dicIndex) {
            data = diction;
        }
        
    }
    
    return data;
}

#pragma mark -
#pragma mark Photo (Page) Management
#define PADDING  10

- (void)loadPhoto:(NSInteger)index {
    
    if (index < 0 || index >= photoCount_) {
        return;
    }
//    if (self.currentType==NewDaTuArray) {
//        if (self.photoArrays_id.count<=index) {
//            return;
//        }
//    }else
//    {
//        if (self.photoArrays.count<=index) {
//            return;
//        }
//    }
    if (self.photoArrays.count<=index) {
        return;
    }
    
    id currentPhotoView = [photoViews_ objectAtIndex:index];
    NSLog(@"******  loadPhoto  **********");
    
    if (NO == [currentPhotoView isKindOfClass:[KTPhotoView class]]) {
        // Load the photo view.
        CGRect frame = [self frameForPageAtIndex:index];
        KTPhotoView *photoView = [[KTPhotoView alloc] initWithFrame:frame];
        photoView.disableDoubleClick = NO;
        [photoView setIndex:index];
        id imageObj = [self.photoArrays objectAtIndex:index];
        //        if (self.currentType==YingJi) {
        //            imageObj = [self getRightDataWithIndex:index];
        //        }
        if ([imageObj isKindOfClass:[UIImage class]]) {
            //1.使用图片对象
            UIImage *image = imageObj;
            photoView.imageView.image = image;
        }
        else if ([imageObj isKindOfClass:[NSString class]]) {
            //2.使用图片地址
            ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
            [assetLibrary assetForURL:[NSURL URLWithString:imageObj] resultBlock: ^(ALAsset *asset) {
                 UIImage *image = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
                photoView.imageView.image = image;
             } failureBlock: ^(NSError *error) {
                NSLog(@"error=%@", error);
            }];
        }else
        {
            //3.使用网络返回图片字典
            if (self.currentType==YingJi) {
                //3.1影集
                NSDictionary *diction = (NSDictionary *)imageObj;
                NSString *urlString = diction[@"url"];
                //加水印
                urlString = [CommonUtils appendPostfix:urlString];
                photoView.imageData = urlString;
                UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
                UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString];
                
                if (image||image2) {
                    if (image) {
                        photoView.imageView.image = image;
                        
                    }else
                    {
                        photoView.imageView.image = image2;
                     }
                }else
                {
                    [photoView.imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                 }
                
            }else if (self.currentType==NewDaTu) {
                //3.2NewDaTu
                NSDictionary *diction = (NSDictionary *)imageObj[@"info"];
                [self setPhotoView:photoView WithDiction:diction];
                
            }else if (self.currentType==NewDaTuArray) {
                //3.3NewDaTuArray
                NSDictionary *diction = (NSDictionary *)imageObj;
                [self setPhotoView:photoView WithDiction:diction];
            }else
            {   //3.4
                NSDictionary *diction = (NSDictionary *)imageObj;
                [self setPhotoView:photoView WithDiction:diction];
            }
        }
        photoView.tag = index + 1;
        [self.photoScrollView addSubview:photoView];
        [photoViews_ replaceObjectAtIndex:index withObject:photoView];
     }
    else {
        id imageObj = [self.photoArrays objectAtIndex:index];
        
        KTPhotoView *photoView = [photoViews_ objectAtIndex:index];
        NSDictionary *diction = (NSDictionary *)imageObj;
        if (self.currentType==NewDaTu) {
            diction = diction[@"info"];
        }
        NSString *urlString = diction[@"url"];
        urlString = [CommonUtils appendPostfix:urlString];
        photoView.imageView.image = nil;
        
        if (self.currentType==YingJi) {
             UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlString];
            UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlString];
            
            if (image||image2) {
                if (image) {
                    photoView.imageView.image = image;
                    
                }else
                {
                    photoView.imageView.image = image2;
                    
                }
            }else
            {
                [photoView.imageView setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
             }
            
        }else
        {
            [self setPhotoView:photoView WithDiction:diction];
            
        }
        
    }
}


#pragma mark 其他方法的辅助设置方法
//设置图片
- (void)setPhotoView:(KTPhotoView *)photoView WithDiction:(NSDictionary *)diction{
    NSString *urlString = diction[@"url"];
    //如果是从服务器获取的动态图片
    if ([diction[@"feedType"] isEqualToString:@"11"]) {
        urlString = diction[@"cover_url"];
    }
    //从服务器端获取的图片宽高
    NSString *width = [NSString stringWithFormat:@"%@",diction[@"width"]];
    NSString *heih = [NSString stringWithFormat:@"%@",diction[@"height"]];
    //在屏幕上显示宽度
    float wid = kScreenWidth-30;
    float hei = (wid*[heih floatValue])/[width floatValue];
    //hei = MIN(CGRectGetHeight(photoView.imageView.frame), hei);
    //以CDN样式获取图片
    NSInteger wid_l = wid * 3;
    NSInteger hei_l = hei * 3;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid_l height:hei_l];
    //拼接服务器字段，得到完整路径
    NSString *completeUrl = [NSString stringWithFormat:@"%@%@",urlString,jpg];
    completeUrl = [CommonUtils appendPostfix:completeUrl];
    if (_needBlurry) {
        //如果需要模糊
       NSString *imgUrl = [NSString stringWithFormat:@"%@%@|50-30bl",urlString,jpg];
       NSString *handleuUlStr = [CommonUtils appendPostfix:imgUrl];
        completeUrl= [handleuUlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    
    
    //设置显示模式
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    photoView.imageData = completeUrl;
    
    //从缓存中取出图片
    UIImage *image1 = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:completeUrl];
    UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:completeUrl];
    if (image1||image2) {
        if (image1) {
            photoView.imageView.image = image1;
        }else
        {
            photoView.imageView.image = image2;
         }
    }else
    {
        //否则直接使用网络加载
        //[photoView.imageView setImageWithURL:[NSURL URLWithString:completeUrl] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        //__weak typeof(photoView) pw=  photoView;
        [photoView.imageView setImageWithURL:[NSURL URLWithString:completeUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
//            if(self.needBlurry){
//                  pw.image = [UIImage coreBlurImage:image withBlurNumber:10];
//            }
 
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
    }
}









- (void)unloadPhoto:(NSInteger)index {
    if (index < 0 || index >= photoCount_) {
        return;
    }
    if (self.photoArrays.count<=index) {
        return;
    }
    NSLog(@"******  unloadPhoto  **********");
    if (photoViews_.count <= index) {
        return;
    }
    
    id currentPhotoView = [photoViews_ objectAtIndex:index];
    if ([currentPhotoView isKindOfClass:[KTPhotoView class]]) {
        [currentPhotoView removeFromSuperview];
        [photoViews_ replaceObjectAtIndex:index withObject:[NSNull null]];
    }
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    CGRect bounds = [self.photoScrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

//判断登陆和验证
- (BOOL)isFailForCheckLogInStatus{
    if (getCurrentUid().length != 0) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            //处于登陆状态，并且已经绑定过
            return NO;
        }else
        {   //未绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return YES;;
        }
    }else
    {   //未登录
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return YES;
    }
}


#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    NSInteger page = floor(fractionalPage);
        if (page != currentIndex_) {
            [self setCurrentIndex:page];
        }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self setPhotoDescription:currentIndex_];
    [self changeView];
}



#pragma mark McFooterViewDelegate
- (void)footerView:(McFooterView *)tabBar didSelectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (!uid) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                
                return;
            }
            NSString *photoId = @"";
            if (self.currentType==YingJi) {
                photoId = self.photoArrays[currentIndex_][@"photoId"];
            }else if (self.currentType==NewDaTu) {
                photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
            }else if (self.currentType==NewDaTuArray) {
                photoId = self.photoArrays[currentIndex_][@"photoId"];
            }else
            {
                photoId = self.photoArrays[currentIndex_][@"id"];
            }
            
            NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid];
            [AFNetwork likeAdd:dict success:^(id data){
                NSLog(@"data:%@",data);
                if ([data[@"status"] integerValue] == kRight) {
                    isRefresh = YES;
                    [_footerView setStatus:YES atIndex:0];
                    [_footerView addNumAtIndex:index];
                    NSMutableDictionary *diction = self.photoArrays[currentIndex_];
                    [diction setValue:@"1" forKey:@"islike"];
                    [diction setValue:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[_footerView getCurrentNumAtIndex:index]]] forKey:@"likecount"];
                    [self.photoArrays replaceObjectAtIndex:currentIndex_ withObject:diction];
                    
                    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[currentIndex_]];
                    [mutDict setValue:diction forKey:@"info"];
                    [self.dataArray replaceObjectAtIndex:currentIndex_ withObject:mutDict];
                }
            }failed:^(NSError *error){
                
            }];
        }
            
            break;
        case 2://打赏
        {
            BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
            if (isAppearShang) {
                
                
            }else
            {
                return;
                
            }
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (uid) {
                BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
                if (!isBangDing) {
                    //显示绑定
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                    return;
                }
            }else{
                //显示登陆
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                return;
            }

            if (self.isCurrentUser) {
                if (self.photoArrays.count>currentIndex_) {
                    NSString *photoId = @"";
                    if (self.currentType==YingJi) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else if (self.currentType==NewDaTu) {
                        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
                    }else if (self.currentType==NewDaTuArray) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else
                    {
                        photoId = self.photoArrays[currentIndex_][@"id"];
                    }
                    PhotoViewDetailController *detail = [[PhotoViewDetailController alloc] initWithNibName:@"PhotoViewDetailController" bundle:[NSBundle mainBundle]];
                    detail.isJumpToShang = YES;
                    [detail requestWithPhotoId:photoId uid:self.currentUid];
                    detail.infoDict = self.photoArrays[currentIndex_];
                    
                    UserDefaultSetBool(YES, @"isHiddenTabbar");
                    [USER_DEFAULT synchronize];
                    
                    [self.navigationController pushViewController:detail animated:YES];
                }
                return;
            }
            
            //赏
            [self.view addSubview:self.shangView];
//            [self.shangView setUpviews];
            
            }
            
            break;
        case 1: //评论
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (uid) {
                BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
                if (!isBangDing) {
                    //显示绑定
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                    return;
                }
            }else{
                //显示登陆
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                return;
            }
            [self commentMethod:nil];
        }
            
            break;
            
        default:
            break;
    }
}

- (void)footerView:(McFooterView *)tabBar didNotSelectIndex:(NSInteger)index
{
    switch (index) {
        case 0:
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (!uid) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                
                return;
            }
            
            NSString *photoId = @"";
            if (self.currentType==YingJi) {
                photoId = self.photoArrays[currentIndex_][@"photoId"];
            }else if (self.currentType==NewDaTu) {
                photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
            }else if (self.currentType==NewDaTuArray) {
                photoId = self.photoArrays[currentIndex_][@"photoId"];
            }else
            {
                photoId = self.photoArrays[currentIndex_][@"id"];
            }
            NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid];
            [AFNetwork likeCancel:dict success:^(id data){
                NSLog(@"data:%@",data);
                if([data[@"status"] integerValue] == kRight){
                    isRefresh = YES;
                    [_footerView setStatus:NO atIndex:0];
                    [_footerView minusNumAtIndex:index];
                    NSMutableDictionary *diction = self.photoArrays[currentIndex_];
                    [diction setValue:@"0" forKey:@"islike"];
                    [diction setValue:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[_footerView getCurrentNumAtIndex:index]]] forKey:@"likecount"];
                    [self.photoArrays replaceObjectAtIndex:currentIndex_ withObject:diction];
                    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[currentIndex_]];
                    [mutDict setValue:diction forKey:@"info"];
                    [self.dataArray replaceObjectAtIndex:currentIndex_ withObject:mutDict];
                }
            }failed:^(NSError *error){
                
            }];
        }
            break;
        case 2:
        {
            
            BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
            if (isAppearShang) {
                
                
            }else
            {
                return;
                
            }
            
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (uid) {
                BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
                if (!isBangDing) {
                    //显示绑定
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                    return;
                }
            }else{
                //显示登陆
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                return;
            }

            if (self.isCurrentUser) {
                if (self.photoArrays.count>currentIndex_) {
                    NSString *photoId = @"";
                    if (self.currentType==YingJi) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else if (self.currentType==NewDaTu) {
                        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
                    }else if (self.currentType==NewDaTuArray) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else
                    {
                        photoId = self.photoArrays[currentIndex_][@"id"];
                    }
                    PhotoViewDetailController *detail = [[PhotoViewDetailController alloc] initWithNibName:@"PhotoViewDetailController" bundle:[NSBundle mainBundle]];
//                    detail.isJumpToShang = YES;
                    [detail requestWithPhotoId:photoId uid:self.currentUid];
                    detail.infoDict = self.photoArrays[currentIndex_];
                    
                    UserDefaultSetBool(YES, @"isHiddenTabbar");
                    [USER_DEFAULT synchronize];
                    
                    [self.navigationController pushViewController:detail animated:YES];
                }
                /*
                if (self.photoArrays.count>currentIndex_) {
                    NSString *photoId = @"";
                    if (self.currentType==YingJi) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else if (self.currentType==NewDaTu) {
                        photoId = self.photoArrays[currentIndex_][@"info"][@"id"];
                    }else if (self.currentType==NewDaTuArray) {
                        photoId = self.photoArrays[currentIndex_][@"photoId"];
                    }else
                    {
                        photoId = self.photoArrays[currentIndex_][@"id"];
                    }
                    PhotoViewDetailController *detail = [[PhotoViewDetailController alloc] initWithNibName:@"PhotoViewDetailController" bundle:[NSBundle mainBundle]];
                    [detail requestWithPhotoId:photoId uid:self.currentUid];
                    detail.infoDict = self.photoArrays[currentIndex_];
                    
                    UserDefaultSetBool(YES, @"isHiddenTabbar");
                    [USER_DEFAULT synchronize];
                    
                    [self.navigationController pushViewController:detail animated:YES];
                }
                */
                return;
            }else{
            //赏
                [self.view addSubview:self.shangView];
//                [self.shangView setUpviews];
                
            }
            
        }
            
            break;
        case 1:
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (uid) {
                BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
                if (!isBangDing) {
                    //显示绑定
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                    return;
                }
            }else{
                //显示登陆
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                return;
            }

            [self commentMethod:nil];
        }
            break;
            
        default:
            break;
    }
}


-(NSString *)getSafeStr:(NSString *)str{
    if (str == nil) {
        str = @"";
    }
    return str;
}


@end
