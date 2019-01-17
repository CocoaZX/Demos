//
//  NewCropViewController.m
//  Mocha
//
//  Created by sun on 15/9/9.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewCropViewController.h"
#import "BJImageCropper.h"

@interface NewCropViewController ()

@property (nonatomic, strong) BJImageCropper *imageCropper;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation NewCropViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isEqual:self.imageCropper] && [keyPath isEqualToString:@"crop"]) {
        
    
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    float width = kScreenWidth;
    float height = kScreenHeight;
    
    float scale = width/self.originImage.size.width;
    
    float imageWidth = self.originImage.size.width*scale*0.8;
    float imageHeight = self.originImage.size.height*scale*0.8;
    
    switch (self.cardType) {
        case 0:
        {   //五图经典大
            if (imageWidth>imageHeight) {
                width = imageHeight-20;
                height = imageHeight-20;
            }else
            {
                width = imageWidth-20;
                height = imageWidth-20;
            }
            
        }
            break;
        case 1://五图经典小
        {
            if (imageWidth>imageHeight) {
                width = imageHeight-40;
                height = imageWidth-40;
            }else
            {
                width = imageWidth-40;
                height = imageHeight-40;
            }
           
            
        }
            break;
        case 2://新式五图大
        {
            width = imageWidth-10;
            height = width*0.6;
        }
            break;
        case 3:
        {
            width = imageWidth-40;
            height = imageHeight-40;
        }
            break;
        case 4:
        {
            if (imageWidth>imageHeight) {
                width = imageHeight-20;
                height = imageHeight-20;
            }else
            {
                width = imageWidth-20;
                height = imageWidth-20;
            }
        }
            break;
        case 5:
        {
            if (imageWidth>imageHeight) {
                width = imageHeight-90;
                height = imageWidth-50;
            }else
            {
                width = imageWidth-90;
                height = imageHeight-50;
            }
        }
            break;
        case 6:
        {
            if (imageWidth>imageHeight) {
                width = imageHeight-40;
                height = imageWidth-50;
            }else
            {
                width = imageWidth-40;
                height = imageHeight-50;
            }
        }
            break;
        case 7:
        {
            if (imageWidth>imageHeight) {
                width = imageHeight-80;
                height = imageWidth-40;
            }else
            {
                width = imageWidth-80;
                height = imageHeight-40;
            }
        }
            break;
        case 8:{//八图
            if (imageWidth>imageHeight) {
                width = imageHeight-40;
                height = imageWidth-40;
            }else
            {
                width = imageWidth-40;
                height = imageHeight-40;
            }
        }
            break;
        case 9:{//一加六的一
            if (imageWidth>imageHeight) {
                height = imageHeight;
                width = height - 40;
            }else{
                width = imageWidth;
                height = imageHeight - 40;
            }
        }
            break;
        case 10:{//一加六的六
            if (imageWidth > imageHeight) {
                height = imageHeight - 40;
                width = height - 40;
            }else{
                width = imageWidth - 40;
                height = imageHeight - 40;
            }
        }
            break;
        default:
            break;
    }
    
    self.imageCropper = [[BJImageCropper alloc] initWithImage:self.originImage andMaxSize:CGSizeMake(kScreenWidth, kScreenHeight) isCustom:YES width:width height:height];
    [self.view addSubview:self.imageCropper];
    self.imageCropper.center = self.view.center;
    self.imageCropper.imageView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.imageCropper.imageView.layer.shadowRadius = 3.0f;
    self.imageCropper.imageView.layer.shadowOpacity = 0.8f;
    self.imageCropper.imageView.layer.shadowOffset = CGSizeMake(1, 1);
//    [self.imageCropper addObserver:self forKeyPath:@"crop" options:NSKeyValueObservingOptionNew context:nil];

    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.imageCropper.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    self.saveButton.frame = CGRectMake(kScreenWidth-87, 11, 87, 43);
    [self.view bringSubviewToFront:self.saveButton];
    [self.view bringSubviewToFront:self.backButton];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateNO" object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateYES" object:nil];

}

- (IBAction)backMethod:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (IBAction)saveMethod:(id)sender {
    UIImage *image = [self.imageCropper getCroppedImage];
//    self.callBack(image);
    if ([self.delegate respondsToSelector:@selector(finishCropImage:)]) {
        [self.delegate finishCropImage:image];
    }
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)setreturnBlock:(ChangeCropFinishBlock)block
{
    self.callBack = block;
    
}

@end