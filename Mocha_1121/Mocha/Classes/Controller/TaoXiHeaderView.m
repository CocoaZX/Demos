//
//  TaoXiHeaderView.m
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiHeaderView.h"

#import "TaoXiInformationController.h"

@interface TaoXiHeaderView ()
{
    float _leftWidth;
    NSDictionary *_dict;
    float _newWidth;
    float _newSpacing;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *typeToName;

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation TaoXiHeaderView



- (void)layoutSubviews{
    [super layoutSubviews];

    _leftWidth = (kDeviceWidth - 212) / 3;
    _secondLaft.constant = 56 + _leftWidth;
    _thiredLaft.constant = 106 + _leftWidth * 2;
    _fourthLaft.constant = 156 + _leftWidth * 3;
    _photoLaft.constant = 40 + _leftWidth;
    _jingxiuLaft.constant = 90 + _leftWidth * 2;
    _timeLaft.constant = 140 + _leftWidth * 3;
    _nameLabelWidth.constant = _newWidth;
    _typeToName.constant = _newSpacing;
    _detailLabel.layer.borderWidth = 2;
    _detailLabel.layer.borderColor = [[CommonUtils colorFromHexString:kLikeOrangeColor] CGColor];
    _detailLabel.layer.masksToBounds = YES;
    _detailLabel.layer.cornerRadius = 3;
}

+ (TaoXiHeaderView *)getTaoXiHeaderView{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TaoXiHeaderView" owner:nil options:nil];
    TaoXiHeaderView *taoxiHeaderV = array[0];
    return taoxiHeaderV;
}

-(void)initWithDictionary:(NSDictionary *)dictionary{
    _dict = [NSDictionary dictionaryWithDictionary:dictionary];
    //设置数据
    NSDictionary *content = dictionary[@"content"];
    if (!((NSNull *)content == [NSNull null])){
    NSString *urlStr = dictionary[@"content"][@"coverurl"];
    if (urlStr.length) {
        NSString *urlStr = [NSString stringWithFormat:@"%@%@",getSafeString(dictionary[@"content"][@"coverurl"]),[CommonUtils imageStringWithWidth:kDeviceWidth * 2 height:265 * 2]];
        NSLog(@"%f",self.bigImgView.size.height);
        [self.bigImgView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
    }
    }
    
    if (dictionary[@"content"][@"setplace"]) {
        self.locationLabel.text = getSafeString(dictionary[@"content"][@"setplace"]);
        if ([self.locationLabel.text isEqualToString:@"0"]) {
            self.locationLabel.text = @"";
        }
    }
    
    if (dictionary[@"content"][@"settime"]) {
        NSString *timeStr = getSafeString(dictionary[@"content"][@"settime"]);
        if (timeStr.length) {
            self.timeLabel.text = [NSString stringWithFormat:@"%@小时",timeStr];
        }
    }
    
    if (dictionary[@"content"][@"settotalcont"]) {
        NSString *photos = getSafeString(dictionary[@"content"][@"settotalcont"]);
        if (photos.length) {
            self.photosLabel.text = [NSString stringWithFormat:@"%@张",photos];
        }
    }
    
    if (dictionary[@"content"][@"settruingcount"]) {
        NSString *goodPhotos = getSafeString(dictionary[@"content"][@"settruingcount"]);
        if (goodPhotos.length) {
            self.goodPhotosLabel.text = [NSString stringWithFormat:@"%@张",getSafeString(dictionary[@"content"][@"settruingcount"])];
        }
    }
    
    if (dictionary[@"content"][@"setprice"]) {
        self.priceLabel.text = [NSString stringWithFormat:@"￥%@",getSafeString(dictionary[@"content"][@"setprice"])];
        if ([self.priceLabel.text isEqualToString:@"￥0"]) {
            self.priceLabel.text = @"免费";
        }
        self.priceLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
    }
//
    if (dictionary[@"content"][@"setname"]) {
        self.nameLabel.text = getSafeString(dictionary[@"content"][@"setname"]);
        float oldWidth = _nameLabelWidth.constant;
        CGSize size = [CommonUtils sizeFromText:self.nameLabel.text textFont:self.nameLabel.font boundingRectWithSizeOrconstrainedToSize:CGSizeMake(MAXFLOAT, self.nameLabel.height)];
        _newWidth = size.width;
        _newSpacing = _nameLabelWidth.constant - oldWidth + 15;
    }
//
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
    _detailLabel.textColor = [CommonUtils colorFromHexString:kLikeOrangeColor];
}

- (IBAction)DetailBtnAction:(id)sender {
    NSLog(@"detail");
    TaoXiInformationController *taoXiInfor = [[TaoXiInformationController alloc]init];
    taoXiInfor.isCheck = YES;
    [taoXiInfor initWithDictionary:_dict];
    NSLog(@"%@",self.supCon);
    [self.supCon.navigationController pushViewController:taoXiInfor animated:YES];

}

@end
