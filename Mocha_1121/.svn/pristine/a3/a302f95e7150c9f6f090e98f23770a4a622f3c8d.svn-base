//
//  NewPersonalHeaderView.m
//  Mocha
//
//  Created by sun on 15/8/31.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewPersonalHeaderView.h"
#import "WatchedViewController.h"
#import "FansViewController.h"
#import "NewMyPageViewController.h"
#import "NewTimeLineViewController.h"
#import "McMyFeedListViewController.h"
#import "PhotoBrowseViewController.h"
#import "PersonCardViewController.h"
#import "BuildCropViewController.h"
#import "HeaderViewController.h"
#import "McMainFeedViewController.h"
#import "McWebViewController.h"
@implementation NewPersonalHeaderView


- (void)initViewWithData:(NSDictionary *)diction {
    NSString *bannar = [NSString stringWithFormat:@"%@",getSafeString(diction[@"bannar"])];
    
    _headerURL = [NSString stringWithFormat:@"%@",getSafeString(diction[@"headerURL"])];
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",_headerURL,[CommonUtils imageStringWithWidth:kDeviceWidth height:kDeviceWidth]];
    NSString *mokaNum = [NSString stringWithFormat:@"%@",getSafeString(diction[@"mokaNum"])];
    NSString *userType = [NSString stringWithFormat:@"%@",getSafeString(diction[@"userType"])];
    NSString *sex = [NSString stringWithFormat:@"%@",getSafeString(diction[@"sex"])];
    NSString *citys = [NSString stringWithFormat:@"%@",getSafeString(diction[@"citys"])];
    NSString *dongtaiNum = [NSString stringWithFormat:@"%@",getSafeString(diction[@"dongtaiNum"])];
    NSString *guanzhuNum = [NSString stringWithFormat:@"%@",getSafeString(diction[@"guanzhuNum"])];
    NSString *fensiNum = [NSString stringWithFormat:@"%@",getSafeString(diction[@"fensiNum"])];
    NSString *vip = [NSString stringWithFormat:@"%@",getSafeString(diction[@"vip"])];
    NSString *member = [NSString stringWithFormat:@"%@",getSafeString(diction[@"member"])];
    NSString *newFansCount = getSafeString(diction[@"newFansCount"]);
    
    if (citys.length<2) {
        citys = @"";
    }
    
    if ([member isEqualToString:@"1"]) {
        self.VipImageView.hidden = NO;
    }
    else{
        self.VipImageView.hidden = YES;
    }
    
    self.numberView.hidden = NO;
    self.userName = diction[@"nickname"];
    self.uid = diction[@"uid"];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (![newFansCount isEqualToString:@"0"] && [self.uid isEqualToString:uid]) {
        self.redImageView.hidden = NO;
    }else{
        self.redImageView.hidden = YES;
    }

    //------设置背景图片和图片提示图标
    if([bannar isEqualToString:@""]){
        //不存在图片链接，使用默认图
        self.backgroundImageView.image = [UIImage imageNamed:@"profile_bannar_bg"];
        NSString *currentUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if ([self.uid isEqualToString:currentUid]) {
            //仅当当前是本人界面而且没有更换过背景的时候，显示提示
            [self showChangeBgView:YES];
        }else{
            _changeBgView.hidden = YES;
        }
    }else{
        NSString *completeBannar = [NSString stringWithFormat:@"%@%@",bannar,[CommonUtils imageStringWithWidth:kDeviceWidth*6/5 height:kDeviceHeight *2/3]];
        UIImage *backImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:completeBannar];
        if (backImage) {
            self.backgroundImageView.image = backImage;
        }else{
            [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:bannar] placeholderImage:[UIImage imageNamed:@"profile_bannar_bg"]];
        }
        
        _changeBgView.hidden = YES;
    }
    self.backgroundImageView.clipsToBounds = YES;
  
    //------设置底部头像和等级的相关信息
    //头像
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.mokaNumber.text = mokaNum;
    self.userType.text = userType;
    self.sex.text = sex;
    self.citys.text = citys;
    if ([sex isEqualToString:@"男"]) {
        self.maleImageView.image = [UIImage imageNamed:@"newmale"];
    }else
    {
        self.maleImageView.image = [UIImage imageNamed:@"newfemale"];
    }
    self.dongtaiNum.text = dongtaiNum;
    self.guanzhuNum.text = guanzhuNum;
    self.fensiNum.text = fensiNum;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, 247);
    self.infoView.frame = CGRectMake(0, 119, kScreenWidth, 65);
    self.headerImageView.frame = CGRectMake(10, 0, 65,65);
    self.headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.headerImageView.layer.borderWidth = 1.0;
    self.headerImageView.layer.cornerRadius = 32.5;
    
    //显示等级
    CGFloat mokaNumberTop = 0;
    if ([vip isEqualToString:@"1"]) {
        mokaNumberTop = 0;
    }else{
        mokaNumberTop = 16;
    }

    //显示模卡号
    self.mokaNumber.frame = CGRectMake(90, mokaNumberTop, kScreenWidth-100, 21);
    if (self.mokaNumber.text) {
        CGSize mokaNumSize = [CommonUtils sizeFromText:self.mokaNumber.text textFont:self.mokaNumber.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth, 20)];
        self.mokaNumber.frame = CGRectMake(90, mokaNumberTop, mokaNumSize.width, 21);
        //vip标识
        self.VipImageView.frame = CGRectMake(95 + self.mokaNumber.width, mokaNumberTop+5 , 15, 10);
    }
    //用户身份
    self.userType.frame = CGRectMake(90,_mokaNumber.bottom, 60, 21);
    
    float space = -5;
    if (userType.length==2) {
        space = -20;
    }
    //性别标识
    self.maleImageView.frame = CGRectMake(150+space,_mokaNumber.bottom +5, 7, 11);
    //性别
    self.sex.frame = CGRectMake(160+space, _mokaNumber.bottom, 30, 21);
    //城市
    self.citys.frame = CGRectMake(190+space, _mokaNumber.bottom, kScreenWidth-160, 21);
    
    self.renZhengImg.hidden = NO;
    if ([vip isEqualToString:@"1"]) {
        //显示等级信息
        self.levelView.hidden = NO;
        NSString *levelInfo = diction[@"approve_content"];
        //levelInfo = @"3级认证";
        CGFloat levelWidth = [SQCStringUtils getCustomWidthWithText:levelInfo viewHeight:19 textSize:13] +10;
        _levelView.frame = CGRectMake(90, _userType.bottom+3, 19 +5 +levelWidth, 19);
        _levelView.backgroundColor = [CommonUtils colorFromHexString:@"#FABE00"];
        _levelView.layer.cornerRadius = 9.5;
        _levelView.layer.masksToBounds = YES;
        _renZhengImg.frame = CGRectMake(0, 0, 19, 19);
        _levelLabel.frame = CGRectMake(19 +5, 0, levelWidth , 19);
        _levelInfoBtn.frame = _levelView.bounds;
        _levelLabel.text = levelInfo;
        
    }else
    {
        self.levelView.hidden = YES;
    }

    //------设置动态、关注、粉丝
    self.dongtai.frame = CGRectMake(14, 27, 46, 21);
    self.guanzhu.frame = CGRectMake(kScreenWidth/2-23, 27, 46, 21);
    self.fensi.frame = CGRectMake(kScreenWidth-70, 27, 46, 21);

    self.dongtaiNum.frame = CGRectMake(14, 8, 46, 21);
    self.guanzhuNum.frame = CGRectMake(kScreenWidth/2-23, 8, 46, 21);
    self.fensiNum.frame = CGRectMake(kScreenWidth-70, 8, 46, 21);

    self.numberView.frame = CGRectMake(0, 191, kScreenWidth, 56);
    self.lineView.frame = CGRectMake(0, 55, kScreenWidth, 1);
    self.backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, 190);
    self.backgroundButton.frame = CGRectMake(0, 0, kScreenWidth, 190);

    self.dongtaiButton.frame = CGRectMake(14, 8, 64, 57);
    self.guanzhuButton.frame = CGRectMake(kScreenWidth/2-23, 8, 64, 57);
    self.fensiButton.frame = CGRectMake(kScreenWidth-70, 8, 64, 57);
    self.redImageView.frame = CGRectMake(kScreenWidth - 35, 10, 10, 10);
    self.redImageView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.redImageView.layer.cornerRadius = 5;
    self.redImageView.clipsToBounds = YES;
    
    self.MokaCardView.layer.cornerRadius = 5;
    self.MokaCardView.frame = CGRectMake(kDeviceWidth - 100 - 10, 10, 100, 32);
    
    //-----身价展示
    if (_personValueCtrol == nil) {
        _personValueCtrol = [[UIControl alloc] initWithFrame:CGRectZero];
        //_personValueCtrol.backgroundColor = [UIColor orangeColor];
        [self addSubview:_personValueCtrol];

        _personValueImgView = [[UIImageView alloc]initWithFrame:_personValueCtrol.bounds];
        _personValueImgView.image = [UIImage imageNamed:@"personValueGrade_2"];
        [_personValueCtrol addSubview:_personValueImgView];
        
        _personValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //_personValueLabel.backgroundColor= [UIColor redColor];
        _personValueLabel.textAlignment = NSTextAlignmentLeft;
        _personValueLabel.text = @"0";
        _personValueLabel.textColor = [UIColor whiteColor];
        _personValueLabel.font = [UIFont systemFontOfSize:13];
        [_personValueImgView addSubview:_personValueLabel];
        //审核环境隐藏身价
        BOOL isAppearShenJia = [USER_DEFAULT boolForKey:ConfigShang];
        if (isAppearShenJia) {
            [_personValueCtrol addTarget:self action:@selector(pushToPersonValue) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    //身价跳转链接
    _rankUrl = diction[@"rankUrl"];

    //需要Label的长度
    CGFloat personValueInfoLength = [SQCStringUtils getCustomWidthWithText:[NSString stringWithFormat:@"身价:%@",diction[@"rank"]] viewHeight:30 textSize:14];
    //设置frame
    if (personValueInfoLength <40) {
        _personValueCtrol.frame = CGRectMake(kDeviceWidth -100, 10, 75, 21+10);
        _personValueImgView.frame= CGRectMake(0, 5, _personValueCtrol.width, 21) ;
        _personValueLabel.frame = CGRectMake(28, 4, _personValueImgView.width -28 -5, 17);
        
    }else{
        CGFloat personValueWidth = personValueInfoLength +28 +5;
        _personValueCtrol.frame = CGRectMake(kDeviceWidth -personValueWidth -10, 10, personValueWidth, 21+10);
        _personValueImgView.frame = CGRectMake(0, 5, _personValueCtrol.width, 21);
        _personValueLabel.frame = CGRectMake(28, 4, personValueInfoLength, 17);
    }
    //等级值图片
    NSString *imgStr = [NSString stringWithFormat:@"personValueGrade_%@",diction[@"currLevel"]];
    UIImage *image =  [UIImage imageNamed:imgStr];
    image = [image stretchableImageWithLeftCapWidth:35 topCapHeight:0];
    _personValueImgView.image = image;
    _personValueLabel.text = [NSString stringWithFormat:@"身价:%@",diction[@"rank"]];
    
    self.clipsToBounds = NO;
    
}

//截图视图
- (UIImage *)snapshot:(UIView *)view
{
    //创建画布
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    //绘制图片
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    //从当前画布得到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭画布,很占内存
    UIGraphicsEndImageContext();
    
    
    return image;
    
}

- (void)resetBackView
{
    self.backgroundImageView.frame = CGRectMake(0, 0, kScreenWidth, 190);
    
    self.numberView.hidden = YES;
}


//点头像响应
- (IBAction)headerBut:(UIButton *)sender {
    NSLog(@"headerAction");
     HeaderViewController *headerVC = [[HeaderViewController alloc]initWithNibName:@"HeaderViewController" bundle:[NSBundle mainBundle]];
    if (self.headerImageView.image) {
        headerVC.headerURL = self.headerURL;
        headerVC.nickNameStr = self.userName;
        [self.supCon.navigationController pushViewController:headerVC animated:YES];
    }
}

//点名片响应
- (IBAction)CardBut:(UIButton *)sender {
    NSLog(@"jumpToPersonCardViewController");
    PersonCardViewController *personCardVC = [[PersonCardViewController alloc]init];
    personCardVC.supViewController = (NewMyPageViewController *)self.supCon;
    personCardVC.curruid = [NSString stringWithFormat:@"%@",self.uid];
    personCardVC.nickName = [NSString stringWithFormat:@"%@",self.userName];
    personCardVC.mokaNum = [NSString stringWithFormat:@"%@",self.mokaNumber.text];
    
    [self.supCon.navigationController pushViewController:personCardVC animated:YES];
}


//换背景图响应
- (IBAction)changeheader:(id)sender {
    
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
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.supCon];
        return;
    }
    NSLog(@"changeheader");
    NSString *currentUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([self.uid isEqualToString:currentUid]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                
                                                  otherButtonTitles:@"相机", @"从手机相册中选择", nil];
        [sheet showInView:self.supCon.view];
    }
    
}

