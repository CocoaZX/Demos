//
//  JingPaiPartFourTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseJingPaiViewController.h"

@interface JingPaiPartFourTableViewCell : UITableViewCell

@property (strong, nonatomic) NSMutableArray *labelsArray;

@property (strong, nonatomic) UIView *labelsBackView;

@property (strong, nonatomic) UIView *labelTitleView;

@property (assign, nonatomic) float itemHeight;

@property (assign, nonatomic) int space;

@property (assign, nonatomic) float cellHeight;

@property (weak, nonatomic) ReleaseJingPaiViewController *controller;

@property (strong, nonatomic) UIView *customView;

@property (strong, nonatomic) NSMutableArray *redArrowArray;

@property (strong, nonatomic) NSMutableArray *itemViewArray;

- (void)resetLabelsView;

- (NSArray *)getTagsIdArr;

- (NSString *)getIdString;


+ (JingPaiPartFourTableViewCell *)getJingPaiPartFourTableViewCell;




@end
