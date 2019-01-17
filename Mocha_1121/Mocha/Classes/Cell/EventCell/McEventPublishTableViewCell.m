//
//  McEventPublishTableViewCell.m
//  Mocha
//
//  Created by renningning on 15-4-7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McEventPublishTableViewCell.h"

@interface McEventPublishTableViewCell()
{
    IBOutlet UIImageView *iconImageView;
    IBOutlet UILabel *titleLabel;
}

@end

@implementation McEventPublishTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McEventPublishTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self initSubViews];
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

- (void)initSubViews
{
    titleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    _contentLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    _contentLabel.textAlignment = NSTextAlignmentRight;
}

- (void)setItemValueWithDict:(NSDictionary *)itemDict
{
    [iconImageView setImage:[UIImage imageNamed:itemDict[@"image"]]];
    [titleLabel setText:itemDict[@"title"]];
    _contentLabel.text = @"";
}

- (void)setContent:(NSString *)content
{
    _contentLabel.text = content;
}


@end
