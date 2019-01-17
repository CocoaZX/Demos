//
//  McFeedViewController.m
//  Mocha
//
//  Created by renningning on 15/4/17.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McFeedViewController.h"
#import "RNBlurModalView.h"
#import "DaShangView.h"
#import "McMyFeedListViewController.h"
#import "McHotFeedViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "PhotoViewDetailController.h"
#import "PhotoBrowseViewController.h"
#import "AddLabelViewController.h"
#import "McNearFeedViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVTime.h>
#import "ReleaseJingPaiViewController.h"
#import "DaShangGoodsView.h"
#import "NewLoginViewController.h"
#import "MCJingpaiDetailController.h"
#import "MCHotJingpaiModel.h"
#import "JinBiViewController.h"
#import "MCAuctionTipsController.h"
#import "TaoXiViewController.h"
#import "BrowseAlbumPhotosController.h"

#ifdef TusdkRelease
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "ExtendCameraBaseComponent.h"
#endif

#import "UploadVideoManager.h"

#import "McReportViewController.h"




@interface McFeedViewController () <UIActionSheetDelegate,McBaseFeedControllerDelegate,RNBlurModalViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
    UIWindow *backWindow;
    UILabel *releaseLabel;
    UIImageView *cancelImageView;
    UIImageView *roundImageView;
    UIView *firstView;
    UIView *secondView;
    UIView *thirdView;
    UIImage *fixImage;
    
#ifdef TusdkRelease
    // 自定义系统相册组件
    TuSDKCPAlbumComponent *_albumComponent;
    // 多功能图片编辑组件
    TuSDKCPPhotoEditMultipleComponent *_photoEditMultipleComponent;
#endif
   
}

typedef enum : NSUInteger {
    
    isPhontoType = 1, //选择照片模式
    isVideoType = 2,//选择视频模式
    
}PickerType;

@property (nonatomic, assign) NSInteger seletedIndex;
@property (strong, nonatomic) UISegmentedControl *segControl;

//三个子视图控制器
@property (strong, nonatomic) McHotFeedViewController *hotFeedVc;
@property (strong, nonatomic) McNearFeedViewController *nearFeedVC;
@property (strong, nonatomic) McMyFeedListViewController *myFeedVC;
@property (strong, nonatomic) UIImage *currentImage;
@property (copy, nonatomic) NSString *currentUid;
//举报id
@property(copy,nonatomic)NSString *feedID;
//举报的类型
@property(nonatomic,copy)NSString *feedType;

@property (copy, nonatomic) NSString *photoIdStr;

//举报
@property (strong, nonatomic) UIActionSheet *jubaoSheet;
@property (strong, nonatomic) UIActionSheet *delegateSheet;

@property (copy, nonatomic) NSURL *videoURL;
@property (copy, nonatomic) UIImage *videoImage;
@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property (strong, nonatomic) UILabel *daojishi;
@property (strong, nonatomic) NSTimer *daojishiTimer;

//@property (strong , nonatomic) DaShangView *dashang;
@property (nonatomic,strong) DaShangGoodsView *dashang;


@end

@implementation McFeedViewController


#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef TusdkRelease
    //初始化tusdk
    [[TuSDKTKLocation shared] requireAuthorWithController:self];
#endif
    
#ifdef TencentRelease
    //初始化tusdk
    [UploadVideoManager sharedInstance];
    
#endif
    
    
    //设置titleView
    [self setTitleView];
    
    //设置当前显示视图的内容区域大小
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = kScreenHeight - kTabBarHeight - kNavHeight;
    self.view.frame = viewFrame;
    [self showViewControllerAtIndex:_segControl.selectedSegmentIndex];
    
    //添加通知
    [self addNotifications];
    
    //设置导航栏
    [self setNavigationBar];

    //单元格上的举报
    self.jubaoSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"举报", nil];
    
    self.delegateSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

    [self.customTabBarController hidesTabBar:NO animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
}



-(void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doJumpDetailAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doJumpDetailAction_guanzhu" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doCommitAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doJumpPersonCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doDelegatePhoto" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"doJumpJuBao" object:nil];
}


- (void)setTitleView{
    NSDictionary *langDic = [USER_DEFAULT objectForKey:@"lang_description"];
    NSString *hotStr = @"热门秀";
    NSString *nearStr = @"同城秀";
    NSString *firendStr = @"朋友秀";
    if (langDic) {
        hotStr = langDic[@"tab_feed_hot"];
        nearStr = langDic[@"tab_feed_near"];
        firendStr = langDic[@"tab_feed_my"];
    }
    BOOL nearFeed = UserDefaultGetBool(ConfigNearFeed);
    if (nearFeed) {
        _segControl = [[UISegmentedControl alloc] initWithItems:@[hotStr,nearStr,firendStr]];
    }else{
        _segControl = [[UISegmentedControl alloc] initWithItems:@[hotStr,firendStr]];
    }
    
    _segControl.frame = CGRectMake((kScreenWidth - 240)/2, 24.0, 240, 30.0);
    _segControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [_segControl addTarget:self action:@selector(doSelectedControl:) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segControl;

}


- (void)addNotifications{
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailAction:) name:@"doJumpDetailAction" object:nil];
    
    //跳转竞拍详情界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailJingpaiVC:) name:@"doJumpDetailJingpaiVC" object:nil];
    //金币充值界面
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToRechargeVC) name:@"jumpToRechargeVC" object:nil];
    
    //视频详情跳转
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpVideoDetailAction:) name:@"doJumpVideoDetailAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailAction_guanzhu:) name:@"doJumpDetailAction_guanzhu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCommitAction:) name:@"doCommitAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpPersonCenter:) name:@"doJumpPersonCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doDelegatePhoto:) name:@"doDelegatePhoto" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpJuBao:) name:@"doJumpJuBao" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showJuBaoViewController) name:@"showJuBaoViewController" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToLogin) name:@"jumpToLogin" object:nil];
    //跳转充值界面
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(jumpToRecharge) name:@"jumpToAuctionRecharge" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToAuctionTipsVC) name:@"jumpToAuctionTipVC" object:nil];
}


