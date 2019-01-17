//
//  MCHotJingpaiCell.h
//  Mocha
//
//  Created by TanJian on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCHotJingpaiModel.h"
#import "McFeedTableViewCell.h"
#import "McHotFeedViewController.h"
#import "McMyFeedListViewController.h"
#import "McNearFeedViewController.h"

typedef enum{
    superHot,
    superList,
    superNear,
    superElse,
} MCsuperType;

@protocol MCJingpaiCellDelegate <NSObject>

@end

@interface MCHotJingpaiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIImageView *renzhengImage;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *IdentityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;
@property (weak, nonatomic) IBOutlet UILabel *browseCount;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLable;
@property (weak, nonatomic) IBOutlet UIImageView *firstImageViwe;
@property (weak, nonatomic) IBOutlet UIImageView *secondImageView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fouthImageView;
@property (weak, nonatomic) IBOutlet UILabel *firstTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTagLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdTagLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondTagBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdTagBtn;
@property (weak, nonatomic) IBOutlet UIView *seprateLime;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UIImageView *jingpaiHeaderImageView;
@property (weak, nonatomic) IBOutlet UIButton *jingpaiButton;
@property (weak, nonatomic) IBOutlet UILabel *currentJingpaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastJingpaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *nobodyDoJingpaiLabel;
@property (weak, nonatomic) IBOutlet UIView *topLime;
@property (weak, nonatomic) IBOutlet UIView *jingpaiBottomView;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nicknameWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seprateLineTop;

@property (nonatomic, assign) id<McFeedTableViewCellDelegate> cellDelegate;

@property (nonatomic, strong) McHotFeedViewController *superHotVC;
@property (nonatomic, strong) McMyFeedListViewController *superListVC;
@property (nonatomic, strong) McNearFeedViewController *superNearVC;

@property (nonatomic, strong) MCHotJingpaiModel *model;
//获取cell高度
+(float)getJingpaiCellHeightWith:(NSDictionary *)dict;


-(void)setDataWithDict:(NSDictionary *)dict;




@end














