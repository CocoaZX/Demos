//
//  McListTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

//static float headWidth = 40;
//static float photoWidth = 80;

@interface McListTableViewCell()
{
    NSMutableArray *constraintArray;
}

@end


@implementation McListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor whiteColor]];
        //头像
        headImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:headImageView];
        [headImageView.layer setMasksToBounds:YES];
        [headImageView.layer setCornerRadius:10.0f];
        
        //昵称
        nameLabel = [[UILabel alloc] init];
        nameLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        nameLabel.font = kFont16;
        nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:nameLabel];
        
        photoImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:photoImageView];
        photoImageView.backgroundColor = [UIColor whiteColor];
        [photoImageView.layer setMasksToBounds:YES];
        [photoImageView.layer setCornerRadius:10.0f];
        
        zanLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 42, 58, 21)];
        [self.contentView addSubview:zanLabel];
        zanLabel.font = [UIFont systemFontOfSize:14];
        zanLabel.text = @"给你点赞";
        zanLabel.textColor = [UIColor lightGrayColor];
        zanLabel.backgroundColor = [UIColor whiteColor];
        
        likeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(128, 35, 30, 30)];
        [self.contentView addSubview:likeImageView];
        likeImageView.image = [UIImage imageNamed:@"likeButton"];
        likeImageView.backgroundColor = [UIColor whiteColor];
        [likeImageView.layer setMasksToBounds:YES];
        
        contentLabel = [[UILabel alloc] init];
        contentLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
        contentLabel.font = kFont14;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        
        plusLable = [[UILabel alloc] init];
        plusLable.textColor = [UIColor colorForHex:kLikeRedColor];
        plusLable.font = kFont14;
        plusLable.text = @"x1";
//        plusLable.numberOfLines = 0;
        plusLable.backgroundColor = [UIColor clearColor];

        [self.contentView addSubview:plusLable];
        
        goodsImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:goodsImageView];
        goodsImageView.backgroundColor = [UIColor clearColor];
        [goodsImageView.layer setMasksToBounds:YES];
        [goodsImageView.layer setCornerRadius:5.0f];
        
        
        timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
        timeLabel.font = kFont12;
        timeLabel.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:timeLabel];
        
        lineImageView = [[UIImageView alloc] init];
        lineImageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
        [self.contentView addSubview:lineImageView];
        
        [headImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [timeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [lineImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [photoImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [plusLable setTranslatesAutoresizingMaskIntoConstraints:NO];
        [goodsImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[headImageView(==40)]" options:0 metrics:nil views:@{@"headImageView":headImageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[headImageView(==40)]" options:0 metrics:nil views:@{@"headImageView":headImageView}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:headImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[photoImageView(==80)]" options:0 metrics:nil views:@{@"photoImageView":photoImageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[photoImageView(==80)]" options:0 metrics:nil views:@{@"photoImageView":photoImageView}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:photoImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[nameLabel(==21)]" options:0 metrics:nil views:@{@"nameLabel":nameLabel}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headImageView attribute:NSLayoutAttributeRight multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:nameLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:photoImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-5]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[contentLabel(>=21)]" options:0 metrics:nil views:@{@"contentLabel":contentLabel}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nameLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:5]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[goodsImageView(==20)]" options:0 metrics:nil views:@{@"goodsImageView":goodsImageView}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[goodsImageView(==20)]" options:0 metrics:nil views:@{@"goodsImageView":goodsImageView}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goodsImageView    attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentLabel attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:goodsImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[plusLable(==21)]" options:0 metrics:nil views:@{@"plusLable":plusLable}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:plusLable    attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:goodsImageView attribute:NSLayoutAttributeRight multiplier:1 constant:5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:plusLable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentLabel attribute:NSLayoutAttributeTop multiplier:1 constant:0]];

    
        
        
        
//        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:photoImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:-30]];
        
        
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[timeLabel(==120)]" options:0 metrics:nil views:@{@"timeLabel":timeLabel}]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[timeLabel(==15)]" options:0 metrics:nil views:@{@"timeLabel":timeLabel}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentLabel attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-10]];
        
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[lineImageView(==0.5)]" options:0 metrics:nil views:@{@"lineImageView":lineImageView}]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1 constant:10]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-0.5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:lineImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1 constant:-10]];
        
        
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (float)getContentViewHeightWithDict:(NSDictionary *)itemDict
{
    float width = self.contentView.frame.size.width - 60 - 100;
    NSString *str = getSafeString(itemDict[@"content"]);
    CGSize size = [CommonUtils sizeFromText:str textFont:contentLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, width)];
    float top = 36;
    float bottom = 30;
    
    return (size.height + top + bottom) > 100? (size.height + 36 + 30): 100 ;
}

- (float)getContentViewHeightWithDict_shang:(NSDictionary *)itemDict
{
    float width = self.contentView.frame.size.width - 60 - 100;
    CGSize size = [CommonUtils sizeFromText:itemDict[@"description"] textFont:contentLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, width)];
    float top = 36;
    float bottom = 30;
    
    return (size.height + top + bottom) > 100? (size.height + 36 + 30): 100 ;
}

