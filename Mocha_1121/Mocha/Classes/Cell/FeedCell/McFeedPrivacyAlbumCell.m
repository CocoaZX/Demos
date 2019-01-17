//
//  McFeedPrivacyAlbumCell.m
//  Mocha
//
//  Created by zhoushuai on 16/6/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McFeedPrivacyAlbumCell.h"

@implementation McFeedPrivacyAlbumCell

- (void)awakeFromNib {
    // Initialization code
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
    [self.contentView bringSubviewToFront: self.bottomView];
    
    //图片显示比例
    _photoSizeScale = 1.0/2.0;
    
    self.privacyMarkImgView_top.constant = (kDeviceWidth *_photoSizeScale-80)/2;
    
    //个人信息设置
    NSDictionary *userDic = _dataDic[@"user"];
    //头像
    NSString *headUrl = [NSString stringWithFormat:@"%@%@",userDic[@"head_pic"],[CommonUtils imageStringWithWidth:_headImgView.width*2 height:_headImgView.height * 2]];
    [self.headImgView setImageWithURL:[NSURL URLWithString:headUrl?headUrl:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //VIP
    NSString *vip = [NSString stringWithFormat:@"%@", userDic[@"vip"]];//
    if ([vip isEqualToString:@"1"]) {
        self.renzhengImgView.hidden = NO;
    }else
    {
        self.renzhengImgView.hidden = YES;
    }
    
    //昵称
    self.nameLabel.text = getSafeString(userDic[@"nickname"]) ;
    //身份类型
    self.personTypeLabel.text = getSafeString(userDic[@"user_type"]);
    
    //皇冠会员
    NSString *member = getSafeString(userDic[@"member"]);
    if ([member isEqualToString:@"0"]) {
        self.nameLabel.textColor = [UIColor blackColor];
        self.personTypeLabel.textColor = [UIColor blackColor];
        self.memberImgView.hidden = YES;
    }else{
        self.nameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        self.personTypeLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        self.memberImgView.hidden = NO;
    }
    
    //位置
    NSString *adress = [NSString stringWithFormat:@"%@ %@",getSafeString(userDic[@"provinceName"]),getSafeString(userDic[@"cityName"])];
    self.addressLabel.text = adress;
    
    
    
    //图片
    self.contentImgView_height.constant = kDeviceWidth *_photoSizeScale;
    NSString *url= getSafeString(_dataDic[@"url"]);
    NSString *urlString = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:2 * self.contentImgView.width height:self.contentImgView.height*2]];
    //判断是否模糊
    BOOL needBlurry = NO;
    NSString *albumPersonId = getSafeString(userDic[@"id"]);
    if (![getCurrentUid() isEqualToString:albumPersonId]){
        //非本人
        NSDictionary *albumSettingDic = _dataDic[@"info"][@"album_setting"];
        if (albumSettingDic) {
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
    //needBlurry = YES;
    NSString *finalImageStr = @"";
    if (needBlurry) {
        finalImageStr = [NSString stringWithFormat:@"%@|30-15bl",urlString];
        _privacyMarkImgView.hidden = NO;
        _albumInfoLabel.text =  [NSString stringWithFormat:@"包含%@张私图",getSafeString(_dataDic[@"info"][@"num_photos"])];
    }else{
        finalImageStr = urlString;
        _privacyMarkImgView.hidden = YES;
        _albumInfoLabel.text = @"点击浏览相册";
    }

    NSString *handleuUrlStr = [finalImageStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.contentImgView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",handleuUrlStr]] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //相册的名称和风格类型和张数
    _albumNameLabel.text = getSafeString(_dataDic[@"info"][@"title"]);
    _albumTypeLabel.text = getSafeString(_dataDic[@"info"][@"album_genre_name"]);
    //_albumPhotoCountLabel.text = [NSString stringWithFormat:@"%@张",getSafeString(_dataDic[@"info"][@"num_photos"])];
    
    //时间
    _timeLabel.text = [CommonUtils dateTimeIntervalString:_dataDic[@"createline"]];
}




#pragma mark - 类方法
+ (McFeedPrivacyAlbumCell *)getMcFeedPrivacyAlbumCell
{
    return [[NSBundle mainBundle] loadNibNamed:@"McFeedPrivacyAlbumCell" owner:self options:nil].lastObject;
}

#pragma mark - 事件点击
- (IBAction)jubaoMethod:(id)sender {
    NSLog(@"jubaoOrDelegate");
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
        //举报
        [self.cellDelegate doTouchUpInsideWithItem:_dataDic status:100];
    }
    
}

#pragma mark - 类方法
- (IBAction)personHeadViewClick:(id)sender {
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:self.dataDic];
    }
}


+ (CGFloat)getMcFeedPrivacyAlbumCelllHeight{
    return 65 +kDeviceWidth *1.0/2.0 +65;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

 }

@end
