//
//  SHDongTaiViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "SHDongTaiViewController.h"
#import "RNBlurModalView.h"
#import "McMyFeedListViewController.h"
#import "McHotFeedViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "PhotoViewDetailController.h"
#import "PhotoBrowseViewController.h"
#import "AddLabelViewController.h"
#import <TuSDKGeeV1/TuSDKCPPhotoEditComponent.h>
#import <TuSDKGeeV1/TuSDKGeeV1.h>
#import "McReportViewController.h"

@interface SHDongTaiViewController () <UIActionSheetDelegate,TuSDKPFCameraDelegate,McBaseFeedControllerDelegate,RNBlurModalViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    TuSDKCPPhotoEditComponent *_photoEditComponent;
    
}
@property (nonatomic, assign) NSInteger seletedIndex;
@property (strong, nonatomic) UISegmentedControl *segControl;
@property (strong, nonatomic) McHotFeedViewController *hotFeedVc;
@property (strong, nonatomic) McMyFeedListViewController *myFeedVC;
@property (strong, nonatomic) UIImage *currentImage;
@property (copy, nonatomic) NSString *currentUid;
@property (strong, nonatomic) UIActionSheet *jubaoSheet;


@end

@implementation SHDongTaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 启动GPS
    [TuSDKTKLocation shared].requireAuthor = YES;
    
    self.navigationItem.leftBarButtonItem = nil;
    
    _segControl = [[UISegmentedControl alloc] initWithItems:@[@"热门动态",@"关注动态"]];
    _segControl.frame = CGRectMake((kScreenWidth - 160)/2, 24.0, 160, 30.0);
    _segControl.selectedSegmentIndex = 0;//设置默认选择项索引
    _segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [_segControl addTarget:self action:@selector(doSelectedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segControl;
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = kScreenHeight - kTabBarHeight - kNavHeight;
    self.view.frame = viewFrame;
    
    [self showViewControllerAtIndex:_segControl.selectedSegmentIndex];
    
    NSLog(@"feed:%@,%f",self.view,kScreenHeight);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailAction:) name:@"doJumpDetailAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpDetailAction_guanzhu:) name:@"doJumpDetailAction_guanzhu" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doCommitAction:) name:@"doCommitAction" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpPersonCenter:) name:@"doJumpPersonCenter" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doJumpJuBao:) name:@"doJumpJuBao" object:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 30.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"发布" forState:UIControlStateNormal];
    //    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(releaseMethod:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.jubaoSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"举报", nil];
    
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

- (void)releaseMethod:(id)sender
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
        return;
    }
    [self showAddPhoto];
    
}

- (void)doJumpJuBao:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    
    NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"user"][@"id"]];
    self.currentUid = uid;
    
    [self.jubaoSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if (uid) {
            //
            
            McReportViewController *report = [[McReportViewController alloc] init];
            report.targetUid = self.currentUid;
            [self.navigationController pushViewController:report animated:YES];
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            
        }
    }
    
    
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

#pragma mark RNBlurModalViewDelegate
- (void)RNBlurModalViewAtIndex:(NSInteger)index
{
    /* ning ning
     McUploadPhotoViewController *uploadVC = [[McUploadPhotoViewController alloc] init];
     UINavigationController *naviVC = [[UINavigationController alloc] initWithRootViewController:uploadVC];
     uploadVC.takeType = index + 1;
     [_customTabBarController presentViewController:naviVC animated:YES completion:nil];
     */
    
    //sqc
    
    [SingleData shareSingleData].currnetImageType = 1;
    if (index==0) {
        [self takePicture];
        
    }else
    {
        [self takePhoto];
        
    }
    
}

