//
//  CommentTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/15.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoViewDetailController.h"

@interface CommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeString;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (nonatomic , strong)PhotoViewDetailController *supCon;

- (void)reSetFrame;

+ (CommentTableViewCell *)getCommentCell;

- (void)setItemValueWithDict:(NSDictionary *)dict;


@end
