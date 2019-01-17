//
//  McFeedTableViewCell.h
//  Mocha
//
//  Created by renningning on 15/4/20.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McFooterView.h"
#import "SingleData.h"
#ifdef TencentRelease

#import <MediaPlayer/MPMoviePlayerController.h>

#endif
@protocol McFeedTableViewCellDelegate <NSObject>

@optional
- (void)doTouchUpInsideWithItem:(NSDictionary *)dict status:(NSInteger)status;

- (void)actionDoneWithItem:(NSDictionary *)dict message:(NSString *)msg isReload:(BOOL)isReload;

- (void)doJumpPersonCenter:(NSDictionary *)itemDict;

- (void)doJumpType:(NSInteger)type fromCommentDict:(NSDictionary *)commentDict;

- (void)doJumpDaShangView:(NSDictionary *)itemDict;


@end

@interface McFeedTableViewCell : UITableViewCell

@property (weak,nonatomic) IBOutlet UIView *bgTopView;

@property (weak, nonatomic) IBOutlet UIImageView *bgTopImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoPonLabel;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImg;
@property (strong, nonatomic) UIImageView *video_picImageView;


@property (weak, nonatomic) IBOutlet UIView * bottomView;
@property (weak, nonatomic) IBOutlet UILabel *picInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *nearFarLab;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@property (weak, nonatomic) IBOutlet UIView *buttonsView;
@property (weak, nonatomic) IBOutlet McFooterButton *likeBtn;
@property (weak, nonatomic) IBOutlet McFooterButton *privateBtn;
@property (weak, nonatomic) IBOutlet McFooterButton *commitBtn;

@property (weak, nonatomic) IBOutlet UIButton *jubaoButton;

@property (weak, nonatomic) UIViewController *selfCon;

@property (weak, nonatomic) IBOutlet UIView *likeUsersView;

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;

@property (assign, nonatomic) BOOL isPersonDongtai;

@property (copy,nonatomic) NSString *currentUid;

@property (strong, nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) NSDictionary *itemDict;
@property (assign, nonatomic) int currentIndex;
@property (assign, nonatomic) int playedIndex;
#ifdef TencentRelease

@property (strong, nonatomic) MPMoviePlayerController *player;



- (void)removePlayer;

- (void)resetFullImage;

- (void)resetPlayButton;

- (void)resetRePlayButton;

#else



#endif

@property (nonatomic, assign) id<McFeedTableViewCellDelegate> cellDelegate;

- (void)setCellItemWithDiction:(NSDictionary *)diction atIndex:(NSInteger )indexRow isNear:(BOOL)near;

- (void)setCellItemWithDiction_mine:(NSDictionary *)diction atIndex:(NSInteger )indexRow;

- (void)setCellItemWithDiction_person:(NSDictionary *)diction atIndex:(NSInteger )indexRow;

+ (float)getCellHeight:(NSDictionary *)diction;

+ (float)getCellHeight_mine:(NSDictionary *)diction;

//- (float)getCellHeight_mine:(NSDictionary *)diction;
//
//-(float)getCellHeight_person:(NSDictionary *)diction;


+(float)getCellHeight_person:(NSDictionary *)diction;


+ (McFeedTableViewCell *)getFeedTableViewCell;

//传入图片信息字典，计算图片显示大小
+ (CGSize)getPictureViewSize:(NSDictionary *)photoDict;


@end