#pragma mark - cameraComponentHandler TuSDKPFCameraDelegate
- (void)showCameraController;
{
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKPFCameraOptions.html
    TuSDKPFCameraOptions *opt = [TuSDKPFCameraOptions build];
    
    // 视图类 (默认:TuSDKPFCameraView, 需要继承 TuSDKPFCameraView)
    // opt.viewClazz = [TuSDKPFCameraView class];
    
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
    // opt.avPostion = [AVCaptureDevice firstBackCameraPosition];
    
    // 设置分辨率模式
    // opt.sessionPreset = AVCaptureSessionPresetHigh;
    
    // 闪光灯模式 (默认:AVCaptureFlashModeOff)
    // opt.defaultFlashMode = AVCaptureFlashModeOff;
    
    // 是否开启滤镜支持 (默认: 关闭)
    opt.enableFilters = YES;
    
    // 默认是否显示滤镜视图 (默认: 不显示, 如果enableFilters = NO, showFilterDefault将失效)
    opt.showFilterDefault = YES;
    
    // 开启滤镜历史记录
    opt.enableFilterHistory = YES;
    
    // 开启在线滤镜
    opt.enableOnlineFilter = YES;
    
    // 显示滤镜标题视图
    opt.displayFilterSubtitles = YES;
    
    // 滤镜列表行视图宽度
    // opt.filterBarCellWidth = 75;
    
    // 滤镜列表选择栏高度
    // opt.filterBarHeight = 100;
    
    // 滤镜分组列表行视图类 (默认:TuSDKCPGroupFilterGroupCell, 需要继承 TuSDKCPGroupFilterGroupCell)
    // opt.filterBarGroupCellClazz = [TuSDKCPGroupFilterGroupCell class];
    
    // 滤镜列表行视图类 (默认:TuSDKCPGroupFilterItemCell, 需要继承 TuSDKCPGroupFilterItemCell)
    // opt.filterBarTableCellClazz = [TuSDKCPGroupFilterItemCell class];
    
    // 需要显示的滤镜名称列表 (如果为空将显示所有自定义滤镜)
    // 滤镜名称参考 TuSDK.bundle/others/lsq_tusdk_configs.json
    // filterGroups[]->filters[]->name lsq_filter_%{Brilliant}
    // opt.filterGroup = @[@"SkinNature", @"SkinPink", @"SkinJelly", @"SkinNoir", @"SkinRuddy", @"SkinPowder", @"SkinSugar"];
    
    // 是否保存最后一次使用的滤镜
    opt.saveLastFilter = YES;
    
    // 自动选择分组滤镜指定的默认滤镜
    opt.autoSelectGroupDefaultFilter = YES;
    
    // 开启滤镜配置选项
    opt.enableFilterConfig = YES;
    
    // 视频视图显示比例 (默认：0， 0 <= mRegionRatio, 当设置为0时全屏显示)
    // opt.cameraViewRatio = 0.75f;
    
    // 视频视图显示比例类型 (默认:lsqRatioAll, 如果设置cameraViewRatio > 0, 将忽略ratioType)
    opt.ratioType = lsqRatioAll;
    
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
    
    TuSDKPFCameraViewController *controller = opt.viewController;
    // 添加委托
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
    [controller dismissModalViewControllerAnimated:YES];
    
    self.currentImage = [result loadResultImage];
    
    [self performSelector:@selector(jumpViewController) withObject:nil afterDelay:0.5];
}

#pragma mark take

- (void)takePhoto
{
    
    //    // 开启访问相机权限
    //    [TuSDKTSDeviceSettings checkAllowWithType:lsqDeviceSettingsCamera
    //                                    completed:^(lsqDeviceSettingsType type, BOOL openSetting)
    //     {
    //         if (openSetting) {
    //             lsqLError(@"Can not open camera");
    //             return;
    //         }
    //         [self showCameraController];
    //     }];
    
    
    //    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    imagePickerController.videoMaximumDuration = 8;
    imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)takePicture
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"sorry, no photo library is unavailable.");
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage,(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)doSelectedControl:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    
    [self showViewControllerAtIndex:segControl.selectedSegmentIndex];
}

- (void)showViewControllerAtIndex:(NSInteger)index
{
    self.seletedIndex = index;
    
    if (index == 0) {
        if (!_hotFeedVc) {
            _hotFeedVc = [[McHotFeedViewController alloc] init];
            //            [_hotFeedVc requestGetList];
            _hotFeedVc.feedDelegate =self;
            _hotFeedVc.view.frame = self.view.bounds;
            [self.view addSubview:_hotFeedVc.view];
        }
        else{
            _hotFeedVc.view.frame = self.view.bounds;
            _hotFeedVc.feedDelegate =self;
            [self.view addSubview:_hotFeedVc.view];
        }
    }
    else{
        if (_myFeedVC) {
            _myFeedVC.view.frame = self.view.bounds;
            _myFeedVC.feedDelegate =self;
            [self.view addSubview:_myFeedVC.view];
        }
        else{
            _myFeedVC = [[McMyFeedListViewController alloc] init];
            NSString *uid = [USER_DEFAULT valueForKey:MOKA_USER_VALUE][@"id"];
            _myFeedVC.isNeedToAppearBar = YES;
            _myFeedVC.currentUid = uid;
            _myFeedVC.feedDelegate =self;
            _myFeedVC.view.frame = self.view.bounds;
            [self.view addSubview:_myFeedVC.view];
            
        }
    }
}

#pragma mark notification
- (void)doJumpDetailAction:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    NSInteger currentIndex = [feedDict[@"index"] integerValue];
    NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"user"][@"id"]];
    NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"array"][currentIndex][@"id"]];
    PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
    browseVC.startWithIndex = 0;
    browseVC.currentUid = uid;
    //    [browseVC setDataFromFeedArray:feedDict[@"array"]];
    //    browseVC.dataArray = feedDict[@"array"];
    [browseVC setDataFromPhotoId:photoId uid:uid];
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
    [self.navigationController pushViewController:browseVC animated:YES];
    
    
    
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
    //    [browseVC setDataFromFeedArray:feedDict[@"array"]];
    //    browseVC.dataArray = feedDict[@"array"];
    [browseVC setDataFromPhotoId:photoId uid:uid];
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
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
    //    [browseVC setDataFromFeedArray:feedDict[@"array"]];
    //    browseVC.dataArray = feedDict[@"array"];
    [browseVC setDataFromPhotoId:photoId uid:uid];
    
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
    
    [self.navigationController pushViewController:browseVC animated:YES];
    
}

