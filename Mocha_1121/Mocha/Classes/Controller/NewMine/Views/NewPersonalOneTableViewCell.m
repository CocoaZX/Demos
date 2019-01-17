//
//  NewPersonalOneTableViewCell.m
//  Mocha
//
//  Created by sun on 15/8/31.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewPersonalOneTableViewCell.h"

@implementation NewPersonalOneTableViewCell

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
    float xiongheight = 0;
//    if (self.isAppearXiong) {
//        xiongheight = 40;
//    }
    NSString *contentString = self.dataDiction[@"content"];
    float contentHeight = [SQCStringUtils getStringHeight:contentString width:kScreenWidth-40 font:15];
    self.contentLabel.frame = CGRectMake(20, 37+xiongheight, kScreenWidth-40, contentHeight);
    self.titleLabel.frame = CGRectMake(20, 8+xiongheight, 68, 21);
//    self.titleView.frame = CGRectMake(23, 30+xiongheight, 45, 2);
    self.lineView.frame = CGRectMake(0, contentHeight+50+xiongheight, kScreenWidth, 1);
}


- (void)initViewWithData:(NSDictionary *)diction
{
    self.dataDiction = diction;
//    if (self.isAppearXiong) {
//        [self addXiongViewToHere];
//    }else
//    {
//        self.xiongView.hidden = YES;
//
//    }
    NSString *titleString = diction[@"title"];
    NSString *contentString = diction[@"content"];
    self.titleLabel.text = titleString;
    self.contentLabel.text = contentString;
    if (contentString.length==0) {
        self.titleLabel.hidden = YES;
        self.titleView.hidden = YES;
    }
}

- (void)addXiongViewToHere
{
    float textfont = 14.0;
    NSString *heightString = [NSString stringWithFormat:@"身高:%@cm",self.dataDiction[@"height"]];
    NSString *weightString = [NSString stringWithFormat:@"体重:%@kg",self.dataDiction[@"weight"]];
    NSString *xiongString = [NSString stringWithFormat:@"三围:%@",self.dataDiction[@"sanwei"]];

    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    backV.backgroundColor = [UIColor clearColor];
    self.xiongView = backV;
    [self addSubview:self.xiongView];
    
    UILabel *heightLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 100, 30)];
    heightLabel.textAlignment = NSTextAlignmentLeft;
    heightLabel.textColor = [UIColor lightGrayColor];
    heightLabel.font = [UIFont systemFontOfSize:textfont];
    heightLabel.text = heightString;
    if ([self.dataDiction[@"height"] length]>0) {
        [backV addSubview:heightLabel];
        
    }
    
    UILabel *weightLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-50, 5, 100, 30)];
    weightLabel.textAlignment = NSTextAlignmentCenter;
    weightLabel.textColor = [UIColor lightGrayColor];
    weightLabel.font = [UIFont systemFontOfSize:textfont];
    weightLabel.text = weightString;
    if ([self.dataDiction[@"weight"] length]>0) {
        [backV addSubview:weightLabel];

    }
    
    UILabel *xiongLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-140, 5, 120, 30)];
    xiongLabel.textAlignment = NSTextAlignmentRight;
    xiongLabel.textColor = [UIColor lightGrayColor];
    xiongLabel.font = [UIFont systemFontOfSize:textfont];
    xiongLabel.text = xiongString;
    if ([self.dataDiction[@"sanwei"] length]>0) {
        [backV addSubview:xiongLabel];
        
    }
    
}

+ (NewPersonalOneTableViewCell *)getNewPersonalOneTableViewCell
{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"NewPersonalOneTableViewCell" owner:self options:nil];
    NewPersonalOneTableViewCell *cell = views[0];
    return cell;
    
}


+ (float)getCellheightWithString:(NSString *)content
{
    float contentHeight = [SQCStringUtils getStringHeight:content width:kScreenWidth-40 font:15];
    
    return contentHeight+50;
}




@end
