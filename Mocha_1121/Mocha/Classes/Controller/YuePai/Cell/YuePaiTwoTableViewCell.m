//
//  YuePaiTwoTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiTwoTableViewCell.h"

@implementation YuePaiTwoTableViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.payButton.clipsToBounds = YES;
    self.payButton.layer.borderColor = [CommonUtils colorFromHexString:kLikeRedColor].CGColor;
    self.payButton.layer.cornerRadius = 3;
    self.payButton.layer.borderWidth = 1;
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
    self.opCode = getSafeString(diction[@"opCode"]);
     id opname = diction[@"opName"];
    NSString *opName = @"";
    self.object_id = getSafeString(diction[@"object_id"]);
    self.covenant_id = getSafeString(diction[@"covenant_id"]);
    if ([opname isKindOfClass:[NSDictionary class]]) {
        opName = getSafeString(opname[@"1"]);
        
    }
    
    self.faqiLabel.text = startName;
    self.jieshouLabel.text = receiveName;
    self.creatLabel.text = createTime;
    self.stateLabel.text = state;
    self.moneyLabel.text = paiMoney;
    self.paisheLabel.text = paiTime;

    [self.faqiHeader sd_setImageWithURL:[NSURL URLWithString:startHeader] placeholderImage:[UIImage imageNamed:@"AppIcon"]];
    [self.jieshouHeader sd_setImageWithURL:[NSURL URLWithString:receiveHeader] placeholderImage:[UIImage imageNamed:@"AppIcon"]];

    
    if ([self.opCode isEqualToString:@"0"])
    {
        if (opName.length==0) {
            opName = @"详情";
        }
        [self.payButton setTitle:opName forState:UIControlStateNormal];
    }else
    {
        if (opName.length==0) {
            opName = @"支付";
        }
        [self.payButton setTitle:opName forState:UIControlStateNormal];

    }
    NSString *object_type = getSafeString(diction[@"object_type"]);
    if ([object_type isEqualToString:@"10"]) {
        _isTaoXi = YES;
        if ([diction[@"object_content"] isKindOfClass:[NSDictionary class]]) {
            NSString *taoXiName = getSafeString(diction[@"object_content"][@"setname"]);
             self.taoXiNameLabel.text = [NSString stringWithFormat:@"专题名称:%@",taoXiName];
        }
        NSString *mark = getSafeString(diction[@"mark"]);
       
        self.taoXiPersonNameLabel.text = [NSString stringWithFormat:@"摄影师：%@",receiveName];
        self.taoXiTimeLabel.text = [NSString stringWithFormat:@"日期:%@",paiTime];
        self.taoxiMark.text = [NSString stringWithFormat:@" 备注:%@",mark];

    }

    
    if (_isTaoXi) {
        _taoXiView.hidden = NO;
    }else{
        _taoXiView.hidden = YES;
    }
    
    
}

- (IBAction)payYuePai:(id)sender {
    if (self.payMethod) {
        if ([self.opCode isEqualToString:@"0"]) {
            self.payMethod(500);

        }else if ([self.opCode isEqualToString:@"4"]) {
            self.payMethod(400);
            
        }else if ([self.opCode isEqualToString:@"5"]) {
            self.payMethod(300);
            
        }else if ([self.opCode isEqualToString:@"6"]) {
            self.payMethod(600);
            
        }else
        {
            self.payMethod(self.currentIndex);

        }

    }
    
}


+ (YuePaiTwoTableViewCell *)getYuePaiTwoTableViewCell
{
    NSArray *array = [[NSBundle mainBundle]loadNibNamed:@"YuePaiTwoTableViewCell" owner:self options:nil];
    YuePaiTwoTableViewCell *view = array[0];
    return view;
    
}

- (IBAction)deleteYuePai:(id)sender {
    [self.supCon deleteYuePaiWithId:self.covenant_id.copy];
}


@end
