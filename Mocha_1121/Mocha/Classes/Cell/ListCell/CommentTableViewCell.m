//
//  CommentTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/15.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)reSetFrame
{
    self.timeString.frame = CGRectMake(kScreenWidth-130, 10, 120, 21);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CommentTableViewCell *)getCommentCell
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"CommentTableViewCell" owner:self options:nil];
    CommentTableViewCell *cell = nibs[0];
    cell.headerImageView.layer.cornerRadius = 19;
    cell.nameLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    cell.descriptionLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    cell.lineImageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
    cell.lineImageView.frame = CGRectMake(10, 0, kScreenWidth - 20, 0.5);
    return cell;
}

- (void)setItemValueWithDict:(NSDictionary *)dict
{
    NSString *urlString = dict[@"head_pic"];
    [_headerImageView setImageWithURL:[NSURL URLWithString:urlString?urlString:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSString *name = dict[@"nickname"];
    NSString *content = dict[@"content"];
    NSString *createline = [NSString stringWithFormat:@"%@",dict[@"createline"]];
    NSLog(@"%@",createline);
    //设置昵称，vip
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
    _timeString.text = [CommonUtils dateTimeIntervalString:createline];
    
    
}

//- (IBAction)doTouchHeaderBut:(id)sender {
//    NSLog(@"头像点击");
//    UIButton *but = (UIButton *)sender;
//    NSLog(@"%ld",(long)but.tag);
//}





@end
