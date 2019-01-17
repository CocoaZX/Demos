//
//  ActivityListViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ActivityListViewCell.h"

@implementation ActivityListViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _initViews];
    }
    return self;
}

//初始化视图组件
- (void)_initViews{
    //背景图片:self.width
    _bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.width)];
    [self.contentView addSubview:_bgImgView];

    //类型
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,5, 35, 20)];
    _typeLabel.numberOfLines = 0;
    _typeLabel.font = [UIFont boldSystemFontOfSize:13];
    _typeLabel.textColor = [UIColor whiteColor];
    _typeLabel.layer.cornerRadius = 3;
    _typeLabel.layer.masksToBounds = YES;
    _typeLabel.textAlignment = NSTextAlignmentCenter;
    //_typeLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeBgRedColor];
    [self.contentView addSubview:_typeLabel];
    
    //底部视图 8
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _bgImgView.bottom+5, self.width, 75)];
    [self.contentView addSubview:_bottomView];
    
    //灰色背景
//    _backView = [[UIView alloc] initWithFrame:_bottomView.frame];
//    _backView.backgroundColor = [UIColor blackColor];
//    _backView.alpha = 0.7;
//    [self addSubview:_backView];
    
    //时间
//    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.width, 15)];
//    _timeLabel.font = [UIFont systemFontOfSize:15];
//    _timeLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
//    [_bottomView addSubview:_timeLabel];
    
    
    //费用
    _feeLabel  = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.width-10, 20)];
    _feeLabel.font = [UIFont systemFontOfSize:15];
    _feeLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
    [_bottomView addSubview: _feeLabel];
    
    //浏览量
    _liuLanLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, self.width -10, 20)];
    _liuLanLabel.textAlignment = NSTextAlignmentRight;
    _liuLanLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _liuLanLabel.font = [UIFont systemFontOfSize:13];
    [_bottomView addSubview:_liuLanLabel];
    
    
    
    //活动名称 8+30
    _themeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _feeLabel.bottom +5, self.width-10,40 )];
    //_themeNameLabel.backgroundColor = [UIColor redColor];
    _themeNameLabel.font = [UIFont boldSystemFontOfSize:16];
    _themeNameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    _themeNameLabel.numberOfLines = 2;
    
    [_bottomView addSubview:_themeNameLabel];
    

    /*
    //头像
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, _themeNameLabel.bottom +5,35, 35)];
    _headImgView.layer.cornerRadius = 17.5;
    _headImgView.layer.masksToBounds = YES;
    [_bottomView addSubview:_headImgView];
    
    //认证
    _renZhengImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 19)];
    _renZhengImgView.center = CGPointMake(_headImgView.right-5, _headImgView.bottom-5);
    _renZhengImgView.image = [UIImage imageNamed:@"jiaV"];
    _renZhengImgView.hidden = YES;
    [_bottomView addSubview:_renZhengImgView];
    
    //说明
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right +5, _themeNameLabel.bottom +5, self.width -50, 15)];
    _descLabel.font = [UIFont boldSystemFontOfSize:15];
    _descLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    [_bottomView addSubview:_descLabel];
    
    //发起人名字
    _nameLabel =  [[UILabel alloc] initWithFrame:CGRectMake(_headImgView.right +5, _descLabel.bottom +5, self.width -50, 15)];
    _nameLabel.font = [UIFont systemFontOfSize:13];
    _nameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    [_bottomView addSubview:_nameLabel];
    
     */
}



//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if (_dataDic != dataDic) {
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}