- (void)setNavigationBar{
    
    self.navigationItem.leftBarButtonItem = nil;

    //发布按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 55.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    NSString *titleStr = NSLocalizedString(@"release", nil);
    if ([titleStr isEqualToString:@"发布"]) {
        button.frame = CGRectMake(0.0f, 8.0f, 30.0f, 30.0f);
    }
    
    [button setTitle:titleStr forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(releaseMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;

}



#pragma mark - selectedControl

- (void)doSelectedControl:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    [self showViewControllerAtIndex:segControl.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSInteger)index
{
    BOOL nearFeed = UserDefaultGetBool(ConfigNearFeed);
    self.seletedIndex = index;
    
    _hotFeedVc.superNVC = self.navigationController;
    _myFeedVC.superNVC = self.navigationController;
    _nearFeedVC.superNVC = self.navigationController;
    
    if (nearFeed) {
        if (index == 0) {
            [self.view addSubview:self.hotFeedVc.view];
            _hotFeedVc.feedDelegate =self;
            _hotFeedVc.view.frame = self.view.bounds;
            self.hotFeedVc.tableView.scrollEnabled = YES;
            self.myFeedVC.tableView.scrollEnabled = NO;
            self.nearFeedVC.tableView.scrollEnabled = NO;
            
        }
        else if (index == 2){
            [self.view addSubview:self.myFeedVC.view];
            NSString *uid = [USER_DEFAULT valueForKey:MOKA_USER_VALUE][@"id"];
            _myFeedVC.isNeedToAppearBar = YES;
            _myFeedVC.currentUid = uid;
            _myFeedVC.feedDelegate =self;
            _myFeedVC.view.frame = self.view.bounds;
            
            
            self.myFeedVC.tableView.scrollEnabled = YES;
            self.nearFeedVC.tableView.scrollEnabled = NO;
            self.hotFeedVc.tableView.scrollEnabled = NO;
            
        }else if (index == 1){
            [self.view addSubview:self.nearFeedVC.view];
            _nearFeedVC.view.frame = self.view.bounds;
            _nearFeedVC.feedDelegate =self;
            self.nearFeedVC.tableView.scrollEnabled = YES;
            self.myFeedVC.tableView.scrollEnabled = NO;
            self.hotFeedVc.tableView.scrollEnabled = NO;
            
        }
    }else{
        if (index == 0) {
            [self.view addSubview:self.hotFeedVc.view];
            _hotFeedVc.feedDelegate =self;
            _hotFeedVc.view.frame = self.view.bounds;
            self.hotFeedVc.tableView.scrollEnabled = YES;
            self.myFeedVC.tableView.scrollEnabled = NO;
            self.nearFeedVC.tableView.scrollEnabled = NO;
        }else if(index == 1){
            [self.view addSubview:self.myFeedVC.view];
            NSString *uid = [USER_DEFAULT valueForKey:MOKA_USER_VALUE][@"id"];
            _myFeedVC.isNeedToAppearBar = YES;
            _myFeedVC.currentUid = uid;
            _myFeedVC.feedDelegate =self;
            _myFeedVC.view.frame = self.view.bounds;
            
            self.myFeedVC.tableView.scrollEnabled = YES;
            self.nearFeedVC.tableView.scrollEnabled = NO;
            self.hotFeedVc.tableView.scrollEnabled = NO;
            
        }
    }
    
}
#pragma mark - cellDelegate
- (void)releaseMethod:(id)sender
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
    [self newShowAddPhoto];
    
}

-(void)jumpToRecharge{
    JinBiViewController *rechargeVC = [[JinBiViewController alloc]init];
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

-(void)goToAuctionTipsVC{
    MCAuctionTipsController *tipsVC = [[MCAuctionTipsController alloc] initWithNibName:@"MCAuctionTipsController" bundle:nil];
    
    NSString *urlStr = [USER_DEFAULT valueForKey:@"webUrl"];
    tipsVC.linkUrl = [NSString stringWithFormat:@"%@/about/BiddingRule",urlStr];
    
    [self.navigationController pushViewController:tipsVC animated:YES];
}

- (void)doJumpJuBao:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSString *uid = getSafeString(feedDict[@"user"][@"id"]);
    if (uid.length == 0 ||uid == nil) {
        //热门动态和附近秀
        uid = feedDict[@"uid"];
    }
    self.currentUid = uid;
    //单元格内容类型
    _feedType = getSafeString(feedDict[@"feedType"]);
    if (_feedType.length == 0) {
        _feedType = getSafeString(feedDict[@"info"][@"feedType"]);
    }
    //视频或者图片的id
    _feedID = getSafeString(feedDict[@"id"]);
    if (_feedID.length == 0) {
        _feedID = getSafeString(feedDict[@"info"][@"id"]);
    }
    
    [self.jubaoSheet showInView:self.view];
}

-(void)doDelegatePhoto:(id)sender{
     NSLog(@"doDelegate");
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    if (feedDict[@"id"]) {
        self.photoIdStr = feedDict[@"id"];
    }
    [self.delegateSheet showInView:self.view];
}

-(void)jumpToLogin{
    NewLoginViewController *loginVC = [[NewLoginViewController alloc]initWithNibName:[NSString stringWithFormat:@"NewLoginViewController"] bundle:nil];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    return;
}

- (void)showJuBaoViewController
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        //
        MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
        
//        McReportViewController *report = [[McReportViewController alloc] init];
        if ([_feedType isEqualToString:@"11"]) {
            report.videoUid = _feedID;
        }else{
            report.photoUid = _feedID;
        }
        report.photoid = self.photoIdStr;
        report.reportuid = self.currentUid;
        [self.navigationController pushViewController:report animated:YES];
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet != self.delegateSheet) {
    if (buttonIndex == 0) {
        [self showJuBaoViewController];
    }
    }else{
        if (buttonIndex == 0) {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (uid) {
            [self isMasterDelegateAction];
            
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            
            }

        }
    }
}

-(void)isMasterDelegateAction{
    NSString *uid = [self getSafeStr:[NSString stringWithFormat:@"%@", [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]]];
    NSString *photoId = [self getSafeStr:self.photoIdStr];
    NSDictionary *dict = [AFParamFormat formatDeleteActionParams:photoId userId:uid];
    [AFNetwork deletePicture:dict success:^(id data){
        
        if([data[@"status"] integerValue] == kRight){
            
            [LeafNotification showInController:self.customTabBarController withText:@"已成功删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePictureSuccess" object:dict];
        }
        else{
            [LeafNotification showInController:self.customTabBarController withText:data[@"msg"]];
            
        }
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self.customTabBarController withText:@"当前网络不太顺畅哟"];
        
    }];

}


- (void)showAddPhoto
{
    float viewWidth = kScreenWidth;
    float viewHeight = 200;
    float headheight = 60;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    view.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (headheight - 30)/2, view.frame.size.width, 30)];
    
    NSDictionary *textAttributes = nil;
    UIColor *color = [CommonUtils colorFromHexString:kLikeGrayColor];
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        
        textAttributes = @{
                           NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                           NSForegroundColorAttributeName: color
                           };
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textAttributes = @{
                           UITextAttributeFont: [UIFont boldSystemFontOfSize:20],
                           UITextAttributeTextColor: color,
                           UITextAttributeTextShadowColor: [UIColor clearColor],
                           UITextAttributeTextShadowOffset: [NSValue valueWithUIOffset:UIOffsetZero],
                           };
