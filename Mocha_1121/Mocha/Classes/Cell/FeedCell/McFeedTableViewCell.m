//
//  McFeedTableViewCell.m
//  Mocha
//
//  Created by renningning on 15/4/20.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McFeedTableViewCell.h"
#import "ReadPlistFile.h"
#import "VideoMaskView.h"
#import "MoreTableViewCell.h"
#import "McSmallCommentTableViewCell.h"
#import "McHotFeedViewController.h"
#import <CoreText/CoreText.h>
#import <MediaPlayer/MediaPlayer.h>
#import "UploadVideoManager.h"
#import "DaShangGoodsView.h"
#import "MCAnimForVideo.h"

@interface McFeedTableViewCell ()
{
    BOOL isSave;
    BOOL isLike;
    float cellWidth;
    NSArray *allAreaInfoArray;
    NSDictionary *roleTypeDict;
    int trueCommentcount;
    //热门动态
    BOOL _isHot;
    NSMutableArray *_likeUsersArr;
    NSString *photoUid;
    NSString *_object_type;
}

@property (nonatomic, retain) NSMutableArray *commentArray;
@property (nonatomic, retain) UIButton *playVideoButton;
@property (nonatomic, retain) UIButton *playVideoButton_full;
@property (nonatomic,strong) UILabel *plusLable;
@property (nonatomic,strong) UIImageView *goodsImage;
@property (nonatomic,strong) MCAnimForVideo *loadingView;
@property (strong, nonatomic) VideoMaskView *player_maskview ;
@property (nonatomic,strong) UIImageView *memberImg;

@property (nonatomic,copy) NSString *photoId;
@property (nonatomic,strong) NSMutableArray *bigImgArr;

@property (nonatomic,strong) UILabel *taoxiPriceLabel;

//真实的显示的图片的高度
@property (nonatomic,assign)CGFloat currentPhotoHeight;


@end

#define kPhotoHeight 290
#define kPhotoOrignX 65
#define kPhotoGap 30
#define shangImageNormal @"dashang"



@implementation McFeedTableViewCell

-(UIImageView *)memberImg{
    if (!_memberImg) {
        _memberImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"huangguan"]];
        
    }
    return _memberImg;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.backgroundColor = [UIColor blackColor];
        _timeLabel.alpha = 0.5;
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

#pragma mark -初始化
+ (McFeedTableViewCell *)getFeedTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"McFeedTableViewCell" owner:self options:nil];
    McFeedTableViewCell *cell = array[0];
    
    [cell initSubViews];
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McFeedTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor whiteColor]];

        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    _picImageView.contentMode =UIViewContentModeScaleAspectFit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



- (void)initSubViews
{
    //单元格分割线
    _bgTopView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    //头像
    _headImageView.layer.cornerRadius = _headImageView.frame.size.height/2;
    _headImageView.layer.masksToBounds = YES;
    //昵称
    _nickNameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    //地址
    _infoPonLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    //时间标签
    _createTimeLab.textColor = [UIColor colorForHex:kLikeGrayColor];
    //附近距离
    _nearFarLab.textColor = [UIColor colorForHex:kLikeGrayColor];
    
    _nearFarLab.text = @"";
    _nickNameLabel.text = @"";
    _infoPonLabel.text = @"";
    _picInfoLabel.text = @"";
    _createTimeLab.text = @"";
    //时间分割线
    CGRect lineFrame = _lineImageView.frame;
    lineFrame.size.height = 1.0;
    _lineImageView.frame = lineFrame;
    _lineImageView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    //赞，评论，赏
    [_likeBtn setImage:[UIImage imageNamed:@"zangray"] forState:UIControlStateNormal];
    [_likeBtn setTitle:@" 赞" forState:UIControlStateNormal];
    _likeBtn.layer.cornerRadius = 15;
    _likeBtn.tag = 1;
    
    [_commitBtn setImage:[UIImage imageNamed:@"pinglungray"] forState:UIControlStateNormal];
    [_commitBtn setTitle:@" 评论" forState:UIControlStateNormal];
    _commitBtn.layer.cornerRadius = 15;
    _commitBtn.tag = 3;
    
    _privateBtn.layer.cornerRadius = 15;
    _privateBtn.tag = 2;
    [_privateBtn setImage:[UIImage imageNamed:shangImageNormal] forState:UIControlStateNormal];
    [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(0)"] forState:UIControlStateNormal];
    
    
    //读取地址配置信息
    allAreaInfoArray = [ReadPlistFile readAreaArray];
    //读取身份配置信息
    roleTypeDict = [ReadPlistFile getRoleTypes];
    _commentTableView.scrollEnabled = NO;
    
    _privateBtn.frame = CGRectMake(kScreenWidth-120, 0, 120, 30);
    _jubaoButton.frame = CGRectMake(kScreenWidth-70, 10, 75, 40);
    BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
    if (isAppearShang) {
        _privateBtn.hidden = NO;
        _memberImg.hidden = NO;
    }else
    {
        _memberImg.hidden = YES;
        _privateBtn.hidden = YES;
    }

    
}

-(void)removeAnimation{
    [self.loadingView removeFromSuperview];
    
}

//动画所需要的图层
-(void)viewForAnimation{
    
    
    //+1效果
    _plusLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-45, CGRectGetMinY(self.bottomView.frame)+30, 40, 25)];
    _plusLable.text = @"+1";
    _plusLable.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _plusLable.alpha = 0;
    
    [self addSubview:_plusLable];
    
    //1.取到选择礼物显示到view上
    self.goodsImage = [[UIImageView alloc]init];
    
    [_goodsImage sizeToFit];
    _goodsImage.center = CGPointMake(kDeviceWidth*0.5, kDeviceHeight*0.5-100);
    _goodsImage.hidden = YES;

}


//通知调用动画
-(void)goodsPlusAnimation:(NSNotification *)text{
    //动画期间礼物按钮不能点击
    self.userInteractionEnabled = NO;
    
    //购物车动画
    //1.取到选择礼物显示到view上
    NSString *dataStr = text.userInfo[@"imgData"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:dataStr];
    UIImage *image = [[UIImage alloc]initWithData:data];

    _goodsImage.image = image;
    self.goodsImage.hidden = NO;
    [_goodsImage sizeToFit];
    _goodsImage.center = self.contentView.center;
    
    [self addSubview:_goodsImage];

    //2.抛物线动画
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPoint startP = self.contentView.center;
    CGPoint endP = self.plusLable.center;
    
    
    CGPathMoveToPoint(thePath, NULL, startP.x, startP.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 200, 200, endP.x-20, endP.y+10);
    
    goodsAnimation.path = thePath;
    
    //图片缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
    scaleAnimation.autoreverses = NO;
    
    group.animations = @[scaleAnimation,goodsAnimation];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_goodsImage.layer addAnimation:group forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
 
            //礼物加1动画效果
            self.plusLable.alpha = 1;
            [UIView animateWithDuration:1 animations:^{
                _plusLable.alpha = 0;
                _goodsImage.alpha = 0;
                _plusLable.center = CGPointMake(self.plusLable.center.x, self.plusLable.center.y - 25);
                
            }];
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                self.userInteractionEnabled = YES;
                [_plusLable removeFromSuperview];
                [_goodsImage removeFromSuperview];
                
                
            });
        });
        
    });

}





