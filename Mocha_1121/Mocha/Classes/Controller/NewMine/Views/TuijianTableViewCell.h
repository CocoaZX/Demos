//
//  TuijianTableViewCell.h
//  Mocha
//
//  Created by sunqichao on 15/9/13.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TuijianTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//第一个label的左边距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabel_left;


+ (TuijianTableViewCell *)getTuijianTableViewCell;


@end
