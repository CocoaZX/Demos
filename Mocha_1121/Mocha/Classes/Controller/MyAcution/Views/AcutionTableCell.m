//
//  AcutionTableCell.m
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionTableCell.h"
#import "AcutionInfoView.h"

@implementation AcutionTableCell

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        [self _initViews];
//    }
//    return self;
//}


- (void)awakeFromNib{
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;

}

//初始化视图组件
- (void)_initViews{

}


//设置数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [self setNeedsLayout];
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    //状态设置
    _acutionInfoLabel.text = _dataDic[@"opName"];
    
    //设置时间
    _timeLabel.text = _dataDic[@"create_time"];
    
    //设置图片
    _imgView.image = nil;
    NSDictionary *videoUrlDic = _dataDic[@"video_url"];
     NSString *videoCoverUrlString  =
    @"";
    if ([videoUrlDic isKindOfClass:[NSDictionary class]]) {
       videoCoverUrlString = getSafeString(videoUrlDic[@"cover_url"]);
    }
    
    if (videoCoverUrlString.length != 0) {
        //首先获取视频封面图片
        NSURL *url = [self getImgUrlWithImgurlstring:videoCoverUrlString];
        [_imgView sd_setImageWithURL:url];
    }else{
        NSArray *pictureUrls = _dataDic[@"img_urls"];
        if (pictureUrls.count > 0) {
        NSDictionary *dic = pictureUrls[0];
        NSString *imgUrlString = dic[@"url"];
            NSURL *url = [self getImgUrlWithImgurlstring:imgUrlString];
        [_imgView sd_setImageWithURL:url];
        }
    }
       //设置detil
    _AcutionDetailLabel.text = _dataDic[@"auction_description"];
    
    //设置价格
    CGFloat price = [getSafeString(_dataDic[@"last_price"]) floatValue];
    if (price >0) {
        _priceLabel.text = [NSString stringWithFormat:@"竞拍价格%@元",getSafeString(_dataDic[@"last_price"])];
    }else{
        _priceLabel.text = [NSString stringWithFormat:@"竞拍价格%@元",getSafeString(_dataDic[@"initial_price"])];
    }
}

#pragma mark - 辅助方法
//返回图片Url
- (NSURL *)getImgUrlWithImgurlstring:(NSString *)imgUrlStr{
    NSString *bigImgJpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
    NSString *bigImgCompleteurl = [NSString stringWithFormat:@"%@%@",imgUrlStr,bigImgJpg];
    
    NSURL *url = [NSURL URLWithString:bigImgCompleteurl];
    
    return url;
}


#pragma mark - 获取单元格
+ (AcutionTableCell *)getAcutionTableCell{
    AcutionTableCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"AcutionTableCell" owner:nil
                                                          options:nil] lastObject];
    return cell;
}

@end
