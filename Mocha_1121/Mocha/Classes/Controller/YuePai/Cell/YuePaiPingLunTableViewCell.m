//
//  YuePaiPingLunTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/1/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "YuePaiPingLunTableViewCell.h"

@implementation YuePaiPingLunTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}  

- (void)setDataWithDic:(NSDictionary *)diction
{
    
    NSString *headerURL = getSafeString(diction[@"head_pic"]);
    NSString *name = getSafeString(diction[@"nickname"]);
    NSString *type = @"";
    NSString *content = getSafeString(diction[@"content"]);
    NSString *time = getSafeString(diction[@"create_time"]);
    NSString *stars = getSafeString(diction[@"star_level"]);

    NSString *is_owner = diction[@"is_owner"];
    if ([is_owner isEqualToString:@"0"]) {
        self.typeLabel.backgroundColor = RGB(156, 214, 46);
    }else{
        self.typeLabel.backgroundColor = RGB(237, 59, 78);
    }
    
    type = diction[@"user_type"];
    self.typeLabel.layer.cornerRadius = 5;
    self.headerImage.layer.cornerRadius = 15;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = name;
    self.typeLabel.text = type;
    self.contentLabel.text = content;
    self.timeLabel.text = time;
    [self getStarWithNumber:[stars intValue]];
    
}

- (void)getStarWithNumber:(int)number
{
    int startWidth = 20;
    if (kScreenWidth==320) {
        startWidth = 18;
    }else if(kScreenWidth==375)
    {
        
    }else
    {
        
    }
    
    for (int i=0; i<number; i++) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.starView.width - 20 - i * startWidth, 5, startWidth, startWidth)];
        imgView.image = [UIImage imageNamed:@"xingxing"];
        [self.starView addSubview:imgView];
    }
    
}

+ (YuePaiPingLunTableViewCell *)getYuePaiPingLunTableViewCell
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"YuePaiPingLunTableViewCell" owner:self options:nil];
    YuePaiPingLunTableViewCell *view = array[0];
    return view;
    
}











@end