#pragma mark - 事件点击
//进入动态
- (IBAction)dongtaiMethod:(id)sender {
    NSLog(@"dongtaiMethod");
    
    
//#ifdef TencentRelease
////    
////    McMyFeedListViewController *newMyPage = [[McMyFeedListViewController alloc] init];
////    newMyPage.currentUid = self.uid;
////    newMyPage.currentTitle = self.userName;
////    newMyPage.isPersonDongTai = YES;
////    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
////    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
    
    //原有的collection显示动态模式
//    McMainFeedViewController *mainFeedVC = [[McMainFeedViewController alloc]init];
//    mainFeedVC.currentTitle = self.userName;
//    mainFeedVC.currentUid = self.uid;
//    
//    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
//    [self.supCon.navigationController pushViewController:mainFeedVC animated:YES];
//#else
    
    McMyFeedListViewController *newMyPage = [[McMyFeedListViewController alloc] init];
    newMyPage.currentUid = self.uid;
    newMyPage.currentTitle = self.userName;
    newMyPage.isTabelViewStyle = YES;
    newMyPage.isPersonDongTai = YES;

    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];

//#endif
  
}

//进入关注
- (IBAction)guanzhuMethod:(id)sender {
    NSLog(@"guanzhuMethod");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.supCon];
        return;
    }
    WatchedViewController *watch = [[WatchedViewController alloc] initWithNibName:@"WatchedViewController" bundle:[NSBundle mainBundle]];
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [watch setWatchedDataWithUid:self.uid];
    watch.isAllowDelete = YES;
    NSString *titleStr = NSLocalizedString(@"me", nil);;
    NSString *uidself = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (![self.uid isEqualToString:uidself]) {
        titleStr = self.userName;
    }
    watch.selfTitle = titleStr;
    [self.supCon.navigationController pushViewController:watch animated:YES];
    
}


