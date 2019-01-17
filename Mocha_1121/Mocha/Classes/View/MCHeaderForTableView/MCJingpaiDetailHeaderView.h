//
//  MCJingpaiDetailHeaderView.h
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiDetailModel.h"
#import "VideoMaskView.h"
#import "MCJingpaiDetailController.h"
#import "MCVideoView.h"

#ifdef TencentRelease
#import <MediaPlayer/MPMoviePlayerController.h>
#endif

@interface MCJingpaiDetailHeaderView : UIView

@property (nonatomic,strong) MCJingpaiDetailController *superVC;
@property (nonatomic,strong) MCJingpaiDetailModel *model;
@property (nonatomic,strong) UIImage *shareImg;
@property (nonatomic,strong) MCVideoView *smallVideoView;


+(float)getHeightWithData:(MCJingpaiDetailModel *)model;
-(void)setupUI:(MCJingpaiDetailModel *)model;

@property (assign, nonatomic) int currentIndex;
@property (assign, nonatomic) int playedIndex;

#ifdef TencentRelease

@property (strong, nonatomic) MPMoviePlayerController *player;



- (void)removePlayer;

//- (void)resetFullImage;

//- (void)resetPlayButton;

#else



#endif

@end
