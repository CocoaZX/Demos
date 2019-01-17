//
//  SystemMessageTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 15/2/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "SystemMessageTableViewCell.h"

@implementation SystemMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [self setNeedsLayout];
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    

    self.nameLabel.text = _dataDic[@"title"];
    self.nameLabel.textColor = [UIColor colorForHex:kLikeGrayColor];

    
    self.descLabel.text = _dataDic[@"content"];
    NSString *content = self.descLabel.text;
    CGFloat height = [CommonUtils sizeFromText:content textFont:kFont15 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
    self.descLabel.frame = CGRectMake(15,35,kScreenWidth - 30,height);
    
    self.timeLabel.text = [CommonUtils dateTimeIntervalString:_dataDic[@"createline"]];
    
    //调整背景色显示新通知
    NSString *isNew = getSafeString(_dataDic[@"is_new"]);
    if ([isNew integerValue] == 1) {
         self.backgroundColor = [CommonUtils colorFromHexString:kLikePinkColor];
        self.descLabel.textColor = [UIColor colorForHex:kLikeBlackColor];
    }else{
         self.backgroundColor = [UIColor clearColor];
        self.descLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
        
    }
    
    self.contentView.frame = CGRectMake(0, 0, kScreenWidth, height + 50);
}








- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"SystemMessageTableViewCell" owner:nil options:nil];
        self = nibs[0];
    }
    return self;
}

+ (SystemMessageTableViewCell *)getSystemMessage
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"SystemMessageTableViewCell" owner:self options:nil];
    SystemMessageTableViewCell *cell = array[0];

    return cell;
}

@end