#pragma mark - setDcitionary
//个人动态,2.18版本已经暂时废弃
- (void)setCellItemWithDiction_person:(NSDictionary *)diction atIndex:(NSInteger )indexRow
{
    
    _commentTableView.width = kDeviceWidth - 17-10;
    self.isPersonDongtai = YES;
    //    float space = -50;
    self.itemDict = diction;
    self.currentUid = getSafeString(self.itemDict[@"uid"]);
//    NSLog(@"%@",diction);
    //更新礼物数量数据
    NSString *vgoodCount = diction[@"goodsCount"];
    if (!vgoodCount) {
        [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(0)"] forState:UIControlStateNormal];
    }else{
        [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(%@)",vgoodCount] forState:UIControlStateNormal];
    }
    
    /*个人信息*/
    NSDictionary *userDict = diction;
    if ([userDict isKindOfClass:[NSDictionary class]]) {
        _headImageView.hidden = YES;
        _nickNameLabel.hidden = YES;
        _vipImg.hidden = YES;
        _infoPonLabel.hidden = YES;
        if (self.playVideoButton) {
            [self.playVideoButton removeFromSuperview];
            
        }
        
        /*图片信息*/
        id data = self.itemDict;
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            //            NSDictionary *photoDict = data;
            //            float height = kPhotoHeight;
            //            float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
            //            float wid;
            //            if ([photoDict[@"height"] integerValue] > 0) {
            //                wid = [photoDict[@"width"] floatValue] * height /[photoDict[@"height"] floatValue] ;
            //                 wid = MIN(wid, width);
            //            }
            NSDictionary *photoDict = data;
            CGSize size = [McFeedTableViewCell getPictureViewSize:photoDict];
            _currentPhotoHeight = self.height;
            float height = size.height;
            float wid = size.width;
            
            //
            NSString *detail = [NSString stringWithFormat:@"%@",getSafeString(photoDict[@"title"])];
            if ([detail isEqualToString:@"0"]) {
                detail = @"";
            }
            
            
            CGRect picInfoRect = CGRectMake(64, 60, 0, 0);
            if (detail && detail.length > 0) {
                picInfoRect = _picInfoLabel.frame;
                CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
                picInfoRect.size = detailSize;
                _picInfoLabel.frame = picInfoRect;
            }
            _picInfoLabel.text = detail;
            _picInfoLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
            [_picInfoLabel sizeToFit];
            CGRect urlFrame = _picImageView.frame;
            urlFrame.origin.x = kPhotoOrignX;
            urlFrame.size.width = wid;
            urlFrame.origin.y = 70 + picInfoRect.size.height;
            urlFrame.size.height = height;
            _picImageView.frame = urlFrame;
            
            NSString *url;
            NSString *type = getSafeString(diction[@"object_type"]);
            if ([type isEqualToString:@"6"]) {
                url = [NSString stringWithFormat:@"%@%@",photoDict[@"url"],[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
            }else if([type isEqualToString:@"11"]){
                url = [NSString stringWithFormat:@"%@%@",photoDict[@"cover_url"],[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
            }else{
                
            }
            
            
            
            url = [CommonUtils appendPostfix:url];
            [_picImageView setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            
            CGRect bottowFrame = _bottomView.frame;
            bottowFrame.origin.y = CGRectGetMaxY(_picImageView.frame);
            CGRect createFrame = _createTimeLab.frame;
            createFrame.origin.x = 60;
            _createTimeLab.frame = createFrame;
            _createTimeLab.text = [CommonUtils dateTimeIntervalString:diction[@"createline"]];
            
            float userHeight = [self setShowUsers:photoDict[@"likeusers"]];;
            _likeUsersArr = [NSMutableArray arrayWithArray:photoDict[@"likeusers"]];
            
            bottowFrame.size.height = 110 - 40 + userHeight;
            _bottomView.frame = bottowFrame;
            
            
            isLike = [photoDict[@"islike"] boolValue];
            [self likeButtonHighlight:isLike];
            
            isSave = [photoDict[@"isfavorite"] boolValue];
            [self saveButtonHighlight:isSave];
            
            float tableHei = 0;
            NSArray *commentsArr = diction[@"info"][@"comments"];
            //计算评论表视高度
            if ([diction[@"info"][@"comments"] count] > 3) {
                for (int i = 0; i < 3; i ++) {
                    CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:commentsArr[i] WidthValue:_commentTableView.width];
                    tableHei += (tempH +2);
                }
                //加上了“更多”的单元格高度
                tableHei += 20;
            }else{
                for (int i = 0; i < [diction[@"info"][@"comments"] count]; i++) {
                    CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:commentsArr[i] WidthValue:_commentTableView.width];

                    tableHei += (tempH+2);
                }
            }
            
            //评论表视图
            _commentTableView.frame = CGRectMake(17, CGRectGetMaxY(_bottomView.frame), self.width -10-17, tableHei);
            
            //commentcount  comments setItemValueWithDict
            if ([photoDict[@"commentcount"] integerValue]> 0) {
                
                if (!_commentArray) {
                    _commentArray = [NSMutableArray arrayWithCapacity:[photoDict[@"commentcount"] integerValue]];
                }
                [_commentArray removeAllObjects];
                _commentArray = [NSMutableArray arrayWithArray:photoDict[@"comments"]];
                trueCommentcount = [photoDict[@"commentcount"] intValue];
                [self.commentTableView reloadData];
            }
            NSString *feedType = getSafeString(photoDict[@"feedType"]);
            
#ifdef TencentRelease
            
            if([feedType isEqualToString:@"11"])
            {
                _picInfoLabel.text = @"";
                if (!self.playVideoButton) {
                    self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                }
                self.video_picImageView.hidden = YES;

                [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
                [self.playVideoButton setFrame:_picImageView.frame];
                [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
                [self addSubview:self.playVideoButton];
                [self bringSubviewToFront:self.playVideoButton];
            }
            
#else
            
            
            
#endif
        }
    }
    
    NSString *uid = getSafeString([[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]);
    if ([self.currentUid isEqualToString:uid]) {
        self.privateBtn.hidden = YES;
        
    }
    
    
}

#ifdef TencentRelease


- (VideoMaskView *)player_maskview
{
    if (!_player_maskview) {
        _player_maskview = [[VideoMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _player_maskview.isAllowedShang = YES;
        [_player_maskview initViews];
    }
    return _player_maskview;
}

- (UIImageView *)video_picImageView
{
    if (!_video_picImageView) {
        _video_picImageView = [[UIImageView alloc] init];
    }
    return _video_picImageView;
}


- (void)playVideoMethod:(UIButton *)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStates) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatesExist) name:MPMoviePlayerWillExitFullscreenNotification object:nil];

    if(_player)
    {
        [_player.view removeFromSuperview];
        _player = nil;
    }
    _player = [[MPMoviePlayerController alloc] init];

    if (![UploadVideoManager sharedInstance].playersArray) {
        [UploadVideoManager sharedInstance].playersArray = @[].mutableCopy;
    }
    self.playedIndex = self.currentIndex;
    for (int i=0; i<[UploadVideoManager sharedInstance].playerFullButtonArray.count; i++) {
        UIButton *full = [UploadVideoManager sharedInstance].playerFullButtonArray[i];
        [full removeFromSuperview];
    }
    for (int i=0; i<[UploadVideoManager sharedInstance].playersArray.count; i++) {
        MPMoviePlayerController *players = [UploadVideoManager sharedInstance].playersArray[i];
        if (players) {
            [players stop];
            [players.view removeFromSuperview];
            [self.playVideoButton_full removeFromSuperview];
        }
    }
    NSString *videoURL = getSafeString(self.itemDict[@"url"]);
    NSString *vid = getSafeString(self.itemDict[@"id"]);
    self.currentUid = getSafeString(self.itemDict[@"uid"]);

    if (![self isRightKey:videoURL]) {
        videoURL = getSafeString(self.itemDict[@"info"][@"url"]);
        vid = getSafeString(self.itemDict[@"info"][@"id"]);
        self.currentUid = getSafeString(self.itemDict[@"info"][@"uid"]);
    }
    
    self.player.contentURL = [NSURL URLWithString:videoURL];
    self.player.view.frame = _picImageView.frame;
    NSLog(@"%f---%f",_picImageView.frame.origin.x,_picImageView.frame.origin.y);
    NSLog(@"%f---%f",_picImageView.frame.size.width,_picImageView.frame.size.height);
    
    self.video_picImageView.hidden = NO;
    
    self.video_picImageView.backgroundColor = [UIColor blackColor];
    self.video_picImageView.contentMode = UIViewContentModeScaleToFill;
    self.video_picImageView.image = _picImageView.image;
    self.video_picImageView.frame = CGRectMake(0, 0, _picImageView.frame.size.width, _picImageView.frame.size.height);
    [self.player.view addSubview:self.video_picImageView];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeNone;
    /*
     视频静音播放暂时去掉，声音为默认
    float volume = [MPMusicPlayerController applicationMusicPlayer].volume;
    if (volume>0.0000001) {
        __block UISlider *volumeViewSlider = nil;
        
        __block MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(-150, -150, 100, 100)];
        volumeView.hidden = NO;
        [self addSubview:volumeView];
        
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)view;
                break;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:0];
        });
    }
    */
    
    [self.playVideoButton removeFromSuperview];
    //加载动画
    [self.loadingView removeFromSuperview];
    self.loadingView = [[MCAnimForVideo alloc]init];
    self.loadingView.frame = CGRectMake(CGRectGetWidth(self.video_picImageView.frame)*0.40,CGRectGetHeight(self.video_picImageView.frame)*0.42, 45, 45);
    self.loadingView.center = self.video_picImageView.center;
    self.loadingView.backgroundColor = [UIColor clearColor];
    self.timeLabel.frame = CGRectMake(0,CGRectGetHeight(self.video_picImageView.frame)-30, CGRectGetWidth(self.video_picImageView.frame), 30);
    self.timeLabel.text = @"0:00 / 0:00";
    self.timeLabel.hidden = NO;
    [self.player.view addSubview:self.loadingView];
    [self.player.view addSubview:self.timeLabel];

    [self.player play];
    
    [[UploadVideoManager sharedInstance].playersArray addObject:self.player];
    self.player_maskview.moviePlayer = self.player;
    self.player_maskview.videoURL = videoURL;
    self.player_maskview.vid = vid;
    self.player_maskview.supView = self;
    self.player_maskview.originalFrame = _picImageView.frame;
    self.player_maskview.loadingView = self.loadingView;
    NSLog(@"x=%f,y=%f,w=%f,h=%f",_picImageView.origin.x,_picImageView.origin.y,_picImageView.size.width,_picImageView.size.height);

//    NSLog(@"%@ %@ ",self.itemDict,self.currentUid);
    NSString *uid = getSafeString([[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]);
    if ([self.currentUid isEqualToString:uid]) {
        self.player_maskview.isCurrentUser = YES;
        
    }else{
        self.player_maskview.isCurrentUser = NO;
    }
    self.player_maskview.hidden = YES;
    self.player_maskview.backgroundColor = [UIColor clearColor];

    if (!self.playVideoButton_full) {
        self.playVideoButton_full = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    if (![UploadVideoManager sharedInstance].playerFullButtonArray) {
        [UploadVideoManager sharedInstance].playerFullButtonArray = @[].mutableCopy;
    }
    [[UploadVideoManager sharedInstance].playerFullButtonArray addObject:self.playVideoButton_full];
    [self.playVideoButton_full addTarget:self action:@selector(playFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoButton_full setFrame:_picImageView.frame];
    [self addSubview:self.player.view];
    [self addSubview:self.playVideoButton_full];
    [self bringSubviewToFront:self.playVideoButton_full];
    
}

- (void)didChangeStates
{
    BOOL iscanchange = NO;

    //播放器的状态监听
    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
            NSLog(@"可以播放");
            iscanchange = YES;

            break;
        case MPMovieLoadStatePlaythroughOK:
            NSLog(@"缓冲完成，可以播放");
            iscanchange = YES;

            break;
        case MPMovieLoadStateStalled:
            NSLog(@"缓冲中");
            break;
        case MPMovieLoadStateUnknown:
            NSLog(@"未知状态");
            iscanchange = YES;
            break;
        default:
            break;
    }
    
    if (iscanchange) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.loadingView removeFromSuperview];
            
        });
        
        NSLog(@"did change ");
        if ([SingleData shareSingleData].isInThePhotoDetail) {
            [self performSelector:@selector(hideVideoImage) withObject:nil afterDelay:0.0];

        }else
        {
            [self performSelector:@selector(hideVideoImage) withObject:nil afterDelay:0.8];

        }
    }else {
    
    }
    
    
    
}

- (void)hideVideoImage
{
    if (![SingleData shareSingleData].isInThePhotoDetail) {
        self.video_picImageView.hidden = YES;

    }else
    {
        self.video_picImageView.hidden = NO;
        [self resetPlayButton];
    }
}

- (void)didChangeStatesExist
{
    
    NSLog(@"didChangeStatesExist ");
    
}

- (void)resetFullImage
{
    self.video_picImageView.hidden = YES;
}

- (void)resetPlayButton
{
    [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoButton setFrame:_picImageView.frame];
    [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    [self addSubview:self.playVideoButton];
    [self bringSubviewToFront:self.playVideoButton];
    
}

- (void)resetRePlayButton
{
    self.timeLabel.hidden = YES;
    [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoButton setFrame:_picImageView.frame];
    [self.playVideoButton setImage:[UIImage imageNamed:@"lb_ic_replay"] forState:UIControlStateNormal];
    [self addSubview:self.playVideoButton];
    [self bringSubviewToFront:self.playVideoButton];
    
}

- (void)playFullScreen
{
    LOG_METHOD;
    self.timeLabel.hidden = YES;

    self.video_picImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.player.view.clipsToBounds = YES;
    self.player.scalingMode = MPMovieScalingModeAspectFit;
    self.video_picImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player_maskview.maskImageView = self.video_picImageView;
    NSLog(@"playFullScreen ");
    for(int i=0;i<self.player.view.subviews.count;i++)
    {
        UIView *view = self.player.view.subviews[i];
        if ([view isKindOfClass:[VideoMaskView class]]) {
            [view removeFromSuperview];
        }
    }
    self.player_maskview.infoDict = self.itemDict;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [self.playVideoButton_full removeFromSuperview];

    self.player.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.loadingView.center = self.player.view.center;
    
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeNone;
//    [[MPMusicPlayerController applicationMusicPlayer] setVolume:0.6];

    self.player_maskview.hidden = NO;
    [self.player_maskview setVideoButtonHidden];
    [UIView animateWithDuration:1.0 animations:^{
        [self.player.view addSubview:self.player_maskview];
        
    }];
    
    self.player.shouldAutoplay = YES;
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            [window addSubview:self.player.view];
            
            break;
        }
    }
//    [self.player play];
    
}



- (void)didChangeStatesDone
{
    NSLog(@"didChangeStatesDone ");
    [self removePlayer];
    
}

- (void)removePlayer
{
    [self.player stop];
    [self.player.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //打赏礼品成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsPlusAnimation:) name:@"McFeedTableViewCellPlus" object:nil];
    
    //视频缓冲时跳转后回到秀，移除缓冲动画
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAnimation) name:@"doJumpVideoDetailAction" object:nil];

}


#else



#endif


//关注动态(朋友秀)
- (void)setCellItemWithDiction_mine:(NSDictionary *)diction atIndex:(NSInteger )indexRow
{
    
    //打赏礼品成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goodsPlusAnimation:) name:@"McFeedTableViewCellPlus" object:nil];
    
    NSLog(@"%@",diction);
    NSString *vgoodCount = diction[@"goodsCount"];

    if (!vgoodCount) {
        [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(0)"] forState:UIControlStateNormal];
    }else{
        [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(%@)",vgoodCount] forState:UIControlStateNormal];
    }
    
    
    _commentTableView.width = kDeviceWidth - 17-10;
    _isHot = NO;
    self.itemDict = diction;
//    NSLog(@"%@",diction);
    self.photoId = diction[@"id"];
    /*个人信息*/
    NSDictionary *userDict = diction[@"user"];
    if ([userDict isKindOfClass:[NSDictionary class]]) {
        
        NSString *headUrl = [NSString stringWithFormat:@"%@%@",userDict[@"head_pic"],[CommonUtils imageStringWithWidth:80 height:80]];
        [_headImageView setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head60"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        
        _nickNameLabel.text = [NSString stringWithFormat:@"%@  %@",userDict[@"nickname"],userDict[@"user_type"]];
        [_nickNameLabel sizeToFit];
        
        NSString *vip = [NSString stringWithFormat:@"%@", userDict[@"vip"]];//
        if ([vip isEqualToString:@"1"]) {
            self.vipImg.hidden = NO;
        }else
        {
            self.vipImg.hidden = YES;
        }
        
//        [self.memberImg removeFromSuperview];
        
        NSString *member = [NSString stringWithFormat:@"%@", userDict[@"member"]];//
        self.memberImg.frame = CGRectMake(_nickNameLabel.right+15, _nickNameLabel.top+_nickNameLabel.height*0.5-6.5, 20, 13);
        [self.headerBgView addSubview:self.memberImg];
        
        if ([member isEqualToString:@"1"]) {
        
            _nickNameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
            self.memberImg.hidden = NO;
        }else
        {
            _nickNameLabel.textColor = [UIColor blackColor];
            self.memberImg.hidden = YES;
        }
        
        _infoPonLabel.text = [NSString stringWithFormat:@"%@%@ ",userDict[@"provinceName"],userDict[@"cityName"]];
        
        /*图片信息*/
        id data = self.itemDict;
        if ([data isKindOfClass:[NSDictionary class]]) {
            //            NSDictionary *photoDict = data;
            //            float height = kPhotoHeight;
            //            float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
            //            float wid;
            //            if ([photoDict[@"height"] integerValue] > 0) {
            //               wid = [photoDict[@"width"] floatValue] * height /[photoDict[@"height"] floatValue] ;
            //
            //                wid = MIN(wid, width);
            //            }
            
            NSDictionary *photoDict = data;
            CGSize size = [McFeedTableViewCell getPictureViewSize:photoDict];
            _currentPhotoHeight = size.height;
            float height = size.height;
            float wid = size.width;
            
            
            NSString *detail = [NSString stringWithFormat:@"%@",getSafeString(photoDict[@"title"])];
            if ([detail isEqualToString:@"0"]) {
                detail = @"";
            }
            CGRect picInfoRect = CGRectMake(64, 60, 0, 0);
            if (detail && detail.length > 0) {
                picInfoRect = _picInfoLabel.frame;
                CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
                picInfoRect.size = detailSize;
                _picInfoLabel.frame = picInfoRect;
            }
            
            _picInfoLabel.text = detail;
            _picInfoLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
            [_picInfoLabel sizeToFit];
            CGRect urlFrame = _picImageView.frame;
            urlFrame.origin.x = kPhotoOrignX;
            urlFrame.origin.y = 70 + picInfoRect.size.height;
            urlFrame.size.width = wid;
            urlFrame.size.height = height;
            _picImageView.frame = urlFrame;
            
            NSString *picUrl = @"";
            if ([getSafeString(photoDict[@"object_type"]) isEqualToString:@"6"] ) {
                picUrl = getSafeString(photoDict[@"url"]);
            }else{
                picUrl = getSafeString(photoDict[@"cover_url"]);
            }
            NSString *url = [NSString stringWithFormat:@"%@%@",picUrl,[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
            url = [CommonUtils appendPostfix:url];
            UIImage *picImage = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:url];
            if (picImage) {
                _picImageView.image = picImage;
            }else{
                [_picImageView setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            CGRect bottowFrame = _bottomView.frame;
            bottowFrame.origin.y = CGRectGetMaxY(_picImageView.frame);
            
            CGRect createFrame = _createTimeLab.frame;
            createFrame.origin.x = 60;
            _createTimeLab.frame = createFrame;
            _createTimeLab.text = [CommonUtils dateTimeIntervalString:diction[@"createline"]];
            
            float userHeight = [self setShowUsers:photoDict[@"likeusers"]];;
            _likeUsersArr = [NSMutableArray arrayWithArray:photoDict[@"likeusers"]];
            
            bottowFrame.size.height = 110 - 40 + userHeight;
            _bottomView.frame = bottowFrame;
            
            
            isLike = [photoDict[@"islike"] boolValue];
            [self likeButtonHighlight:isLike];
            
            isSave = [photoDict[@"isfavorite"] boolValue];
            [self saveButtonHighlight:isSave];
            
            
            float tableHei = 0;
            NSArray *commentsArr = diction[@"comments"];
            
            if ([photoDict[@"commentcount"] integerValue]> 0) {
                if (!_commentArray) {
                    _commentArray = [NSMutableArray arrayWithCapacity:[photoDict[@"commentcount"] integerValue]];
                }
                [_commentArray removeAllObjects];
                _commentArray = [NSMutableArray arrayWithArray:photoDict[@"comments"]];
                trueCommentcount = [photoDict[@"commentcount"] intValue];
                [self.commentTableView reloadData];
            }
            
            //计算评论表视高度
            if ([diction[@"comments"] count] > 5) {
                for (int i = 0; i < 5; i ++) {
                    
                    NSString *comStr = _commentArray[i];
                     CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:_commentArray[i] WidthValue:_commentTableView.width];

                    tableHei += (tempH +2);
                }
                //加上了更多的单元格高度
                tableHei += 20;
            }else{
                for (int i = 0; i < [diction[@"comments"] count]; i++) {
//                    CGFloat tempH = [self getAttributedStrHeight:commentsArr[i] WidthValue:_commentTableView.width];
                    CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:_commentArray[i] WidthValue:_commentTableView.width];

                    tableHei += (tempH+2);
                }
            }
            
            //评论表视图
            _commentTableView.frame = CGRectMake(17, CGRectGetMaxY(_bottomView.frame), self.width -10-17, tableHei);
            //            self.commentTableView.backgroundColor = [UIColor purpleColor];
            /*
             float tableHei = 2;
             width = self.commentTableView.width;
             NSArray *commentsArr = diction[@"comments"];
             if ([diction[@"comments"] count] > 3) {
             for (int i = 0; i < 3; i ++) {
             NSString *tempStr = commentsArr[i][@"content"];
             CGSize strSize = [CommonUtils sizeFromText:tempStr textFont:[UIFont systemFontOfSize:12] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, MAXFLOAT)];
             tableHei += strSize.height + 11;
             }
             }else{
             for (int i = 0; i < [diction[@"comments"] count]; i++) {
             NSString *tempStr = commentsArr[i][@"content"];
             CGSize strSize = [CommonUtils sizeFromText:tempStr textFont:[UIFont systemFontOfSize:12] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, MAXFLOAT)];
             tableHei += strSize.height + 2;
             }
             }
             
             CGRect tableFrame = _commentTableView.frame;
             tableFrame.origin.y = CGRectGetMaxY(_bottomView.frame);
             tableFrame.size.height = tableHei;
             _commentTableView.frame = tableFrame;
             
             */
            NSString *feedType = getSafeString(photoDict[@"feedType"]);
            
            
#ifdef TencentRelease
            
            
            [self.playVideoButton removeFromSuperview];
            if([feedType isEqualToString:@"11"])
            {
//                _picInfoLabel.text = @"";
                if (!self.playVideoButton) {
                    self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                }
                [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
                [self.playVideoButton setFrame:_picImageView.frame];
                [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
                [self addSubview:self.playVideoButton];
                [self bringSubviewToFront:self.playVideoButton];
                
            }
            
#else
            
            
            
#endif
            //上面计算评论表视图高度时会用到_commentArray，后更新赋值会有数组越界问题，代码上移
//            if ([photoDict[@"commentcount"] integerValue]> 0) {
//                if (!_commentArray) {
//                    _commentArray = [NSMutableArray arrayWithCapacity:[photoDict[@"commentcount"] integerValue]];
//                }
//                [_commentArray removeAllObjects];
//                _commentArray = [NSMutableArray arrayWithArray:photoDict[@"comments"]];
//                trueCommentcount = [photoDict[@"commentcount"] intValue];
//                [self.commentTableView reloadData];
//            }
        }
    }
}






//热门动态 || 附近动态
- (void)setCellItemWithDiction:(NSDictionary *)diction atIndex:(NSInteger )indexRow isNear:(BOOL)near
{
    //显示评论的表视图
    _commentTableView.width = kDeviceWidth -17-10;
    _isHot = YES;
    self.itemDict = diction;
//    if (self.itemDict==nil) {
//        self.itemDict = diction;
//    }

    [self.playVideoButton setHidden:YES];

    //=======个人信息设置
    NSDictionary *userDict = diction[@"user"];
    if ([userDict isKindOfClass:[NSDictionary class]]) {
        //头像
        NSString *headUrl = [NSString stringWithFormat:@"%@%@",userDict[@"head_pic"],[CommonUtils imageStringWithWidth:80 height:80]];
        UIImage *headImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:headUrl];
        if (headImage) {
            _headImageView.image = headImage;
        }else{
            [_headImageView setImageWithURL:[NSURL URLWithString:headUrl] placeholderImage:[UIImage imageNamed:@"head60"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        }
        //昵称
        NSString *nicknameStr = [NSString stringWithFormat:@"%@  %@",userDict[@"nickname"],userDict[@"user_type"]];
        _nickNameLabel.text =nicknameStr;
        
        [_nickNameLabel sizeToFit];
        NSString *member = getSafeString([NSString stringWithFormat:@"%@", userDict[@"member"]]);//
        self.memberImg.frame = CGRectMake(_nickNameLabel.right+15, _nickNameLabel.top+_nickNameLabel.height*0.5-6.5, 20, 13);
        [self.headerBgView addSubview:self.memberImg];
        
        if ([member isEqualToString:@"1"]) {
            
            _memberImg.hidden = NO;
            _nickNameLabel.textColor = [UIColor colorForHex:kLikeRedColor];
            
            
        }else
        {
            _nickNameLabel.textColor = [UIColor blackColor];
            self.memberImg.hidden = YES;
        }

        
        //vip标识
        NSString *vip = [NSString stringWithFormat:@"%@", userDict[@"vip"]];//
        if ([vip isEqualToString:@"1"]) {
            self.vipImg.hidden = NO;
        }else
        {
            self.vipImg.hidden = YES;
        }
        //照片uid
        photoUid = diction[@"info"][@"uid"];
        self.photoId = diction[@"info"][@"id"];
        NSString *vgoodCount = diction[@"info"][@"goodsCount"];
        if (!vgoodCount) {
            [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(0)"] forState:UIControlStateNormal];
        }else{
            [_privateBtn setTitle:[NSString stringWithFormat: @" 礼物(%@)",vgoodCount] forState:UIControlStateNormal];
        }
        
//#pragma mark 有套系图片
//        NSLog(@"%@",diction);
//        
//        [self.taoxiPriceLabel removeFromSuperview];
//        //判断是否为套系专题图片，若有则显示
//        NSString *zhuantiPic = getSafeString(diction[@"info"][@"object_parent_type"]);
//        self.taoxiPriceLabel = [[UILabel alloc]init];
//        _taoxiPriceLabel.textColor = [UIColor colorForHex:kLikeRedColor];
//        _taoxiPriceLabel.font = [UIFont systemFontOfSize:13];
//        NSLog(@"%@",diction);
//        if (zhuantiPic.length>0) {
//            _taoxiPriceLabel.text = [NSString stringWithFormat:@"价格%@",getSafeString(diction[@"info"][@"price"])];
//            [_taoxiPriceLabel sizeToFit];
//            
//            _taoxiPriceLabel.frame = CGRectMake(_privateBtn.left-_taoxiPriceLabel.width+10*kDeviceWidth/375, _privateBtn.top, _taoxiPriceLabel.width, _privateBtn.height);
//            [self.buttonsView addSubview:_taoxiPriceLabel];
//            
//        }
        
        //显示地址
        _infoPonLabel.text = [NSString stringWithFormat:@"%@%@ ",userDict[@"provinceName"],userDict[@"cityName"]];
        
        /*图片信息*/
        id data = diction[@"info"];
        if ([data isKindOfClass:[NSDictionary class]]) {
            NSDictionary *photoDict = data;
            
            //获取图片视图的size
            CGSize size = [McFeedTableViewCell getPictureViewSize:photoDict];
            _currentPhotoHeight = size.height;
            float height = size.height;
            float wid = size.width;
            
            //文字内容
            CGRect picInfoRect = CGRectMake(64, 60, 0, 0);
            
            NSString *detail = [NSString stringWithFormat:@"%@",getSafeString(photoDict[@"title"])];
            if ([detail isEqualToString:@"0"]) {
                detail = @"";
            }
            NSLog(@"%@",detail);
            if (detail && detail.length > 0) {
                picInfoRect = _picInfoLabel.frame;
                
                CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
                
                picInfoRect.size = detailSize;
                _picInfoLabel.frame = picInfoRect;
            }
            _picInfoLabel.text = detail;
            _picInfoLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
            [_picInfoLabel sizeToFit];
            
            //显示图片
            CGRect urlFrame = _picImageView.frame;
            urlFrame.origin.x = kPhotoOrignX;
            urlFrame.origin.y = 70 + picInfoRect.size.height;
            NSLog(@"%f",urlFrame.origin.y);
            urlFrame.size.width = wid;
            urlFrame.size.height = height;
            _picImageView.frame = urlFrame;
            
            NSString *url = [NSString stringWithFormat:@"%@%@",photoDict[@"url"],[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
            NSString *feedType = getSafeString(photoDict[@"feedType"]);
            _object_type = getSafeString(feedType);
            //区别视频类型
            if ([feedType isEqualToString:@"11"]) {
                url = [NSString stringWithFormat:@"%@%@",photoDict[@"cover_url"],[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
            }
            NSString *newUrl = [NSString stringWithFormat:@"%@%@",url,[USER_DEFAULT objectForKey:@"pic_postfix"]];
            NSString *urlStr = [CommonUtils appendPostfix:newUrl];
            UIImage *pickImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
            if (pickImage) {
                
                _picImageView.image = pickImage;
                
            }else{
                
                [_picImageView setImageWithURL:[NSURL URLWithString:urlStr] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            }
            
            //显示时间
            CGRect bottowFrame = _bottomView.frame;
            bottowFrame.origin.y = CGRectGetMaxY(_picImageView.frame);
            CGRect createFrame = _createTimeLab.frame;
            createFrame.origin.x = 60;
            _createTimeLab.frame = createFrame;
            _createTimeLab.text = [CommonUtils dateTimeIntervalString:diction[@"createline"]];
            //附近秀显示距离
            if (near) {
                CGRect farRect = createFrame;
                farRect.origin.x = 120;
                _nearFarLab.frame = farRect;
                
                @try {
                    _nearFarLab.text = [NSString stringWithFormat:@"%@",getSafeString(diction[@"distance"])];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception.name);
                }
                @finally {
                    
                }
            }
            //点赞的人头像
            float userHeight = [self setShowUsers:photoDict[@"likeusers"]];;
            _likeUsersArr = [NSMutableArray arrayWithArray:photoDict[@"likeusers"]];
            
            bottowFrame.size.height = 110 - 40 + userHeight;
            _bottomView.frame = bottowFrame;
            
            isLike = [photoDict[@"islike"] boolValue];
            [self likeButtonHighlight:isLike];
            
            isSave = [photoDict[@"isfavorite"] boolValue];
            [self saveButtonHighlight:isSave];
            
        
            float tableHei = 0;
            NSArray *commentsArr = diction[@"info"][@"comments"];
            //计算评论表视高度
            if ([commentsArr count] > 5) {
                for (int i = 0; i < 5; i ++) {
                    CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:commentsArr[i] WidthValue:_commentTableView.width];
                    tableHei += (tempH +2);
                }
                //加上了更多的单元格高度
                tableHei += 20;
            }else{
                for (int i = 0; i < [commentsArr count]; i++) {
                    CGFloat tempH = [McFeedTableViewCell getAttributedStrHeight:commentsArr[i] WidthValue:_commentTableView.width];
                    tableHei += (tempH+2);
                }
            }
            
            //评论表视图
            _commentTableView.frame = CGRectMake(17, CGRectGetMaxY(_bottomView.frame), self.width -10-17, tableHei);
            //            self.commentTableView.backgroundColor = [UIColor purpleColor];
            
            //记录评论表视图数据
            NSLog(@"%@",photoDict);
            if ([photoDict[@"commentcount"] integerValue]> 0) {
                if (!_commentArray) {
                    _commentArray = [NSMutableArray array];
                }
                [_commentArray removeAllObjects];
                _commentArray = [NSMutableArray arrayWithArray:photoDict[@"comments"]];
                trueCommentcount = [photoDict[@"commentcount"] intValue];
                [self.commentTableView reloadData];
            }
#ifdef TencentRelease
            
//            if(self.player.playbackState == MPMoviePlaybackStatePlaying)
//            {
//                [self removePlayer];
//                
//            }
            [self removePlayer];

            if([feedType isEqualToString:@"11"])
            {
//                _picInfoLabel.text = @"";
                if (!self.playVideoButton) {
                    self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    
                }
                self.video_picImageView.hidden = YES;
                [self.playVideoButton setHidden:NO];

                [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
                [self.playVideoButton setFrame:_picImageView.frame];
                [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
                [self addSubview:self.playVideoButton];
                [self bringSubviewToFront:self.playVideoButton];
                if (self.currentIndex==self.playedIndex) {
                    [self removePlayer];
                    for (int i=0; i<[UploadVideoManager sharedInstance].playerFullButtonArray.count; i++) {
                        UIButton *full = [UploadVideoManager sharedInstance].playerFullButtonArray[i];
                        if (full==self.playVideoButton_full) {
                            
                        }else
                        {
                            [full removeFromSuperview];
                            
                        }
                    }
                }
                
            }else
            {
                [self.playVideoButton setHidden:YES];
                [self.playVideoButton removeFromSuperview];
                [self.playVideoButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];

            }
            
#else
            
            
            
#endif
            //数组形式的数据的处理
        }else if([data isKindOfClass:[NSArray class]])
        {
            NSArray *arr = diction[@"info"];
            if (arr.count>0) {
                NSDictionary *photoDict = arr[0];
                
                float height = kPhotoHeight;
                float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
                float wid;
                if ([photoDict[@"height"] integerValue] > 0) {
                    wid = [diction[@"info"][@"width"] floatValue] * height /[diction[@"info"][@"height"] floatValue] ;
                    
                    wid = MIN(wid, width);
                    //                    height = [diction[@"info"][@"height"] floatValue] * wid / [diction[@"info"][@"width"] floatValue];
                }
                CGRect urlFrame = _picImageView.frame;
                urlFrame.origin.x = kPhotoOrignX;
                urlFrame.size.width = wid;
                urlFrame.size.height = height;
                _picImageView.frame = urlFrame;
                
                NSString *url = [NSString stringWithFormat:@"%@%@",photoDict[@"url"],[CommonUtils imageStringWithWidth:wid * 2 height:height * 2]];
                url = [CommonUtils appendPostfix:url];
                UIImage *pickImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
                if (pickImage) {
                    _picImageView.image = pickImage;
                }else{
                    [_picImageView setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                }
                
                CGRect bottowFrame = _bottomView.frame;
                bottowFrame.origin.y = CGRectGetMaxY(_picImageView.frame);
                CGRect picInfoRect = CGRectMake(64, 60, 0, 0);
                NSString *detail = photoDict[@"title"];
                if (detail && detail.length > 0) {
                    picInfoRect = _picInfoLabel.frame;
                    CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
                    picInfoRect.size = detailSize;
                }
                _picInfoLabel.frame = picInfoRect;
                _picInfoLabel.text = photoDict[@"title"];
                
                [_picInfoLabel sizeToFit];
                CGRect createFrame = _createTimeLab.frame;
                createFrame.origin.x = 60;
                _createTimeLab.frame = createFrame;
                _createTimeLab.text = [CommonUtils dateTimeIntervalString:diction[@"createline"]];
                
                float userHeight = [self setShowUsers:photoDict[@"likeusers"]];;
                
                bottowFrame.size.height = 110 - 40 + userHeight;
                _bottomView.frame = bottowFrame;
                
                
                isLike = [photoDict[@"islike"] boolValue];
                [self likeButtonHighlight:isLike];
                
                isSave = [photoDict[@"isfavorite"] boolValue];
                [self saveButtonHighlight:isSave];
                
                float tableHei = 2;
                width = self.commentTableView.width;
                NSArray *commentsArr = diction[@"info"][@"comments"];
                if ([diction[@"info"][@"comments"] count] > 3) {
                    for (int i = 0; i < 5; i ++) {
                        NSString *tempStr = commentsArr[i][@"content"];
                        CGSize strSize = [CommonUtils sizeFromText:tempStr textFont:[UIFont systemFontOfSize:12] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, MAXFLOAT)];
                        tableHei += strSize.height + 2;
                    }
                    tableHei += 20;
                }else{
                    for (int i = 0; i < [diction[@"info"][@"comments"] count]; i++) {
                        NSString *tempStr = commentsArr[i][@"content"];
                        CGSize strSize = [CommonUtils sizeFromText:tempStr textFont:[UIFont systemFontOfSize:12] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(width, MAXFLOAT)];
                        tableHei += strSize.height + 2;
                    }
                }
                CGRect tableFrame = _commentTableView.frame;
                tableFrame.origin.y = CGRectGetMaxY(_bottomView.frame);
                tableFrame.size.height = tableHei;
                _commentTableView.frame = tableFrame;
                
                
                //commentcount  comments setItemValueWithDict
                if ([photoDict[@"commentcount"] integerValue]> 0) {
                    if (!_commentArray) {
                        _commentArray = [NSMutableArray arrayWithCapacity:[photoDict[@"commentcount"] integerValue]];
                    }
                    [_commentArray removeAllObjects];
                    _commentArray = [NSMutableArray arrayWithArray:photoDict[@"comments"]];
                    trueCommentcount = [photoDict[@"commentcount"] intValue];
                    [self.commentTableView reloadData];
                }
                NSString *feedType = getSafeString(photoDict[@"feedType"]);
                
#ifdef TencentRelease
                
                if([feedType isEqualToString:@"11"])
                {
//                    _picInfoLabel.text = @"";
                    if (!self.playVideoButton) {
                        self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
                    }
                    [self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
                    [self.playVideoButton setFrame:_picImageView.frame];
                    [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
                    [self addSubview:self.playVideoButton];
                    [self bringSubviewToFront:self.playVideoButton];
                    
                }
                
#else
                
                
                
#endif
                
            }
            
        }//数组
        
    }
    
}
#pragma mark - getHeight
//热门动态||附近动态
+ (float)getCellHeight:(NSDictionary *)diction
{
    float headerHeight = 80;
    float width = kDeviceWidth -17-10;
    float commentHeight = 0;
    //float imageHeight = kPhotoHeight;
    NSLog(@"%@",diction);
    CGSize size = [McFeedTableViewCell getPictureViewSize:diction[@"info"]];
    float imageHeight = size.height;

    float userHeight = 0;
    float titleHeight = 0;
    float controllerHeight = 60;
    NSArray *arr = diction[@"info"];
    if (arr.count>0) {
        NSString *detail = getSafeString(diction[@"info"][@"title"]);
        if ([detail isEqualToString:@"0"]) {
            detail = @"";
        }
        CGRect picInfoRect = CGRectMake(64, 60, 0, 0);
        if (detail && detail.length > 0) {
            CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
            picInfoRect.size = detailSize;
            titleHeight = picInfoRect.size.height;
        }
        
        if ([diction[@"info"][@"likeusers"] count] > 0) {
            userHeight = 40;
        }
        CGRect bottowFrame = CGRectZero;
        bottowFrame.size.height = 110 - 40 + userHeight;
        
        
        float tableHei = 0;
        NSArray *commentsArr = diction[@"info"][@"comments"];
        if (commentsArr == nil) {
            commentsArr = diction[@"comments"];
        }
        //计算评论表视高度
        if ([commentsArr count] > 5) {
            for (int i = 0; i < 5; i ++) {
                //创建富文本并且计算高度
                CGFloat tempH = [self getAttributedStrHeight:commentsArr[i] WidthValue:width];
                tableHei += (tempH +2);
            }
            //加上了更多的单元格高度
            tableHei += 20;
        }else{
            for (int i = 0; i < [diction[@"info"][@"comments"] count]; i++) {
                CGFloat tempH = [self getAttributedStrHeight:commentsArr[i] WidthValue:width];
                tableHei += (tempH+2);
            }
        }
        commentHeight = tableHei;
    }
    return imageHeight + userHeight + titleHeight + commentHeight +headerHeight + controllerHeight;
}


//关注动态
+ (float)getCellHeight_mine:(NSDictionary *)diction
{
    float headerHeight = 80;
    //float imageHeight = kPhotoHeight;
    CGSize size = [McFeedTableViewCell getPictureViewSize:diction];
    float imageHeight = size.height;
    
    float width = kDeviceWidth -17 - 10;
    float titleHeight = 0;
    float userHeight = 0;
    float controlerHeight = 60;
    float commentHeight = 0;
    
    if ([diction isKindOfClass:[NSDictionary class]]) {
        NSString *detail = [NSString stringWithFormat:@"%@",getSafeString(diction[@"title"])];
        if ([detail isEqualToString:@"0"]) {
            detail = @"";
        }
        if (detail && detail.length > 0) {
            CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
            titleHeight = detailSize.height;
        }
        if ([diction[@"likeusers"] count] > 0) {
            userHeight = 40;
        }
        
        //表视图高度
        float tableHei = 0;
        NSArray *commentsArr = diction[@"comments"];
        //计算评论表视高度
        if ([diction[@"comments"] count] > 5) {
            for (int i = 0; i < 5; i ++) {
                //创建富文本并且计算高度
                CGFloat tempH = [self getAttributedStrHeight:commentsArr[i] WidthValue:width];
                tableHei += (tempH +2);
            }
            //加上了更多的单元格高度
            tableHei += 20;
        }else{
            for (int i = 0; i < [diction[@"comments"] count]; i++) {
                CGFloat tempH = [self getAttributedStrHeight:commentsArr[i] WidthValue:width];
                tableHei += (tempH+2);
            }
        }
        commentHeight = tableHei;
    }
    return imageHeight + userHeight + controlerHeight + titleHeight + commentHeight + headerHeight;
}


//个人动态
+(float)getCellHeight_person:(NSDictionary *)diction{
    float headerHeight = 80;
    //float imageHeight = kPhotoHeight;
    CGSize size = [McFeedTableViewCell getPictureViewSize:diction];
    float imageHeight = size.height;

    //float width = kDeviceWidth -17 - 10;
    float titleHeight = 0;
    float userHeight = 0;
    float controlerHeight = 60;
    //float commentHeight = 0;
    
    if ([diction isKindOfClass:[NSDictionary class]]) {
        NSString *detail = [NSString stringWithFormat:@"%@",getSafeString(diction[@"title"])];
        if ([detail isEqualToString:@"0"]) {
            detail = @"";
        }
        if (detail && detail.length > 0) {
            CGSize detailSize = [CommonUtils sizeFromText:detail textFont:[UIFont systemFontOfSize:15] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 75, MAXFLOAT)];
            titleHeight = detailSize.height;
        }
        if ([diction[@"likeusers"] count] > 0) {
            userHeight = 40;
        }
    }
    return userHeight + headerHeight + imageHeight + titleHeight + controlerHeight;
}

- (float)setShowUsers:(NSArray *)users
{
    while ([_likeUsersView.subviews count] != 0) {
        [[_likeUsersView.subviews lastObject]removeFromSuperview];
    }
    
    if ([users count] > 0) {
        float hei = 40;
        float x = 8;
        float tap = 5;
        float y = 0;
        float w = 25;
        
        int i = 0;
        float orginX = 0;
        float originY = 0;
        NSMutableArray *arrView = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in users) {
            NSString *headpic = dict[@"head_pic"];
            NSString *jpgL = [CommonUtils imageStringWithWidth:25 * 2 height:25 * 2];
            NSString *urlLogo = [NSString stringWithFormat:@"%@%@",headpic,jpgL];
            orginX = (tap + w) * i + x;
            originY = y;
            if (orginX < kScreenWidth - 110) {
                UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(orginX, y, 25, 25)];
                [headView setImageWithURL:[NSURL URLWithString:urlLogo] placeholderImage:[UIImage imageNamed:@"head.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                
                headView.layer.cornerRadius = 5;
                headView.clipsToBounds = YES;
                headView.backgroundColor = [UIColor lightGrayColor];
                [_likeUsersView addSubview:headView];
                [arrView addObject:headView];
                
                UIButton *imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                imgBtn.frame = headView.frame;
                imgBtn.tag = [dict[@"id"] integerValue];
                [imgBtn addTarget:self action:@selector(doLookPersonnal:) forControlEvents:UIControlEventTouchUpInside];
                [_likeUsersView addSubview:imgBtn];
                
                i++;
            }
            else{
                break;
            }
        }
        
        
        float ox = orginX + 35;
        if (orginX >= kScreenWidth - 70) {
            ox = orginX;
        }
        
        UIButton *_signListBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signListBtn.frame = CGRectMake(ox, originY, 25, 25);
        _signListBtn.layer.cornerRadius = 5;
        _signListBtn.clipsToBounds = YES;
        [_signListBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _signListBtn.titleLabel.font = kFont11;
        //        _signListBtn.layer.cornerRadius = 12;
        _signListBtn.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
        if ([arrView count] < [users count]) {
            [_signListBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)users.count] forState:UIControlStateNormal];
            [_signListBtn addTarget:self action:@selector(doShowList:) forControlEvents:UIControlEventTouchUpInside];
        }
        else{
            [_signListBtn setTitle:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[users count]]] forState:UIControlStateNormal];
        }
        
        [_likeUsersView addSubview:_signListBtn];
        
        _likeUsersView.hidden = NO;
        _likeUsersView.frame = CGRectMake(_likeBtn.left, CGRectGetMaxY(_buttonsView.frame) + 5, CGRectGetWidth(self.frame) - _likeBtn.left - 5, hei);
        return hei;
    }
    _likeUsersView.hidden = YES;
    _likeUsersView.frame = CGRectMake(0, CGRectGetMaxY(_buttonsView.frame) + 0, CGRectGetWidth(self.frame), 0);
    return 0;
}

- (void)likeButtonHighlight:(BOOL)isHigh
{
    if (isHigh) {
        [_likeBtn setImage:[UIImage imageNamed:@"zannew2"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        //        _likeBtn.layer.borderColor = [UIColor colorForHex:kLikeRedColor].CGColor;
        
    }
    else{
        [_likeBtn setImage:[UIImage imageNamed:@"zangray"] forState:UIControlStateNormal];
        [_likeBtn setTitleColor:[UIColor colorForHex:kLikeGrayColor] forState:UIControlStateNormal];
        //        _likeBtn.layer.borderColor = [UIColor colorForHex:kLikeGrayColor].CGColor;
    }
}

- (void)saveButtonHighlight:(BOOL)isHigh
{
    if (isHigh) {
        [_privateBtn setImage:[UIImage imageNamed:@"dashang"] forState:UIControlStateNormal];
        [_privateBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        //        _privateBtn.layer.borderColor = [UIColor colorForHex:kLikeRedColor].CGColor;
    }
    else{
        [_privateBtn setImage:[UIImage imageNamed:@"dashang"] forState:UIControlStateNormal];
        [_privateBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        //        _privateBtn.layer.borderColor = [UIColor colorForHex:kLikeGrayColor].CGColor;
    }
}

#pragma mark Action
- (void)doShowList:(id)sender
{
    
}

- (void)doLookPersonnal:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *uid = [NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:btn.tag]];
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:@{@"user":@{@"id":uid}}];
    }
}

- (IBAction)juBaoMethod:(id)sender {
    NSLog(@"jubaoOrDelegate");
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
        NSString *uidStr = getSafeString(_itemDict[@"user"][@"id"]);
        if (uidStr == nil ||uidStr.length == 0) {
            uidStr = _itemDict[@"uid"];
        }
        NSString *uid = getSafeString([[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]);
        if ([uid isEqualToString:uidStr]) {
            //deleate
            //热门动态无法删除
            [self.cellDelegate doTouchUpInsideWithItem:_itemDict status:101];
        }
        else{
            //举报
            [self.cellDelegate doTouchUpInsideWithItem:_itemDict status:100];
        }
    }
}


- (IBAction)jumpPersonCenterAction:(id)sender
{
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doJumpPersonCenter:)]) {
        [self.cellDelegate doJumpPersonCenter:self.itemDict];
    }
}


- (IBAction)doTouchAction:(id)sender
{
    
    UIButton *btn = (UIButton *)sender;
//    NSLog(@"%@",self.itemDict);
    if (btn.tag == 3) {
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
//            NSLog(@"%@",_itemDict);
            [self.cellDelegate doTouchUpInsideWithItem:self.itemDict status:btn.tag];
            
        }
        
    }
    else if (btn.tag == 1){
        if (isLike) {
            [self cancelLike];
        }
        else{
            [self addLike];
        }
    }
    else if (btn.tag == 2){
        
        NSLog(@"点击了礼物btn");

        NSString *uid = getSafeString([[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]);
     
        //点击礼物
        if ([photoUid isEqualToString:uid]) {
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
                [self.cellDelegate doTouchUpInsideWithItem:self.itemDict status:3];
                return;
            }
        }
        
        if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(doTouchUpInsideWithItem:status:)]) {
            [self.cellDelegate doJumpDaShangView:self.itemDict];

            [self viewForAnimation];
            
        }
        //        if (isSave) {
        //            [self cancelSave];
        //        }
        //        else{
        //            [self addSave];
        //        }
    }
    
}

- (BOOL)isRightKey:(NSString *)string
{
    if (string==nil||string.length==0) {
        return NO;
    }else
    {
        return YES;
    }
}

- (void)addLike
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.selfCon];
        
        [LeafNotification showInController:self.selfCon withText:@"请先登录"];
        return;
    }
    
    NSString *photoId = getSafeString(_itemDict[@"id"]);
    if (![self isRightKey:photoId]) {
        photoId = getSafeString(_itemDict[@"info"][@"id"]);
    }
    _object_type = getSafeString(_itemDict[@"feedType"]);
    if (![self isRightKey:_object_type]) {
        _object_type = getSafeString(_itemDict[@"info"][@"feedType"]);
    }
    NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:_object_type];
//    NSLog(@"%@",dict);
    isLike = YES;

    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_itemDict];
    
    if (mutDict[@"info"]) {
        NSMutableDictionary *photoDict = [NSMutableDictionary dictionaryWithDictionary:mutDict[@"info"]];
        
        [photoDict setValue:@"1" forKey:@"islike"];
        NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
        //热门
        NSMutableArray *likeUsers = [NSMutableArray arrayWithArray:photoDict[@"likeusers"]];
        
        NSMutableDictionary *likeDic = [NSMutableDictionary dictionary];
        
        [likeDic setObject:uid forKey:@"id"];
        [likeDic setObject:headerURL forKey:@"head_pic"];
//        [likeUsers addObject:likeDic];
        NSMutableArray *newArr = [NSMutableArray arrayWithObject:likeDic];
        [newArr addObjectsFromArray:likeUsers];
        [photoDict setValue:newArr forKey:@"likeusers"];
        [mutDict setValue:photoDict forKey:@"info"];
    }else{
        
        [mutDict setValue:@"1" forKey:@"islike"];
        NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
        //热门
        NSMutableArray *likeUsers = [NSMutableArray arrayWithArray:mutDict[@"likeusers"]];
        
        NSMutableDictionary *likeDic = [NSMutableDictionary dictionary];
        
        [likeDic setObject:uid forKey:@"id"];
        [likeDic setObject:headerURL forKey:@"head_pic"];
//        [likeUsers addObject:likeDic];
        NSMutableArray *newArr = [NSMutableArray arrayWithObject:likeDic];
        [newArr addObjectsFromArray:likeUsers];
        
        [mutDict setValue:newArr forKey:@"likeusers"];

    }
    
    
    
//    //关注
//    [mutDict setValue:@"1" forKey:@"islike"];
//    NSMutableArray *guanzhuLikeArr = [NSMutableArray arrayWithArray:[mutDict objectForKey:@"likeusers"]];
//    [guanzhuLikeArr addObject:likeDic];
//    [mutDict setValue:guanzhuLikeArr forKey:@"likeusers"];

    

    [self likeButtonHighlight:isLike];

    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDoneWithItem:message:isReload:)]) {
        [self.cellDelegate actionDoneWithItem:mutDict message:@"" isReload:YES];
    }

    [AFNetwork likeAdd:dict success:^(id data){
//        NSLog(@"data:%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            
            
        }else if ([data[@"status"] integerValue] == 1){

            [LeafNotification showInController:self.selfCon withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self.selfCon withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        NSLog(@"%@",error);
    }];
}

