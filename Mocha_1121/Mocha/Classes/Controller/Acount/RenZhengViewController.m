//
//  RenZhengViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/1/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "RenZhengViewController.h"
#import "PersonPageViewModel.h"

@interface RenZhengViewController () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *renzhengIcon;
//@property (weak, nonatomic) IBOutlet UIImageView *renzhengContent;

//显示认证的介绍Label
@property (weak, nonatomic) IBOutlet UILabel *renzhengDetailLabel;
//认证提示文字
@property (nonatomic,copy)NSString *renzhengTxt;
@property (nonatomic,copy)NSString *failRenzhengTxt;


@property (weak, nonatomic) IBOutlet UIImageView *renzhengContentIcon;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bottomLine;
@property (weak, nonatomic) IBOutlet UIImageView *topLine;
@property (weak, nonatomic) IBOutlet UIImageView *threeLine;

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIView *addPhotoView;
@property (weak, nonatomic) IBOutlet UIImageView *addImageView;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;
@property (weak, nonatomic) IBOutlet UILabel *remindLab;
@property (weak, nonatomic) IBOutlet UIButton *showBtn;

@property (retain, nonatomic) IBOutlet UIImageView *bigImageView; //weak

@property (strong, nonatomic) PersonPageViewModel *pViewModel;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (strong, nonatomic) NSString *headPic;



@end

@implementation RenZhengViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self notRenzheng];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doCloseShowImage:)];
    [_bigImageView addGestureRecognizer:tap];

    self.title = @"资质认证";
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    [self requestGetUserInfoWithUid_renzheng:uid];
    
    
    //_renzhengDetailLabel.backgroundColor = [UIColor orangeColor];
    _renzhengDetailLabel.font  = [UIFont systemFontOfSize:15];
    _renzhengDetailLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    //显示文本
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    _renzhengTxt = [descriptionDic objectForKey:@"auth_tips"];
    _failRenzhengTxt= [descriptionDic objectForKey:@"auth_failed"];
     if(_renzhengTxt.length == 0){
        _renzhengTxt  =@"认证前请完善个人资料，确保真实。再根据下面的步骤要求，上传本人清晰照片。经纪人将在2-3个工作日内完成资质审，通过后，方可接通知，并且验证后身高、体重、生日将不能修。";
     }
    if (_failRenzhengTxt.length == 0) {
        _failRenzhengTxt = @"亲，您的身份验证失败，可能您的资料不全或者有误，您可以重新提交自己的资料或者联系我们。";
    }
    _renzhengDetailLabel.numberOfLines = 0;
    
}

- (void)initViews
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark action
- (IBAction)submitDone:(id)sender {
    if([self.pViewModel.authentication isEqualToString:@"-1"])//未认证
    {
        if (![self isFinishInformation]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"请先完善资料,再提交审核.";
            self.hud.removeFromSuperViewOnHide = YES;
            
            [self.hud hide:YES afterDelay:2.0];
            return;
        }
        
        if(!_headPic){
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"请上传身份证.";
            self.hud.removeFromSuperViewOnHide = YES;
            
            [self.hud hide:YES afterDelay:2.0];
            return;
        }else
        {
            [self doingRenzheng];
            [self sendRenZhengRequest];
            [self isHadImage:2];
        }
        
        
    }else if ([self.pViewModel.authentication isEqualToString:@"-2"])//认证失败
    {
        if (![self isFinishInformation]) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"请上传身份证.";
            self.hud.removeFromSuperViewOnHide = YES;
            
            [self.hud hide:YES afterDelay:2.0];
            return;
        }
        if(!_headPic){
            
        }else
        {
            [self doingRenzheng];
            [self sendRenZhengRequest];
        }
        
    }else if ([self.pViewModel.authentication isEqualToString:@"0"])//审核中
    {
//        [self doingRenzheng];
        [self isHadImage:2];
        
    }else  //审核成功
    {
//        [self successRenzheng];
    }
    
}

