//
//  BuildTaoXiHeaderView.m
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BuildTaoXiHeaderView.h"


@interface BuildTaoXiHeaderView ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,changeMokaPictureDelegate>
{
    UIButton *_button;
    UIImageView *_defaultImageView;
    UILabel *_defaultLabel;
}


@end

@implementation BuildTaoXiHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        
        _coverImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_coverImageView];

        //默认提示上传的图片
        _defaultImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kDeviceWidth -56)/2, (self.height -40 -30)/2, 56, 40)];
        _defaultImageView.contentMode = UIViewContentModeScaleAspectFit;
        _defaultImageView.image = [UIImage imageNamed:@"upload"];
        [self addSubview:_defaultImageView];

        //上传按钮
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = _coverImageView.bounds;
        [_button addTarget:self action:@selector(uploadCoverImage) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_button];

        
        //上传Label
        _defaultLabel = [[UILabel alloc]initWithFrame:CGRectMake(_defaultImageView.left - 15, _defaultImageView.bottom, 100, 30)];
        _defaultLabel.center = CGPointMake(_defaultImageView.center.x, _defaultImageView.bottom +15);
        _defaultLabel.text = @"上传封面";
        _defaultLabel.textAlignment = NSTextAlignmentCenter;
        _defaultLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        [self addSubview:_defaultLabel];
    }
    return self;
}

-(void)initWithDictionary:(NSDictionary *)dic{
    NSDictionary *content = dic[@"content"];
    if (!((NSNull *)content == [NSNull null])){
    NSString *coverStr = getSafeString(dic[@"content"][@"coverurl"]);
    NSString *cdnStr = [NSString stringWithFormat:@"%@%@",coverStr,[CommonUtils imageStringWithWidth:kDeviceWidth height:kDeviceWidth *TaoXiScale]];
    _defaultImageView.image = nil;
    NSString *url = [cdnStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    [self bringSubviewToFront:self.coverImageView];
    }
}

-(void)uploadCoverImage{
    NSLog(@"uploadCoverImage");
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                         destructiveButtonTitle:nil
//                            
//                                              otherButtonTitles:@"相机", @"从手机相册中选择", nil];
//    [sheet showInView:self.supCon.view];
    [self takePicture];


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
#pragma mark photo
- (void)takePicture
{
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

#pragma mark - imagePickerController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:NO completion:nil];
    
    //打印出字典中的内容
//    NSLog(@"get the media info: %@", info);
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
            buildCrop.cardType = 25;
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
//图片处理完成,上传
- (void)finishCropImage:(UIImage *)image{
    [self uploadCoverImageWithImage:image];
}

-(void)uploadCoverImageWithImage:(UIImage *)image{
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
    
    [_defaultImageView removeFromSuperview];
    [_defaultLabel removeFromSuperview];
    
    //参数
    //uploadCoverImage
    NSString *tags = @"";
    NSString *title = @"";
    NSInteger imgType = 6;
    
    NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid tags:tags title:title type:imgType file:@"file"];
    
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data) {
        NSDictionary *diction = (NSDictionary *)data;
        NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
        if ([str isEqualToString:@"0"]) {
            NSString *str = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"url"])];
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",str,[CommonUtils imageStringWithWidth:kDeviceWidth*2 height:kDeviceWidth *TaoXiScale*2]];
            [_coverImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"taoxiCoverurl" object:str];
        }else{
            [LeafNotification showInController:self.supCon withText:diction[@"msg"]];
        }
    
    } failed:^(NSError *error) {
        [LeafNotification showInController:self.supCon withText:@"网络不太顺畅哦"];
    }];
}


//-(UIImageView *)coverImageView{
//    if (!_coverImageView) {
//        _coverImageView = [[UIImageView alloc]init];
//    }
//    return _coverImageView;
//}
@end
