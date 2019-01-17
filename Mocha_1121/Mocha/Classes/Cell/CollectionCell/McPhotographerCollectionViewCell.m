//
//  McPhotographerCollectionViewCell.m
//  Mocha
//
//  Created by zhoushuai on 15/11/12.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McPhotographerCollectionViewCell.h"

#import "ReadPlistFile.h"

@implementation McPhotographerCollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self _initViews];
    }
    return self;
}

//初始化组件
- (void)_initViews{
    //显示大图片
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_imgView];
    
    
    //显示相片信息视图
    _backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = 0.4;
    [self.contentView addSubview:_backgroundView];
    
    //相册名称
    _albumLable = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth/2-100, 0, 100, 50)];
    _albumLable.text = @"";
    _albumLable.textColor = [UIColor whiteColor];
    _albumLable.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_albumLable];
    
    //分割线
    _lineLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _lineLabel.backgroundColor  =[UIColor whiteColor];
    [self.contentView addSubview:_lineLabel];
    _lineLabel.backgroundColor = [UIColor whiteColor];
    
    //作品数
    _photoCountLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _photoCountLable.textColor = [UIColor whiteColor];
    _photoCountLable.textAlignment = NSTextAlignmentLeft;
    _photoCountLable.text = @"";
    [self.contentView addSubview:_photoCountLable];
    
    
    //头像
    _headImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _headImgView.layer.cornerRadius = 25;
    _headImgView.layer.masksToBounds = YES;
    [self.contentView addSubview:_headImgView];
    
    
    //昵称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 10, 100, 50)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.text = @"";
    [self.contentView addSubview:_nameLabel];
    
    //住址
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectZero ];
    _addressLabel.textAlignment = NSTextAlignmentRight;
    _addressLabel.font = [UIFont systemFontOfSize:18];
    [self.contentView addSubview:_addressLabel];
    
}


//数据源
- (void)setDataDic:(NSDictionary *)dataDic{
    if(_dataDic != dataDic){
        _dataDic = dataDic;
        [self setNeedsLayout];
    }
}

//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
     NSLog(@"%@",_dataDic);
    //显示图片
    //计算高度
    //_imgView.backgroundColor = [UIColor redColor];
    CGFloat imgH = [[_dataDic objectForKey:@"photoHeight"] floatValue];
    CGFloat imgW = [[_dataDic objectForKey:@"photoWidth"] floatValue];
    CGFloat height  = 0;
    if (imgH == 0 ||imgW == 0) {
        height = kDeviceWidth;
    }else{
        height = (imgH/imgW)*kDeviceWidth;
    }
    _imgView.frame = CGRectMake(0, 0,kDeviceWidth, height);
    
    NSString *urlstring = [NSString stringWithFormat:@"%@%@",[_dataDic objectForKey:@"picture"],[CommonUtils imageStringWithWidth:kDeviceWidth*2 height:height*2]];
    NSURL *imgUrlString = [NSURL URLWithString:urlstring];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlstring];
    UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:urlstring];
    if (image||image2) {
        _imgView.image = image?:image2;
    }else
    {
        [_imgView setImageWithURL:imgUrlString usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
    }
    
    
    if ([[_dataDic objectForKey:@"albumName"] isEqualToString:@""]) {
        _backgroundView.hidden = YES;
        _albumLable.hidden = YES;
        _photoCountLable.hidden = YES;
        _lineLabel.hidden = YES;
    }else{
        _backgroundView.hidden = NO;
        _albumLable.hidden = NO;
        _photoCountLable.hidden = NO;
        _lineLabel.hidden = NO;
        
        //背景色
        _backgroundView.frame = CGRectMake(0,_imgView.frame.size.height -50, kDeviceWidth, 50);
        
        //相册
        _albumLable.frame = CGRectMake(kDeviceWidth/2-10-100, _imgView.frame.size.height -50, 100, 50);
        _albumLable.text = [_dataDic objectForKey:@"albumName"];
        _lineLabel.frame = CGRectMake(kDeviceWidth/2,_imgView.frame.size.height-40, 1, 30);
        
        //作品数
        _photoCountLable.frame = CGRectMake(kDeviceWidth/2+10, _imgView.frame.size.height-50, 100, 50);
        _photoCountLable.text = [NSString stringWithFormat:@"%@个作品",[_dataDic objectForKey:@"photoNumber"]];
    }
    
    
    
    //头像
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:[_dataDic objectForKey:@"head_pic"]] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
    _headImgView.frame = CGRectMake(10, _imgView.frame.size.height+10, 50, 50);
    
    //昵称
    _nameLabel.frame = CGRectMake(70, _imgView.frame.size.height+10, kDeviceWidth-70-100, 50);
    _nameLabel.text = [_dataDic objectForKey:@"nickname"];
    
    //地址
    _addressLabel.frame =CGRectMake(kDeviceWidth -100, _imgView.frame.size.height +10, 90, 50);
    _addressLabel.textColor = [CommonUtils colorFromHexString:@"a3a3a3"];
    _addressLabel.font = [UIFont systemFontOfSize:15];
    _addressLabel.text = [_dataDic objectForKey:@"provinceName"];
    if ([_addressLabel.text isEqualToString:@"未知"]) {
        _addressLabel.text = @"";
    }
    
}

@end
