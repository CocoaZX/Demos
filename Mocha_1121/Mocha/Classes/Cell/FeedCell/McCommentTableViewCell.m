//
//  McCommentTableViewCell.m
//  Mocha
//
//  Created by renningning on 15/5/18.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McCommentTableViewCell.h"

@implementation McCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (McCommentTableViewCell *)getFeedCommentCell
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McCommentTableViewCell" owner:self options:nil];
    McCommentTableViewCell *cell = nibs[0];
    
    cell.nameLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    cell.descriptionLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    cell.timeStringLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    
    cell.lineImageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
    
    return cell;
}

- (void)setItemValueWithDict:(NSDictionary *)dict
{
    NSString *urlString = dict[@"head_pic"];
    [_headerImageView setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSString *name = dict[@"nickname"];
    NSString *content = dict[@"content"];
    NSString *createline = [NSString stringWithFormat:@"%@",dict[@"createline"]];
    
    _nameLabel.text = name;
    _descriptionLabel.text = content;
    
    float width = CGRectGetWidth(self.frame) - 80;
    CGSize size = [CommonUtils sizeFromText:content textFont:_descriptionLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, 200)];
    if (size.height > 21) {
        _descriptionLabel.numberOfLines = 0;
        CGRect frame = _descriptionLabel.frame;
        frame.size.height = size.height;
        _descriptionLabel.frame = frame;
    }
    _timeStringLabel.text = [CommonUtils dateTimeIntervalString:createline];
    
    
}

@end
