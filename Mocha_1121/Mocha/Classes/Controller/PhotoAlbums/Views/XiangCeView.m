//
//  XiangCeView.m
//  Mocha
//
//  Created by zhoushuai on 16/4/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "XiangCeView.h"

@implementation XiangCeView

- (void)awakeFromNib{
   // self.layer.cornerRadius = 5;
    //self.layer.masksToBounds = YES;
    [self bringSubviewToFront:_blackView];
    [self bringSubviewToFront:_albumNameLabel];
    [self bringSubviewToFront:_styleNamelLabel];
    [self bringSubviewToFront:_numLabel];
    [self bringSubviewToFront:_privacyImgView];

}

- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
    }
    [self setNeedsLayout];
    
    _numLabel.layer.cornerRadius = 12.5;
    _numLabel.layer.masksToBounds = YES;

    _numLabel.adjustsFontSizeToFitWidth = YES;


    //NSLog(@"%@",_dataDic[@"title"]);
    //NSLog(@"%@",_dataDic[@"styleName"]);
   
    //相册名
    _albumNameLabel.text = _dataDic[@"title"];
    

    //如果是动态moka,进行下面的设置
    //隐藏风格样式，重新设置name和num
    NSString *xiangCellType =getSafeString(_dataDic[@"type"]);
    if((xiangCellType.length != 0) && [xiangCellType isEqualToString:@"dynamicMOKA"]){
        _albumName_bottom.constant = 15;
        _styleNamelLabel.hidden = YES;
        _privacyImgView.hidden =YES;
        //设置数量
        _numLabel.text = getSafeString(_dataDic[@"daynamic_albumcount"]);
        //最新动态模卡封面，从服务器返回
        NSString *imgUrlStr = _dataDic[@"cover_url"];
        NSURL *imgURL = [self getImgUrlWithimgurlstring:imgUrlStr];
         [_imgView sd_setImageWithURL:imgURL];
        
    }
    else{

        //风格
        _styleNamelLabel.hidden = NO;
        _styleNamelLabel.text = _dataDic[@"album_genre_name"];
        
        //设置数量显示
        _numLabel.text = _dataDic[@"numPhotoes"];
        
        _imgView.image = nil;
        NSString *imgUrlString = getSafeString(_dataDic[@"cover_url"]);
        if (imgUrlString.length != 0) {
            NSURL *imgURL = [self getImgUrlWithimgurlstring:imgUrlString];
            [_imgView sd_setImageWithURL:imgURL];
        }else{
            _imgView.image = [UIImage imageNamed:@"upload"];
        }

//        "setting": {
//            "open": {
//                "is_private": "0",
//                "visit_coin": "0",
//                "is_forever_uids_list": []
//            }
//        },
        
        NSDictionary *openDic = _dataDic[@"setting"][@"open"];
        NSString *isPrivate = [openDic objectForKey:@"is_private"];
        if ([isPrivate isEqualToString:@"0"]) {
            _privacyImgView.hidden = YES;
            _albumName_bottom.constant = 25;
            _styleName_bottom.constant = 5;

        }else{
            //有私密设置
            _privacyImgView.hidden = NO;
            _albumName_bottom.constant = 28;
            _styleName_bottom.constant = 7;
        }
    }
}


#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
 }


#pragma mark - 从xib获取视图
////返回视图
//+(XiangCeView *)getXiangCeView{
//    return [[[NSBundle mainBundle] loadNibNamed:@"XiangCeView" owner:nil
//                                       options:nil] lastObject];
//}


#pragma mark - 辅助方法
//返回图片Url
- (NSURL *)getImgUrlWithimgurlstring:(NSString *)imgUrlStr{
    NSString *bigImgJpg = [CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2];
    NSString *bigImgCompleteurl = [NSString stringWithFormat:@"%@%@",imgUrlStr,bigImgJpg];
    
    NSURL *url = [NSURL URLWithString:bigImgCompleteurl];
    
    return url;
}



 @end
