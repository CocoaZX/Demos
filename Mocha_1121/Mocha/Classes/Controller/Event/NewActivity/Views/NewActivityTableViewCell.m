//
//  NewActivityTableViewCell.m
//  Mocha
//
//  Created by sun on 15/8/19.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewActivityTableViewCell.h"
#import "ReadPlistFile.h"

@implementation NewActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.baomingView.layer.cornerRadius = 30;
    self.baomingView.layer.borderColor = RGB(220, 220, 220).CGColor;
    self.baomingView.layer.borderWidth = 0.5;
    self.shenfenLabel.layer.cornerRadius = 3;
    self.headerImageView.layer.cornerRadius = 20;
    
    
}


- (void)setCelldataWithDiction:(NSDictionary *)diction
{
    NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:diction];

    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSString *headerUrl = getSafeString([NSString stringWithFormat:@"%@",dict[@"publisher"][@"head_pic"]]);
        headerUrl = [NSString stringWithFormat:@"%@%@",headerUrl,[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        NSString *name = getSafeString([NSString stringWithFormat:@"%@",dict[@"publisher"][@"nickname"]]);
        
        NSString *vip = getSafeString([NSString stringWithFormat:@"%@",dict[@"publisher"][@"vip"]]);

        NSString *renzhengRen = getSafeString([NSString stringWithFormat:@" %@ ",dict[@"publisher"][@"user_type"]]);
        
        NSString *title = getSafeString([NSString stringWithFormat:@"%@",dict[@"title"]]);

        NSString *activityTime = [NSString stringWithFormat:@"%@至%@",dict[@"startdate"],dict[@"enddate"]];
        
        NSString *province = getSafeString(dict[@"provinceName"]);
        NSString *city = getSafeString(dict[@"cityName"]);
        
        NSString *activityArea = [NSString stringWithFormat:@"%@%@",province,city];
        
        NSString *yibaoming = getSafeString([NSString stringWithFormat:@"%@人",dict[@"signcount"]]);
        
        NSString *moneyPerDay = getSafeString([NSString stringWithFormat:@"%@元/天",dict[@"payment"]]);
        NSString *isMianYi = [NSString stringWithFormat:@"%@",dict[@"payment"]];
        if ([isMianYi isEqualToString:@"面议"]) {
            moneyPerDay = isMianYi;
        }
        NSString *limitPerson = getSafeString([NSString stringWithFormat:@"%@人",dict[@"number"]]);

        NSString *personType = getSafeString([NSString stringWithFormat:@"%@",dict[@"user_type"]]);

        NSString *mianshiType = getSafeString([NSString stringWithFormat:@"%@",dict[@"interview_method"]]);

        NSString *sexType = getSafeString([NSString stringWithFormat:@"%@",dict[@"sex"]]);
        
        UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:headerUrl];
        UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:headerUrl];
        if (image||image2) {
            self.headerImageView.image = image?:image2;
        }else
        {
            [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@"head60"]];
        }
        self.nameLabel.text = name;
        self.shenfenLabel.text = renzhengRen;
        self.activityDesc.text = title;
        self.timeLabel.text = activityTime;
        self.addressLabel.text = activityArea;
        self.peopleNumber.text = yibaoming;
        self.moneyPerDay.text = moneyPerDay;
        self.limitPeople.text = limitPerson;
        self.zhiyeLabel.text = personType;
        self.mianshiLabel.text = mianshiType;
        self.sexLabel.text = sexType;
       // vip = @"1";
        if ([vip isEqualToString:@"1"]) {
            self.renzheng.hidden = NO;
        }else
        {
            self.renzheng.hidden = YES;
        }
        
        
    }
    
    
}


+ (NewActivityTableViewCell *)getNewActivityCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewActivityTableViewCell" owner:self options:nil];
    NewActivityTableViewCell *cell = array[0];
    
    return cell;
    
}




@end
