//
//  McFeedAlbumCell.m
//  Mocha
//
//  Created by zhoushuai on 16/5/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McFeedAlbumCell.h"

@implementation McFeedAlbumCell

#pragma mark - 视图生命周期及控件加载
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self _initViews];
     }
    return self;
}

- (void)awakeFromNib{
    //大图圆角
    //self.contentImgView.layer.cornerRadius = 10;
    //self.contentImgView.layer.masksToBounds = YES;
    
    //self.infoView.layer.cornerRadius = 10;
    
    //infor圆角
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
//    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.infoView.bounds byRoundingCorners: UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)].CGPath;
//    self.infoView.layer.mask = shapeLayer;
//    self.infoView.layer.masksToBounds = YES;

}

//初始化视图组件
- (void)_initViews{
    
}


//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic !=  dataDic) {
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];

    [self bringSubviewToFront:self.topView];
    [self bringSubviewToFront:self.upView];

    [self.upView bringSubviewToFront:self.infoView];
    [self.upView bringSubviewToFront:self.privacyMarkImgView];
    
    [self.infoView bringSubviewToFront:self.albumNameLabel];
    [self.infoView bringSubviewToFront:self.albumTypeLabel];
    [self.infoView bringSubviewToFront:self.timeLabel];
    [self.infoView bringSubviewToFront:self.feeDescLabel];
    
    self.contentImg_height.constant =  kDeviceWidth *3/4;
    self.privacyMarkImgView_top.constant = (kDeviceWidth *3/4 -70 -60)/2;

    
     //个人信息设置
    NSDictionary *userDic = _dataDic[@"user"];
    //头像
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",userDic[@"head_pic"],[CommonUtils imageStringWithWidth:_headImgView.width*2 height:_headImgView.height * 2]];
     [self.headImgView setImageWithURL:[NSURL URLWithString:headUrl?headUrl:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    //VIP
    NSString *vip = [NSString stringWithFormat:@"%@", userDic[@"vip"]];//
    if ([vip isEqualToString:@"1"]) {
        self.jiaVImgView.hidden = NO;
    }else
    {
        self.jiaVImgView.hidden = YES;
    }

    //昵称
    _nickNameLabel.text = getSafeString(userDic[@"nickname"]) ;
    //身份类型
    _typeLabel.text = getSafeString(userDic[@"user_type"]);
    
    //皇冠会员
    NSString *member = getSafeString(userDic[@"member"]);
    if ([member isEqualToString:@"0"]) {
        _nickNameLabel.textColor = [UIColor blackColor];
        _typeLabel.textColor = [UIColor blackColor];
        self.huangGuanImgView.hidden = YES;
    }else{
        _nickNameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        _typeLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        self.huangGuanImgView.hidden = NO;
    }
    
    //位置
    
    NSString *adress = [NSString stringWithFormat:@"%@ %@",getSafeString(userDic[@"provinceName"]),getSafeString(userDic[@"cityName"])];
    self.addressLabel.text = adress;
    
    //图片相关信息设置
    /*
    float width = getSafeString(_dataDic[@"info"][@"width"]).floatValue;
    float height = getSafeString(_dataDic[@"info"][@"height"]).floatValue;
    float imgH = height/width*kDeviceWidth;
    NSLog(@"%f",imgH);
     */

    
    NSString *url= getSafeString(_dataDic[@"url"]);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:2 * self.contentImgView.width height:self.contentImgView.height*2]];
    
    
    //判断是否模糊
    BOOL needBlurry = NO;
    NSString *albumPersonId = getSafeString(userDic[@"id"]);
    if (![getCurrentUid() isEqualToString:albumPersonId]){
        //非本人
        NSDictionary *albumSettingDic = _dataDic[@"info"][@"album_setting"];
        if (albumSettingDic) {
            NSLog(@"%@",albumSettingDic);
            //获取私密性数据
            NSDictionary *openDic = albumSettingDic[@"open"];
            NSString *isPrivate = [openDic objectForKey:@"is_private"];
            if ([isPrivate isEqualToString:@"0"]) {
                needBlurry = NO;
             }else{
                 needBlurry = YES;
                //有私密设置
                NSArray *is_forever_uids_list = openDic[@"is_forever_uids_list"];
                  for (int i = 0; i<is_forever_uids_list.count;i++){
                    NSString *tempStr = getSafeString(is_forever_uids_list[i]);
                    if ([tempStr isEqualToString:getCurrentUid()]) {
                        needBlurry = NO;
                        break;
                    }
                }
             }
        }
    }
    
    NSString *finalImageStr = @"";
    if (needBlurry) {
        finalImageStr = [NSString stringWithFormat:@"%@|50-50bl",urlString];
        _privacyMarkImgView.hidden = NO;
        _feeDescLabel.text = @"付费浏览私密相册";
     }else{
        finalImageStr = urlString;
         _privacyMarkImgView.hidden = YES;
         _feeDescLabel.text = @"点击浏览相册";
     }
    
    NSString *handleuUlStr = [finalImageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.contentImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",handleuUlStr]] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    _albumNameLabel.text = getSafeString(_dataDic[@"info"][@"title"]);
    _albumTypeLabel.text = getSafeString(_dataDic[@"info"][@"album_genre_name"]);

    //时间
    _timeLabel.text = [CommonUtils dateTimeIntervalString:_dataDic[@"createline"]];

}

- (IBAction)jubaoMethod:(id)sender {
    NSLog(@"jubaoOrDelegate");
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
        //举报
        [self.cellDelegate doTouchUpInsideWithItem:_dataDic status:100];
    }
}

- (IBAction)personHeadViewClick:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:self.dataDic];
    }
}



+ (McFeedAlbumCell *)getMcFeedAlbumCell
{
    
    return [[NSBundle mainBundle] loadNibNamed:@"McFeedAlbumCell" owner:self options:nil].lastObject;
}


+ (CGFloat)getMcFeedAlbumCellHeight{
    return 65 +kDeviceWidth*3/4;
}



@end
