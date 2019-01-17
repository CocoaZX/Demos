//
//  NearByPersonView.m
//  Mocha
//
//  Created by zhoushuai on 15/12/9.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "NearByPersonView.h"
#import "NewMyPageViewController.h"
#import "DrawPictureView.h"
@implementation NearByPersonView

- (instancetype)initWithFrame:(CGRect)frame
                       person:(NSDictionary *)personDic
                      options:(MDCSwipeToChooseViewOptions *)options {
    self = [super initWithFrame:frame options:options];
    if (self) {
        //默认不可点击
        self.userInteractionEnabled = NO;
        self.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];

        CGFloat width = self.width;
        //适配iOS和pad
        if([CommonUtils getRuntimeClassIsIphone]){
            _imgViewHeight = width;
        }else{
            _imgViewHeight =width/10*7-10;
        }
        
        //得到数据
        _personData = [NSDictionary dictionaryWithDictionary:personDic];
        
        
        self.imageView.backgroundColor =[CommonUtils colorFromHexString:kLikeWhiteColor];
        NSURL *imgURL = nil;
        if ([CommonUtils getRuntimeClassIsIphone]) {
            //这里没有使用原来自带的imagView对象来展示图片
            self.imageView.contentMode = UIViewContentModeScaleAspectFill;
            imgURL = [NSURL URLWithString:[self getCompleteImgUrlString]];
        }else{
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            imgURL = [NSURL URLWithString:[self getCustomImgUrlString]];
        }

        [self.imageView setImageWithURL :imgURL usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        //这里使用了自定义2D绘图来展示图片，
        //使用图片数据将图片绘制在视图上
        //初始化的同时会创建异步线程来请求图片数据
        //DrawPictureView *pictureView = [[DrawPictureView alloc] initWithFrame:CGRectMake(0, 0, self.width, _imgViewHeight) withImgDic:_personData];
        //[self addSubview:pictureView];
        
        //原来的两个标记视图是加在imgView上的
        //修改视图的位置在视图上，并且放在最上面
        [self bringSubviewToFront:self.likedView];
        [self bringSubviewToFront: self.nopeView];
        
//        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
//        UIViewAutoresizingFlexibleWidth |
//        UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleTopMargin;
        
        //由于添加了动画的原因，这里设置自适应
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight |
        UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleTopMargin;
        
        //适配
        self.imageView.autoresizingMask = self.autoresizingMask;
        //pictureView.autoresizingMask = self.autoresizingMask;
        
        
        //创建并添加展示信息的底部视图
        [self addInformationView];
        
        //增加点击手势，进入个人主页
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
     }
    return self;
}

#pragma mark 添加底部视图
- (void)addInformationView {
    CGFloat bottomHeight = 70.f;
    CGRect bottomFrame = CGRectMake(0,
                                    CGRectGetHeight(self.bounds) - bottomHeight,
                                    CGRectGetWidth(self.bounds),
                                    bottomHeight);
//    CGRect bottomFrame = CGRectMake(0,
//                                     self.imageView.bottom,
//                                    CGRectGetWidth(self.bounds),
//                                    bottomHeight);

    _informationView = [[UIView alloc] initWithFrame:bottomFrame];
    _informationView.backgroundColor = [UIColor whiteColor];
    _informationView.clipsToBounds = YES;
    _informationView.autoresizingMask = UIViewAutoresizingFlexibleWidth |
    UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleRightMargin;
    
    [self addSubview:_informationView];
    [self addViewsToBottomView];
}



//自定义视图
- (void)addViewsToBottomView{
    
    CGFloat leftPadding = 10.f;
    CGFloat topPadding = 10.f;
    //用户名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding,topPadding,200,20)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    if ([_personData objectForKey:@"nickname"]== [NSNull null]) {
        _nameLabel.text = @"";
        _nameLabel.frame = CGRectMake(leftPadding, topPadding, 0, 20);
        
    }else{
        _nameLabel.text = [_personData objectForKey:@"nickname"];
        //计算长度
        CGFloat nameLabLength = [SQCStringUtils getCustomWidthWithText:_nameLabel.text viewHeight:20 textSize:18];
        _nameLabel.frame = CGRectMake(leftPadding, topPadding, nameLabLength, 20);
    }
    [_informationView addSubview:_nameLabel];
    
    //用户身份
    CGFloat statusLabLength = [SQCStringUtils getCustomWidthWithText:[_personData objectForKey:@"usertype"] viewHeight:20 textSize:18] ;
    _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.right +10, topPadding, statusLabLength+10, 20)];
    _statusLabel.font = [UIFont systemFontOfSize:18];
    _statusLabel.text  = [_personData objectForKey:@"usertype"];
    [_informationView addSubview:_statusLabel];
    
    
    //mapIcon
    _mapIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(leftPadding, _nameLabel.bottom + topPadding, 15, 15)];
    _mapIconImgView.image = [UIImage imageNamed:@"mapSite"];
    [_informationView addSubview:_mapIconImgView];
    
    //距离
    _distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(_mapIconImgView.right +leftPadding, _nameLabel.bottom +topPadding, 100, 15)];
    _distanceLabel.font = [UIFont systemFontOfSize:14];
    _distanceLabel.textColor = [CommonUtils colorFromHexString:@"a3a3a3"];
    if ([_personData objectForKey:@"distance"]== [NSNull null]) {
        _distanceLabel.text = @"";
    }else{
        _distanceLabel.text = [_personData objectForKey:@"distance"];
    }
    [_informationView addSubview:_distanceLabel];
    
    
    
    //计算赞的数字长度
    CGFloat likeTextWidth = [SQCStringUtils getTxtLength:[_personData objectForKey:@"likecount"] font:16 limit:100];
    
    //赞的图标
    _likeIconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width -10- likeTextWidth -5 -20, _nameLabel.bottom, 20, 20)];
    _likeIconImgView.image = [UIImage imageNamed:@"zangray2"];
    _likeIconImgView.autoresizingMask = UIViewContentModeTopLeft| UIViewContentModeBottomLeft;
    [_informationView addSubview:_likeIconImgView];
    
    
    //赞的个数
    _likeCountLable = [[UILabel alloc] initWithFrame:CGRectMake(_likeIconImgView.right +5, _nameLabel.bottom , likeTextWidth, 20)];
    if ([_personData objectForKey:@"likecount"]== [NSNull null]) {
        _likeCountLable.text = @"";
    }
    _likeCountLable.text = [_personData objectForKey:@"likecount"];
    _likeCountLable.textColor = [CommonUtils colorFromHexString:@"a3a3a3"];
    _likeCountLable.textAlignment = NSTextAlignmentCenter;
    _likeCountLable.font = [UIFont systemFontOfSize:16];
    _likeCountLable.autoresizingMask =UIViewContentModeBottomLeft;
    [_informationView addSubview:_likeCountLable];
    
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    
}


