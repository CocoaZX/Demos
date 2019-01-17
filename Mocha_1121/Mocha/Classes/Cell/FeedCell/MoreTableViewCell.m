//
//  MoreTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 15/12/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(MoreTableViewCell *)getMoreTableViewCell{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"MoreTableViewCell" owner:self options:nil];
    MoreTableViewCell *cell = nibs[0];
    cell.height = 20;
    cell.commentsLabel.font = [UIFont systemFontOfSize:14];
    //cell.backgroundColor = RGBA(102, 102, 102, 0.1);
    [cell addSubview:cell.commentsLabel];
    [cell.commentsLabel addSubview:cell.enterImageView];
    return cell;
}

-(void)initWithInt:(int)comments{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"查看全部%d条评论 ",comments]];
    NSTextAttachment *attch = [[NSTextAttachment alloc]init];
    attch.image = [UIImage imageNamed:@"enter"];
    attch.bounds = CGRectMake(0, 0, 10, 10);
    
    NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
    
    [str appendAttributedString:imageStr];
    self.commentsLabel.attributedText = str;
    self.commentsLabel.frame = CGRectMake(0, 0, kDeviceWidth - 16,self.height);
    self.commentsLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
 }

-(UILabel *)commentsLabel{
    if (!_commentsLabel) {
        _commentsLabel = [[UILabel alloc]init];
    }
    return _commentsLabel;
}

-(UIImageView *)enterImageView{
    if (!_enterImageView) {
        _enterImageView = [[UIImageView alloc]init];
    }
    return _enterImageView;
}

@end
