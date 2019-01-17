//
//  PhotoDetailView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonPageDetailViewModel.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import "VideoMaskView.h"



@protocol PhotoDetailViewDelegate <NSObject>

- (void)doLikeUsersToPersonCenter:(NSString *)uid;

@end


@interface PhotoDetailView : UIView
@property (strong, nonatomic) VideoMaskView *player_maskview ;

@property (weak, nonatomic) IBOutlet UILabel *liulanNumber;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) IBOutlet UIImageView *backLine;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *userDesc;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *privateButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIView *headerListView;
@property (weak, nonatomic) IBOutlet UIView *shangListView;
@property (weak, nonatomic) IBOutlet UIButton *shangButton;
@property (nonatomic,strong) UIViewController *superCon;

@property (copy, nonatomic) NSString *userID;

@property (weak, nonatomic) IBOutlet UIButton *headerClickButton;

@property (weak, nonatomic) IBOutlet UIImageView *liulanImage;

@property (strong, nonatomic) NSMutableArray *headerArray;
@property (strong, nonatomic) NSMutableArray *shangHeaderArray;

@property (nonatomic, strong) UIButton *nShangBtn;

@property (strong, nonatomic) UIButton *headerMoreButton;
@property (strong, nonatomic) UIButton *rewardHeaderMoreButton;
@property (strong, nonatomic) PersonPageDetailViewModel *modelView;
@property (nonatomic, assign) id<PhotoDetailViewDelegate> delegate;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (nonatomic, retain) UIButton *playVideoButton;

- (void)addUsersHeaderImage:(NSArray *)array;

- (void)reSetDetailViewFrameWithDetailModel:(PersonPageDetailViewModel *)detailModel;

+ (PhotoDetailView *)getPhotoDetailView;



@end
