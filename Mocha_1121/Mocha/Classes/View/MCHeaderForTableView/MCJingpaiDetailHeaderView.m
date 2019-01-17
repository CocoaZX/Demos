//
//  MCJingpaiDetailHeaderView.m
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiDetailHeaderView.h"
#import "topViewForJingpaiDetailHeader.h"
#import "MCAnimForVideo.h"
#import <MediaPlayer/MediaPlayer.h>
#import "VideoMaskView.h"
#import "UploadVideoManager.h"


#define KjpDetailFont 14


@interface MCJingpaiDetailHeaderView ()

@property (strong, nonatomic) UIImageView *video_picImageView;
@property (nonatomic,strong) UIImageView *picImgView;
@property (nonatomic,strong) UIImageView *playVideoImage;
@property (nonatomic,strong) UIButton *playVideoFullButton;
@property (nonatomic,strong) UIButton *playBtn;

@property (nonatomic,strong) MCVideoView *bigVideoView;

@property (nonatomic ,assign) BOOL isFull;

@property (nonatomic,strong) MCAnimForVideo *loadingView;
@property (strong, nonatomic) VideoMaskView *player_maskview ;
@property (nonatomic,strong) UIButton *playVideoButton;
@property (nonatomic, retain) UIButton *playVideoButton_full;

@end

@implementation MCJingpaiDetailHeaderView

-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
    }
    return _playBtn;
}

-(UIButton *)playVideoFullButton{
    if (!_playVideoFullButton) {
        _playVideoFullButton = [[UIButton alloc]init];
    }
    return _playVideoFullButton;
}

-(UIImageView *)playVideoImage{
    if (!_playVideoImage) {
        _playVideoImage = [[UIImageView alloc]init];
    }
    return _playVideoImage;
}

-(MCVideoView *)bigVideoView{
    if (!_bigVideoView) {
        _bigVideoView = [[MCVideoView alloc]init];
    }
    return _bigVideoView;
}


-(void)setupUI:(MCJingpaiDetailModel *)model{
    
    self.backgroundColor = [UIColor whiteColor];
    self.isFull = NO;
    
    self.model = model;
    
    topViewForJingpaiDetailHeader *topView = [[topViewForJingpaiDetailHeader alloc]init];
    topView.frame = CGRectMake(0, 0, kDeviceWidth, 85);
    [topView setupUI:model];
    topView.superVC = self.superVC;
    [self addSubview:topView];
    
    UILabel *describeLabel = [[UILabel alloc]init];
    describeLabel.text = model.auction_description;
    float descriptionLabelH = [SQCStringUtils getCustomHeightWithText:model.auction_description viewWidth:kDeviceWidth-40 textSize:KjpDetailFont];
    describeLabel.frame = CGRectMake(20, topView.bottom+5, kDeviceWidth-40, descriptionLabelH);
    describeLabel.font = [UIFont systemFontOfSize:KjpDetailFont];
    describeLabel.numberOfLines = 0;
    [self addSubview:describeLabel];
    
    //根据数据添加视频块和图片块
    
    NSInteger imageCount = model.img_urls.count;
    UIImageView *currentImg = [[UIImageView alloc]init];
    
    for (int i = 0; i<imageCount; i++) {
        
        
        float imgH = [model.img_urls[i][@"height"] floatValue];
        float imgW = [model.img_urls[i][@"width"] floatValue];
        float imageH = imgH/imgW*(kDeviceWidth-40);
        
        float tempH = 0;
        if (i == 0) {
            tempH = describeLabel.bottom;
        }else{
            tempH = 0;
        }
        
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(20, tempH+currentImg.bottom+10, kDeviceWidth-40, imageH)];
        currentImg = imgView;
        
        NSString *url = @"";
        url = self.model.img_urls[i][@"url"];
        
        [imgView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (i == 0) {
                self.shareImg = image;
            }
        } usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        imgView.backgroundColor = [UIColor darkGrayColor];
        
        if (i == 0) {
            
            if ([model.video_url[@"video_url"] length]>0) {
                
                UIImageView *playBtnImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"playButton"]];
                playBtnImage.frame = CGRectMake(imgView.width*0.5-25,imgView.height*0.5-25,50,50);
                self.playVideoImage = playBtnImage;
//                [imgView addSubview:playBtnImage];
                
                self.video_picImageView = imgView;
            }
            
        }
        
        [self addSubview:imgView];
    }
    
    //自动小屏播放视频
    if ([model.video_url[@"video_url"] length]>0) {
        [self addVideoView];
    }
    
}


+(float)getHeightWithData:(MCJingpaiDetailModel *)model{
    
    float descriptionLabelH = [SQCStringUtils getCustomHeightWithText:model.auction_description viewWidth:kDeviceWidth-40 textSize:KjpDetailFont];
    float topViewH = 85;
    
    //图片和视频块高度
    NSInteger imageCount = model.img_urls.count;
    
    float mediaH = 10*imageCount+20;
    for (int i = 0; i<imageCount; i++) {
        float imgH = [model.img_urls[i][@"height"] floatValue];
        float imgW = [model.img_urls[i][@"width"] floatValue];
        float tempImageH = imgH/imgW*(kDeviceWidth-40);
        
        mediaH = mediaH+tempImageH;
    }
    
    
    return topViewH+descriptionLabelH+mediaH;
    
}

