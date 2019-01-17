//
//  HeaderView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonPageViewModel.h"

@protocol HeaderViewDelegate <NSObject>

- (void)headerViewClick:(UIButton *)sender;


@end

@interface HeaderView : UIView

@property (assign, nonatomic) id<HeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackImage;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagsLabel;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *tuijianButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *changPictureButton;
@property (weak, nonatomic) IBOutlet UIButton *changeLabelButton;
@property (weak, nonatomic) IBOutlet UIButton *changeFollowerButton;
@property (weak, nonatomic) IBOutlet UIButton *changeFansButton;
@property (weak, nonatomic) IBOutlet UILabel *pictureNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabelLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *pictureNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *mokaNumber;

@property (weak, nonatomic) IBOutlet UIButton *mokaBackButton;
@property (weak, nonatomic) IBOutlet UIButton *dongtaiButton;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuButton;
@property (weak, nonatomic) IBOutlet UIButton *fansButton;

@property (weak, nonatomic) IBOutlet UIImageView *renzhengImageV;

@property (nonatomic, strong) PersonPageViewModel *pViewModel;

- (void)setViewWithViewModel:(PersonPageViewModel *)pViewModel;

- (void)hidenAllBackView;

- (void)reSetFrame;

- (void)appearPersonalPageView;

- (void)appearFriendPageView;

- (void)setFollow:(BOOL)isFollowed;

+ (HeaderView *)getPersonalHeaderView;


@end