#endif
    }
    label.attributedText = [[NSAttributedString alloc] initWithString:@"添加照片" attributes:textAttributes];
    label.textAlignment = NSTextAlignmentCenter;
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, headheight - 0.5, viewWidth, 0.5)];
    [lineImageView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    
    
    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(view.frame.size.width/2, headheight, view.frame.size.width/2, viewHeight - headheight)];
    [photoBtn setImage:[UIImage imageNamed:@"take_photo"] forState:UIControlStateNormal];//45
    float left = (photoBtn.frame.size.width - 45)/2;
    float bottom = photoBtn.frame.size.height - 45 - 20;
    [photoBtn setImageEdgeInsets:UIEdgeInsetsMake(20, left, bottom, left)];
    
    UIButton *pictureBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, headheight, view.frame.size.width/2, viewHeight - headheight)];
    [pictureBtn setImage:[UIImage imageNamed:@"take_picture"] forState:UIControlStateNormal];//45
    [pictureBtn setImageEdgeInsets:UIEdgeInsetsMake(20, left, bottom, left)];
    
    
    float titleTop = 70 + headheight;
    float titleWith = view.frame.size.width/2 - 20;
    
    UILabel *photoLab = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width/2 + 10,titleTop,titleWith,20)];
    [photoLab setText:@"相机拍摄"];
    photoLab.textAlignment = NSTextAlignmentCenter;
    
    UILabel *picLab = [[UILabel alloc] initWithFrame:CGRectMake(10,titleTop,titleWith,20)];
    [picLab setText:@"从相册中选择"];
    picLab.textAlignment = NSTextAlignmentCenter;
    

    UIImageView *lineImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(view.frame.size.width/2 - 0.5, photoBtn.frame.origin.y + 5, 0.5, photoBtn.frame.size.height - 10)];
    [lineImageView2 setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    
    [view addSubview:lineImageView];
    [view addSubview:label];
    [view addSubview:photoBtn];
    [view addSubview:pictureBtn];
    [view addSubview:lineImageView2];
    [view addSubview:photoLab];
    [view addSubview:picLab];
    
    RNBlurModalView *modal = [[RNBlurModalView alloc] initWithViewController:self.customTabBarController view:view buttonObjects:@[pictureBtn,photoBtn]];
    modal.delegate = self;
    [modal show];
    
}

#pragma mark - NEWAnimationRelease
-(void)newShowAddPhoto{
    [self createBackWindow];
    //细线
    releaseLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth - 30, 60 , 1, 5)];
    releaseLabel.backgroundColor = [UIColor whiteColor];
    releaseLabel.layer.anchorPoint = CGPointMake(0.5, 0);
    releaseLabel.alpha = 0;
    [backWindow addSubview:releaseLabel];
    //取消按钮
    cancelImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth - 45, 30, 30, 30)];
    cancelImageView.image = [UIImage imageNamed:@"photoBrowseCancel"];
    cancelImageView.alpha = 0;
    [backWindow addSubview:cancelImageView];
    //圆圈
    roundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth - 34, 66, 10, 10)];
    roundImageView.image = [UIImage imageNamed:@"round"];
    [backWindow addSubview:roundImageView];
    
    //
    
    [UIView animateWithDuration:0.3 animations:^{
        backWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    }];
    
    firstView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth - 30, 80, 30, 50)];
    firstView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    UIImageView *photosImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 17, 15)];
    photosImageV.image = [UIImage imageNamed:@"photos"];
    UILabel *labelPhone = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 130, 30)];
    labelPhone.text = @"手机相册选择";
    labelPhone.textColor = [UIColor whiteColor];
    [firstView addSubview:labelPhone];
    [firstView addSubview:photosImageV];
    firstView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    firstView.alpha = 0;
    [backWindow addSubview:firstView];
    
    
    secondView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth - 30, 150, 30, 50)];
    secondView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    secondView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    UIImageView *carmarImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 17, 15)];
    carmarImageV.image = [UIImage imageNamed:@"whiteCam"];
    UILabel *labelcarmar = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 130, 30)];
    labelcarmar.textColor = [UIColor whiteColor];
    labelcarmar.text = @"相机拍摄";
    [secondView addSubview:labelcarmar];
    [secondView addSubview:carmarImageV];
    secondView.alpha = 0;
    [backWindow addSubview:secondView];
    
    thirdView = [[UIView alloc]initWithFrame:CGRectMake(kDeviceWidth - 30, 220, 30, 50)];
    thirdView.layer.anchorPoint = CGPointMake(1.0, 0.5);
    thirdView.alpha = 0;
    thirdView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    UIImageView *videoImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15, 18, 17, 15)];
    videoImageV.image = [UIImage imageNamed:@"video"];
    UILabel *labelVideo = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 130, 30)];
    labelVideo.textColor = [UIColor whiteColor];
    labelVideo.text = @"视频拍摄";
    [thirdView addSubview:labelVideo];
    [thirdView addSubview:videoImageV];
#ifdef TencentRelease
    
    #ifdef PublicJingPaiRelease
    
        [backWindow addSubview:thirdView];
    
    #else
        //用户是否有权限使用视频发布功能
        NSString *isShowVideo = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"is_show_video"];
        if ([isShowVideo isEqualToString:@"1"]) {
            [backWindow addSubview:thirdView];
        }
    
    #endif

#else

#endif
 
    
    [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        releaseLabel.frame = CGRectMake(kDeviceWidth - 30, 60, 1, 182);
        firstView.transform = CGAffineTransformMakeTranslation(-135.0, 0);
        firstView.size = CGSizeMake(170, 50);
        secondView.transform = CGAffineTransformMakeTranslation(-115, 0);
        secondView.size = CGSizeMake(150, 50);
        thirdView.transform = CGAffineTransformMakeTranslation(-115, 0);
        thirdView.size = CGSizeMake(150, 50);
        
        roundImageView.frame = CGRectMake(kDeviceWidth - 34, 242, 10, 10);
        releaseLabel.alpha = 1;
        cancelImageView.alpha = 1;
        firstView.alpha = 1;
        secondView.alpha = 1;
        thirdView.alpha = 1;
        backWindow.alpha = 0.9;
    } completion:^(BOOL finished) {
        releaseLabel.frame = CGRectMake(kDeviceWidth - 30, 60, 1, 182);
        UIButton *buttonOne = [UIButton buttonWithType:UIButtonTypeSystem];

        buttonOne.frame = firstView.bounds;
        [firstView addSubview:buttonOne];
        
        UIButton *buttonTwo = [UIButton buttonWithType:UIButtonTypeSystem];
        
        buttonTwo.frame = secondView.bounds;
        [secondView addSubview:buttonTwo];
        
        UIButton *buttonThird = [UIButton buttonWithType:UIButtonTypeSystem];
        buttonThird.frame = thirdView.bounds;
        [thirdView addSubview:buttonThird];
        
        
        
#ifdef TusdkRelease
        [buttonOne addTarget:self action:@selector(appearTuSDKAlbum) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonTwo addTarget:self action:@selector(appearTuSDKCamera) forControlEvents:UIControlEventTouchUpInside];

        [buttonThird addTarget:self action:@selector(appearTuSDKCamera) forControlEvents:UIControlEventTouchUpInside];
#else
        [buttonOne addTarget:self action:@selector(takePicture) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonTwo addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
       
#endif
        
#ifdef TencentRelease
        
        [buttonThird addTarget:self action:@selector(takeVideo) forControlEvents:UIControlEventTouchUpInside];
        
#else
        
        
        
#endif
        

    }];
}
-(void)hideBackWindow{
    [UIView animateWithDuration:0.3 animations:^{
        firstView.transform = CGAffineTransformMakeTranslation(135.0, 0);
        secondView.transform = CGAffineTransformMakeTranslation(115.0, 0);
        thirdView.transform = CGAffineTransformMakeTranslation(115.0, 0);
        firstView.size = CGSizeMake(30, 50);
        secondView.size = CGSizeMake(30, 50);
        thirdView.size = CGSizeMake(30, 50);
        releaseLabel.frame = CGRectMake(kDeviceWidth - 30, 60, 1, 1);
        cancelImageView.alpha = 0;
        roundImageView.frame = CGRectMake(kDeviceWidth - 34, 66, 10, 10);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            backWindow.frame = CGRectMake(0, - kDeviceHeight, kDeviceWidth, kDeviceHeight);
        } completion:^(BOOL finished) {
            backWindow.hidden = YES;
            backWindow = nil;

        }];
    }];
}

