//
//  AlbumDetailViewController.h
//  Mocha
//
//  Created by sun on 15/9/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface AlbumDetailViewController : McBaseViewController

@property (copy, nonatomic) NSString *currentTitle;

@property (copy, nonatomic) NSString *albumid;

@property (copy, nonatomic) NSString *currentUid;

@end
