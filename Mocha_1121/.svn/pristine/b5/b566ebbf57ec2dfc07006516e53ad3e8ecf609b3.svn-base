//
//  YuePaiTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiTableViewCell.h"

@implementation YuePaiTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.faqiHeader.layer.cornerRadius = 25;
    self.jieshouHeader.layer.cornerRadius = 25;
    self.startTitleUserName.layer.cornerRadius = 3;
    self.accecptTitleUserName.layer.cornerRadius = 3;
    
}

- (void)setData:(id)dict
{
    //AppIcon
    NSDictionary *diction = (NSDictionary *)dict;
    
    NSString *startName = getSafeString(diction[@"nickname"]);
    NSString *startHeader = getSafeString(diction[@"head_pic"]);
    
    NSString *receiveName = getSafeString(diction[@"to_nickname"]);
    NSString *receiveHeader = getSafeString(diction[@"to_head_pic"]);
    
    NSString *state = getSafeString(diction[@"statusName"]);
    NSString *createTime = getSafeString(diction[@"create_time"]);
    NSString *paiTime = getSafeString(diction[@"covenant_time"]);
    NSString *paiMoney = getSafeString(diction[@"money"]);
    
    NSString *object_type = getSafeString(diction[@"object_type"]);
    self.object_id = getSafeString(diction[@"object_id"]);
    self.covenant_id = getSafeString(diction[@"covenant_id"]);
    NSString *mark = getSafeString(diction[@"mark"]);

    if ([object_type isEqualToString:@"10"]) {
        _isTaoXi = YES;
        if ([diction[@"object_content"] isKindOfClass:[NSDictionary class]]) {
            NSString *taoXiName = getSafeString(diction[@"object_content"][@"setname"]);
            self.TaoXiNameLabel.text = [NSString stringWithFormat:@"专题名称:%@",taoXiName];
        }
        self.TaoXiPersonNameLabel.text = [NSString stringWithFormat:@"摄影师：%@",receiveName];
        self.TaoXiTimeLabel.text = [NSString stringWithFormat:@"日期:%@",paiTime];
        self.TaoXiMarkText.text = [NSString stringWithFormat:@" 备注:%@",mark];
    }
    self.faqiLabel.text = startName;
    self.jieshouLabel.text = receiveName;
    self.creatLabel.text = createTime;
    self.stateLabel.text = state;
    self.moneyLabel.text = paiMoney;
    self.paisheLabel.text = paiTime;

    
    [self.faqiHeader sd_setImageWithURL:[NSURL URLWithString:startHeader] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    [self.jieshouHeader sd_setImageWithURL:[NSURL URLWithString:receiveHeader] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    
    if (_isTaoXi) {
        _taoXIView.hidden = NO;
    }else{
        _taoXIView.hidden = YES;
    }
}

+ (YuePaiTableViewCell *)getYuePaiTableViewCell
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"YuePaiTableViewCell" owner:self options:nil];
    YuePaiTableViewCell *view = array[0];
    return view;
}


- (IBAction)deleteYuePai:(id)sender {
    [self.supCon deleteYuePaiWithId:self.covenant_id.copy];
}



@end
