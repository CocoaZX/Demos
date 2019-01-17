//
//  AcutionInfoView.m
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionInfoView.h"

@implementation AcutionInfoView

//- (id)init{
//    self = [super init];
//    if (self) {
//        [self creatView];
//    }
//    return self;
//}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self = [super initWithCoder:aDecoder]) {
        
        [self creatView];
    }
    
    return self;
}

- (void)creatView{
    
    [[NSBundle mainBundle] loadNibNamed:@"AcutionInfoView" owner:self options:nil];
    [self addSubview:self.view];
    
    self.view.frame = self.bounds;
    //填一下自动布局的坑！最好要写这一句
}



//设置数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [self setViewsWithData];
}

//重新布局
- (void)setViewsWithData{
    
    //状态设置
    _acutionInfoLabel.text = _dataDic[@"opName"];
    
    //设置时间
    _timeLabel.text = _dataDic[@"create_time"];
    
    //设置图片
    _imgView.image = nil;
    //NSDictionary *videoUrlDic = _dataDic[@"video_url"];
    //NSDictionary *video_url_dic = videoUrlDic[@"cover_url"];
    //NSString *videoCoverUrlString = video_url_dic[@"url"];
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
    _auctionDetailLabel.text = _dataDic[@"auction_description"];
    
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

@end