- (void)cancelLike
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.selfCon];
        
        return;
    }
//    for (NSDictionary *dic in _likeUsersArr) {
//        if (uid == dic[@"id"]) {
//            [_likeUsersArr removeObject:dic];
//            [self setShowUsers:_likeUsersArr];
//            break;
//        }
//    }
    
    
    NSString *photoId = getSafeString(_itemDict[@"id"]);
    if (![self isRightKey:photoId]) {
        photoId = getSafeString(_itemDict[@"info"][@"id"]);
    }
    _object_type = getSafeString(_itemDict[@"feedType"]);
    if (![self isRightKey:_object_type]) {
        _object_type = getSafeString(_itemDict[@"info"][@"feedType"]);
    }
    
    NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:_object_type];
    isLike = NO;

    
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_itemDict];
    
    if (mutDict[@"info"]) {
        //热门
        NSMutableDictionary *photoDict = [NSMutableDictionary dictionaryWithDictionary:mutDict[@"info"]];
        [photoDict setValue:@"0" forKey:@"islike"];
        NSMutableArray *likeUser = [NSMutableArray arrayWithArray:mutDict[@"info"][@"likeusers"]];
        for (NSDictionary *dic in likeUser) {
            if ([dic[@"id"] intValue] == [uid intValue]) {
                [likeUser removeObject:dic];
                break;
            }
        }
        [photoDict setValue:likeUser forKey:@"likeusers"];
        [mutDict setValue:photoDict forKey:@"info"];
    }else{
        
        [mutDict setValue:@"0" forKey:@"islike"];
        NSMutableArray *likeUser = [NSMutableArray arrayWithArray:mutDict[@"likeusers"]];
        for (NSDictionary *dic in likeUser){
            if ([dic[@"id"] intValue] == [uid intValue]) {
                [likeUser removeObject:dic];
                break;
            }
        }
        [mutDict setValue:likeUser forKey:@"likeusers"];
    }
    