#pragma mark - createWindow
-(void)createBackWindow{
    backWindow = [[UIWindow alloc]initWithFrame:CGRectMake(0, - kDeviceHeight, kDeviceWidth, kDeviceHeight)];
    backWindow.backgroundColor = [UIColor blackColor];
    backWindow.alpha = 0.9;
    backWindow.hidden = NO;
    backWindow.windowLevel = UIWindowLevelStatusBar;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideBackWindow)];
    [backWindow addGestureRecognizer:tapGR];
}





//#pragma mark RNBlurModalViewDelegate
//- (void)RNBlurModalViewAtIndex:(NSInteger)index
//{
//    [SingleData shareSingleData].currnetImageType = 1;
//    if (index==0) {
//        [self takePicture];
//        
//    }else
//    {
//#ifdef TusdkRelease
//        [self appearTuSDKCamera];
//#else
//        [self takePhoto];
//
//#endif
//    }
//    
//}

#pragma mark tusdk

#ifdef TusdkRelease

- (void)appearTuSDKCamera
{
    [self hideBackWindow];
    
    [TuSDKTSDeviceSettings checkAllowWithController:self
                                               type:lsqDeviceSettingsCamera
                                          completed:^(lsqDeviceSettingsType type, BOOL openSetting)
     {
         if (openSetting) {
             lsqLError(@"Can not open camera");
             return;
         }
         [self showCameraController];
     }];
    
}

- (void)appearTuSDKAlbum
{
    [self hideBackWindow];
    
    _albumComponent =
    [TuSDKGeeV1 albumCommponentWithController:self
                                callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片错误
         if (error) {
             lsqLError(@"album reader error: %@", error.userInfo);
             return;
         }
         [self openEditMultipleWithController:controller result:result];
     }];
    
    [_albumComponent showComponent];
}

- (void)showCameraController;
{
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFCameraOptions.html
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 控制器类
    opt.componentClazz = [ExtendCameraBaseController class];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    opt.viewClazz = [ExtendCameraBaseView class];
    
    // 默认相机控制栏视图类 (默认:TuSDKPFCameraConfigView, 需要继承 TuSDKPFCameraConfigView)
    // opt.configBarViewClazz = [TuSDKPFCameraConfigView class];
    
    // 默认相机底部栏视图类 (默认:TuSDKPFCameraBottomView, 需要继承 TuSDKPFCameraBottomView)
    // opt.bottomBarViewClazz = [TuSDKPFCameraBottomView class];
    
    // 闪光灯视图类 (默认:TuSDKPFCameraFlashView, 需要继承 TuSDKPFCameraFlashView)
    // opt.flashViewClazz = [TuSDKPFCameraFlashView class];
    
    // 滤镜视图类 (默认:TuSDKPFCameraFilterGroupView, 需要继承 TuSDKPFCameraFilterGroupView)
    // opt.filterViewClazz = [TuSDKPFCameraFilterGroupView class];
    
    
    // 聚焦触摸视图类 (默认:TuSDKCPFocusTouchView, 需要继承 TuSDKCPFocusTouchView)
    // opt.focusTouchViewClazz = [TuSDKCPFocusTouchView class];
    // 摄像头前后方向 (默认为后置优先)
    // opt.cameraPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.cameraDefaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    // opt.showFilterDefault = YES;
    
    // 开启滤镜历史记录
    opt.enableFilterHistory = YES;
    
    // 开启在线滤镜
    opt.enableOnlineFilter = YES;
    
    // 显示滤镜标题视图
    opt.displayFilterSubtitles = YES;
    
    // 滤镜列表行视图宽度
    opt.filterBarCellWidth = 60;
    
    // 滤镜列表选择栏高度
    opt.filterBarHeight = 60;
    
    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    // opt.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    
    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItemCell, 需要继承 TuSDKCPGroupFilterItemCell)
    opt.filterBarTableCellClazz = [ExtendCameraBaseFilterItemCell class];
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // 滤镜名称参考 TuSDK.bundle/others/lsq_tusdk_configs.json
    // filterGroups[]->filters[]->name lsq_filter_%{Brilliant}
    opt.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    
    // 是否保存最后一次使用的滤镜
    // opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    opt.autoSelectGroupDefaultFilter = YES;
    
    // 开启滤镜配置选项
    // opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioOrgin; // 不设置比例
    
    // 是否开启长按拍摄 (默认: NO)
    opt.enableLongTouchCapture = YES;
    
    // 禁用持续自动对焦 (默认: NO)
    // opt.disableContinueFoucs = YES;
    
    // 自动聚焦延时 (默认: 5秒)
    // opt.autoFoucsDelay = 5;
    
    // 长按延时 (默认: 1.2秒)
    // opt.longTouchDelay = 1.2;
    
    // 保存到系统相册 (默认不保存, 当设置为YES时, TuSDKResult.asset)
    opt.saveToAlbum = YES;
    
    // 保存到临时文件 (默认不保存, 当设置为YES时, TuSDKResult.tmpFile)
    // opt.saveToTemp = NO;
    
    // 保存到系统相册的相册名称
    // opt.saveToAlbumName = @"TuSdk";
    
    // 照片输出压缩率 0-1 如果设置为0 将保存为PNG格式 (默认: 0.95)
    // opt.outputCompress = 0.95f;
    
    // 视频覆盖区域颜色 (默认：[UIColor clearColor])
    opt.regionViewColor = lsqRGB(51, 51, 51);
    
    // 照片输出分辨率
    // opt.outputSize = CGSizeMake(1440, 1920);
    
    // 禁用前置摄像头自动水平镜像 (默认: NO，前置摄像头拍摄结果自动进行水平镜像)
    // opt.disableMirrorFrontFacing = YES;
    
    // 是否开启脸部追踪
    opt.enableFaceDetection = YES;
    /* 这里是option配置功能选项，配置相机的功能，一切以 TuSDK 官方demo为准 */
    TuSDKPFCameraViewController *controller = opt.viewController;
    controller.delegate = self;
    [self presentModalNavigationController:controller animated:YES];
    
}

