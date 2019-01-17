//
//  JuBaoPartTwoTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JuBaoPartTwoTableViewCell.h"
#import "JingPaiUploadView.h"
#import "UploadVideoManager.h"
#import "LocalPhotoViewController.h"

@implementation JuBaoPartTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self addSubview:self.statusBackView];
    
    [self addButtons];
    
}

- (void)addButtons
{
    for (int i=0; i<self.statusArray.count; i++) {
        NSDictionary *diction = self.statusArray[i];
        NSString *type = diction[@"type"];
        NSString *image = diction[@"image"];
        NSString *jid = diction[@"jid"];
        
        int row = (int)i/4;
        int cln = (int)i%4;
        
        JingPaiUploadView *buttonView = [[JingPaiUploadView alloc] init];
        buttonView.tag = [jid intValue];
        buttonView.space = self.space;
        buttonView.clipsToBounds = YES;
        buttonView.itemHeight = self.itemHeight;
        buttonView.cellHeight = self.cellHeight;
        if ([type isEqualToString:@"0"]) {
            
            [buttonView getTypeOneButtonViewWithIndex:i];
            [buttonView.clickButton addTarget:self action:@selector(addVideo:) forControlEvents:UIControlEventTouchUpInside];
            
        }else if ([type isEqualToString:@"1"]) {
            
            [buttonView getTypeTwoButtonViewWithIndex:i];
            [buttonView.clickButton addTarget:self action:@selector(addImage:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if ([type isEqualToString:@"2"]) {
            
            [buttonView getTypeThreeButtonViewWithImage:image WithIndex:i];
            [buttonView.clickButton addTarget:self action:@selector(deleteVideo:) forControlEvents:UIControlEventTouchUpInside];
            if (self.videoImage) {
                buttonView.imgView.image = self.videoImage;
                
            }
            
            
        }else if ([type isEqualToString:@"3"]) {
            UIImage *image = diction[@"image"];
            [buttonView getTypeFourButtonViewWithImage:@"" WithIndex:i];
            [buttonView.clickButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
            if (image) {
                if([image isKindOfClass:[UIImage class]])
                {
                    buttonView.imgView.image = image;
                }
            }
            
        }
        
        buttonView.frame = CGRectMake(cln*(self.itemHeight+self.space), row*(self.itemHeight+self.space), self.itemHeight, self.itemHeight);
        
        BOOL isInTheArray = NO;
        for (int k=0; k<self.viewsArray.count; k++) {
            JingPaiUploadView *old = self.viewsArray[k];
            if (old.tag==buttonView.tag) {
                isInTheArray = YES;
                
            }
        }
        
        if (!isInTheArray) {
            [self.statusBackView addSubview:buttonView];
            if ([type isEqualToString:@"2"]||[type isEqualToString:@"0"]) {
                [self.viewsArray insertObject:buttonView atIndex:0];
                
            }else
            {
                [self.viewsArray insertObject:buttonView atIndex:0];
                
            }
        }
        
    }
    
    for (int k=0; k<self.viewsArray.count; k++) {
        JingPaiUploadView *old = self.viewsArray[k];
        int row = (int)k/4;
        int cln = (int)k%4;
        old.frame = CGRectMake(cln*(self.itemHeight+self.space), row*(self.itemHeight+self.space), self.itemHeight, self.itemHeight);
        
    }
    
}


- (void)addVideo:(UIButton *)sender
{
    LOG_METHOD;
    
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
    [self.controller presentViewController:self.imagePickerController animated:YES completion:nil];
    
}


- (void)addImage:(UIButton *)sender
{
    LocalPhotoViewController *loadPhotoC = [[LocalPhotoViewController alloc] init];
    loadPhotoC.existCount = self.picturesArray.count;
    loadPhotoC.selectPhotoDelegate = self;
    loadPhotoC.selectPhotos = self.picturesAlbumArray.mutableCopy;
    [self.controller.navigationController pushViewController:loadPhotoC animated:YES];
    
}


- (void)deleteImage:(UIButton *)sender
{
    LOG_METHOD;
    NSDictionary *diction = @{};
    for (int i=0; i<self.statusArray.count; i++) {
        NSDictionary *old = self.statusArray[i];
        NSString *jidString = getSafeString(old[@"jid"]);
        if (sender.tag==[jidString intValue]) {
            diction = self.statusArray[i];
        }
    }
    NSString *jid = getSafeString(diction[@"jid"]);
    int removeIndex = 200;
    for (int i=0; i<self.viewsArray.count; i++) {
        JingPaiUploadView *old = self.viewsArray[i];
        if (old.tag==[jid intValue]) {
            removeIndex = i;
            old.frame = CGRectMake(0, 0, 0, 0);
        }
    }
    if (removeIndex!=200) {
        [self.picturesAlbumArray removeObjectAtIndex:removeIndex-2];
        [self.viewsArray removeObjectAtIndex:removeIndex];
    }
    
    int removeIndexTwo = 200;
    for (int i=0; i<self.statusArray.count; i++) {
        NSDictionary *old = self.statusArray[i];
        NSString *jidString = getSafeString(old[@"jid"]);
        if ([jidString isEqualToString:jid]) {
            removeIndexTwo = i;
        }
    }
    if (removeIndexTwo!=200) {
        [self.statusArray removeObjectAtIndex:removeIndexTwo];
    }
    [self addButtons];
    [self.controller reloadTableView];
}


- (void)deleteVideo:(UIButton *)sender
{
    LOG_METHOD;
    if (self.viewsArray.count>0) {
        [self.viewsArray removeObjectAtIndex:0];
    }
    [self.statusArray replaceObjectAtIndex:0 withObject:@{@"type":@"0",@"image":@"",@"jid":@"0"}.mutableCopy];
    [self addButtons];
}

- (int)space
{
    if (_space==0) {
        _space = 5;
    }
    return _space;
}

- (float)itemHeight
{
    if (_itemHeight==0.0) {
        _itemHeight = (kScreenWidth-40-self.space*3)/4;
    }
    return _itemHeight;
}

- (float)cellHeight
{
    int cln = (int)self.statusArray.count/4+1;
    if (self.statusArray.count%4==0) {
        cln = cln - 1;
    }
    float height = self.itemHeight*cln+self.space*cln+20;
    _cellHeight = height;
    return _cellHeight;
}

- (UIView *)statusBackView
{
    if (!_statusBackView) {
        _statusBackView = [[UIView alloc] init];
    }
    _statusBackView.frame = CGRectMake(20, 10, kScreenWidth-40, self.cellHeight-20);
    return _statusBackView;
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
    //    [topview addSubview:guangbutton];
    
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

float daojishi_jubao = 0.0;

- (void)changeDaojishi
{
    daojishi_jubao+=0.1;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.daojishi.text = [NSString stringWithFormat:@"%.1f",daojishi_jubao];
        
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
        [self takePictureWithType:2];
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

-(void)takePictureWithType:(NSInteger)pickertype
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        NSLog(@"sorry, no photo library is unavailable.");
        [LeafNotification showInController:self.controller withText:@"媒体格式暂不支持"];
        return;
    }
    //创建图像选取控制器
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    //设置图像选取控制器的来源模式为
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeVideo,kUTTypeMovie,kUTTypeMPEG4, nil];
    
    //允许用户进行编辑
    imagePickerController.allowsEditing = NO;
    //设置委托对象
    imagePickerController.delegate = self;
    //以模视图控制器的形式显示
    [self.controller presentViewController:imagePickerController animated:YES completion:nil];
    
}

#pragma mark - SelectPhotoDelegate
-(void)getSelectedPhoto:(NSMutableArray *)photos{
    LOG_METHOD;
    [self.picturesArray removeAllObjects];
    [self.picturesAlbumArray removeAllObjects];
    
    for (id obj in photos) {
        if ([obj isKindOfClass:[ALAsset class]]) {
            CGImageRef posterImageRef= [[obj defaultRepresentation] fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:posterImageRef];
            [self.picturesArray addObject:image];
        }
    }
    [self.picturesAlbumArray addObjectsFromArray:photos];
    
    for (int i=0; i<self.statusArray.count; i++) {
        JingPaiUploadView *view = self.viewsArray[i];
        view.frame = CGRectMake(0, 0, 0, 0);
    }
    
    NSMutableArray *statuArr = @[@{@"type":@"1",@"image":@"",@"jid":@"100"}.mutableCopy].mutableCopy;
    NSMutableArray *viewArr = @[].mutableCopy;
    
    self.statusArray = statuArr;
    self.viewsArray = viewArr;
    
    for (int i=0; i<self.picturesArray.count; i++) {
        if (i>=9) {
            break;
        }
        UIImage *image = self.picturesArray[i];
        [self.statusArray addObject:@{@"type":@"3",@"image":image,@"jid":[NSString stringWithFormat:@"%d",(int)self.statusArray.count]}.mutableCopy];
        
    }
    [self addButtons];
    NSLog(@"%@",self.picturesArray);
    [self.controller reloadTableView];

}

-(void)delegatePhoto:(id)sender{
    LOG_METHOD;
    
}


#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    daojishi_jubao = 0.0;
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
        [self.statusArray insertObject:@{@"type":@"3",@"image":image,@"jid":[NSString stringWithFormat:@"%d",(int)self.statusArray.count]}.mutableCopy atIndex:self.statusArray.count];
        [self addButtons];
        [self.controller reloadTableView];
        
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
        [self uploadVideo];
        
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
    
    generator.maximumSize = self.controller.view.frame.size;
    [generator generateCGImagesAsynchronouslyForTimes:
     [NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
    
}

- (void)gotoReleaseVideo
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.viewsArray.count>0) {
            [self.viewsArray removeObjectAtIndex:0];
        }
        [self.statusArray replaceObjectAtIndex:0 withObject:@{@"type":@"2",@"image":@"",@"jid":@"100"}.mutableCopy];
        [self addButtons];
        //        [self uploadVideoImage];
    });
    
}

