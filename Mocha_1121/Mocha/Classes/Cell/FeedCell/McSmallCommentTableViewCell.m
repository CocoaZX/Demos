//
//  McCommentTableViewCell.m
//  Mocha
//
//  Created by renningning on 15/5/18.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McSmallCommentTableViewCell.h"
#import <CoreText/CoreText.h>

@implementation McSmallCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//反回评论单元格
+ (McSmallCommentTableViewCell *)getFeedCommentCell
{
    
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McSmallCommentTableViewCell" owner:self options:nil];
    McSmallCommentTableViewCell *cell = nibs[0];
    //cell.backgroundColor = [UIColor colorWithRed:arc4random()%10*0.1 green:arc4random()%10*0.1 blue:arc4random()%10*0.1 alpha:1];
    return cell;
}



- (void)setDict:(NSDictionary *)dict{
    if (_dict != dict) {
        _dict = dict;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //评论人的昵称上的按钮
    _headNameBtn.frame = CGRectMake(0, 0, CGRectGetWidth(_headNameBtn.frame) + 10, 20);
   // _headNameBtn.backgroundColor  = [UIColor redColor];
    [_headNameBtn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [self bringSubviewToFront:_headNameBtn];

    //昵称
    _nameLabel.textColor = [UIColor clearColor];
    _nameLabel.hidden =YES;
    //评论内容
    _descriptionLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    //富文本
    NSAttributedString *aString = [self getAttributedString:_dict];
    _descriptionLabel.attributedText =aString;
    _descriptionLabel.numberOfLines = 0;
    _descriptionLabel.frame = CGRectMake(0, 0, self.width, self.height);
    
}





#pragma mark 处理富文本
//获取一个富文本
- (NSAttributedString *)getAttributedString:(NSDictionary *)dict{
    
    NSString *name = dict[@"nickname"];
    NSString *content = getSafeString(dict[@"content"]);
    NSRange enterName = [name rangeOfString:@"\n"];
    if (enterName.length) {
        name = [name substringToIndex:enterName.location];
    }
    //完整字符串
    NSString *allString = [NSString stringWithFormat:@"%@ : %@",name,content];
    NSRange nameRange = [allString rangeOfString:name];
    NSRange contentRange = [allString rangeOfString:content];
    
    //创建富文本
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:allString attributes:nil];
    
    //昵称的属性
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByClipping;//不断行
    
    //设置会员昵称颜色
    NSString *nameTextColor = kLikeGrayColor;
    NSString *isMember = getSafeString(self.dict[@"member"]);
    if ([isMember isEqualToString:@"1"]) {
        nameTextColor = kLikeMemberNameColor;
    }else{
        nameTextColor = kLikeGrayColor;
    }
    
    NSDictionary *nickAttrDict = @{NSParagraphStyleAttributeName: paraStyle01,
                                  NSFontAttributeName: [UIFont systemFontOfSize: 14],NSForegroundColorAttributeName:[UIColor colorForHex:nameTextColor]};
    //评论内容的属性
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;//断行
    NSDictionary *conetentAttrDict = @{NSParagraphStyleAttributeName: paraStyle02,
                                   NSFontAttributeName: [UIFont systemFontOfSize: 14],NSForegroundColorAttributeName:[UIColor colorForHex:kLikeGrayTextColor]};
    //设置属性
    [attributedString setAttributes:nickAttrDict range:nameRange];
    [attributedString setAttributes:conetentAttrDict range:contentRange];

    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont boldSystemFontOfSize:14] range:nameRange];
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:14] range:contentRange];
    
    return attributedString;
}


@end