//点击身价按钮
- (IBAction)personValueBtnClick:(id)sender {
    
}






//查看粉丝
- (IBAction)fensiMethod:(id)sender {
    NSLog(@"fensiMethod");
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.supCon];
        return;
    }
    
    FansViewController *fans = [[FansViewController alloc] init];
    [fans setFansDataWithUid:self.uid];
    NSString *titleStr = NSLocalizedString(@"me", nil);;
    NSString *uidself = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (![self.uid isEqualToString:uidself]) {
        titleStr = self.userName;
    }
    fans.selfTitle = titleStr;
    [self.supCon.customTabBarController hidesTabBar:YES animated:NO];
    [self.supCon.navigationController pushViewController:fans animated:YES];
    
}









+ (NewPersonalHeaderView *)getNewPersonalHeaderView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewPersonalHeaderView" owner:self options:nil];
    NewPersonalHeaderView *cell = array[0];
    [cell resetBackView];
    return cell;
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0) {
        [self takePhoto];
    }else if(buttonIndex==1)
    {
        [self takePicture];
    }
    
}

- (IBAction)levelInfoBtnClick:(id)sender {
    
    
}


- (void)pushToPersonValue{
    NSLog(@"进身价界面");
    McWebViewController *webVC = [[McWebViewController alloc] init];
    //http://yzh.api.mokacool.com/ucenter/rank?uid=
    //    NSString *shenJia = [NSString stringWithFormat:@"http://yzh.api.mokacool.com%@",PathUcenter_Rank];
    //    webVC.webUrlString = [NSString stringWithFormat:@"%@uid=%@",shenJia,self.uid];
    webVC.webUrlString = _rankUrl;
    webVC.needAppear = YES;
    [self.supCon.navigationController pushViewController:webVC animated:YES];
    
}