//    //关注
//    [mutDict setValue:@"0" forKey:@"islike"];
//    NSMutableArray *guanzhuLikeUser = [NSMutableArray arrayWithArray:mutDict[@"likeusers"]];
//    for (NSDictionary *dic in guanzhuLikeUser) {
//        if ([dic[@"id"] intValue]== [uid intValue]) {
//            [guanzhuLikeUser removeObject:dic];
//            break;
//        }
//    }
//    [mutDict setValue:guanzhuLikeUser forKey:@"likeusers"];
    
    _itemDict = mutDict;
    
    [self likeButtonHighlight:isLike];
//    NSLog(@"%@",_itemDict);
    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDoneWithItem:message:isReload:)]) {
        
        [self.cellDelegate actionDoneWithItem:_itemDict message:@"" isReload:YES];

        
    }
    
    [AFNetwork likeCancel:dict success:^(id data){
//        NSLog(@"data:%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            
        }else if ([data[@"status"] integerValue] == 1){
            NSLog(@"\n\n");
            NSLog(@"%@",data[@"msg"]);
        }
        
    }failed:^(NSError *error){
        NSLog(@"\n\n");
        NSLog(@"%@",error.description);
        NSLog(@"failed");
        
    }];
}

- (void)addSave
{
    //favoriteAdd
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.selfCon];
        
        return;
    }
    NSString *photoId = getSafeString(_itemDict[@"id"]);
    if (![self isRightKey:photoId]) {
        photoId = getSafeString(_itemDict[@"info"][@"id"]);
    }
   
    NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:_object_type];
    [AFNetwork favoriteAdd:dict success:^(id data){
//        NSLog(@"data:%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            isSave = YES;
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_itemDict];
            NSMutableDictionary *photoDict = [NSMutableDictionary dictionaryWithDictionary:mutDict[@"info"]];
            [photoDict setValue:@"1" forKey:@"isfavorite"];
            [mutDict setValue:photoDict forKey:@"info"];
//            _itemDict = mutDict;
            [self saveButtonHighlight:isSave];
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDoneWithItem:message:isReload:)]) {
                [self.cellDelegate actionDoneWithItem:mutDict message:@"收藏成功" isReload:YES];
            }
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)cancelSave
{
    //favoriteCancel
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (!uid) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.selfCon];
        
        return;
    }
    NSString *photoId = getSafeString(_itemDict[@"id"]);
    if (![self isRightKey:photoId]) {
        photoId = getSafeString(_itemDict[@"info"][@"id"]);
    }
    
    NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid objectType:_object_type];
    [AFNetwork favoriteCancel:dict success:^(id data){
//        NSLog(@"data:%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            
            isSave = NO;
            NSMutableDictionary *mutDict = [NSMutableDictionary dictionaryWithDictionary:_itemDict];
            NSMutableDictionary *photoDict = [NSMutableDictionary dictionaryWithDictionary:mutDict[@"info"]];
            [photoDict setValue:@"1" forKey:@"isfavorite"];
            [mutDict setValue:photoDict forKey:@"info"];
//            _itemDict = mutDict;
            [self saveButtonHighlight:isSave];
            
            if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDoneWithItem:message:isReload:)]) {
                [self.cellDelegate actionDoneWithItem:mutDict message:@"取消收藏成功" isReload:YES];
            }
            
        }
    }failed:^(NSError *error){
        
    }];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_commentArray.count<6) {
        return _commentArray.count;
    }else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"McCommentTableViewCell";
    McSmallCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [McSmallCommentTableViewCell getFeedCommentCell];
    }
    cell.tableViewWidth = self.commentTableView.width;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *dict = [_commentArray objectAtIndex:indexPath.row];
    
    cell.headNameBtn.tag = indexPath.row;
    [cell.headNameBtn addTarget:self action:@selector(doTouchCommentNameAction:) forControlEvents:UIControlEventTouchUpInside];
    //    [cell setItemValueWithDict:dict];
    cell.dict = dict;
    //点击查看更多
    if (indexPath.row == 5) {
        MoreTableViewCell *moreCell = [MoreTableViewCell getMoreTableViewCell];
        [moreCell initWithInt:trueCommentcount];
        moreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        //moreCell.backgroundColor = [UIColor redColor];
        return moreCell;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==5) {
        //返回一个显示加载更多的单元格高度
        return 20;
    }
    //评论信息字典
    NSDictionary *dict = [_commentArray objectAtIndex:indexPath.row];
    //构建富文本对象
    NSAttributedString *aString = [self getAttributedString:dict];
    CGFloat tempH = [self getAttributedStringHeightWithString:aString WidthValue:_commentTableView.width];
   // tempH = [self getAttributedStrHeight:dict WidthValue:_commentTableView.width];
    tempH = [McFeedTableViewCell getAttributedStrHeight:dict WidthValue:_commentTableView.width];

    return tempH+2;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSDictionary *dict = [_commentArray objectAtIndex:indexPath.row];
    //    if (self.cellDelegate && [self .cellDelegate respondsToSelector:@selector(doJumpType:fromCommentDict:)]) {
    //        [self.cellDelegate doJumpType:0 fromCommentDict:dict];
    //    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"doCommitAction" object:_itemDict];
    
}

