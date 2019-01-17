//
//  TimeLineTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMoviePlayerController.h>

#define kPhotoHeight 230

@interface TimeLineTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bgTopImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeTitleLab;

@property (weak, nonatomic) IBOutlet UILabel *mouthLab;

@property (weak, nonatomic) IBOutlet UIView *divView;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;

@property (weak, nonatomic) IBOutlet UILabel *themeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (weak, nonatomic) IBOutlet UIButton *likeButton;

@property (weak, nonatomic) IBOutlet UIButton *privateButton;

@property (weak, nonatomic) IBOutlet UIButton *commentButton;


@property (weak, nonatomic) IBOutlet UIView *headerListView;

@property (strong, nonatomic) NSMutableArray *headerArray;

@property (strong, nonatomic) UIButton *headerMoreButton;

@property (strong, nonatomic) PhotoInfo *dataObject;

@property (strong, nonatomic) MPMoviePlayerController *player;

@property (strong, nonatomic) UIButton *playerButton;

- (void)addUsersHeaderImage:(NSArray *)array;

- (void)addTagsView:(NSString *)tagstr;

- (void)setCellViewWithDiction:(PhotoInfo *)diction indexpath:(NSIndexPath *)indexPath;

- (void)setCellViewWithDiction:(PhotoInfo *)diction indexpath:(NSIndexPath *)indexPath dataDiction:(NSDictionary *)dataDiction;

+ (TimeLineTableViewCell *)getTimeLineCell;

- (void)addVideoPlayer;

- (void)removePlayer;

@end