//增加手势，单击视图，进入个人主页
- (void)tapAction:(UIGestureRecognizer *)gesture{
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = _personData[@"nickname"];
    newMyPage.currentUid = _personData[@"uid"];
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [self.superNVC  pushViewController:newMyPage animated:YES];
    
}


//pad情况下使用的图片链接
- (NSString *)getCustomImgUrlString{
    //图片大小
    CGFloat pictureWidth = [[_personData objectForKey:@"photoWidth"] floatValue];
    CGFloat pictureHeigth = [[_personData objectForKey:@"photoHeight"] floatValue];
    
    NSString *jpg  = @"";
    //图片链接
    NSString *imgUrlString = @"";
    
    if (pictureHeigth == 0 ||pictureWidth ==0){
        
    }else{
        if (pictureWidth>pictureHeigth) {
            jpg = [NSString stringWithFormat:@"@1e_%@h_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:pictureHeigth]];
            
        }else if(pictureWidth == pictureHeigth){
            jpg = [NSString stringWithFormat:@"@1e_%@h_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:pictureHeigth]];

        }else if(pictureWidth<pictureHeigth){
            jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:pictureWidth]];
        }
        
    }
    
    imgUrlString = [NSString stringWithFormat:@"%@%@",_personData[@"photo_url"],jpg];
    //对网址的安全处理
    NSString *completeImgUrlString = [imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return completeImgUrlString;
}




//异步加载图片
- (NSString *)getCompleteImgUrlString{
    //图片大小
    CGFloat pictureWidth = [[_personData objectForKey:@"photoWidth"] floatValue];
    CGFloat pictureHeigth = [[_personData objectForKey:@"photoHeight"] floatValue];
    
    //NSLog(@"图片链接:%@,附近图片w-%f, h-%f",_imgDic[@"photo_url"],pictureWidth,pictureHeigth);
    //裁剪使用宽度和高度
    NSNumber *clipWidth  = nil;
    NSNumber *clipHeight = nil;
    NSString *jpg  = @"";
    //图片链接
    NSString *imgUrlString = @"";
    
    if (pictureHeigth == 0 ||pictureWidth ==0){
        
    }else{
        if (pictureWidth>pictureHeigth) {
            //横长图:以高为标准获取图片
            clipWidth = [NSNumber numberWithInteger:self.width*(pictureHeigth/self.height)];
            clipHeight = [NSNumber numberWithInteger:pictureHeigth];
            jpg = [NSString stringWithFormat:@"@1e_%@h_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureHeigth],clipWidth,clipHeight];
            
        }else if(pictureWidth == pictureHeigth){
            //方图
            clipWidth = [NSNumber numberWithInteger:pictureWidth];
            clipHeight = [NSNumber numberWithInteger:pictureWidth *(self.height/self.width)];
            jpg = [NSString stringWithFormat:@"@1e_%@w_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureWidth],clipWidth,clipHeight];
            
        }else if(pictureWidth<pictureHeigth){
            //纵向长图片
            clipWidth = [NSNumber numberWithInteger:pictureWidth];
            clipHeight = [NSNumber numberWithInteger:pictureWidth *(self.height/self.width)];
            jpg = [NSString stringWithFormat:@"@1e_%@w_0c_0i_1o_90Q_1x|%@x%@-2rc.jpg",[NSNumber numberWithInteger:pictureWidth],clipWidth,clipHeight];
        }
        
    }
    
    imgUrlString = [NSString stringWithFormat:@"%@%@",_personData[@"photo_url"],jpg];
    //对网址的安全处理
    NSString *completeImgUrlString = [imgUrlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return completeImgUrlString;
}

@end
