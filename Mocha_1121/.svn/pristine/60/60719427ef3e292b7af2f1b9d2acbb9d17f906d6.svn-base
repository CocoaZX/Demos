//
//  McFeedZhuanTiCell.m
//  Mocha
//
//  Created by TanJian on 16/5/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McFeedZhuanTiCell.h"

@interface McFeedZhuanTiCell ()

@property(nonatomic,strong)NSDictionary *dataDict;

@end

@implementation McFeedZhuanTiCell

+ (McFeedZhuanTiCell *)getFeedZhuanTiCell
{
    
    return [[NSBundle mainBundle] loadNibNamed:@"McFeedZhuanTiCell" owner:self options:nil].lastObject;
}

+(float)getHeightWithDict:(NSDictionary *)dict{
    
    float width = getSafeString(dict[@"info"][@"width"]).floatValue;
    float height = getSafeString(dict[@"info"][@"height"]).floatValue;
    
    float imgH = height/width*kDeviceWidth;
    //需求更改：改变宽高比
    imgH = kDeviceWidth/2;
    float headerH = 75;
    float footerH = 75;
    
    return imgH+headerH+footerH;
    
}

-(void)initWithDict:(NSDictionary *)dict{
    
    _dataDict = dict;
    
    NSString *headUrl = getSafeString(dict[@"user"][@"head_pic"]);
    [self.headerImg setImageWithURL:[NSURL URLWithString:headUrl?headUrl:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    NSString *vip = getSafeString(dict[@"user"][@"vip"]);
    if ([vip isEqualToString:@"0"]) {
        self.vipImg.hidden = YES;
    }else{
        self.vipImg.hidden = NO;
    }
    
    //4.昵称
    self.nicknameLabel.text = getSafeString(dict[@"user"][@"nickname"]);
    //5.身份
    self.typeLabel.text = getSafeString(dict[@"user"][@"user_type"]);
    //6.皇冠会员
    NSString *member = getSafeString(dict[@"user"][@"member"]);
    if ([member isEqualToString:@"0"]) {
        _nicknameLabel.textColor = [UIColor blackColor];
        _typeLabel.textColor = [UIColor blackColor];
        self.memberImg.hidden = YES;
    }else{
        _nicknameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        _typeLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        self.memberImg.hidden = NO;
    }
    
    NSString *adress = [NSString stringWithFormat:@"%@ %@",getSafeString(dict[@"user"][@"provinceName"]),getSafeString(dict[@"user"][@"cityName"])];
    self.adressLabel.text = adress;
    
    //专题照片设置
    float width = getSafeString(dict[@"info"][@"width"]).floatValue;
    float height = getSafeString(dict[@"info"][@"height"]).floatValue;
    
    float imgH = height/width*kDeviceWidth;
    //需求更改：改变宽高比
    imgH  = kDeviceWidth/2;
    NSLog(@"%f",imgH);
    
    [_contentImgH setConstant:imgH];
    NSLog(@"%f",_contentImg.height);
    
    NSString *urlString = getSafeString(dict[@"url"]);
    NSString *url = [NSString stringWithFormat:@"%@%@",urlString,[CommonUtils imageStringWithWidth:2 * kDeviceWidth height:imgH*2]];
    [self.contentImg setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [_zhuantiType setTitle:[NSString stringWithFormat:@"   %@   " ,getSafeString(dict[@"info"][@"settype"])] forState:UIControlStateNormal];
    [_zhuantiType sizeToFit];
    
    
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {
        
        _memberImg.hidden =  NO;
        _priceLabel.text = [NSString stringWithFormat:@"%@元/套",getSafeString(dict[@"info"][@"price"])];
        
    }else
    {
        _memberImg.hidden = YES;
        _priceLabel.text = @"快来私信我吧";
        
    }
    [_priceLabel sizeToFit];
    
    _titleLabel.text = [NSString stringWithFormat:@"%@",getSafeString(dict[@"info"][@"setname"])];
    [_titleLabel sizeToFit];
    
    
    
    NSLog(@"%@",dict);

}

//-(void)layoutSubviews{
//    
//    
//    float width = getSafeString(_dataDict[@"info"][@"width"]).floatValue;
//    float height = getSafeString(_dataDict[@"info"][@"height"]).floatValue;
//    float imgH = height/width*kDeviceWidth;
//    NSLog(@"%f",imgH);
//    CGRect imgRect = self.contentImg.frame;
//    imgRect.size.height = imgH;
//    _contentImg.frame = imgRect;
//    NSLog(@"%f",_contentImg.height);
//}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headerImg.layer.cornerRadius = _headerImg.width*0.5;
    _headerImg.clipsToBounds = YES;
    
    _adressLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    
    _seprateline.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    _zhuantiType.layer.cornerRadius = 5;
    _zhuantiType.clipsToBounds = YES;
    _zhuantiType.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
    _priceLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    
    
    //self.bgVeiw.layer.cornerRadius = 30;
   // self.clipsToBounds = YES;
    
}


- (IBAction)headBtnClick:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:self.dataDict];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
