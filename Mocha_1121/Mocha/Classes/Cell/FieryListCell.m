//
//  FieryListCell.m
//  Mocha
//
//  Created by TanJian on 16/5/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "FieryListCell.h"

@implementation FieryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _shenjiaWordsLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _priceLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _seprateline.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}


-(void)setupUIWithDict:(NSDictionary *)dict withTypeStr:(NSString *)type{
    
    //火爆接口数据刷新界面
    //第1、2、3名图片，和火的图标
    NSString *rank = getSafeString(dict[@"position"]);
    if ([rank isEqualToString:@"1"]) {
        _prizeImg.image = [UIImage imageNamed:@"2jin"];
        _prizeImg.hidden = NO;
        _rankLabel.hidden = YES;
        _huoImg.hidden = NO;
        
    }else if ([rank isEqualToString:@"2"]){
        
        _prizeImg.image = [UIImage imageNamed:@"2yin1"];
        _prizeImg.hidden = NO;
        _rankLabel.hidden = YES;
        _huoImg.hidden = NO;
        
    }else if([rank isEqualToString:@"3"]){
        
        _prizeImg.image = [UIImage imageNamed:@"3tong"];
        _prizeImg.hidden = NO;
        _rankLabel.hidden = YES;
        _huoImg.hidden = NO;
        
    }else{
        _prizeImg.hidden = YES;
        _rankLabel.hidden = NO;
        _rankLabel.text = rank;
        _huoImg.hidden = YES;
    }
    
    NSString *headUrl = getSafeString(dict[@"head_pic"]);
    
    headUrl = [NSString stringWithFormat:@"%@%@",getSafeString(headUrl),[CommonUtils imageStringWithWidth:_headImg.width*2 height:_headImg.width*2]];
    [_headImg sd_setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    _numberLabel.text = [NSString stringWithFormat:@"编号:%@",getSafeString(dict[@"uid"])];
    _nicknameLabel.text = getSafeString(dict[@"nickname"]);
    
    if ([type isEqualToString:@"2"]) {
        _shenjiaWordsLabel.text = @"身价";
        _priceLabel.text = getSafeString(dict[@"rank"]);
        
    }else{
        _shenjiaWordsLabel.text = @"财富";
        _priceLabel.text = getSafeString(dict[@"gold"]);
    }
    
    if (_priceLabel.text.length>6) {
        _priceLabel.adjustsFontSizeToFitWidth = YES;
    }else{
        _priceLabel.adjustsFontSizeToFitWidth = NO;
    }
    
    
    
}

@end