- (IBAction)doAddPhoto:(id)sender
{
    UIActionSheet *choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"拍照", @"相册", nil];
    
    
    [choosePhotoActionSheet showInView:self.view];
}

- (IBAction)doShowBigImage:(id)sender
{
    NSLog(@"doShowBigImage");
//    _bigImageView.hidden = NO;
//    _mainView.hidden = YES;
//    if (!_headPic) {
//        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
//        _headPic = [USER_DEFAULT objectForKey:MOKA_USER_LOGO][uid];
//    }
//    
//    NSString *jpg = [CommonUtils imageStringWithWidth:kScreenWidth height:kScreenWidth];
//    NSString *headUrl = [NSString stringWithFormat:@"%@%@",_headPic,jpg];
//    [_bigImageView sd_setImageWithURL:[NSURL URLWithString:headUrl]];
}

- (IBAction)doCloseShowImage:(id)sender
{
    NSLog(@"doCloseShowImage");
    _bigImageView.hidden = YES;
    _mainView.hidden = NO;
}

- (void)sendRenZhengRequest
{
    
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    [dict setValue:@"0" forKey:@"authentication"];

    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){

    }failed:^(NSError *error){
        NSLog(@"error:%@",error);
    }];

}

/*
 认证：-2=认证失败，-1=未认证
 0=审核中，非0认证级别
 */

 
- (void)requestGetUserInfoWithUid_renzheng:(NSString *)uid
{
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            
            [self processData:dict];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
        
    }failed:^(NSError *error){
        
    }];
}

