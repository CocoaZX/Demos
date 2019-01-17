//
//  JingPaiPartTwoTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseJingPaiViewController.h"
#import "LocalPhotoViewController.h"

@interface JingPaiPartTwoTableViewCell : UITableViewCell<SelectPhotoDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSMutableArray *statusArray;
@property (strong, nonatomic) NSMutableArray *viewsArray;
@property (strong, nonatomic) NSMutableArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *picturesAlbumArray;

@property (strong, nonatomic) UIView *statusBackView;

@property (assign, nonatomic) float itemHeight;

@property (assign, nonatomic) int space;

@property (assign, nonatomic) float cellHeight;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property (weak, nonatomic) ReleaseJingPaiViewController *controller;

@property (strong, nonatomic) UILabel *daojishi;
@property (strong, nonatomic) NSTimer *daojishiTimer;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) UIImage *videoImage;

@property (strong, nonatomic) UIImageView *videoImageView;


@property (copy, nonatomic) NSString *videoString;
@property (copy, nonatomic) NSString *videoImageString;

- (void)addButtons;

+ (JingPaiPartTwoTableViewCell *)getJingPaiPartTwoTableViewCell;


@end
