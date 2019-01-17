//
//  MCHotJingpaiCell.m
//  Mocha
//
//  Created by TanJian on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCHotJingpaiCell.h"
#import "NewLoginViewController.h"
#import "MCJingpaiView.h"
#import "auctionTips.h"
#import "VideoMaskView.h"


#define kHotFont  12*kDeviceWidth/375
@interface MCHotJingpaiCell ()

@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *jingjiaID;
@property(nonatomic,assign)int secondsCountDown;
@property(nonatomic,strong)NSTimer *countDownTimer;
@property(nonatomic,assign)MCsuperType superVCType;
@property(nonatomic,strong)UIViewController *superVC;

@property(nonatomic,strong)NSArray *imgViewArr;
@property(nonatomic,strong)NSArray *tagLabelArr;

@property(nonatomic,strong)MCJingpaiView *jingpaiView;

@end

@implementation MCHotJingpaiCell

-(NSArray *)imgViewArr{
    if (!_imgViewArr) {
        _imgViewArr = [[NSArray alloc]init];;
    }
    return _imgViewArr;
}

-(NSArray *)tagLabelArr{
    if (!_tagLabelArr) {
        _tagLabelArr = [[NSArray alloc]init];
    }
    return _tagLabelArr;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //颜色大小设置
    _nickNameLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _IdentityLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _browseCount.textColor = [UIColor colorForHex:kLikeBlackColor];
    _descriptionLable.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _firstTagLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _secondTagLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _thirdTagLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    
    _topLime.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    _seprateLime.hidden = YES;
    _headImageView.layer.cornerRadius = self.headImageView.width*0.5;
    _headImageView.clipsToBounds = YES;
    _jingpaiHeaderImageView.layer.cornerRadius = self.jingpaiHeaderImageView.width*0.5;
    _jingpaiHeaderImageView.clipsToBounds = YES;
    _jingpaiBottomView.layer.cornerRadius = 10;
    _jingpaiBottomView.clipsToBounds = YES;
    _jingpaiBottomView.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    _jingpaiButton.layer.cornerRadius = 10;
    _jingpaiButton.clipsToBounds = YES;
    _jingpaiCountLabel.layer.cornerRadius = 8;
    _jingpaiCountLabel.clipsToBounds = YES;
    
    _jingpaiCountLabel.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    _currentPriceLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    _jingpaiButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
    _currentJingpaiLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _lastJingpaiLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _nobodyDoJingpaiLabel.textColor = [UIColor colorForHex:kLikeBlackTextColor];
    _currentJingpaiLabel.font = [UIFont systemFontOfSize:kHotFont];
    _currentPriceLabel.font = [UIFont systemFontOfSize:kHotFont];
    _lastJingpaiLabel.font = [UIFont systemFontOfSize:kHotFont];
    
    _firstTagLabel.hidden = YES;
    _secondTagLabel.hidden = YES;
    _thirdTagLabel.hidden = YES;
    _firstTagBtn.hidden = YES;
    _secondTagBtn.hidden = YES;
    _thirdTagBtn.hidden = YES;
 
    _firstImageViwe.hidden = YES;
    _secondImageView.hidden = YES;
    _thirdImageView.hidden = YES;
    _fouthImageView.hidden = YES;
    
    _nobodyDoJingpaiLabel.hidden = YES;
    
    [self.headerButton addTarget:self action:@selector(jumpToMyPage) forControlEvents:UIControlEventTouchUpInside];
    [self.jingpaiButton addTarget:self action:@selector(JoinJingpai) forControlEvents:UIControlEventTouchUpInside];
}

-(void)jumpToMyPage{
    
    NSDictionary *dict = @{@"uid":self.uid};

    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:dict];
    }
    
}

-(void)JoinJingpai{
    NSLog(@"弹出竞价窗口");
    [self isNeedLogin];
    
}

-(void)isNeedLogin{
    
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //如果自己不能参与自己的，则打开此处
//
//    if ([self.uid isEqualToString:uid]) {
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"不能参与自己的竞拍" delegate:self.superVC cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        [alert show];
//        return;
//    }
    
    if (!uid) {
        
        UserDefaultSetBool(YES, @"isHiddenTabbar");
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToLogin" object:nil];
        
    }else{

        [self appearJingpaiView];
    }
    
}