#pragma mark 获取礼物信息
//获取打赏界面礼物列表信息
- (void)getServiceData{
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (!cuid) {
        return;
    }else{
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
        [AFNetwork postRequeatDataParams:params path:PathUserWalletVgoods success:^(id data){
//            NSLog(@"%@",data);
            if ([data[@"status"] integerValue] == kRight) {
                NSMutableArray *arr = data[@"data"];
                
                UIImageView *imgView = [[UIImageView alloc]init];
                
                NSString *jpg = [CommonUtils PngImageStringWithWidth:200 height:200];
                for (int i = 0; i<arr.count; i++) {
                    NSString *url = [NSString stringWithFormat:@"%@%@",arr[i][@"vgoods_img"],jpg];
                    
                    [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        
                        [self.bigImgArr addObject:image];
                        
                    }];
                }
                
            }
            else if([data[@"status"] integerValue] == kReLogin){
                
            }
            
        }failed:^(NSError *error){
            
            
        }];
    }
    
}

#pragma mark - 评论头像跳转
- (void)doTouchCommentNameAction:(id)sender
{
    if (self.cellDelegate && [self .cellDelegate respondsToSelector:@selector(doJumpType:fromCommentDict:)]) {
        //热门动态
        if (_isHot) {
            UIButton *btn = (UIButton *)sender;
            NSLog(@"%ld",(long)btn.tag);
//            NSLog(@"%@",_itemDict);
            NSString *photoId = getSafeString(_itemDict[@"id"]);
            if (![self isRightKey:photoId]) {
                [self.cellDelegate doJumpType:1 fromCommentDict:_itemDict[@"info"][@"comments"][btn.tag]];
            }else
            {
                [self.cellDelegate doJumpType:1 fromCommentDict:_itemDict[@"comments"][btn.tag]];

            }
           
            
            
            
            //关注动态
        }else{
            UIButton *btn = (UIButton *)sender;
            NSLog(@"%ld",(long)btn.tag);
            NSDictionary *userDic = _itemDict[@"comments"][btn.tag];
            if (userDic) {
                [self.cellDelegate doJumpType:1 fromCommentDict:userDic];
            }else
            {
                [self.cellDelegate doJumpType:1 fromCommentDict:_itemDict[@"info"][@"comments"][btn.tag]];
            }
        }
    }
}


