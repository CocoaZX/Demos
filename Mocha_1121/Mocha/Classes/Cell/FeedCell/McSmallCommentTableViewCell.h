//
//  McCommentTableViewCell.h
//  Mocha
//
//  Created by renningning on 15/5/18.
//  Copyright (c) 2015年 renningning. All rights reserved.
//Feed列表里面展示的评论

#import <UIKit/UIKit.h>

@interface McSmallCommentTableViewCell : UITableViewCell

@property (nonatomic , assign)CGFloat tableViewWidth;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UIButton *headNameBtn;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

+ (McSmallCommentTableViewCell *)getFeedCommentCell;

@property (nonatomic,strong)NSDictionary *dict;


@end
