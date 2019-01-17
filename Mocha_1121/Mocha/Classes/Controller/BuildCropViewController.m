//
//  BuildCropViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/11.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "BuildCropViewController.h"

@interface BuildCropViewController ()
{
    //对应的模卡图片应有的截取宽和高
    float cropWidth;
    float cropHeight;
}
@end

@implementation BuildCropViewController

//传入图片资源
- (id)initWithImageData:(NSData *)data{
    self = [super init];
    if (self) {
        _imgData = data;
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //隐藏导航栏
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBarHidden = YES;

    
    CGRect frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    _cropImageView = [[KICropImageView alloc] initWithFrame:frame];
    //设置裁剪框的大小
    [self resizeScale];
    [_cropImageView setCropSize:CGSizeMake(cropWidth, cropHeight)];
    [_cropImageView setImage:[UIImage imageWithData:_imgData]];
    //[_cropImageView setImage:_originImage];
    _cropImageView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_cropImageView];
    
    //返回按钮
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 100, 30)];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    //保存按钮
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 100, 20, 100, 30)];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];

}


//设置裁剪框的大小
- (void)resizeScale{
    cropWidth = kScreenWidth;
    cropHeight = kScreenHeight;
    
    float scale = cropWidth/self.originImage.size.width;
    
    float imageWidth = self.originImage.size.width*scale*0.8;
    float imageHeight = self.originImage.size.height*scale*0.8;
    
    switch (self.cardType) {
        case 0:
        {//十图小
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight-20;
                cropWidth = cropHeight / 2 * 3;
            }else
            {
                cropWidth = imageWidth-20;
                cropHeight= cropWidth * 3 / 2;
            }
            
        }
            break;
        case 1:
        {   //五图经典小  十图小
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight * 12 / 17;
            }else{
                cropWidth = imageWidth;
                cropHeight = cropWidth * 17 / 12;
            }
        }
            break;
        case 2:
        {   // 新式五图右上大
            cropWidth = imageWidth-10;
            cropHeight = cropWidth*0.6;
        }
            break;
        case 3:
        {
            cropWidth = imageWidth-40;
            cropHeight = imageHeight-40;
        }
            break;
        case 4://九宫格
        {
            if (imageWidth>imageHeight) {
                cropWidth = imageHeight-20;
                cropHeight = imageHeight-20;
            }else
            {
                cropWidth = imageWidth-20;
                cropHeight = imageWidth-20;
            }
        }
            break;
        case 5:
        {//新式五图右下小  新式十图大
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight;
                cropWidth = cropHeight * 33 / 53;
            }else
            {
                cropWidth = imageWidth;
                cropHeight = imageWidth * 53 / 33;
            }
        }
            break;
        case 6://五图经典大
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 3 * 2;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 3 / 2;
            }
        }
            break;
        case 7://新式五图竖大
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight - 60;
                cropWidth = imageHeight * 30 / 51;
            }else
            {
                cropWidth = imageWidth;
                cropHeight = imageWidth * 51 / 30;
            }
        }
            break;
        case 8:{//八图
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight - 20;
                cropWidth = cropHeight / 23 * 15;
            }else
            {
                cropWidth = imageWidth - 20;
                cropHeight = cropWidth / 15 * 23;
            }
        }
            break;
        case 9:{//一加六大
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight * 0.9;
                cropWidth = cropHeight / 3 * 2;
            }else{
                cropWidth = imageWidth * 0.9;
                cropHeight = cropWidth * 3 / 2;
            }
        }
            break;
        case 10:{//一加六小
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight * 75 / 117;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 117 / 75;
            }
        }
            break;
        case 11:{//六图的大
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight;
                cropWidth = cropHeight / 21 * 26;
            }else{
                cropWidth = imageWidth;
                cropHeight = cropWidth / 26 * 21;
            }
        }
            break;
        case 12:{//六图的小
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 26 * 21;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 26 / 21;
            }
        }
            break;
        case 13:{//三上三下大
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight;
                cropWidth = cropHeight / 125 * 177;
            }else{
                cropWidth = imageWidth;
                cropHeight = cropWidth * 125 / 177;
            }
        }
            break;
        case 14:{//三上三下小
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight;
                cropWidth = imageHeight / 115 * 87;
            }else{
                cropWidth = imageWidth;
                cropHeight = imageWidth / 87 * 115;
            }
        }
            break;
        case 15:{//名片
            if ([self.phoneModel isEqualToString:@"iPad"]) {
                cropWidth = kDeviceWidth - 40;
                cropHeight =  kDeviceWidth - 40;
            }else{
                cropWidth = kDeviceWidth - 40;
                cropHeight = kDeviceWidth * 5 / 4 - 40;
            }
        }
            break;
        case 16:{//一加八小
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight - 40;
                cropWidth = cropHeight * 60 / 127;
            }else{
                cropWidth = imageWidth - 40;
                cropHeight = cropWidth * 127 / 60;
            }
        }
            break;
        case 17:{//一加八大
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight - 40;
                cropWidth = cropHeight * 111 / 255;
            }else{
                cropWidth = imageWidth - 40;
                cropHeight = cropWidth * 255 / 111;
            }
        }
            break;
            //背景
        case 18:{
            if (imageWidth > imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight * 1.2;
            }else{
                cropWidth =imageWidth ;
                cropHeight = cropWidth / 1.2;
            }
        }
            break;
            //右大五图右大
        case 19:
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 6 * 5;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 6 / 5;
            }
        }
            break;
            //七图中大
        case 20:
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight;
            }else{
                cropWidth = imageWidth;
                cropHeight = cropWidth;
            }
        }
            break;
            //上大五图大
        case 21:
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight * 2;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth / 2;
            }
        }
            break;
             //上大五图小
        case 22:
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 4 * 7;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 4 / 7;
            }
        }
            break;
            //4加1左大
        case 23:
        {
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 65 * 110;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 65 / 110;
            }
        }
            break;
             //4加1左小
        case 24:{
            if (imageWidth>imageHeight) {
                cropHeight = imageHeight ;
                cropWidth = cropHeight / 75 * 53;
            }else{
                cropWidth = imageWidth ;
                cropHeight = cropWidth * 75 / 53;
            }
        }
            break;
        case 25:{
            //裁剪套系图片
            cropWidth = kDeviceWidth;
            cropHeight = kDeviceWidth *TaoXiScale;
            cropWidth  = cropWidth * 0.9;
            cropHeight = cropHeight * 0.9;
            //cropHeight = kDeviceHeight/3;
            //cropWidth = kDeviceWidth / 8  * 7;
        }
        default:
            break;
    }

}



//返回按钮
- (void)backBtnClick:(UIButton *)btn{
    [self.navigationController  popViewControllerAnimated:YES];
}

//保存图片
- (void)saveBtnClick:(UIButton *)btn{
    //
    if ([self.delegate respondsToSelector:@selector(finishCropImage:)]) {
        [self.delegate finishCropImage:[_cropImageView cropImage] ];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