#pragma mark 处理富文本
//获取一个富文本
- (NSAttributedString *)getAttributedString:(NSDictionary *)dict{
    
    NSString *name = dict[@"nickname"];
    NSString *content =  getSafeString(dict[@"content"]);

    //完整字符串
    NSString *allString = [NSString stringWithFormat:@"%@ : %@",name,content];
    NSRange nameRange = [allString rangeOfString:name];
    NSRange contentRange = [allString rangeOfString:content];
    
    //创建富文本
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc] initWithString:allString attributes:nil];
    
    //昵称的属性
    NSMutableParagraphStyle *paraStyle01 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByClipping;//不断行
    NSDictionary *nickAttrDict = @{NSParagraphStyleAttributeName: paraStyle01,
                                   NSFontAttributeName: [UIFont systemFontOfSize: 14],NSForegroundColorAttributeName:[UIColor colorForHex:kLikeGrayColor]};
    //评论内容的属性
    NSMutableParagraphStyle *paraStyle02 = [[NSMutableParagraphStyle alloc] init];
    paraStyle01.lineBreakMode = NSLineBreakByCharWrapping;//断行
    NSDictionary *conetentAttrDict = @{NSParagraphStyleAttributeName: paraStyle02,
                                       NSFontAttributeName: [UIFont systemFontOfSize: 14],NSForegroundColorAttributeName:[UIColor colorForHex:kLikeGrayTextColor]};
    //设置属性
    [attributedString setAttributes:nickAttrDict range:nameRange];
    [attributedString setAttributes:conetentAttrDict range:contentRange];
    
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont boldSystemFontOfSize:14] range:nameRange];
    [attributedString addAttribute:(NSString *)kCTFontAttributeName value:(id)[UIFont systemFontOfSize:14] range:contentRange];
    
    return attributedString;
}



