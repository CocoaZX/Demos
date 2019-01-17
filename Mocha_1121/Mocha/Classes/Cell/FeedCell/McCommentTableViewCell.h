//
//  McCommentTableViewCell.h
//  Mocha
//
//  Created by renningning on 15/5/18.
//  Copyright (c) 2015年 renningning. All rights reserved.
//Feed列表里面展示的评论

#import <UIKit/UIKit.h>

@interface McCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeStringLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

+ (McCommentTableViewCell *)getFeedCommentCell;

- (void)setItemValueWithDict:(NSDictionary *)dict;

@end