- (BOOL)isFinishInformation
{
    BOOL isFinish = YES;
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];

    NSString *sexString = [NSString stringWithFormat:@"%@",userDict[@"sex"]];
    if ([sexString isEqualToString:@"2"]||[sexString isEqualToString:@"1"]) {
        
    }else
    {
        isFinish = NO;
    }
    
    NSString *cityString = [NSString stringWithFormat:@"%@",userDict[@"city"]];
    if ([cityString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    NSString *birthString = [NSString stringWithFormat:@"%@",userDict[@"birth"]];
    if ([birthString isEqualToString:@"0000-00-00"]) {
        isFinish = NO;
    }
    NSString *heightString = [NSString stringWithFormat:@"%@",userDict[@"height"]];
    if ([heightString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    NSString *weightString = [NSString stringWithFormat:@"%@",userDict[@"weight"]];
    if ([weightString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    NSString *hiplineString = [NSString stringWithFormat:@"%@",userDict[@"hipline"]];
    NSString *bustString = [NSString stringWithFormat:@"%@",userDict[@"bust"]];
    NSString *waistString = [NSString stringWithFormat:@"%@",userDict[@"waist"]];

    if ([hiplineString isEqualToString:@"0"]||[bustString isEqualToString:@"0"]||[waistString isEqualToString:@"0"]) {
        isFinish = NO;

    }
    if(!_headPic){
        isFinish = NO;
    }
    
    NSString *footString = [NSString stringWithFormat:@"%@",userDict[@"foot"]];
    if ([footString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    NSString *legString = [NSString stringWithFormat:@"%@",userDict[@"leg"]];
    if ([legString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    NSString *hairString = [NSString stringWithFormat:@"%@",userDict[@"hair"]];
    if ([hairString isEqualToString:@"0"]) {
        isFinish = NO;
    }
    
    return YES;
    
}

- (void)processData:(NSDictionary *)dict
{
    @try {
        [USER_DEFAULT setValue:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];

    }
    @catch (NSException *exception) {
        NSLog(@"错误：%@",exception);
    }
    @finally {
        
    }

    self.pViewModel = [[PersonPageViewModel alloc] initWithDiction:dict];
    NSString *url = [self.pViewModel getCutHeaderURLWithView:self.headerImageView];
    self.titleLabel.text = self.pViewModel.headerName;
    self.descLabel.text = self.pViewModel.headerIntroduce;
    self.headerImageView.clipsToBounds = YES;
    self.headerImageView.layer.cornerRadius = 5;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
//    self.pViewModel.authentication = @"1";
    if([self.pViewModel.authentication isEqualToString:@"-1"])//未认证
    {
        [self notRenzheng];
        [self isHadImage:0];//
        
    }else if ([self.pViewModel.authentication isEqualToString:@"-2"])//认证失败
    {
        [self failedRenzheng];
        [self isHadImage:0];
        
    }else if ([self.pViewModel.authentication isEqualToString:@"0"])//审核中
    {
        [self doingRenzheng];
        [self isHadImage:2];
        
    }else  //审核成功
    {
        [self successRenzheng];
        [self isHadImage:1];
    }
    
}


- (void)notRenzheng
{
    self.renzhengIcon.image = [UIImage imageNamed:@"notRenZhengImage"];
    self.renzhengContentIcon.image = [UIImage imageNamed:@"notShenHe"];
    //没有被认证
    //self.renzhengContent.image = [UIImage imageNamed:@"renZhengContent"];
    self.renzhengDetailLabel.text = _renzhengTxt;
    
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateSelected];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateHighlighted];

    self.headerImageView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.renzhengContentIcon.hidden = NO;
    self.submitButton.hidden = NO;
    
    self.submitButton.frame = CGRectMake((kScreenWidth-217)/2, 330, 217, 38);
    self.mainView.frame = CGRectMake(0, 20, kScreenWidth, 385);
    self.renzhengIcon.frame = CGRectMake(24, 10, 47, 62);
    self.bottomLine.frame = CGRectMake(10, 250, kScreenWidth-20, 3);
    self.topLine.frame = CGRectMake(10, 80, kScreenWidth-20, 3);
    self.threeLine.frame = CGRectMake(10, 310, kScreenWidth-20, 3);
    //self.renzhengContent.frame = CGRectMake(90, 104, 212, 129);
    //设置认证提示label
    self.renzhengDetailLabel.frame = CGRectMake(90, 90, kDeviceWidth -90 -20, 150);
    self.addPhotoView.frame = CGRectMake(0,253,kScreenWidth,55);

}

- (void)failedRenzheng
{
    self.renzhengIcon.image = [UIImage imageNamed:@"failedRenZheng"];
    //认证失败
    self.renzhengContentIcon.image = [UIImage imageNamed:@""];
    
   // self.renzhengContent.image = [UIImage imageNamed:@"failedContent"];
    self.renzhengDetailLabel.text = _failRenzhengTxt;
    
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateSelected];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateHighlighted];
    self.headerImageView.hidden = YES;
    self.titleLabel.hidden = YES;
    self.descLabel.hidden = YES;
    self.renzhengContentIcon.hidden = YES;
    self.submitButton.hidden = NO;

    self.submitButton.frame = CGRectMake((kScreenWidth-217)/2, 285, 217, 38);
    self.mainView.frame = CGRectMake(0, 20, kScreenWidth, 350);
     self.renzhengIcon.frame = CGRectMake(24, 10, 47, 62);

    self.topLine.frame = CGRectMake(10, 80, kScreenWidth-20, 3);
    self.bottomLine.frame = CGRectMake(10, 205, kScreenWidth-20, 3);
    self.threeLine.frame = CGRectMake(10, 265, kScreenWidth-20, 3);
    
    //self.renzhengContent.frame = CGRectMake(60, 110, 202, 59);
    self.renzhengDetailLabel.frame = CGRectMake(24, 90, kDeviceWidth -24 -24, 105);
    self.addPhotoView.frame = CGRectMake(0,208,kScreenWidth,55);
}


- (void)doingRenzheng
{
    self.renzhengIcon.image = [UIImage imageNamed:@"notRenZhengImage"];
    self.renzhengContentIcon.image = [UIImage imageNamed:@"doingRenZheng"];
    
    //self.renzhengContent.image = [UIImage imageNamed:@"renZhengContent"];
    self.renzhengDetailLabel.text = _renzhengTxt;
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"doingShenHe"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"doingShenHe"] forState:UIControlStateSelected];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"doingShenHe"] forState:UIControlStateHighlighted];
    [self.submitButton setUserInteractionEnabled:NO];
    self.headerImageView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.renzhengContentIcon.hidden = NO;
    self.submitButton.hidden = NO;

    self.submitButton.frame = CGRectMake((kScreenWidth-217)/2, 330, 217, 38);
    self.mainView.frame = CGRectMake(0, 20, kScreenWidth, 385);
    self.renzhengIcon.frame = CGRectMake(24, 10, 47, 62);
    self.bottomLine.frame = CGRectMake(10, 250, kScreenWidth-20, 3);
    self.topLine.frame = CGRectMake(10, 80, kScreenWidth-20, 3);
    self.threeLine.frame = CGRectMake(10, 310, kScreenWidth-20, 3);
    //self.renzhengContent.frame = CGRectMake(90, 104, 212, 129);
    self.renzhengDetailLabel.frame = CGRectMake(90, 90, kDeviceWidth -90-20,150);
    self.addPhotoView.frame = CGRectMake(0,253,kScreenWidth,55);
}


- (void)successRenzheng
{
    self.renzhengIcon.image = [UIImage imageNamed:@"successRenZheng"];
    self.renzhengContentIcon.image = [UIImage imageNamed:@"successShenHe"];
    
    //self.renzhengContent.image = [UIImage imageNamed:@"renZhengContent"];
    self.renzhengDetailLabel.text = _renzhengTxt;
    
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateSelected];
    [self.submitButton setBackgroundImage:[UIImage imageNamed:@"notSubmit"] forState:UIControlStateHighlighted];

    self.headerImageView.hidden = NO;
    self.titleLabel.hidden = NO;
    self.descLabel.hidden = NO;
    self.renzhengContentIcon.hidden = NO;
    self.submitButton.hidden = YES;
    
    
    self.addPhotoView.hidden = YES;
    self.threeLine.hidden = YES;
    
    self.submitButton.frame = CGRectMake((kScreenWidth-217)/2, 255, 217, 38);
    self.mainView.frame = CGRectMake(0, 20, kScreenWidth, 330);
    self.renzhengIcon.frame = CGRectMake(24, 10, 47, 62);
    self.bottomLine.frame = CGRectMake(10, 250, kScreenWidth-20, 3);
    self.topLine.frame = CGRectMake(10, 80, kScreenWidth-20, 3);
    self.threeLine.frame = CGRectMake(10, 310, kScreenWidth-20, 3);
    //self.renzhengContent.frame = CGRectMake(90, 104, 212, 129);
    self.renzhengDetailLabel.frame = CGRectMake(90, 90, kDeviceWidth - 90 -20, 150);
    

}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        switch (buttonIndex) {
            case 0:
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                else{
                    //                    [NotificationManager notificationWithMessage:@"您的设备不支持照相功能"];
                    return;
                }
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
                return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    _showImageView.image = image;
    //上传身份证
    [self modifyUserHeadAction:image];
    [self isHadImage:1];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)modifyUserHeadAction:(UIImage *)image
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
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

    NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid type:4 file:@"file"];
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@  SVN",data);
        if ([data[@"status"] integerValue] == kRight) {
            
            [LeafNotification showInController:self withText:@"上传成功"];
            NSString *jpg = [CommonUtils imageStringWithWidth:100 height:100];
            NSString *headUrl = [NSString stringWithFormat:@"%@%@",data[@"data"][@"url"],jpg];
            
            self.headPic = data[@"data"][@"url"];
            NSDictionary *dict = [NSDictionary dictionaryWithObject:data[@"data"][@"url"] forKey:uid];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_LOGO];
            [USER_DEFAULT synchronize];
            
            [_showImageView sd_setImageWithURL:[NSURL URLWithString:headUrl]];
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
            
        }
    }failed:^(NSError *error){
        
    }];
}