- (void)doCommitAction:(id)sender
{
    NSNotification *notify = (NSNotification *)sender;
    NSDictionary *feedDict = notify.object;
    
    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
    id photo = feedDict[@"photo"];
    if (photo) {
        [detailVc requestWithPhotoId:feedDict[@"photo"][@"id"] uid:feedDict[@"user"][@"id"]];
        
    }else
    {
        [detailVc requestWithPhotoId:feedDict[@"id"] uid:feedDict[@"uid"]];
        
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
    
    NSString *userName = @"";
    NSString *uid = itemDict[@"user"][@"id"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
    
    [self.navigationController pushViewController:newMyPage animated:YES];
}

- (void)doTouchUpActionWithDict:(NSDictionary *)itemDict actionType:(NSInteger)type
{
    switch (type) {
        case McFeedActionTypeComment:{
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:itemDict[@"pid"] uid:itemDict[@"uid"]];
            detailVc.isFromTimeLine = YES;
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
            
            [self.navigationController pushViewController:detailVc animated:YES];
        }
            break;
        case McFeedActionTypePhotoDetail:{
            NSDictionary *feedDict = itemDict;
            NSString *uid = [NSString stringWithFormat:@"%@",feedDict[@"user"][@"id"]];
            NSString *photoId = [NSString stringWithFormat:@"%@",feedDict[@"photo"][@"id"]];
            PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
            browseVC.startWithIndex = 0;
            browseVC.currentUid = uid;
            browseVC.isNeedShangView = @"1";
            //    [browseVC setDataFromFeedArray:feedDict[@"array"]];
            //    browseVC.dataArray = feedDict[@"array"];
            [browseVC setDataFromPhotoId:photoId uid:uid];
            
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
            
            [self.navigationController pushViewController:browseVC animated:YES];
        }
            break;
        case McFeedActionTypePersonCenter:{
            
            
            NSString *userName = @"";
            NSString *uid = itemDict[@"uid"];
            
            NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
            newMyPage.currentTitle = userName;
            newMyPage.currentUid = uid;
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
            
            
            [self.navigationController pushViewController:newMyPage animated:YES];
        }
            
        default:
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    
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
            //            [self showNewImageEditerWith:image path:mediaURL.absoluteString];
            //            return;
            AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
            addLabel.currentImage = image;
            [self presentViewController:addLabel animated:YES completion:nil];
            
        }
        
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
#ifdef QiniuRelease
        //获取视频的thumbnail
        MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:mediaURL];
        UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
        [player stop];
        
        player = nil;
        AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
        addLabel.currentImage = thumbnail;
        addLabel.videoURL = mediaURL;
        [self presentViewController:addLabel animated:YES completion:nil];
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

- (void)hideTabbar
{
    
    
}

- (void)jumpViewController
{
    AddLabelViewController *addLabel = [[AddLabelViewController alloc] initWithNibName:@"AddLabelViewController" bundle:[NSBundle mainBundle]];
    addLabel.currentImage = self.currentImage;
    [self.view.window.rootViewController presentViewController:addLabel animated:YES completion:nil];
    //    [self presentViewController:addLabel animated:YES completion:nil];
}


- (void)showNewImageEditerWith:(UIImage *)image path:(NSString *)path
{
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.6];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.7];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.8];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:0.9];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:1.0];
    [self performSelector:@selector(hideTabbar) withObject:nil afterDelay:1.1];
    
    // 组件选项配置
    // @see-http://tusdk.com/docs/ios/api/Classes/TuSDKCPPhotoEditComponent.html
    _photoEditComponent =
    [TuSDKGeeV1 photoEditCommponentWithController:self
                                    callbackBlock:^(TuSDKResult *result, NSError *error, UIViewController *controller)
     {
         // 获取图片失败
         if (error) {
             lsqLError(@"editAdvanced error: %@", error.userInfo);
             return;
         }
         [result logInfo];
         self.currentImage = [result loadResultImage];
         [controller popViewControllerAnimated:YES];
         [self performSelector:@selector(jumpViewController) withObject:nil afterDelay:0.5];
         
     }];
    
    
    // 设置图片
    _photoEditComponent.inputImage = image;
    _photoEditComponent.inputTempFilePath = path;
    
    // 是否在组件执行完成后自动关闭组件 (默认:NO)
    _photoEditComponent.autoDismissWhenCompelted = YES;
    [_photoEditComponent showComponent];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    if (!error) {
        NSLog(@"picture saved with no error.");
    }
    else
    {
        NSLog(@"error occured while saving the picture%@", error);
    }
}

#pragma Photo Editor Delegate Methods

// This is called when the user taps "Done" in the photo editor.
- (void)photoEditor:(AVYPhotoEditorController *)editor
  finishedWithImage:(UIImage *)image
{
    
}



// This is called when the user taps "Cancel" in the photo editor.
- (void) photoEditorCanceled:(AVYPhotoEditorController *)editor
{
    
}

@end