#pragma mark - 显示更换背景图的标记
- (void)showChangeBgView:(BOOL)show{
    //添加更换背景图片的提示视图
    //即：如果是本人,但是没有更换过个人中心的背景图片
    //那么会出现提示用户更换的提示文字
    if(_changeBgView ==nil){
        _changeBgView = [[UIControl alloc] initWithFrame:CGRectMake((self.frame.size.width-110)/2,(190-25)/2, 110, 25)];
        _changeBgView.backgroundColor = [UIColor blackColor];
        _changeBgView.alpha = 0.3;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5,5, 15, 15)];
        imgView.image = [UIImage imageNamed:@"mobang"];
        [_changeBgView addSubview:imgView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 80, 25)];
        //label.backgroundColor = [UIColor purpleColor];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        label.text = @"点击更换背景";
        [_changeBgView addSubview:label];
        _changeBgView.hidden = YES;
        [_changeBgView addTarget:self action:@selector(changeheader:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_changeBgView];
    }
    self.changeBgView.hidden = NO;
    
}




#pragma mark photo
- (void)takePicture
{
    [SingleData shareSingleData].currnetImageType = 2;
    
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"sorry, no photo library is unavailable.");
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self.supCon presentViewController:imagePickerController animated:YES completion:nil];
    
}
- (void)takePhoto
{
    [SingleData shareSingleData].currnetImageType = 2;
    
    //检查相机模式是否可用
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSLog(@"sorry, no camera or camera is unavailable.");
        return;
    }
    
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为相机模式
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //设置图像选取控制器的类型为静态图像
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self.supCon presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //打印出字典中的内容
    NSLog(@"get the media info: %@", info);
    //获取媒体类型
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    //判断是静态图像还是视频
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        //获取用户编辑之后的图像
        UIImage* editedImage = [info objectForKey:UIImagePickerControllerOriginalImage];//不可编辑的
        UIImage *image = editedImage;
        if (image.imageOrientation==UIImageOrientationRight) {
            image = [image imageRotatedByDegrees:90];
            
        }
        BOOL isAviary = UserDefaultGetBool(@"isUseAviary");
        if (isAviary) {
            
            
        }else
        {
//            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
            //    //2M以下不压缩
            if (imageData.length/1024 > 1024 * 5) {
                imageData = UIImageJPEGRepresentation(image, 0.3);
            }
            while (imageData.length/1024 > 2048) {
                imageData = UIImageJPEGRepresentation(image, 0.6);
                image = [UIImage imageWithData:imageData];
            }

            BuildCropViewController *buildCrop = [[BuildCropViewController alloc]initWithImageData:imageData];
            buildCrop.cardType = 18;
            buildCrop.delegate = self;
            buildCrop.originImage = image;
            [self.supCon.navigationController pushViewController:buildCrop animated:YES];
        }
 
    }else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
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
    }
    
}

