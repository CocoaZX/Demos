
//
//  BuildDetailViewController.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BuildDetailViewController.h"
#import "NewMyPageViewController.h"
#import "NewCropViewController.h"
#import "MyMokaCardViewController.h"
#import "BuildMokaCardViewController.h"
#import "BuildCropViewController.h"


@interface BuildDetailViewController ()<UIActionSheetDelegate,CropFinished,UINavigationControllerDelegate,UIImagePickerControllerDelegate,
    changeMokaPictureDelegate
>

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) NSMutableArray *imageViews;

@property (strong, nonatomic) NSMutableArray *buttons;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (assign, nonatomic) int currentIndex;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (assign, nonatomic) int currentSuccess;

@property (assign, nonatomic) int currentImageCount;

@property (assign, nonatomic) int currentChoseType;

@property (nonatomic , strong) UIAlertView *alertView;

@property (strong,nonatomic)UIView *mokaView;

@property (nonatomic , strong) NSMutableArray *tagMutArr;

@end

@implementation BuildDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"新建模卡";
    self.imageViews = @[].mutableCopy;
    self.buttons = @[].mutableCopy;
    self.currentImageCount = 0;
    self.currentSuccess = 0;
    self.tagMutArr = @[].mutableCopy;
    //选择模卡类型创建模卡视图
    _mokaView = [MokaCardManager getMokaCardWithType:self.mokaType images:self.imageViews buttons:self.buttons];
    for (int i = 0; i < self.buttons.count; i ++) {
        UIButton *but = self.buttons[i];
        NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)but.tag];
        [_tagMutArr addObject:tagStr];
    }
    [self.contentView addSubview:_mokaView];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBut = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftBarBut;
    
    
    //如果是处于编辑模卡的状态
    if (self.isEditing) {
        self.title = @"我的模卡";
        [self.submitButton setTitle:@"删除模卡" forState:UIControlStateNormal];
        [self getMokaDetailData];
        [self resetButtonTarget];

    }else
    {
        [self resetViewState];

    }
}

#pragma mark - 判断是否上传完毕
-(void)doBackAction:(UIButton *)sender{
    if (!_isEditing) {
        if (self.tagMutArr.count) {
            _alertView = [[UIAlertView alloc]initWithTitle:@"放弃编辑模卡？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
            [_alertView show];
        }else{
            _alertView = [[UIAlertView alloc]initWithTitle:@"放弃保存模卡？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
            [_alertView show];
        }
    }
    else
    {
    [self.navigationController popViewControllerAnimated:YES];
    }
}

////保存模卡图片，即拼接的图片
//- (void)saveMokaImgClick{
//    TestViewController *testVC = [[TestViewController alloc] init];
//    UIImage *image = [self snapshot:_mokaView];
//    testVC.image = image;
//    testVC.viewFrame = _mokaView.frame;
//    [self.supCon.navigationController pushViewController:testVC animated:YES ];
//}

//截图视图
- (UIImage *)snapshot:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}





//视图将要显示的时间设置内容视图的大小
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.firstLabel.frame = CGRectMake(kScreenWidth/2-70, 20, 140, 21);
    self.secondLabel.frame = CGRectMake(kScreenWidth/2-85, 380, 170, 21);
    float height = kScreenWidth - 100;
    int indexP = [self.mokaType intValue];

    //四种模特卡,再加五种
    switch (indexP) {
        case 0:
            height = 365;//照片
            break;
        case 1:
            height = kScreenWidth - 32;//五图
            break;
        case 2:
            height = kScreenWidth - 40;//六图
            break;
        case 3:
            height = kScreenWidth + 60;//九宫格
            break;
        case 4:
            height = kScreenWidth - 7;//十图
            break;
        case 5:
            height = kScreenWidth - 22;//八图
            break;
        case 6:
            height = kScreenWidth - 42;//一加六
            break;
        case 7:
            height = kScreenWidth - 42;//一加八
            break;
        case 8:
            height = kScreenWidth - 42;//经典六图
            break;
        case 9:
            height = kScreenWidth - 42;//新式6
            break;
        case 11:
            height = kScreenWidth - 42;
            break;
            
        case 14:
            height = kScreenWidth - 42;//上大
            break;
        case 12:
            height = kScreenWidth - 42;
            break;
        default:
            height = kDeviceWidth - 89;;
            break;
    }

    
    self.contentView.frame = CGRectMake(0, 56, kScreenWidth, height);
    //self.contentView.backgroundColor = [UIColor purpleColor];
    self.submitButton.frame = CGRectMake(10, self.contentView.frame.origin.y+self.contentView.frame.size.height + 30, kScreenWidth - 20, 44);
    self.navigationController.navigationBarHidden = NO;
    if (self.isEditing) {
        self.submitButton.frame = CGRectMake(0, kScreenHeight - 108, kScreenWidth, 44);
        self.firstLabel.hidden = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateNO" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateYES" object:nil];
    
}


