//
//  McUploadPhotoViewController.h
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface McUploadPhotoViewController : UIViewController

@property (nonatomic, assign) NSInteger takeType;

@property (nonatomic, retain) UIImage *currentImage;
@property (nonatomic, strong) NSDictionary *currentInfoDict;
@property (nonatomic, assign) BOOL isShow;

@end
