//
//  NewFeedbackCellOneTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeedbackCellOneTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *backView;


@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NSMutableArray *statusArray;
@property (strong, nonatomic) NSMutableArray *statusArray_full;

@property (strong, nonatomic) NSMutableArray *viewsArray;

@property (copy, nonatomic) NSString *choseType;

@property (assign, nonatomic) float cellHeight;


- (void)addItemViews;

+ (NewFeedbackCellOneTableViewCell *)getNewFeedbackCellOneTableViewCell;


@end
