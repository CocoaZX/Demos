//
//  MCHotJingpaiModel.h
//  Mocha
//
//  Created by TanJian on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseJsonModel.h"


@interface MCJingpaiInfoModel : BaseJsonModel

@property(nonatomic,copy)NSString *auction_type_name;
@property(nonatomic,copy)NSString *update_time;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *surplus;
@property(nonatomic,copy)NSString *action_type;
@property(nonatomic,copy)NSString *goodsCount;
@property(nonatomic,copy)NSString *object_type;
@property(nonatomic,copy)NSString *last_earn;
@property(nonatomic,copy)NSString *end_time;
@property(nonatomic,copy)NSString *islike;
@property(nonatomic,strong)NSArray  *likeusers;
@property(nonatomic,copy)NSString *feedType;
@property(nonatomic,copy)NSString *goodsuserCount;
@property(nonatomic,copy)NSString *auctionID;
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,copy)NSArray *auction_logs;
@property(nonatomic,copy)NSString *auction_description;
@property(nonatomic,copy)NSString *last_uid;
@property(nonatomic,copy)NSString *banner;
@property(nonatomic,strong)NSArray *goodusers;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *totalReward;
@property(nonatomic,copy)NSString *cover;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,strong)NSArray *img_urls;
@property(nonatomic,copy)NSString *cover_url;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *height;
@property(nonatomic,copy)NSString *auction_number;
@property(nonatomic,strong)NSArray *tags;
//@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *isRewarded;
@property(nonatomic,copy)NSString *auctionTotal;
@property(nonatomic,copy)NSString *isfavorite;
@property(nonatomic,copy)NSString *code_expire_time;
@property(nonatomic,copy)NSString *last_price;
@property(nonatomic,copy)NSString *opName;
@property(nonatomic,copy)NSString *currentTimestamp;
@property(nonatomic,copy)NSString *view_number;
@property(nonatomic,copy)NSString *auction_type;
@property(nonatomic,copy)NSString *up_range;
@property(nonatomic,copy)NSString *start_time;
@property(nonatomic,copy)NSString *opCode;
@property(nonatomic,copy)NSString *statusName;
@property(nonatomic,copy)NSString *rewardAmount;
@property(nonatomic,copy)NSString *initial_price;
@property(nonatomic,copy)NSString *video_url;
@property(nonatomic,copy)NSString *action;
@property(nonatomic,copy)NSString *createLine;
@property(nonatomic,copy)NSString *favoritecount;
@property(nonatomic,copy)NSString *width;
@property(nonatomic,copy)NSString *pre_price;

@end


@interface MCJingpaiUserModel :BaseJsonModel

@property(nonatomic,copy)NSString *hipline;
@property(nonatomic,copy)NSString *weight;
//@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *province;
@property(nonatomic,copy)NSString *waist;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *sex;
@property(nonatomic,copy)NSString *user_sex;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *auction;
@property(nonatomic,copy)NSString *head_pic;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *num;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *height;
@property(nonatomic,copy)NSString *user_type;
@property(nonatomic,copy)NSString *vip;
@property(nonatomic,copy)NSString *bust;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *member;

@end

@interface MCLastUserInfo : BaseJsonModel

@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *head_pic;
@property(nonatomic,copy)NSString *user_type;

@end


#pragma mark mainModel

@interface MCHotJingpaiModel : BaseJsonModel

@property(nonatomic,copy)NSString *createline;
@property(nonatomic,copy)NSString *auctionID;
@property(nonatomic,strong)MCJingpaiInfoModel *info;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,strong)MCJingpaiUserModel *user;
@property(nonatomic,strong)MCLastUserInfo *last_user;


@end