//获取模卡的详细数据
- (void)getMokaDetailData
{
    
    NSString *cuid = self.albumid;
    
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    [AFNetwork getMokaDetail:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            self.dataDic = data[@"data"];
//            NSLog(@"%@",_dataDic);
            [self resetImgViewURL];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        
      [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

//设置模卡中的照片显示
- (void)resetImgViewURL
{
    NSArray *imagesArr = self.dataDic[@"photos"];
    for (int i=0; i<imagesArr.count; i++) {
        NSDictionary *dic = imagesArr[i];
        NSString *sequence = [NSString stringWithFormat:@"%@",dic[@"sequence"]];
        if (self.imageViews.count>[sequence intValue]) {
            UIImageView *imgView = self.imageViews[[sequence intValue]];
            NSString *urlString = [NSString stringWithFormat:@"%@",dic[@"url"]];
            if ([self.mokaType isEqualToString:@"3"]) {
                NSInteger wid = (NSInteger)((kScreenWidth-30)/3)*2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:wid];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
            }
            else{

                NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
                
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                urlString = [NSString stringWithFormat:@"%@%@",dic[@"url"],jpg];
                NSLog(@"%@",urlString);
            }
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
        }
        
    }
    
}

- (void)resetViewState
{
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        [btn addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)resetButtonTarget
{
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        [btn addTarget:self action:@selector(imageViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    }
    
}

//点击模卡图片之后，选择一种方式来更换图片
- (void)imageViewClick:(UIButton *)sender
{
    NSLog(@"imageViewClick");

    NSLog(@"%ld",(long)sender.tag);
    sender.imageView.image = nil;
    self.currentIndex = (int)sender.tag;
    self.currentChoseType = [self getCurrentChoseType];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"相机", @"从手机相册中选择", nil];
    [sheet showInView:self.view];
}

- (int)getCurrentChoseType
{
    NSLog(@"getCurrentChoseType");

    int cardType = [self.mokaType intValue];
    int choseType = 0;
    switch (cardType) {
        case 1:
        {
            if (self.currentIndex==0) {
                choseType = 6;
            }else
            {
                choseType = 6;
            }
        }
            break;
        case 2:
        {
            if (self.currentIndex==0) {
                choseType = 7;
            }else if (self.currentIndex==1)
            {
                choseType = 2;
            }else
            {
                choseType = 5;
            }
        }
            break;
        case 3:
        {
            choseType = 4;
        }
            break;
        case 4:
        {
            if (self.currentIndex==0) {
                choseType = 5;
            }else
            {
                if (kScreenWidth==320) {
                    choseType = 1;
                }else
                {
                    choseType = 0;

                }
            }
        }
            break;
        case 5:{
            choseType = 8;//八图
        }
            break;
        case 6:{
            if (self.currentIndex == 0) {
                choseType = 9;//一加六图左大
            }else{
                choseType = 10;//小图
            }
        }
            break;
        case 7:{
            if (self.currentIndex == 0) {
                choseType = 17;//一加八图左大
            }else{
                choseType = 16;//小图
            }
        }
            break;
        case 8:{
            if (self.currentIndex == 0 || self.currentIndex == 3) {
                choseType = 11;//六图大
            }else{
                choseType = 12;//六图小
            }
        }
            break;
        case 9:{
            if (self.currentIndex == 0 || self.currentIndex == 5) {
                choseType = 13;//三上三下大
            }else{
                choseType = 14;//三上三下小
            }
        }
            break;
            //右大五图
        case 10:
        {
            if (self.currentIndex == 0 || self.currentIndex == 3) {
                choseType = 23;//左大
            }else if (self.currentIndex == 4){
                choseType = 19;//右大
            }else{
                choseType = 24;//左小
            }
        }
            break;
            //中大七图
        case 11:{
            if (self.currentIndex == 3) {
                //有问题
                choseType = 20;
            }else{
                choseType = 0;
            }
        }
            break;
            //五图上大
        case 14:{
            if (self.currentIndex == 0) {
                choseType = 21;
            }else{
                choseType = 22;
            }
        }
            break;
            //五图右下二
        case 13:{
            if (self.currentIndex == 0) {
                choseType = 6;
            }else if (self.currentIndex == 1){
                choseType = 11;
            }else if (self.currentIndex == 2||self.currentIndex == 3){
                choseType = 21;
            }else{
                choseType = 12;
            }
        }
            break;
        default:
            break;
        case 12:{
            if (self.currentIndex == 1 || self.currentIndex == 3) {
                choseType = 13;
            }
        }
            break;
    }
    
    return choseType;
}


- (IBAction)finishAndUpload:(id)sender {
    NSLog(@"finishAndUpload");
    if (self.isEditing) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        if (self.tagMutArr.count) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"模卡缺少照片" message:@"照片需要全部上传后，模卡才能保存" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            return;
            }
        for (UIViewController *con in self.navigationController.childViewControllers) {

            if ([con isKindOfClass:[NewMyPageViewController class]]) {
                NewMyPageViewController *myPageVC = (NewMyPageViewController *)con;
                myPageVC.isAppearShare = YES;
                [self.navigationController popToViewController:myPageVC animated:YES];
                return;
            }
        }
        
        [self skipBuildForPop];
    }
}


- (void)skipBuildForPop{
    NSMutableArray *removeArr = @[].mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[BuildMokaCardViewController class]]) {
            [removeArr addObject:controller];
        }
     }
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
    
    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];
    }
    [self.navigationController setViewControllers:tempArr];
    [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark Delete
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView == _alertView) {
        switch (buttonIndex) {
            case 0:
                
                break;
            case 1:{
                [self.navigationController popViewControllerAnimated:YES];
                NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":self.albumid}];
                [AFNetwork getDeleteAlbum:params success:^(id data){
                    if ([data[@"status"] integerValue] == kRight) {
                        return;
                    }
                    else {
                        
                    }
                }failed:^(NSError *error){
                    
                }];
            }
                break;
            default:
                break;
        }
        
        return;
    }
    if (buttonIndex==1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":self.albumid}];
        [AFNetwork getDeleteAlbum:params success:^(id data){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([data[@"status"] integerValue] == kRight) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }
            else {
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
            
            
        }failed:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            
        }];
    }
    
    
}