//弹出竞价view
-(void)appearJingpaiView{
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    //判断是否是app第一次被打开
    NSString *home = NSHomeDirectory();
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"firstAuction.plist"];
    NSString *auctionData = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    if (!(auctionData.length > 0)) {
        NSLog(@"首次登陆");
        NSString *tempStr = @"secondAuction";
        [tempStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];

        auctionTips *tipsView = [[auctionTips alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        tipsView.superVCType = self.superVCType;
        [tipsView setupUI];
        switch (self.superVCType) {
            case superHot:
                tipsView.superHotVC = self.superHotVC;
                _superVC = _superHotVC;

                break;
            case superList:
                tipsView.superListVC= self.superListVC;
                _superVC = _superListVC;

                break;
            case superNear:
                tipsView.superNearVC = self.superNearVC;
                _superVC = _superNearVC;

                break;
            default:
                break;
        }
        [window addSubview:tipsView];
        
        return;
    }
    
    MCJingpaiView *jingpaiView = [[MCJingpaiView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    
    jingpaiView.isHotFeedVC = YES;
    jingpaiView.auctionID = _model.auctionID;
    jingpaiView.up_range = _model.info.up_range;
    jingpaiView.shareImg = _firstImageViwe.image;
    jingpaiView.lastPrice = _model.info.last_price?_model.info.last_price:_model.info.initial_price;
    jingpaiView.auction_des = _model.info.auction_description;
    
    [jingpaiView setupUI];
    self.jingpaiView = jingpaiView;
    
    switch (self.superVCType) {
        case superHot:
            jingpaiView.superHotVC = self.superHotVC;
            [self.superHotVC.view addSubview:jingpaiView];
            break;
        case superList:
            jingpaiView.superListVC= self.superListVC;
            [self.superListVC.view addSubview:jingpaiView];
            break;
        case superNear:
            jingpaiView.superNearVC = self.superNearVC;
            [self.superNearVC.view addSubview:jingpaiView];
            break;
        default:
            break;
    }
    
    
}


+(float)getJingpaiCellHeightWith:(NSDictionary *)dict{
//    NSLog(@"%@",dict);
    
    float cellHeight = 0;
    
    float topLimeH = 10;
    float timeLabelH = 21;
    float headerImageH = 50;
    float imageViewH = (kDeviceWidth-55)/4+10;
    float jingpaiHeaderH = (kDeviceWidth-50)*8/65;
    
    //需要动态计算的高度
    float tagLabelH = 31;
    float descriptionLabelH = 21;
    timeLabelH = 10;
    
    MCHotJingpaiModel *model = [[MCHotJingpaiModel alloc]initWithDictionary:dict error:nil];
    NSInteger tagCount = model.info.tags.count;
    if (tagCount > 0) {
        
    }else{
        tagLabelH = 0;
    }

    //label高度计算
    
    NSString *descripTotle = [NSString stringWithFormat:@"#%@#  %@",model.info.auction_type_name,model.info.auction_description];
    descriptionLabelH = [SQCStringUtils getCustomHeightWithText:descripTotle viewWidth:kDeviceWidth-60 textSize:14]+10;
    
    if (descriptionLabelH/21>3) {
        descriptionLabelH = 16.707*3;
    }
   
    cellHeight = timeLabelH+headerImageH+descriptionLabelH+imageViewH+tagLabelH+jingpaiHeaderH+topLimeH;
    return cellHeight;
    
}


-(void)setDataWithDict:(NSDictionary *)dict{
    
    if (self.superHotVC) {
        self.superVCType = superHot;
    }else if(self.superNearVC){
        self.superVCType = superNear;
    }else if(self.superListVC){
        self.superVCType = superList;
    }else{
        
    }
    self.model = nil;
    
    MCHotJingpaiModel *model = [[MCHotJingpaiModel alloc]initWithDictionary:dict error:nil];
    self.model = model;
    
    
    //1.倒计时时间（分别显示各自倒计时则打开）
//    [self setCountdownTime];
    self.remainTimeLabel.hidden = YES;
    if (self.remainTimeLabel.hidden) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.remainTimeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.topLime attribute:NSLayoutAttributeHeight multiplier:1 constant:-5]];
    }else{
        
    }
    
    //2.头像
    //给页面uid赋值，用于个人界面跳转
    self.uid = model.user.uid;
    
    NSString *imgUrlString = [NSString stringWithFormat:@"%@%@",getSafeString(model.user.head_pic),[CommonUtils imageStringWithWidth:40*2 height:40*2]];
    [self.headImageView setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    //3.认证图标
    if (model.user.vip.intValue == 1) {
        self.renzhengImage.hidden = NO;
    }else{
        self.renzhengImage.hidden = YES;
    }
    
    //4.昵称
    self.nickNameLabel.text = model.user.nickname;
    //5.身份
    self.IdentityLabel.text = model.user.user_type;
    //6.皇冠会员
    if (model.user.member.intValue == 1) {
        _memberImage.hidden = NO;
        _nickNameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
        _IdentityLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    }else{
        _memberImage.hidden = YES;
        _nickNameLabel.textColor = [UIColor colorForHex:kLikeBlackColor];
        _IdentityLabel.textColor = [UIColor colorForHex:kLikeBlackColor];
    }
    //7.竞拍人数
    self.jingpaiCountLabel.text = [NSString stringWithFormat:@"  %@次竞拍  ",model.info.auction_number?model.info.auction_number:@"0"];
    //8.浏览人数
    self.browseCount.text = [NSString stringWithFormat:@"浏览:%@",model.info.view_number?model.info.view_number:@"0"];
    //9.竞拍描述
    //最多显示三行文字
    self.descriptionLable.text = [NSString stringWithFormat:@"#%@#  %@",model.info.auction_type_name,model.info.auction_description];
    
    float descriptionLabelH = [SQCStringUtils getCustomHeightWithText:_descriptionLable.text viewWidth:kDeviceWidth-40 textSize:14];
    
    if (descriptionLabelH/16>=3) {
        self.descriptionLable.numberOfLines = 3;
    }
    
    //10.图片
    self.imgViewArr = nil;
    @try {
        _imgViewArr = @[self.firstImageViwe,self.secondImageView,self.thirdImageView,self.fouthImageView];

    } @catch (NSException *exception) {
//        NSLog(@"错误：%@",exception.description);
    } @finally {
        
    }
    
    NSInteger imgurlCount = model.info.img_urls.count;
    
    //是否显示视频icon
    if (model.info.video_url.length > 0) {
        _playImg.hidden = NO;
    }else{
        _playImg.hidden = YES;
    }
    //
    for (int i=0; i<4; i++) {
        UIImageView *imgView = _imgViewArr[i];
        imgView.hidden = YES;
    }
    
    
    for (int i = 0; i<imgurlCount; i++) {
        
        if (i<4) {
            if (i<_imgViewArr.count) {
                UIImageView *currentImgView = _imgViewArr[i];
                currentImgView.hidden = NO;
                
                NSString *urlString = getSafeString(model.info.img_urls[i][@"url"]);
                NSString *url = [NSString stringWithFormat:@"%@%@",urlString,[CommonUtils imageStringWithWidth:currentImgView.width * 2 height:currentImgView.height * 2]];
                
                [currentImgView setImageWithURL:[NSURL URLWithString:url?url:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                if (model.info.cover_url.length > 0 ) {
                    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playButton"]];
                    imageView.center = currentImgView.center;
                    [currentImgView addSubview:imageView];
                }

            }
            
        }
    }

    //11.标签行
    
    self.tagLabelArr = @[self.firstTagLabel,self.secondTagLabel,self.thirdTagLabel];
    
    NSInteger tagCount = model.info.tags.count;

    for (int i = 0; i<3; i++) {
        UILabel *currentLabel = _tagLabelArr[i];
        currentLabel.hidden = YES;
    }
    
    for (int i = 0; i<tagCount; i++) {
        UILabel *currentLabel = _tagLabelArr[i];

        if (i<3) {
            
            NSString *tempStr = [NSString stringWithFormat:@" %@",model.info.tags[i]];
            currentLabel.text = [tempStr stringByAppendingString:@"  "];
            currentLabel.frame = CGRectMake(currentLabel.left, currentLabel.top, currentLabel.width+5, currentLabel.height);
            currentLabel.layer.borderColor = [UIColor colorForHex:kLikeBlackTextColor].CGColor;
            currentLabel.layer.borderWidth = 1;
            currentLabel.layer.cornerRadius = currentLabel.height*0.5;
            currentLabel.clipsToBounds = YES;
            currentLabel.hidden = NO;
            currentLabel.layer.masksToBounds = YES;

        }
    }
    
    if (tagCount == 0) {
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.seprateLime attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstImageViwe attribute:NSLayoutAttributeBottom multiplier:1 constant:8]];
    }else{
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.seprateLime attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.firstImageViwe attribute:NSLayoutAttributeBottom multiplier:1 constant:35]];
    }

    //12.参与竞拍栏数据
    
    NSArray *log = [USER_DEFAULT valueForKey:@"auction_feeds_tip"];
    
    //判断是否有人参与竞拍
    int auctionCount = [model.info.auction_number intValue];
    if (auctionCount != 0) {
        
        self.jingpaiHeaderImageView.hidden = NO;
        self.lastJingpaiLabel.hidden = NO;
        self.currentPriceLabel.hidden = NO;
        self.currentJingpaiLabel.hidden = NO;
        self.nobodyDoJingpaiLabel.hidden = YES;
        
        float smallHeadH = (kDeviceWidth - 50)/65*8/9*7;
        NSString *imgUrlString = [NSString stringWithFormat:@"%@%@",getSafeString(model.last_user.head_pic),[CommonUtils imageStringWithWidth:smallHeadH*2 height:smallHeadH*2]];
        [self.jingpaiHeaderImageView setImageWithURL:[NSURL URLWithString:imgUrlString] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        self.currentJingpaiLabel.text = [NSString stringWithFormat:@"%@",log[1]];
        
        NSString *currentPrice = [model.info.last_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.currentPriceLabel.text = [NSString stringWithFormat:@"%@金币",currentPrice?currentPrice:@"0"];
        NSString *lastPrice = [model.info.pre_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
        self.lastJingpaiLabel.text = [NSString stringWithFormat:@"%@%@金币",log[2],lastPrice?lastPrice:@"0"];
        
        //参与人数为一不显示获利
        if (auctionCount == 1) {
            self.lastJingpaiLabel.hidden = YES;
        }else{
            self.lastJingpaiLabel.hidden = NO;
        }
        
    }else{
        
        self.jingpaiHeaderImageView.hidden = YES;
        self.lastJingpaiLabel.hidden = YES;
        self.currentPriceLabel.hidden = YES;
        self.currentJingpaiLabel.hidden = YES;
        self.nobodyDoJingpaiLabel.hidden = NO;
        
        self.nobodyDoJingpaiLabel.text = [NSString stringWithFormat:@"%@",log[0]];
    }
    
    
    
    //13.我要竞拍按钮
    [self.jingpaiButton setTitle:model.info.opName?model.info.opName:@"未知状态" forState:UIControlStateNormal];
    if ([model.info.opCode isEqualToString:@"0"]) {
        _jingpaiButton.userInteractionEnabled = YES;
        _jingpaiButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    }else{
        _jingpaiButton.userInteractionEnabled = NO;
        _jingpaiButton.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
    }
    
    
    

}




#pragma mark 需要每个cell分别显示倒计时的方法
-(void)setCountdownTime{

    //设置倒计时总时长
    NSString *currentTimeStr = self.model.info.currentTimestamp;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[currentTimeStr floatValue]];
    NSTimeInterval currentInterVal = fabs([currentDate timeIntervalSinceNow]);
    
    NSString *endTimeStr = self.model.info.end_time;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTimeStr floatValue]];
    NSTimeInterval endInterVal = fabs([endDate timeIntervalSinceNow]);
    
    int temp = endInterVal - currentInterVal;
    
    self.secondsCountDown = temp;//60秒倒计时
    //开始倒计时
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    //设置倒计时显示的时间
    self.remainTimeLabel.text= [NSString stringWithFormat:@"%@:%@",self.model.info.opName, [CommonUtils formatDateInterval:temp type:0]];
    
}

-(void)timeFireMethod{
    //倒计时-1
    self.secondsCountDown--;//60秒倒计时
    //修改倒计时标签现实内容
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%@:%@",self.model.info.opName, [CommonUtils formatDateInterval:self.secondsCountDown type:0]];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        NSLog(@"计时结束");
    }
    
}

@end
