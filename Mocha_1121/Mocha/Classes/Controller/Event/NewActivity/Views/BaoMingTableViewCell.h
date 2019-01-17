//
//  BaoMingTableViewCell.h
//  Mocha
//
//  Created by sun on 15/8/28.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 
 {
 amount = 0;
 createline = "2015-08-28 10:55:34";
 eventid = 13;
 "head_pic" = "http://cdn.q8oils.cc/fdc1cd1e6c4243eba47bbe87c74d9c6e";
 id = 8;
 nickname = "\U82b1\U9519\U7530";
 status = 1;
 statusName = "\U62a5\U540d\U901a\U8fc7";
 type = "\U6a21\U7279";
 uid = 360;
 }
 
 */








#import "ManageActivityViewController.h"


@interface BaoMingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userType;

@property (weak, nonatomic) IBOutlet UIView *firstLine;

@property (weak, nonatomic) IBOutlet UIView *secondLine;

@property (weak, nonatomic) IBOutlet UIView *thirdLine;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@property (weak, nonatomic) IBOutlet UIButton *refuseButton;

@property (strong, nonatomic) NSDictionary *dataDiction;

@property (weak, nonatomic) ManageActivityViewController *supCon;

- (void)setDataWithDiction:(NSDictionary *)diction;


+ (BaoMingTableViewCell *)getBaoMingTableViewCell;





@end