//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //圆角样式
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    
    //大图
    /*
    NSObject *imgObj = _dataDic[@"img"];
    NSString *bgImgstr = @"";
    _bgImgView.image = nil;
    if (imgObj != nil) {
        if ([imgObj isKindOfClass:[NSString class]]) {
            bgImgstr = _dataDic[@"img"];
        }else if([imgObj isKindOfClass:[NSArray class]]){
            NSDictionary *imgDic = _dataDic[@"img"][0];
            bgImgstr = [imgDic objectForKey:@"url"];
        }
        
        if (bgImgstr.length != 0) {
            NSString *jpg = [CommonUtils imageStringWithWidth:_bgImgView.width*2 height:_bgImgView.width*2];
            NSString *url = [NSString stringWithFormat:@"%@%@",bgImgstr,jpg];
            [_bgImgView sd_setImageWithURL:[NSURL URLWithString:url]];
         }else{
             //使用默认图片
             //众筹都至少有一张图片，通告没有图片会走以下方法
             NSString *activityDefaultImgUrlString  = @"http://cdn.q8oils.cc/12198e613aacd9599b24bb56c1a3ac01@x1.jpg";
             NSDictionary *defaultPicturesDic =  [USER_DEFAULT objectForKey:@"defaultPicturesDic"];
             NSString *defaultImgStr= [defaultPicturesDic objectForKey:@"event_announce"];
             if (defaultImgStr.length != 0) {
                 activityDefaultImgUrlString = defaultImgStr;
             }
             [_bgImgView sd_setImageWithURL:[NSURL URLWithString:activityDefaultImgUrlString]];
        }
    }
     */
    
    //大图片
    NSString *bigImgUrlString = [_dataDic objectForKey:@"defaultImg"];
    NSString *bigImgJpg = [CommonUtils imageStringWithWidth:_bgImgView.width*2 height:_bgImgView.width*2];
    NSString *bigImgCompleteurl = [NSString stringWithFormat:@"%@%@",bigImgUrlString,bigImgJpg];
    [_bgImgView sd_setImageWithURL:[NSURL URLWithString:bigImgCompleteurl]];
    
    //类型标识
    if ([_dataDic[@"type"] isEqualToString:@"4"]||[_dataDic[@"type"] isEqualToString:@"1"]) {
        _typeLabel.backgroundColor = [CommonUtils colorFromHexString:@"#E72F4B"];
        _typeLabel.text = @"通告";
    }else if([_dataDic[@"type"] isEqualToString:@"5"]){
        _typeLabel.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        _typeLabel.text = @"众筹";
    }else if ([_dataDic[@"type"] isEqualToString:@"6"]){
        _typeLabel.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        _typeLabel.text = @"海报";
    }
    
    //主题名称
    //_timeLabel.text = _dataDic[@"startdate"];
    _themeNameLabel.text = _dataDic[@"title"];
    
    //费用
    _feeLabel.text = _dataDic[@"payment"];
    /*
    if([_dataDic[@"payment"] isEqualToString:@"面议"]){
        _feeLabel.text = _dataDic[@"payment"];
    }else{
        _feeLabel.text = [NSString stringWithFormat:@"%@元",_dataDic[@"payment"]];
    }
    */
    
    
    _liuLanLabel.text = [NSString stringWithFormat:@"浏览%@",getSafeString(_dataDic[@"view_number"])];
    
    /*
    //头像
    NSString *headImgStr = _dataDic[@"publisher"][@"head_pic"];
    NSString *jpg = [CommonUtils imageStringWithWidth:_headImgView.width*2 height:_headImgView.width*2];
    NSString *url = [NSString stringWithFormat:@"%@%@",headImgStr,jpg];
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    //认证标识
    _renZhengImgView.hidden = YES;
    NSString *vip = getSafeString([NSString stringWithFormat:@"%@",_dataDic[@"publisher"][@"vip"]]);
    if ([vip isEqualToString:@"1"]) {
        _renZhengImgView.hidden = NO;
    }else
    {
        _renZhengImgView.hidden = YES;
    }
    
    //发起人
    _descLabel.text = @"发起人:";
    
    //发起人昵称
    _nameLabel.text = _dataDic[@"publisher"][@"nickname"];
     
     */
}

@end
