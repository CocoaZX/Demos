//
//  McModelCollectionViewCell.m
//  Mocha
//
//  Created by zhoushuai on 15/12/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McModelCollectionViewCell.h"

@interface McModelCollectionViewCell ()

@property (nonatomic,strong) UIImageView *videoView;
@property (nonatomic,copy) NSString *currentUid;
@property (nonatomic,strong)UIImageView *tagImgView;
@property (nonatomic,strong) UIImageView *playImg;

@end
@implementation McModelCollectionViewCell



- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //背景色
        self.backgroundColor = [UIColor whiteColor];
        [self _initViews];
    }

    return self;
}

//初始化视图组件
- (void)_initViews{
    
    UIView *contentView = [[UIView alloc]initWithFrame:self.bounds];
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [contentView addSubview:_imageView];
    
    UIImageView *videoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"videoIcon"]];
    self.videoView = videoView;
//    [videoView sizeToFit];
    videoView.size = CGSizeMake(20, 20);
    videoView.frame = CGRectMake(self.frame.size.width-22, 2, 20, 20);
    videoView.backgroundColor = [UIColor darkGrayColor];
    videoView.layer.cornerRadius = 10;
    videoView.clipsToBounds = YES;
    
    //默认隐藏视频icon
    self.videoView.hidden = YES;
    
    [contentView addSubview:self.videoView];
    
    [self addSubview:contentView];
    
    //视频按钮
//    _videoBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width -53, 3, 50, 20)];
//    _videoBtn.backgroundColor = [UIColor purpleColor];
//    [_videoBtn setTitle:@"视频" forState:UIControlStateNormal];
//    [_videoBtn addTarget:self action:@selector(videoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_videoBtn];
    
}


//数据源
- (void)setImageUrlString:(NSString *)imageUrlString{
    if (_imageUrlString != imageUrlString) {
        _imageUrlString = imageUrlString;
        [self setNeedsLayout];
    }
    
}


//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:_imageUrlString];
    UIImage *image2 = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_imageUrlString];
    if (image||image2) {
        _imageView.image = image?:image2;
    }else
    {
        //[_imageView sd_setImageWithURL:[NSURL URLWithString:_imageUrlString]];
        
        [_imageView setImageWithURL:[NSURL URLWithString:_imageUrlString] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    
}

#pragma mark button点击处理
//点击进入视频
- (void)videoBtnClick:(UIButton *)btn{
    
    
}

-(void)initWithDictionary:(NSDictionary *)dict{
    
    [self.playImg removeFromSuperview];
    
    float imgViewW = (kDeviceWidth-8)/3;
    //图片比例
    NSString *urlStr;
    NSString *objectType = getSafeString(dict[@"object_type"]);
    switch (objectType.integerValue) {
            
        case 15:
        {
            _currentUid = getSafeString(dict[@"user"][@"id"]);
            
            NSArray *imgArr = dict[@"info"][@"img_urls"];
            NSLog(@"%@",imgArr);
            if (imgArr) {
                NSDictionary *imgDict = imgArr[0];
                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                urlStr = getSafeString(imgDict[@"url"]);
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            }
            _tagImgView.image = [UIImage imageNamed:@"auctionTag"];
        }
            break;
        case 6:
        {
            _currentUid = getSafeString(dict[@"user"][@"id"]);
            
            NSDictionary *parentDict = dict[@"info"][@"album_setting"];
            NSLog(@"%@",dict);
            if (parentDict) {
                
                NSString *currentID = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
                NSArray *uidList = parentDict[@"open"][@"is_forever_uids_list"];
                if ([_currentUid isEqualToString:currentID]) {
                    
                    NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                    urlStr = getSafeString(dict[@"url"]);
                    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
                }else{
                    if (uidList.count == 0) {
                        float imgViewW = kDeviceWidth/15*13 - 41;
                        NSString *tempStr = getSafeString(dict[@"url"]);
                        NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                        NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@|50-25bl",tempStr,jpg];
                        urlStr = [imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                    }else{
                        for (NSString *Cuid in uidList) {
                            if (![Cuid isEqualToString:currentID]) {
                                
                                float imgViewW = kDeviceWidth/15*13 - 41;
                                NSString *tempStr = getSafeString(dict[@"url"]);
                                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                                NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@|50-25bl",tempStr,jpg];
                                urlStr = [imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            }else{
                                
                                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                                urlStr = getSafeString(dict[@"url"]);
                                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
                                break;
                            }
                        }
                    }
                    
                }
                
                _tagImgView.image = [UIImage imageNamed:@"privateTag"];
                
            }else{
                _tagImgView.image = [UIImage imageNamed:@"imgTag"];
                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
                urlStr = getSafeString(dict[@"url"]);
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            }
        }
            break;
            
        case 11:
        {
            
            _tagImgView.image = [UIImage imageNamed:@"VideoTag"];
            NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewW*2];
            urlStr = getSafeString(dict[@"cover_url"]);
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            
            self.playImg.frame = CGRectMake(0, 0, 40*kDeviceWidth/375, 40*kDeviceWidth/375);
            self.playImg.center = self.center;
            
            [self addSubview:_playImg];
        }
            break;
            
        default:
            break;
    }
    self.imageUrlString = urlStr;
    
    
}

-(void)initWithDictionaryForMainModel:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    NSString *url = dict[@"url"];
    if ([dict[@"object_type"] isEqualToString:@"11"]) {
        url = [NSString stringWithFormat:@"%@%@",dict[@"cover_url"],[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        //若动态是视频，出现视频icon
        self.videoView.hidden = NO;
    }else if([getSafeString(dict[@"object_type"]) isEqualToString:@"6"]){
        url = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        //若动态是图片，隐藏视频icon
        self.videoView.hidden = YES;
    }else if([getSafeString(dict[@"object_type"]) isEqualToString:@"15"]){
        NSLog(@"%@",url);
        url = [NSString stringWithFormat:@"%@%@",getSafeString(dict[@"img_urls"][0][@"url"]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        NSLog(@"%@",url);
        //若动态是图片，隐藏视频icon
        self.videoView.hidden = YES;
    }else{
        
    }

//    self.imageUrlString = url;
}


-(UIImageView *)playImg{
    
    if (!_playImg) {
        _playImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playButton"]];
    }
    return _playImg;
    
}

@end
