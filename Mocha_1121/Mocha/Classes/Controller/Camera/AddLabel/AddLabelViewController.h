//
//  AddLabelViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLabelViewController : UIViewController

@property (retain, nonatomic) UIImage *currentImage;

#ifdef TencentRelease

@property (strong, nonatomic) NSURL *videoURL;

#endif


@end
