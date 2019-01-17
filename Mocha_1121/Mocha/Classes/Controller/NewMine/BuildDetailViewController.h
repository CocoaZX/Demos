//
//  BuildDetailViewController.h
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface BuildDetailViewController : UIViewController

@property (copy, nonatomic) NSString *mokaType;
@property (copy, nonatomic) NSString *albumid;
@property (copy, nonatomic) NSString *currentUid;

@property (assign, nonatomic) BOOL isEditing;

@property (assign,nonatomic)UIViewController *supCon;

@end