//
//  PersonPageDetailViewModel.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/31.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonPageDetailViewModel : NSObject
{
    NSDictionary *sexDict;
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
}

@property (nonatomic, strong) NSDictionary *originalDiction;

@property (nonatomic, strong) NSArray *likeusers;
@property (nonatomic, strong) NSArray *rewardUsers;
@property (nonatomic, strong) NSArray *goodsUserCount;

@property (nonatomic, strong) NSDictionary *photoDic;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *headerName;
@property (nonatomic, strong) NSString *headerDescription;
@property (nonatomic, strong) NSString *headerURL;
@property (nonatomic, strong) NSString *rewardAmount;
@property (nonatomic, strong) NSString *isRewarded;
@property (nonatomic, strong) NSString *totalReward;
@property (nonatomic, strong) NSString *totalRewardUser;
@property (nonatomic, strong) NSString *view_number;


@property (nonatomic, strong) NSString *tagString;
@property (nonatomic, strong) NSString *themeString;
@property (nonatomic, strong) NSString *timeString;
@property (nonatomic, strong) NSString *contentImageURL;
@property (nonatomic, strong) NSString *islike;
@property (nonatomic, strong) NSString *isfavorite;
@property (nonatomic, strong) NSString *width;
@property (nonatomic, strong) NSString *height;
@property (nonatomic, assign) float scaleHeight;
@property (nonatomic, copy) NSString *coverImageUrl;

//发布title
@property(nonatomic,copy)NSString *titleString;
@property(nonatomic,copy)NSString *object_type;



- (instancetype)initWithDiction:(NSDictionary *)diction;


- (NSString *)getCutHeaderURLWithView:(UIImageView *)imgView;






@end
