//
//  MCVideoView.m
//  Mocha
//
//  Created by TanJian on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCVideoView.h"
#import "MCAnimForVideo.h"


@interface MCVideoView ()

@property (strong, nonatomic) MCAnimForVideo *loadingView;
@property (nonatomic,strong) UIButton *playVideoFullButton;
@property (nonatomic,strong) UIButton *playBtn;

@end


@implementation MCVideoView

-(void)layoutSubviews{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStates) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStates) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    self.player.view.frame = self.bounds;
}

-(void)setupUIWith:(NSString *)urlStr isFull:(BOOL)isFull{
    
    NSString *videoUrlStr = getSafeString(urlStr);
    NSURL *videoURL = [NSURL URLWithString:videoUrlStr];
    self.player.contentURL = videoURL;
    _player.scalingMode = MPMovieScalingModeAspectFill;
    _player.controlStyle = MPMovieControlStyleNone;
    _player.repeatMode = MPMovieRepeatModeOne;
    _player.view.frame = self.bounds;
    _player.shouldAutoplay = YES;
    
    //缓冲动画
    [self.loadingView removeFromSuperview];
    self.loadingView = [[MCAnimForVideo alloc]init];
    self.loadingView.frame = CGRectMake(self.width*0.5-25,self.height*0.5-25, 50, 50);
    self.loadingView.backgroundColor = [UIColor clearColor];
    [self.player.view addSubview:self.loadingView];
    
    UIButton *playIcon = [[UIButton alloc]init];
    [playIcon setImage:[UIImage imageNamed: @"playButton"] forState:UIControlStateNormal];
    [playIcon sizeToFit];
    playIcon.center = _player.view.center;
    [playIcon addTarget:self action:@selector(playAgain) forControlEvents:UIControlEventTouchUpInside];
    self.playIcon = playIcon;
    playIcon.hidden = YES;
    
    
    [self addSubview:self.player.view];
    
    if (isFull) {
        
        [self volumeWith:8.0];
        
    }else{
        
        [self volumeWith:0.0];
        [self.player play];
        
    }
    [self addSubview:playIcon];
    [self bringSubviewToFront:self.playIcon];
}


//设置音量的方法
-(void)volumeWith:(float)vol{
    
    //    进入默认静音
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
    
    if (vol == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            [[MPMusicPlayerController applicationMusicPlayer] setVolume:vol];
            
        });
    }else{
        [[MPMusicPlayerController applicationMusicPlayer] setVolume:vol];
    }

}


-(void)playAgain{
    [self.player play];
    self.playIcon.hidden = YES;
}

-(void)stopPlay{
    [self.player stop];
    self.playIcon.hidden = NO;
}

-(void)pauseVideo{
    [self.player pause];
}


-(void)didChangeStates{

    switch (self.player.loadState) {
        case MPMovieLoadStatePlayable:
            NSLog(@"可以播放");
            
            self.playIcon.hidden = NO;
            self.loadingView.hidden = YES;
            [self playAgain];
            
            break;
        case MPMovieLoadStatePlaythroughOK:
            NSLog(@"缓冲完成，可以连续播放");
            self.playIcon.hidden = NO;
            break;
        case MPMovieLoadStateStalled:
            NSLog(@"缓冲中");
            self.playIcon.hidden = NO;
            self.loadingView.hidden = NO;
            break;
        case MPMovieLoadStateUnknown:
            NSLog(@"未知状态");
            self.playIcon.hidden = NO;
            
            break;
        default:
            break;
    }
}

-(void)playbackStates{
    switch (self.player.playbackState) {
        case MPMoviePlaybackStateStopped:
            NSLog(@"播放完成");
            self.playIcon.hidden = NO;
            break;
        case MPMoviePlaybackStatePlaying:
            NSLog(@"正在播放");
            self.playIcon.hidden = YES;
            self.loadingView.hidden = YES;
            break;
        case MPMoviePlaybackStatePaused:
            NSLog(@"暂停播放");
            self.playIcon.hidden = NO;
            break;
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"播放中断");
            self.playIcon.hidden = NO;
            break;
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"前端播放");
            self.playIcon.hidden = YES;
            break;
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"后端播放");
            self.playIcon.hidden = YES;
            break;
        default:
            break;
    }
}


-(void)playingMocieState{
    
    NSLog(@"正在播放");
    
}

-(MPMoviePlayerController *)player{
    if (!_player) {
        _player = [[MPMoviePlayerController alloc]init];
    }
    return _player;
}

-(MCAnimForVideo *)loadingView{
    if (!_loadingView) {
        _loadingView = [[MCAnimForVideo alloc]init];
    }
    return _loadingView;
}


-(UIButton *)playBtn{
    if (!_playBtn) {
        _playBtn = [[UIButton alloc]init];
    }
    return _playBtn;
}
@end