- (void)uploadVideoImage
{
    NSData *imageData = UIImageJPEGRepresentation(self.videoImage, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    //    //2M以下不压缩
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(self.videoImage, 0.8);
        self.videoImage = [UIImage imageWithData:imageData];
    }
    
    NSDictionary *dict = [AFParamFormat formatPostUploadParamWithFileJingPai:@"file"];
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@ test SVN",data);
        NSString *dictionURL = [NSString stringWithFormat:@"%@",data[@"data"][@"url"]];
        self.videoImageString = dictionURL;
        
    }failed:^(NSError *error){
        
    }];
    
}

- (void)uploadVideo
{
    [[UploadVideoManager sharedInstance] uploadWithVideo:self.videoURL block:^(NSString *string) {
        
        if (string) {
            NSLog(@"%@",getSafeString(string));
            self.videoString = string;
        }else
        {
            
        }
        
    }];
}

+ (JuBaoPartTwoTableViewCell *)getJuBaoPartTwoTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JuBaoPartTwoTableViewCell" owner:self options:nil];
    JuBaoPartTwoTableViewCell *cell = array[0];
    cell.statusArray = @[@{@"type":@"1",@"image":@"",@"jid":@"100"}.mutableCopy].mutableCopy;
    cell.viewsArray = @[].mutableCopy;
    cell.picturesArray = @[].mutableCopy;
    cell.picturesAlbumArray = @[].mutableCopy;
    return cell;
    
}


@end