//- (CGFloat)getAttributedStrHeight:(NSDictionary *)dict WidthValue:(CGFloat) width{
//    NSString *name = dict[@"nickname"];
//    NSRange enterName = [name rangeOfString:@"\n"];
//    if (enterName.length) {
//        name = [name substringToIndex:enterName.location];
//    }
//    NSString *content = dict[@"content"];
//    //完整字符串
//    NSString *allString = [NSString stringWithFormat:@"%@ :%@",name,content];
//    return [SQCStringUtils getStringHeight:allString width:width font:14];
//    
//}

+ (CGFloat)getAttributedStrHeight:(NSDictionary *)dict WidthValue:(CGFloat) width{
    /*
    NSString *name = dict[@"nickname"];
    if ([name class] == [NSString class]) {
        NSRange enterName = [name rangeOfString:@"\n"];
        if (enterName.length) {
            name = [name substringToIndex:enterName.location];
        }
        NSString *content = dict[@"content"];
        //完整字符串
        NSString *allString = [NSString stringWithFormat:@"%@ :%@",name,content];
        return [SQCStringUtils getStringHeight:allString width:width font:14];
    }
    return 0;
    */
    
    NSString *name = dict[@"nickname"];
    NSRange enterName = [name rangeOfString:@"\n"];
    if (enterName.length) {
        name = [name substringToIndex:enterName.location];
    }
    NSString *content = dict[@"content"];
    //完整字符串
    NSString *allString = [NSString stringWithFormat:@"%@ :%@",name,content];
    return [SQCStringUtils getStringHeight:allString width:width font:14];

}