/**
 *  获取一个拍摄结果
 *
 *  @param controller 默认相机视图控制器
 *  @param result     拍摄结果
 */
- (void)onTuSDKPFCamera:(TuSDKPFCameraViewController *)controller captureResult:(TuSDKResult *)result;
{
    //如需在相机控制器开启编辑组件，必须将此处代码注释
//    [controller dismissViewControllerAnimated:YES completion:nil];
    
    // 拍照完成时，可在此立即开启图片编辑组件，对当前拍摄照片进行编辑
    // 开启裁剪组件
    //    [self openEditAndCutWithController:controller result:result];
    //    // 开启高级编辑组件
    //    [self openEditAdvancedWithController:controller result:result];
    //    // 开启多功能编辑组件
    [self openEditMultipleWithController:controller result:result];

    //详细开启编辑组件的方法请参考demo中各组件开启方法内的详细代码
}


#pragma mark - TuSDKCPComponentErrorDelegate
/**
 *  获取组件返回错误信息
 *
 *  @param controller 控制器
 *  @param result     返回结果
 *  @param error      异常信息
 */
- (void)onComponent:(TuSDKCPViewController *)controller result:(TuSDKResult *)result error:(NSError *)error;
{
    
}


/**
 *  开启多功能图片编辑
 *
 *  @param controller 来源控制器
 *  @param result     处理结果
 */
- (void)openEditMultipleWithController:(UIViewController *)controller
                                result:(TuSDKResult *)result;
{
    if (!controller || !result) return;
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleComponent.html
    _photoEditMultipleComponent =
    [TuSDKGeeV1 photoEditMultipleWithController:controller
                                  callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         _albumComponent = nil;
         
         // 如果以 pushViewController 方式打开编辑器, autoDismissWhenCompelted参数将无效, 请使用以下方法关闭
         //if (_photoEditMultipleComponent.autoDismissWhenCompelted && controller) {
         //    [controller popViewControllerAnimated:YES];
         //}
         
         // 获取图片失败
         if (error) {
             lsqLError(@"editMultiple error: %@", error.userInfo);
             return;
         }
         [result logInfo];
         NSData *imageData = UIImageJPEGRepresentation(result.image,1.0);
         [self gotoReleaseImageWith:[UIImage imageWithData:imageData]];
         // 可在此添加自定义方法，将result结果传出，例如 ：  [self openEditorWithImage:result.image];
         // 并在外部使用方法接收result结果，例如 ： -(void)openEditorWithImage:(UIImage *)image;
         
     }];
    
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditMultipleOptions.html
    // _photoEditMultipleComponent.options
    
    //    // 图片编辑入口控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditMultipleOptions.html
    // _photoEditMultipleComponent.options.editMultipleOptions
    //    // 禁用功能模块 默认：加载全部模块
    //    [_photoEditMultipleComponent.options.editMultipleOptions disableModule:lsqTuSDKCPEditActionCuter];
    //    // 最大输出图片按照设备屏幕 (默认:true, 如果设置了LimitSideSize, 将忽略LimitForScreen)
    //    _photoEditMultipleComponent.options.editMultipleOptions.limitForScreen = YES;
    //    // 保存到系统相册
    //    _photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = YES;
    //    // 控制器关闭后是否自动删除临时文件
    //    _photoEditMultipleComponent.options.editMultipleOptions.isAutoRemoveTemp = YES;
    //
    //    // 图片编辑滤镜控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditFilterOptions.html
    // _photoEditMultipleComponent.options.editFilterOptions
    //    // 默认: true, 开启滤镜配置选项
    //    _photoEditMultipleComponent.options.editFilterOptions.enableFilterConfig = YES;
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editFilterOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editFilterOptions.outputCompress = 0.95f;
    //    // 滤镜列表行视图宽度
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarCellWidth = 75;
    //    // 滤镜列表选择栏高度
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarHeight = 100;
    //    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    //    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItem, 需要继承 TuSDKCPGroupFilterItem)
    //    _photoEditMultipleComponent.options.editFilterOptions.filterBarTableCellClazz = [TuSDKCPGroupFilterItem class];
    //    // 开启用户滤镜历史记录
    //    _photoEditMultipleComponent.options.editFilterOptions.enableFilterHistory = YES;
    //    // 显示滤镜标题视图
    //    _photoEditMultipleComponent.options.editFilterOptions.displayFilterSubtitles = YES;
    //    // 是否渲染滤镜封面 (使用设置的滤镜直接渲染，需要拥有滤镜列表封面设置权限，请访问TuSDK.com控制台)
    //    _photoEditMultipleComponent.options.editFilterOptions.isRenderFilterThumb = YES;
    //
    //    // 图片编辑裁切旋转控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditCuterOptions.html
    // _photoEditMultipleComponent.options.editCuterOptions
    //    // 是否开启图片旋转(默认: false)
    //    _photoEditMultipleComponent.options.editCuterOptions.enableTrun = YES;
    //    // 是否开启图片镜像(默认: false)
    //    _photoEditMultipleComponent.options.editCuterOptions.enableMirror = YES;
    //    // 裁剪比例 (默认:lsqRatioAll)
    //    _photoEditMultipleComponent.options.editCuterOptions.ratioType = lsqRatioAll;
    //    // 裁剪比例排序 (例如：@[@(lsqRatioOrgin), @(lsqRatio_1_1), @(lsqRatio_2_3), @(lsqRatio_3_4)])
    //    _photoEditMultipleComponent.options.editCuterOptions.ratioTypeList = @[@(lsqRatioOrgin), @(lsqRatio_1_1), @(lsqRatio_2_3)];
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editCuterOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editCuterOptions.outputCompress = 0.95f;
    //
    //    // 美颜控制器视图配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditSkinOptions.html
    // _photoEditMultipleComponent.options.editSkinOptions
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editSkinOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSkinOptions.outputCompress = 0.95f;
    //
    //    // 图片编辑贴纸选择控制器配置选项
    // _photoEditMultipleComponent.options.editStickerOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditStickerOptions.html
    //    // 单元格间距 (单位：DP)
    //    _photoEditMultipleComponent.options.editStickerOptions.gridPadding = 2;
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editStickerOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editStickerOptions.outputCompress = 0.95f;
    //
    //    // 颜色调整控制器配置选项
    // _photoEditMultipleComponent.options.editAdjustOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditAdjustOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editAdjustOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editAdjustOptions.outputCompress = 0.95f;
    //
    //    // 锐化功能控制器配置选项
    // _photoEditMultipleComponent.options.editSharpnessOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditSharpnessOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editSharpnessOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSharpnessOptions.outputCompress = 0.95f;
    //
    //    // 大光圈控制器配置选项
    // _photoEditMultipleComponent.options.editApertureOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditApertureOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editApertureOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editApertureOptions.outputCompress = 0.95f;
    //
    //    // 暗角控制器功能控制器配置选项
    // _photoEditMultipleComponent.options.editVignetteOptions
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditVignetteOptions.html
    //    // 保存到临时文
    //    _photoEditMultipleComponent.options.editVignetteOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editVignetteOptions.outputCompress = 0.95f;
    //
    //    // 图片编辑涂抹控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditSmudgeOptions.html
    // _photoEditMultipleComponent.options.editSmudgeOptions
    //    // 默认的笔刷大小 (默认: lsqBrushMedium，中等粗细)
    //    _photoEditMultipleComponent.options.editSmudgeOptions.defaultBrushSize = lsqMediumBrush;
    //    // 是否保存上一次使用的笔刷 (默认: YES)
    //    _photoEditMultipleComponent.options.editSmudgeOptions.saveLastBrush = YES;
    //    // 默认撤销的最大次数 (默认: 5)
    //    _photoEditMultipleComponent.options.editSmudgeOptions.maxUndoCount = 5;
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editSmudgeOptions.saveToTemp = YES;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editSmudgeOptions.outputCompress = 0.95f;
    //
    //    // 图片编辑模糊控制器配置选项
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFEditWipeAndFilterOptions.html
    // _photoEditMultipleComponent.options.editWipeAndFilterOptions
    //    // 默认的笔刷大小 (默认: lsqBrushMedium，中等粗细)
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.defaultBrushSize = lsqMediumBrush;
    //    // 默认撤销的最大次数 (默认: 5)
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.maxUndoCount = 5;
    //    // 保存到临时文件
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.saveToTemp = YES;
    //    // 显示放大镜 (默认: true)
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.displayMagnifier = YES;
    //    // 笔刷效果强度 (默认: 0.2, 范围为0 ~ 1，值为1时强度最高)
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.brushStrength = 0.2f;
    //    // 照片输出压缩率 0-100 如果设置为0 将保存为PNG格式
    //    _photoEditMultipleComponent.options.editWipeAndFilterOptions.outputCompress = 0.95f;
    //
    // 设置图片
    _photoEditMultipleComponent.options.editMultipleOptions.saveToAlbum = NO;
    _photoEditMultipleComponent.options.editMultipleOptions.saveToTemp = NO;
    _photoEditMultipleComponent.inputImage = result.image;
    _photoEditMultipleComponent.inputTempFilePath = result.imagePath;
    _photoEditMultipleComponent.inputAsset = result.imageAsset;
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditMultipleComponent.autoDismissWhenCompelted = YES;
    // 当上一个页面是NavigationController时,是否通过 pushViewController 方式打开编辑器视图 (默认：NO，默认以 presentViewController 方式打开）
    // SDK 内部组件采用了一致的界面设计，会通过 push 方式打开视图。如果用户开启了该选项，在调用时可能会遇到布局不兼容问题，请谨慎处理。
    _photoEditMultipleComponent.autoPushViewController = YES;
    [_photoEditMultipleComponent showComponent];
}