- (void)startUploadImage
{
    NSString *uid = @"";
    uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    int count = 0;

    for (int i=0; i<self.imageViews.count; i++) {
        UIImageView *imgv = self.imageViews[i];
        UIImage *uploadImage = imgv.image;
        if (uploadImage) {
            count++;
            UIButton *button = self.buttons[i];
            NSString *sequence = [NSString stringWithFormat:@"%ld",(long)button.tag];
            //TODO:优化压缩图片
//            NSData *imageData = UIImageJPEGRepresentation(uploadImage, 0.3);
            NSData *imageData = UIImageJPEGRepresentation(uploadImage, 1.0);
            NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
            if (imageData.length/1024 > 1024 * 5) {
                imageData = UIImageJPEGRepresentation(uploadImage, 0.3);
            }
            //    //2M以下不压缩
            while (imageData.length/1024 > 2048) {
                imageData = UIImageJPEGRepresentation(uploadImage, 0.6);
                uploadImage = [UIImage imageWithData:imageData];
            }

//            NSData *imageData = UIImageJPEGRepresentation(uploadImage, 1.0);
            NSLog(@"%lu",(unsigned long)imageData.length);
//            NSData *imageData = UIImagePNGRepresentation(uploadImage);
            NSDictionary *dict = [AFParamFormat formatPostMokaUploadParams:uid tags:@"" title:@"" type:2 sequence:sequence albumid:self.albumid file:@"file"];
            [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
//                NSLog(@"uploadPhoto:%@ test SVN",data);
                
                
                NSDictionary *diction = (NSDictionary *)data;
                NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
                if ([str isEqualToString:@"0"]) {
                    self.currentSuccess++;
                    if (self.currentSuccess==count) {
                        self.hud.detailsLabelText = @"发送成功";
                        [self.hud hide:YES afterDelay:1.0];
                        
                        for (UIViewController *con in self.navigationController.childViewControllers) {
                            if ([con isKindOfClass:[NewMyPageViewController class]]) {
                                [self.navigationController popToViewController:con animated:YES];
                            }
                        }
                    }
                    
                }else{
                    [LeafNotification showInController:self withText:diction[@"msg"]];
                    
                }
                
            }failed:^(NSError *error){
                
            }];
        }
       
    }
    
}