- (void)isHadImage:(NSInteger)isSatus
{
    if (isSatus == 1) {
        [self.addImageView setImage:[UIImage imageNamed:@"oicon031.png"]];
        self.addImageView.frame = CGRectMake(kScreenWidth - 40, 19, 18, 18);
        self.showImageView.hidden = NO;
        self.showBtn.hidden = NO;
        self.addBtn.hidden = NO;
        
        self.remindLab.frame = CGRectMake(kScreenWidth - 120, 18, 80, CGRectGetHeight(self.remindLab.frame));
        self.remindLab.text = @"重新上传";
        self.remindLab.font = kFont14;
        self.remindLab.textColor = [UIColor colorForHex:kLikeGrayColor];
        
    }
    else if (isSatus == 0){
        [self.addImageView setImage:[UIImage imageNamed:@"addIdenity.png"]];
        self.addImageView.frame = CGRectMake((kScreenWidth - 120)/2 - 20, 18, 19, 19);
        self.showImageView.hidden = YES;
        self.showBtn.hidden = YES;
        self.addBtn.hidden = NO;
        
        self.remindLab.frame = CGRectMake((kScreenWidth - 120)/2, 18, 120, CGRectGetHeight(self.remindLab.frame));
        self.remindLab.font = kFont15;
        self.remindLab.text = @"上传身份证影印";
        self.remindLab.textAlignment = NSTextAlignmentCenter;
        self.remindLab.textColor = [UIColor colorForHex:kLikeRedColor];
    }
    else if (isSatus == 2){
        self.addImageView.hidden = YES;
        self.showImageView.hidden = NO;
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        NSString *url = [USER_DEFAULT objectForKey:MOKA_USER_LOGO][uid];
        NSString *jpg = [CommonUtils imageStringWithWidth:100 height:100];
        NSString *headUrl = [NSString stringWithFormat:@"%@%@",url,jpg];
        [_showImageView sd_setImageWithURL:[NSURL URLWithString:headUrl]];
        self.showBtn.hidden = NO;
        self.addBtn.hidden = YES;
        
        self.remindLab.frame = CGRectMake(kScreenWidth - 120, 18, 80, CGRectGetHeight(self.remindLab.frame));
        self.remindLab.text = @"审核中";
        self.remindLab.font = kFont14;
        self.remindLab.textColor = [UIColor colorForHex:kLikeGrayColor];
    }

}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    
//    isFullScreen = !isFullScreen;
//    UITouch *touch = [touches anyObject];
//    
//    CGPoint touchPoint = [touch locationInView:self.view];
//    
//    CGPoint imagePoint = self.showImageView.frame.origin;
//    //touchPoint.x ，touchPoint.y 就是触点的坐标
//    
//    // 触点在imageView内，点击imageView时 放大,再次点击时缩小
//    if(imagePoint.x <= touchPoint.x && imagePoint.x +self.imageView.frame.size.width >=touchPoint.x && imagePoint.y <=  touchPoint.y && imagePoint.y+self.imageView.frame.size.height >= touchPoint.y)
//    {
//        // 设置图片放大动画
//        [UIView beginAnimations:nil context:nil];
//        // 动画时间
//        [UIView setAnimationDuration:1];
//        
//        if (isFullScreen) {
//            // 放大尺寸
//            
//            self.imageView.frame = CGRectMake(0, 0, 320, 480);
//        }
//        else {
//            // 缩小尺寸
//            self.imageView.frame = CGRectMake(50, 65, 90, 115);
//        }
//        
//        // commit动画
//        [UIView commitAnimations];
//        
//    }
//    
//}


@end