- (void)auctionDetailVideoDidChangeStates
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
         [self performSelector:@selector(hideVideoImage) withObject:nil afterDelay:0.0];

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

- (void)resetPlayButton
{
    
    [self.playVideoButton addTarget:self action:@selector(playAuctionVideoMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoButton setFrame:_video_picImageView.frame];
    [self.playVideoButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    [self addSubview:self.playVideoButton];
    [self bringSubviewToFront:self.playVideoButton];
    
    [self playAuctionVideoMethod];
    
}

#pragma mark 添加视频view方法
-(void)addVideoView{
#ifdef TencentRelease

//    [self removePlayer];
    
    if (!self.playVideoButton) {
        self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    self.video_picImageView.hidden = NO;
    
    [self resetPlayButton];

    for (int i=0; i<[UploadVideoManager sharedInstance].playerFullButtonArray.count; i++) {
        UIButton *full = [UploadVideoManager sharedInstance].playerFullButtonArray[i];
        if (full==self.playVideoButton_full) {
            
        }else
        {
            [full removeFromSuperview];
            
        }
    }

#else
    
#endif
    
}


- (void)removePlayer
{
    [self.player stop];
    [self.player.view removeFromSuperview];
    
}


- (void)playAuctionVideoMethod
{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(auctionDetailVideoDidChangeStates) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatesExist) name:MPMoviePlayerWillExitFullscreenNotification object:nil];
    
    
    if (![UploadVideoManager sharedInstance].playersArray) {
        [UploadVideoManager sharedInstance].playersArray = @[].mutableCopy;
    }
//    self.playedIndex = self.currentIndex;
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
    NSString *videoURL = getSafeString(self.model.video_url[@"video_url"]);
    
    self.player.contentURL = [NSURL URLWithString:videoURL];
    self.player.view.frame = _video_picImageView.frame;

    self.video_picImageView.hidden = NO;

    self.video_picImageView.contentMode = UIViewContentModeScaleToFill;

    
     self.player_maskview.originalFrame = _video_picImageView.frame;
    NSLog(@"x=%f,y=%f,w=%f,h=%f",_video_picImageView.frame.origin.x,_video_picImageView.frame.origin.y,_video_picImageView.frame.size.width,_video_picImageView.frame.size.height);
    
    
    _video_picImageView.frame = CGRectMake(0, 0, _video_picImageView.width, _video_picImageView.height);
    [self.player.view addSubview:self.video_picImageView];
    self.player.scalingMode = MPMovieScalingModeAspectFill;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeOne;
    
    [self.playVideoButton removeFromSuperview];
    //加载动画
    [self.loadingView removeFromSuperview];
    self.loadingView = [[MCAnimForVideo alloc]init];
    self.loadingView.frame =
    CGRectMake((_player.view.width-45)*0.5, (_player.view.height-45)*0.5, 45, 45);
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self.player.view addSubview:self.loadingView];
    
    [self.player play];
    
    [[UploadVideoManager sharedInstance].playersArray addObject:self.player];
    self.player_maskview.moviePlayer = self.player;
    self.player_maskview.videoURL = videoURL;

    self.player_maskview.loadingView = self.loadingView;
    
    self.player_maskview.hidden = YES;
    self.player_maskview.backgroundColor = [UIColor clearColor];
    
    if (!self.playVideoButton_full) {
        self.playVideoButton_full = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    if (![UploadVideoManager sharedInstance].playerFullButtonArray) {
        [UploadVideoManager sharedInstance].playerFullButtonArray = @[].mutableCopy;
    }
    [[UploadVideoManager sharedInstance].playerFullButtonArray addObject:self.playVideoButton_full];
    [self.playVideoButton_full addTarget:self action:@selector(playAuctinDetailFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.playVideoButton_full setFrame:_video_picImageView.frame];
    [self addSubview:self.player.view];
    [self addSubview:self.playVideoButton_full];
    [self bringSubviewToFront:self.playVideoButton_full];
    
//    [self volumeWith:0];
    
}


- (void)playAuctinDetailFullScreen
{
    self.video_picImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.video_picImageView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.player_maskview.maskImageView = self.video_picImageView;
    
    for(int i=0;i<self.player.view.subviews.count;i++)
    {
        UIView *view = self.player.view.subviews[i];
        if ([view isKindOfClass:[VideoMaskView class]]) {
            [view removeFromSuperview];
        }
    }
//    self.player_maskview.infoDict = self.itemDict;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.playVideoButton_full removeFromSuperview];
    
    self.player.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.loadingView.center = self.player.view.center;
    
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.repeatMode = MPMovieRepeatModeNone;
    [self volumeWith:0.6];
    
    self.player_maskview.supAuctionView = self;
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

    
}

//设置音量的方法
-(void)volumeWith:(float)vol{
    
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
            
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:vol];
        });
    }else{
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
            
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:vol];
        });
    }
}


- (MPMoviePlayerController *)player
{
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] init];
        
    }
    return _player;
}

- (VideoMaskView *)player_maskview
{
    if (!_player_maskview) {
        _player_maskview = [[VideoMaskView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _player_maskview.isAllowedShang = NO;
        
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

@end