#endif


#pragma mark take
- (void)takeVideo
{
    [self hideBackWindow];

#ifdef PublicJingPaiRelease
    
    [self jumpToPublicJingPai];
    
#else
    
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    self.imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    self.imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    //允许用户进行编辑
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.videoMaximumDuration = 8;
    self.imagePickerController.videoQuality = UIImagePickerControllerQualityType640x480;
    self.imagePickerController.cameraOverlayView = [self getCameraMaskView];
    self.imagePickerController.showsCameraControls = NO;
    //设置委托对象
    self.imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
#endif
    
    
}

#pragma mark - 跳转到发布竞拍界面
- (void)jumpToPublicJingPai
{
    ReleaseJingPaiViewController *jingpai = [[ReleaseJingPaiViewController alloc] initWithNibName:@"ReleaseJingPaiViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:jingpai animated:YES];
    
}

- (UIView *)getCameraMaskView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    UIImageView *backimageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cameraBackground"]];
    backimageview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [view addSubview:backimageview];
    
    UIView *topview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
    topview.backgroundColor = [UIColor clearColor];
    [view addSubview:topview];
    
    UIButton *closebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closebutton setTitle:@"X" forState:UIControlStateNormal];
    [closebutton addTarget:self action:@selector(closeMethod) forControlEvents:UIControlEventTouchUpInside];
    [closebutton setFrame:CGRectMake(0, 20, 40, 40)];
    [topview addSubview:closebutton];
    
    UIButton *changebutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [changebutton setImage:[UIImage imageNamed:@"zhuanhuanjingtou"] forState:UIControlStateNormal];
    [changebutton addTarget:self action:@selector(changebutton) forControlEvents:UIControlEventTouchUpInside];
    [changebutton setFrame:CGRectMake(kScreenWidth-60, 20, 40, 40)];
    [topview addSubview:changebutton];
    
    UIButton *guangbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [guangbutton setImage:[UIImage imageNamed:@"shanguangdeng"] forState:UIControlStateNormal];
    [guangbutton addTarget:self action:@selector(shanbutton) forControlEvents:UIControlEventTouchUpInside];
    [guangbutton setFrame:CGRectMake(kScreenWidth/2-20, 20, 40, 40)];

    
    UIView *bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-100, kScreenWidth, 100)];
    bottomview.backgroundColor = [UIColor clearColor];
    [view addSubview:bottomview];
    
    UIButton *albumbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumbutton setTitle:@"相册" forState:UIControlStateNormal];
    [albumbutton addTarget:self action:@selector(albumbutton) forControlEvents:UIControlEventTouchUpInside];
    [albumbutton setFrame:CGRectMake(0, 0, 60, 60)];
    [bottomview addSubview:albumbutton];
    
    UIButton *paibutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [paibutton setSelected:NO];
    [paibutton setImage:[UIImage imageNamed:@"luxiang"] forState:UIControlStateNormal];
    [paibutton addTarget:self action:@selector(paibutton:) forControlEvents:UIControlEventTouchUpInside];
    [paibutton setFrame:CGRectMake(kScreenWidth/2-30, 0, 60, 60)];
    [bottomview addSubview:paibutton];
    
    int bottomHeight = 280;
    if (kScreenWidth==320) {
        bottomHeight = 235;
    }else if(kScreenWidth==375)
    {
        bottomHeight = 270;
        
    }else
    {
        
        
    }
    
    self.daojishi = [[UILabel alloc] initWithFrame:CGRectMake(0, kScreenHeight-bottomHeight, kScreenWidth, 200)];
    self.daojishi.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.daojishi.font = [UIFont systemFontOfSize:20];
    self.daojishi.textAlignment = NSTextAlignmentCenter;
    self.daojishi.text = @"0";
    [view addSubview:self.daojishi];
    

    return view;
}

float daojishi = 0.0;