-(void)finishCropImage:(UIImage *)image{
    [self uploadBackGroundViewWith:image];
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
 
- (void)uploadBackGroundViewWith:(UIImage *)image
{
    NSString *uid = @"";
    uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    //    //2M以下不压缩
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(image, 0.3);
    }
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
        image = [UIImage imageWithData:imageData];
    }

    NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid tags:@"" title:@"" type:5 file:@"file"];
    NSLog(@"%@",dict);
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@ test SVN",data);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *diction = (NSDictionary *)data;
            NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
            if ([str isEqualToString:@"0"]) {
                NSString *urlString = @"";
                NSInteger wid = (NSInteger)(self.backgroundImageView.frame.size.width)*2;
                NSInteger hei = (NSInteger)(self.backgroundImageView.frame.size.height)*2;
                NSLog(@"hahahahahah  width:%d  height:%d",wid,hei);
                
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                urlString = [NSString stringWithFormat:@"%@%@",diction[@"data"][@"url"],jpg];

                [self.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
                //已经设置了图片就关闭提示视图
                _changeBgView.hidden = YES;

            }else{
                [LeafNotification showInController:self.supCon withText:diction[@"msg"]];
            }
        });
        
        
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self.supCon withText:@"当前网络不太顺畅哟"];

    }];
}



 
@end
