//
//  AddLabelListViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLabelListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *labelArray;

@property (strong, nonatomic) NSMutableArray *selectLabelArray;

@property (strong, nonatomic) NSMutableArray *selectStateArray;

@property (strong, nonatomic) NSMutableArray *hotLabelArray;

@property (strong, nonatomic) UIImage *currentImage;

@property (strong, nonatomic) NSString *titleString;

@end