- (void)changeDaojishi
{
    daojishi+=0.1;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.daojishi.text = [NSString stringWithFormat:@"%.1f",daojishi];

    }];
    
}

- (void)closeMethod
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)changebutton
{
    if (self.imagePickerController.cameraDevice ==UIImagePickerControllerCameraDeviceRear ) {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }else {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }
    
}

- (void)shanbutton
{
    if (self.imagePickerController.cameraFlashMode ==UIImagePickerControllerCameraFlashModeOn ) {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }else {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
    }
    
}

- (void)albumbutton
{
    [self.imagePickerController dismissViewControllerAnimated:YES completion:^{
        [self takePictureWithType:isVideoType];
    }];
    
    
}

- (void)paibutton:(UIButton *)sender
{
    if (sender.selected) {
        sender.selected = NO;
        [self.imagePickerController stopVideoCapture];
        [self.daojishiTimer invalidate];

    }else
    {
        sender.selected = YES;
        [self.imagePickerController startVideoCapture];
        self.daojishiTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeDaojishi) userInfo:nil repeats:YES];

    }
    
}


#pragma  mark - 选取图片，相机和视频
- (void)takePhoto
{
    [self hideBackWindow];

    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    //设置图像选取控制器的类型为静态图像
    //用户是否有权限使用视频发布功能
    NSString *isShowVideo = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"is_show_video"];
    if ([isShowVideo isEqualToString:@"1"]) {
         imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
        imagePickerController.videoMaximumDuration = 8;
        imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    }else{
         imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    }

    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    
    
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)takePicture{
    [self takePictureWithType:isPhontoType];
}

-(void)takePictureWithType:(NSInteger)pickertype
{
    [self hideBackWindow];
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        [LeafNotification showInController:self withText:@"媒体格式暂不支持"];
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //用户是否有权限使用视频发布功能,
    NSString *isShowVideo = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"is_show_video"];
    if ([isShowVideo isEqualToString:@"1"]) {
        if (pickertype == isPhontoType) {
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
        }else if(pickertype == isVideoType){
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
        }
    }else{
    
        if (pickertype == isPhontoType) {
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
        }else if(pickertype == isVideoType){
            imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
        }
    }
    
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


#pragma mark notification

-(void)doJumpDetailJingpaiVC:(id)sender{
    
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSLog(@"%@",feedDict);
   
    MCJingpaiDetailController *jingpaiDetailVC = [[MCJingpaiDetailController alloc]init];

        MCHotJingpaiModel *model = [[MCHotJingpaiModel alloc]initWithDictionary:feedDict error:nil];
        jingpaiDetailVC.jingpaiID = model.info.auctionID;
        
        if ([getSafeString(model.info.opCode) isEqualToString:@"0"] ) {
            jingpaiDetailVC.isOnAuction = YES;
        }else{
            jingpaiDetailVC.isOnAuction = NO;
        }

    [self.navigationController pushViewController:jingpaiDetailVC animated:YES];
}

- (void)doJumpDetailAction:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSInteger currentIndex = [feedDict[@"index"] integerValue];

    @try {
        
        NSString *zhuantiPic = getSafeString(feedDict[@"array"][currentIndex][@"info"][@"object_parent_type"]);
        
        if ([zhuantiPic isEqualToString:@"10"]) {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            
            TaoXiViewController *taoxiVC = [[TaoXiViewController alloc]init];
            taoxiVC.view.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            
            NSDictionary *dict = @{@"albumId":getSafeString(feedDict[@"array"][currentIndex][@"info"][@"object_parent_id"])};
            taoxiVC.isHotFeedsTaoxi = YES;
            taoxiVC.dic = dict;
            taoxiVC.currentUid = getSafeString(uid);
//          [taoxiVC initWithHotFeedsDictionary:dict];
            
            //处理数据
            [self.navigationController pushViewController:taoxiVC animated:YES];
            
        }else{
        
            NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"user"][@"id"]];
            NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"id"]];
            PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
            browseVC.startWithIndex = 0;
            browseVC.currentUid = uid;
            [browseVC setDataFromPhotoId:photoId uid:uid];
            
            [self.navigationController pushViewController:browseVC animated:YES];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
}

- (void)doJumpVideoDetailAction:(id)sender
{
    
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDictAll = notify.object;
    NSInteger currentIndex = [feedDictAll[@"index"] integerValue];
    
    NSDictionary *feedDict = feedDictAll[@"array"][currentIndex];
    
    NSLog(@"%@",feedDictAll);
    
    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
    id photo = feedDict[@"info"];
    if (photo) {
        [detailVc requestWithVideoId:feedDict[@"info"][@"id"] uid:feedDict[@"user"][@"id"]];
    }else
    {
        [detailVc requestWithVideoId:feedDict[@"id"] uid:feedDict[@"uid"]];
        
    }
    detailVc.isFromTimeLine = YES;
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [self.navigationController pushViewController:detailVc animated:YES];
    
}

- (void)doJumpDaShangView:(NSDictionary *)itemDict
{
    NSDictionary *feedDict = itemDict;
    NSInteger currentIndex = [feedDict[@"index"] integerValue];
    NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"user"][@"id"]];
    NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"id"]];
    PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
    browseVC.startWithIndex = 0;
    browseVC.currentUid = uid;
    [browseVC setDataFromPhotoId:photoId uid:uid];

    [self.navigationController pushViewController:browseVC animated:YES];
    
}

- (void)doJumpDetailAction_guanzhu:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSInteger currentIndex = [feedDict[@"index"] integerValue];
    NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"user"][@"id"]];
    NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"id"]];
    PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
    browseVC.startWithIndex = 0;
    browseVC.currentUid = uid;
    [browseVC setDataFromPhotoId:photoId uid:uid];

    [self.navigationController pushViewController:browseVC animated:YES];
  
}

- (void)doCommitAction:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;

    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
    id photo = feedDict[@"info"];
    
    if (photo) {
        NSString *feedType = getSafeString(feedDict[@"info"][@"feedType"]);
        if ([feedType isEqualToString:@"6"]) {
            [detailVc requestWithPhotoId:feedDict[@"info"][@"id"] uid:feedDict[@"user"][@"id"]];
        }else{
            [detailVc requestWithVideoId:feedDict[@"info"][@"id"] uid:feedDict[@"user"][@"id"]];
        }

    }else
    {
        NSString *feedType = getSafeString(feedDict[@"object_type"]);
        if ([feedType isEqualToString:@"6"]) {
            [detailVc requestWithPhotoId:feedDict[@"id"] uid:feedDict[@"uid"]];
        }else{
            [detailVc requestWithVideoId:feedDict[@"id"] uid:feedDict[@"uid"]];
        }
        
    }
    detailVc.isFromTimeLine = YES;
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
     
    [self.navigationController pushViewController:detailVc animated:YES];
}

