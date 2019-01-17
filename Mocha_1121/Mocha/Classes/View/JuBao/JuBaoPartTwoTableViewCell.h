//
//  JuBaoPartTwoTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJuBaoViewController.h"

@interface JuBaoPartTwoTableViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *statusArray;
@property (strong, nonatomic) NSMutableArray *viewsArray;
@property (strong, nonatomic) NSMutableArray *picturesArray;
@property (strong, nonatomic) NSMutableArray *picturesAlbumArray;

@property (strong, nonatomic) UIView *statusBackView;

@property (assign, nonatomic) float itemHeight;

@property (assign, nonatomic) int space;

@property (assign, nonatomic) float cellHeight;

@property (strong, nonatomic) UIImagePickerController* imagePickerController;

@property (weak, nonatomic) MCJuBaoViewController *controller;

@property (strong, nonatomic) UILabel *daojishi;
@property (strong, nonatomic) NSTimer *daojishiTimer;
@property (strong, nonatomic) NSURL *videoURL;
@property (strong, nonatomic) UIImage *videoImage;

@property (strong, nonatomic) UIImageView *videoImageView;


@property (copy, nonatomic) NSString *videoString;
@property (copy, nonatomic) NSString *videoImageString;

- (void)addButtons;



+ (JuBaoPartTwoTableViewCell *)getJuBaoPartTwoTableViewCell;




@end