#pragma mark actionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0) {
        [self takePhoto];
    }else if(buttonIndex==1)
    {
        [self takePicture];
    }
    
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
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
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
    [self presentViewController:imagePickerController animated:YES completion:nil];
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
    
        //使用第三方处理照片
        //NSData *_imageData = UIImageJPEGRepresentation([image fixOrientation], 1);
        NSData *_imageData = UIImageJPEGRepresentation(image, 1);
//        NewCropViewController *cropVC = [[NewCropViewController alloc] init];
        BuildCropViewController *cropVC = [[BuildCropViewController alloc] initWithImageData:_imageData];
        //原始图片
        cropVC.originImage = image;
        cropVC.cardType = self.currentChoseType;
        cropVC.delegate = self;
        [self.navigationController pushViewController:cropVC animated:YES];
        
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

- (void)finishCropImage:(UIImage *)image
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.currentImageCount++;
    UIButton *currentBtn = self.buttons[self.currentIndex];
    NSLog(@"%d",self.currentIndex);
    [currentBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    NSString *tagStr = [NSString stringWithFormat:@"%ld",(long)currentBtn.tag];
    for (NSString *str in self.tagMutArr) {
        if ([str isEqualToString:tagStr]) {
            [self.tagMutArr removeObject:str];
            break;
        }
    }
    NSString *uid = @"";
    uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSString *sequence = [NSString stringWithFormat:@"%d",self.currentIndex];

//    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
//    NSData *imageData = UIImagePNGRepresentation(image);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(image, 0.3);
    }
//    //2M以下不压缩
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
        image = [UIImage imageWithData:imageData];
    }
    
    NSDictionary *dict = [AFParamFormat formatPostMokaUploadParams:uid tags:@"" title:@"" type:2 sequence:sequence albumid:self.albumid file:@"file"];
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
//        NSLog(@"uploadPhoto:%@ test SVN",data);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIImageView *imgView = self.imageViews[self.currentIndex];
        NSDictionary *diction = (NSDictionary *)data;
        NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
        NSString *urlString = @"";
        if ([str isEqualToString:@"0"]) {
            if ([self.mokaType isEqualToString:@"3"]) {
                NSInteger wid = (NSInteger)((kScreenWidth-30)/3)*2;
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:wid];
                urlString = [NSString stringWithFormat:@"%@%@",diction[@"data"][@"url"],jpg];
            }
            else{
                
                NSInteger wid = (NSInteger)(imgView.frame.size.width)*2;
                NSInteger hei = (NSInteger)(imgView.frame.size.height)*2;
                NSLog(@"hahahahahah  width:%ld  height:%ld",(long)wid,(long)hei);
                
                NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
                urlString = [NSString stringWithFormat:@"%@%@",diction[@"data"][@"url"],jpg];
                NSLog(@"%@",urlString);
            }
        
            [imgView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];

            
            
        }else{
            [LeafNotification showInController:self withText:diction[@"msg"]];
            
        }
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    


}

- (void)sendToCropImage:(UIImage *)image
{
    __weak __typeof(self)weakSelf = self;

    NewCropViewController *crop = [[NewCropViewController alloc] initWithNibName:@"NewCropViewController" bundle:[NSBundle mainBundle]];
    crop.originImage = image;
    crop.cardType = self.currentChoseType;
    crop.delegate = self;
    [self.navigationController pushViewController:crop animated:YES];
    
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
 
 
@end