- (void)doJumpPersonCenter:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *itemDict = notify.object;
    NSString *uid = @"";
    NSString *userName = @"";

    if (itemDict[@"info"]) {
        uid = itemDict[@"info"][@"uid"];
    }else{
       uid = itemDict[@"uid"];
    }
        if (uid.length) {
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            [self.navigationController pushViewController:newMyPage animated:YES];
    }else{
        return;
    }
}

- (void)doTouchUpActionWithDict:(NSDictionary *)itemDict actionType:(NSInteger)type
{
    switch (type) {
        case McFeedActionTypeComment:{
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:itemDict[@"pid"] uid:itemDict[@"uid"]];
            detailVc.isFromTimeLine = YES;

            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case McFeedActionTypePhotoDetail:{
            
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            //未登录直接跳转登陆
            if (!uid) {
                UserDefaultSetBool(YES, @"isHiddenTabbar");
                [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
                [USER_DEFAULT synchronize];
                
                NewLoginViewController *loginVC = [[NewLoginViewController alloc]initWithNibName:[NSString stringWithFormat:@"NewLoginViewController"] bundle:nil];
                [self.navigationController pushViewController:loginVC animated:YES];
                
                return;
            }
            
            //红包打赏更换为礼品打赏
            NSDictionary *feedDict = itemDict;
            NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"id"]];
        
            NSString *dashangType;
            NSString *targetUid;
            
            if (feedDict[@"info"]) {
                dashangType = [NSString stringWithFormat:@"%@",getSafeString(feedDict[@"info"][@"object_type"])];
                targetUid = [NSString stringWithFormat:@"%@",feedDict[@"info"][@"uid"]];
                
            }else{
                dashangType = [NSString stringWithFormat:@"%@",getSafeString(feedDict[@"object_type"])];
                targetUid = [NSString stringWithFormat:@"%@",feedDict[@"uid"]];
                
            }

            self.dashang= [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            self.dashang.superController = self;
            self.dashang.currentPhotoId = photoId;
            self.dashang.animationType = @"dashangWithNoAnimation";
            self.dashang.dashangType = dashangType;
            self.dashang.targetUid = targetUid;
            
            [self.dashang setUpviews];
            [self.dashang addToWindow];
            

        }
            break;
        case McFeedActionTypePersonCenter:{
            
            
            NSString *userName = @"";
            NSString *uid = itemDict[@"uid"];
            
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            
            [self.navigationController pushViewController:newMyPage animated:YES];
        }
            
        default:
            break;
    }
}

#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [SingleData shareSingleData].currnetImageType = 1;
    [picker dismissViewControllerAnimated:NO completion:nil];
    daojishi = 0.0;
    [self.daojishiTimer invalidate];

    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];

    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];//不可编辑的
        //将该图像保存到媒体库中
        //        UIImageWriteToSavedPhotosAlbum(editedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        UIImage *image = editedImage;
        if (image.imageOrientation==UIImageOrientationRight) {
            image = [image imageRotatedByDegrees:90];
            
        }
        BOOL isAviary = UserDefaultGetBool(@"isUseAviary");
        if (isAviary) {
            
            
        }else
        {
            @try {
                AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
                addLabel.currentImage = image;
                [self presentViewController:addLabel animated:YES completion:nil];
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
        }
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
#ifdef TencentRelease
        //获取视频的thumbnail

        [self movieToImage:mediaURL];
        NSURL *videoUrl=mediaURL;
        NSString *moviePath = [videoUrl path];
        
        
        NSString *videoCacheDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/UploadPhoto/"];
        if (![[NSFileManager defaultManager] fileExistsAtPath:videoCacheDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:videoCacheDir withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *videoStringPath = @"";

        int value = arc4random();
        NSString *lastPathComponent = [NSString stringWithFormat:@"%d.mp4", value];
        videoStringPath = [videoCacheDir stringByAppendingPathComponent:lastPathComponent];
        [[NSFileManager defaultManager] copyItemAtPath:moviePath toPath:videoStringPath error:nil];
        self.videoURL = [NSURL URLWithString:videoStringPath];
        
#else
        //创建ALAssetsLibrary对象并将视频保存到媒体库
        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary writeVideoAtPathToSavedPhotosAlbum:mediaURL completionBlock:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                NSLog(@"captured video saved with no error.");
            }else
            {
                NSLog(@"error occured while saving the video:%@", error);
            }
        }];
#endif
        
        
    }
    
}


- (void)movieToImage:(NSURL *)movieURL
{
    NSURL *url = movieURL;
    
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:url options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
    CMTime thumbTime = CMTimeMakeWithSeconds(0,30);
    
    AVAssetImageGeneratorCompletionHandler handler =
    ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {       }//没成功
        
        UIImage *thumbImg = [UIImage imageWithCGImage:im];
        self.videoImage = thumbImg;
        [self performSelectorOnMainThread:@selector(gotoReleaseVideo) withObject:nil waitUntilDone:YES];
        
    };
    
    generator.maximumSize = self.view.frame.size;
    [generator generateCGImagesAsynchronouslyForTimes:
    [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
    
}

- (void)gotoReleaseVideo
{
    AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
    addLabel.currentImage = self.videoImage;
#ifdef TencentRelease
    
    addLabel.videoURL = self.videoURL;
    
#endif
    [self presentViewController:addLabel animated:YES completion:nil];
}

- (void)gotoReleaseImageWith:(UIImage *)image
{
    AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
    addLabel.currentImage = image;
    [self presentViewController:addLabel animated:YES completion:nil];
}

- (void)jumpViewController
{
    AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
    addLabel.currentImage = self.currentImage;
    [self.view.window.rootViewController presentViewController:addLabel animated:YES completion:nil];
 
}


//修改取消按钮颜色
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    for (UINavigationItem *item in navigationController.navigationBar.subviews) {
        
        if ([item isKindOfClass:[UIButton class]]&&([item.title isEqualToString:@"取消"]||[item.title isEqualToString:@"Cancel"]))
            
        {
            
            UIButton *button = (UIButton *)item;
            
            button.tintColor = [CommonUtils colorFromHexString:kLikeRedColor];
            
        }
      
    }
    
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        
    }
    else
    {
        
    }
}


-(NSString *)getSafeStr:(NSString *)str{
    if (str == nil) {
        str = @"";
    }
    return str;
}




#pragma mark - lazyLoading
-(McHotFeedViewController *)hotFeedVc{
    if (!_hotFeedVc) {
        _hotFeedVc = [[McHotFeedViewController alloc] init];
        _hotFeedVc.superNVC = self.navigationController;
    }
    
    return _hotFeedVc;
}

-(McMyFeedListViewController *)myFeedVC{
    if (!_myFeedVC) {
        _myFeedVC = [[McMyFeedListViewController alloc] init];
        _myFeedVC.isTabelViewStyle = YES;
    }
    return _myFeedVC;
}

-(McNearFeedViewController *)nearFeedVC{
    if (!_nearFeedVC) {
        _nearFeedVC = [[McNearFeedViewController alloc] init];
    }
    return _nearFeedVC;
}





@end