- (void)setItemValueWithDict:(NSDictionary *)itemDict
{
    //我的评论设置cell约束
    [goodsImageView removeFromSuperview];
    [plusLable removeFromSuperview];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:photoImageView attribute:NSLayoutAttributeLeft multiplier:1 constant:-30]];
    
    
    NSString *jpg = [CommonUtils imageStringWithWidth:40 * 2 height:40 * 2];
    NSString *url = [NSString stringWithFormat:@"%@%@",itemDict[@"head_pic"],jpg];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"]];
    nameLabel.text = itemDict[@"nickname"];
    contentLabel.text = itemDict[@"content"];
    
    float width = self.contentView.frame.size.width - 60 - 100;
    NSString *str = getSafeString(itemDict[@"content"]);
    CGSize size = [CommonUtils sizeFromText:str textFont:contentLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, width)];
    if (size.height > 21) {
        
        //先将原来的高度约束删除
        for(NSLayoutConstraint *lay in self.contentView.constraints){
            switch (lay.firstAttribute) {
                case NSLayoutAttributeHeight:
                    [self removeConstraint:lay];
                    break;
                default:
                    break;
            }
        }
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-30]];
        

    }
    
    NSString *jpgPhoto = [CommonUtils imageStringWithWidth:80 * 2 height:80 * 2];
    //区分视频和其他图片链接
    NSString *imgUrl = @"";
    if ([itemDict[@"object_type"] isEqualToString:@"11"]) {
        //此为视频
        imgUrl = itemDict[@"cover_url"];
    }else{
        imgUrl = itemDict[@"url"];
    }
    NSString *urlPhoto = [NSString stringWithFormat:@"%@%@",imgUrl,jpgPhoto];
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:urlPhoto]];
    timeLabel.text = [CommonUtils dateTimeIntervalString:itemDict[@"createline"]]; //createline
    
    NSString *type = [NSString stringWithFormat:@"%@",itemDict[@"type"]];
    if ([type isEqualToString:@"2"]) {
        likeImageView.hidden = NO;
        zanLabel.hidden = NO;
    }else{
        likeImageView.hidden = YES;
        zanLabel.hidden = YES;
    }
    
    //背景色显示新评论
    NSString *isNew = getSafeString(itemDict[@"is_new"]);
    if ([isNew integerValue] == 1) {
        self.contentView.backgroundColor = [CommonUtils colorFromHexString:kLikePinkColor];
        self.alpha = 1;
        contentLabel.textColor = [UIColor colorForHex:kLikeBlackColor];

    }else{
         self.alpha = 1;
        contentLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
    }
    
}

- (void)setItemValueWithDict_shang:(NSDictionary *)itemDict
{
    NSString *jpg = [CommonUtils imageStringWithWidth:40 * 2 height:40 * 2];
    NSLog(@"%@",itemDict);
    NSString *url = [NSString stringWithFormat:@"%@%@",itemDict[@"from_user"][@"head_pic"],jpg];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"]];
    nameLabel.text = itemDict[@"from_user"][@"nickname"];
    
    NSString *contentStr = getSafeString(itemDict[@"description"]);
    NSString *content = [contentStr stringByReplacingOccurrencesOfString:nameLabel.text withString:@""];
    contentLabel.text = content;
    
    float width = self.contentView.frame.size.width - 60 - 100;
    CGSize size = [CommonUtils sizeFromText:itemDict[@"from_user"][@"description"] textFont:contentLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, width)];
    if (size.height > 21) {
        
        //先将原来的高度约束删除
        for(NSLayoutConstraint *lay in self.contentView.constraints){
            switch (lay.firstAttribute) {
                case NSLayoutAttributeHeight:
                    [self removeConstraint:lay];
                    break;
                default:
                    break;
            }
        }
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:contentLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1 constant:-30]];
        
    }
    
    NSString *jpgPhoto = [CommonUtils imageStringWithWidth:80 * 2 height:80 * 2];
    NSString *urlPhoto = @"";
    if ([getSafeString(itemDict[@"from_object_type"]) isEqualToString:@"6"]) {
        urlPhoto = [NSString stringWithFormat:@"%@%@",itemDict[@"objectData"][@"url"],jpgPhoto];
    }else{
        urlPhoto = [NSString stringWithFormat:@"%@%@",itemDict[@"objectData"][@"cover_url"],jpgPhoto];
    }
    
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:urlPhoto]];
    
    NSString *goodsPhoto = [CommonUtils PngImageStringWithWidth:20 * 2 height:20 * 2];
    NSLog(@"%@",itemDict);
    NSString *goodsUrl = [NSString stringWithFormat:@"%@%@",itemDict[@"vgoods_img"],goodsPhoto];
    [goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsUrl]];
    
    timeLabel.text = [CommonUtils dateTimeIntervalString:itemDict[@"create_time"]]; //createline
    
    likeImageView.hidden = YES;
    zanLabel.hidden = YES;
    
}

@end