//返回富文本高度
- (int)getAttributedStringHeightWithString:(NSAttributedString *)  string  WidthValue:(int) width
{
    int total_height = 0;
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)string);
    //string 为要计算高度的NSAttributedString
    CGRect drawingRect = CGRectMake(0, 0, width, 1000);  //这里的高要设置足够大
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawingRect);
    CTFrameRef textFrame = CTFramesetterCreateFrame(framesetter,CFRangeMake(0,0), path, NULL);
    CGPathRelease(path);
    CFRelease(framesetter);
    
    NSArray *linesArray = (NSArray *) CTFrameGetLines(textFrame);
    
    CGPoint origins[[linesArray count]];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0, 0), origins);
    
    int line_y = (int) origins[[linesArray count] -1].y;  //最后一行line的原点y坐标
    
    CGFloat ascent;
    CGFloat descent;
    CGFloat leading;
    
    CTLineRef line = (__bridge CTLineRef) [linesArray objectAtIndex:[linesArray count]-1];
    CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
    total_height = 1000 - line_y + (int) descent +1;    //+1为了纠正descent转换成int小数点后舍去的值
    CFRelease(textFrame);
    return total_height;
}


#pragma mark 获取图片的高度
+ (CGSize)getPictureViewSize:(NSDictionary *)photoDict{
    CGSize size;
    //1.默认高度和宽度
    float height = kPhotoHeight;
    float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
//    NSLog(@"%@",photoDict);
    //2.取出字典的宽高
    CGFloat picH = 0.0;
    CGFloat picW = 0.0;
    if ([photoDict isKindOfClass:[NSDictionary class]]) {
        picH = [photoDict[@"height"] floatValue];
        picW = [photoDict[@"width"] floatValue];
    }
    
    //3.最终的宽和高
    CGFloat realW = 0;
    CGFloat realH = 0;
    
    //安全处理
    if (picH == 0 || picW == 0) {
        picW = width;
        picH = width;
    }
    
    //计算宽高比例
    CGFloat scale = picW/picH;
    if (scale >0.8) {
        realW = width;
        realH = realW *(picH/picW);
    }else{
        //以高为标准得到宽
        realW = height *(picW/picH);
        if (realW > width) {
            //如果比例得到宽大于默认宽，使用默认宽
            realW = width;
        }
        //得到高
        realH = realW *(picH/picW);
    }
    
    size.width = realW;
    size.height = realH;
    //改变当前单元格图片视图高度
    //_currentPhotoHeight = size.height;
    return size;
}


//+ (float)getPictureViewHeight:(NSDictionary *)photoDict{
//    NSLog(@"%@",photoDict);
//    /*
//    CGSize size;
//    //默认高度和宽度
//    float height = kPhotoHeight;
//    float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
//    float wid;
//    
//    //取出字典的宽高
//    CGFloat picH =[photoDict[@"height"] floatValue];
//    CGFloat picW = [photoDict[@"width"] floatValue];
//    
//    //计算比例宽度
//    wid = [photoDict[@"width"] floatValue] * height /[photoDict[@"height"] floatValue] ;
//    if (wid>width) {
//        //大于可显示的宽度
//        wid = width;
//        height = wid *(picH/picW);
//    }
//    size.width = wid;
//    size.height = height;
//    //改变当前单元格图片视图高度
//    return size.height;
//     */
//    CGSize size;
//    //1.默认高度和宽度
//    float height = kPhotoHeight;
//    float width = kScreenWidth - kPhotoOrignX - kPhotoGap;
//    //2.取出字典的宽高
//    CGFloat picH =[photoDict[@"height"] floatValue];
//    CGFloat picW = [photoDict[@"width"] floatValue];
//    //3.最终的宽和高
//    CGFloat realW = 0;
//    CGFloat realH = 0;
//    
//    //安全处理
//    if (picH == 0 || picW == 0) {
//        picW = width;
//        picH = width;
//    }
//    
//    //计算宽高比例
//    CGFloat scale = picW/picH;
//    if (scale >0.8) {
//        realW = width;
//        realH = realW *(picH/picW);
//    }else{
//        //以高为标准得到宽
//        realW = height *(picW/picH);
//        if (realW > width) {
//            //如果比例得到宽大于默认宽，使用默认宽
//            realW = width;
//        }
//        //得到高
//        realH = realW *(picH/picW);
//    }
//    
//    size.width = realW;
//    size.height = realH;
//    //改变当前单元格图片视图高度
//    return size.height;
//
//}
//

@end
