//
//  MCVideoView.h
//  Mocha
//
//  Created by TanJian on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MCVideoView : UIView

@property(nonatomic ,copy)NSString *urlStr;
@property (nonatomic,assign) BOOL isFullVideo;
@property (nonatomic,strong) UIButton *playIcon;


-(void)playAgain;
-(void)stopPlay;
-(void)pauseVideo;
-(void)volumeWith:(float)vol;

-(void)setupUIWith:(NSString *)urlStr isFull:(BOOL)isFull;

#ifdef TencentRelease

@property (strong, nonatomic) MPMoviePlayerController *player;

#else

#endif


@end
