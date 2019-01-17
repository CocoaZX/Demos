//
//  MokaTaoXiHeadView.m
//  Mocha
//
//  Created by zhoushuai on 16/3/31.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaTaoXiHeadView.h"

@implementation MokaTaoXiHeadView




+ (MokaTaoXiHeadView *)getMokaTaoXiHeaderView{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"MokaTaoXiHeadView" owner:nil options:nil];
    MokaTaoXiHeadView *mokaTaoxiHeaderView = array[0];
    return mokaTaoxiHeaderView;
}



-(void)initWithDictionary:(NSDictionary *)dictionary{
    
    //设置数据
    _dict = [NSDictionary dictionaryWithDictionary:dictionary];
    NSDictionary *content = dictionary[@"content"];

    
    _bigImgView_height.constant = kDeviceWidth *TaoXiScale;
    if (!((NSNull *)content == [NSNull null])){
        
        //设置封面
        NSString *urlStr = content[@"coverurl"];
        if (urlStr.length) {
            NSString *urlStr = [NSString stringWithFormat:@"%@%@",getSafeString(content[@"coverurl"]),[CommonUtils imageStringWithWidth:kDeviceWidth * 2 height:kDeviceWidth *TaoXiScale *2]];
            //NSLog(@"%f",self.bigImgView.size.height);
            [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
        }
        
        //设置专题名称
        if (content[@"setname"]) {
            NSString *themeName =getSafeString(dictionary[@"content"][@"setname"]);
            self.themeNameLabel.text = themeName;

            CGFloat themeTxtWidth = [SQCStringUtils getCustomWidthWithText:self.themeNameLabel.text viewHeight:20 textSize:16];
            _themeLabel_width.constant = themeTxtWidth +10;
         }
        
        //设置类型
        if (dictionary[@"content"][@"settype"]) {
            self.typeLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
            self.typeLabel.text = getSafeString(dictionary[@"content"][@"settype"]);
            self.typeLabel.hidden = NO;
            self.typeLabel.layer.masksToBounds = YES;
            self.typeLabel.layer.cornerRadius = 3;
            if (self.typeLabel.text.length) {
                self.typeLabel.layer.borderColor = [[CommonUtils colorFromHexString:kLikeOrangeColor] CGColor];
                self.typeLabel.layer.borderWidth = 1;
            }
        }else{
            self.typeLabel.hidden = YES;
        }

        //价格
        if (dictionary[@"content"][@"setprice"]) {
            self.priceLabel.text = [NSString stringWithFormat:@"￥%@",getSafeString(dictionary[@"content"][@"setprice"])];
            if ([self.priceLabel.text isEqualToString:@"￥0"]) {
                self.priceLabel.text = @"免费";
            }
            self.priceLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
        }
        NSLog(@"%@",dictionary[@"content"]);
        //四个专题的详细信息
        if (getSafeString(dictionary[@"content"][@"setplace"]).length>0) {
            self.locationLabel.text = [NSString stringWithFormat:@"%@",getSafeString(dictionary[@"content"][@"setplace"])];
            if ([self.locationLabel.text isEqualToString:@"地点"]) {
                self.locationLabel.text = @"未知地";
                
            }
            self.locationLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        }else{
            self.firstImg.hidden = YES;
            _locationLabel.hidden = YES;
            _seprateLine.hidden = YES;
            
            _photoNumLabel.hidden = YES;
            _secondImg.hidden = YES;
            
            _goodPhotoNumLabel.hidden = YES;
            _thirdImg.hidden = YES;
            
            _timeLabel.hidden = YES;
            _fouthImg.hidden = YES;
        }
        
        if (dictionary[@"content"][@"settotalcont"]) {
            self.photoNumLabel.text = [NSString stringWithFormat:@"照片%@张",getSafeString(dictionary[@"content"][@"settotalcont"])];
            if ([self.photoNumLabel.text isEqualToString:@"照片"]) {
                
                self.photoNumLabel.text = @"照片x张";
            }
            self.photoNumLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        }
        if (dictionary[@"content"][@"settruingcount"]) {
            self.goodPhotoNumLabel.text = [NSString stringWithFormat:@"精修%@张",getSafeString(dictionary[@"content"][@"settruingcount"])];
            if ([self.goodPhotoNumLabel.text isEqualToString:@"精修"]) {
                
                self.goodPhotoNumLabel.text = @"精修x张";
            }
            self.goodPhotoNumLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        }
        if (dictionary[@"content"][@"settime"]) {
            self.timeLabel.text = [NSString stringWithFormat:@"时长%@小时",getSafeString(dictionary[@"content"][@"settime"])];
            if ([self.timeLabel.text isEqualToString:@"拍摄时长"]) {
                
                self.timeLabel.text = @"时长x小时";
            }
            self.timeLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        }

    }
    //_detailLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
}


@end
