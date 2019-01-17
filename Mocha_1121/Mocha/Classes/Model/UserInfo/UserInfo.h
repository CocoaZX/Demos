//
//  UserInfo.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseJsonModel.h"


@class UserInfoData;
/**
 *  用户信息root模型
 */
@interface UserInfo : BaseJsonModel

@property (retain,nonatomic) UserInfoData *data;

@end

@class Setting;
@class MessageSettingDesc;
@class PopupItem;
@class MessageEnable;

@protocol MessageRankRewardItem;
@protocol AlbumsItem;
/**
 *  用户信息
 */
@interface UserInfoData : BaseJsonModel

@property (retain,nonatomic) Setting *setting;  //私信配置信息
@property (retain,nonatomic) PopupItem *popup;  //首页弹窗配置信息
@property (retain,nonatomic) MessageEnable *messageEnable;  //私信配置信息
@property (retain,nonatomic) MessageSettingDesc *message_setting_desc;  //私信配置提示语

@property (retain,nonatomic) NSArray<MessageRankRewardItem>*message_rank_reward;
@property (retain,nonatomic) NSArray<AlbumsItem>*albums;
@property (retain,nonatomic) NSArray *grade;
@property (retain,nonatomic) NSArray *orders;

@property (retain,nonatomic) NSString *is_show_video;
@property (retain,nonatomic) NSString *isblack;
@property (assign,nonatomic) BOOL isowner;
@property (assign,nonatomic) BOOL mobile;
@property (assign,nonatomic) BOOL member;

@property (retain,nonatomic) NSString *isfollow;

@property (retain,nonatomic) NSString *uid;
@property (retain,nonatomic) NSString *sex;
@property (retain,nonatomic) NSString *usermoney;
@property (retain,nonatomic) NSString *bannar;
@property (retain,nonatomic) NSString *workhistory;
@property (retain,nonatomic) NSNumber *nextLevel;
@property (retain,nonatomic) NSString *weight;
@property (retain,nonatomic) NSString *head_pic;
@property (retain,nonatomic) NSString *province;
@property (retain,nonatomic) NSString *goldcoin;
@property (retain,nonatomic) NSString *ucUrl;
@property (retain,nonatomic) NSString *inviteNumber;
@property (retain,nonatomic) NSString *rank;
@property (retain,nonatomic) NSNumber *albumcount;
@property (retain,nonatomic) NSString *cityName;
@property (retain,nonatomic) NSString *newfanscount;
@property (retain,nonatomic) NSString *vip;
@property (retain,nonatomic) NSString *status;
@property (retain,nonatomic) NSString *newcommentscount;
@property (retain,nonatomic) NSString *type;
@property (retain,nonatomic) NSNumber *currLevel;
@property (retain,nonatomic) NSString *remain;
@property (retain,nonatomic) NSString *followcount;
@property (retain,nonatomic) NSString *rankUrl;
@property (retain,nonatomic) NSString *nextRank;
@property (retain,nonatomic) NSString *fanscount;
@property (retain,nonatomic) NSString *studio;
@property (retain,nonatomic) NSString *num;
@property (retain,nonatomic) NSString *deadline;
@property (retain,nonatomic) NSString *height;
@property (retain,nonatomic) NSString *provinceName;
@property (retain,nonatomic) NSString *authentication;
@property (retain,nonatomic) NSString *member_tip;
@property (retain,nonatomic) NSString *newaccountlogcount;
@property (retain,nonatomic) NSString *bust;
@property (retain,nonatomic) NSString *trendscount;
@property (retain,nonatomic) NSString *reason;
@property (retain,nonatomic) NSString *hipline;
@property (retain,nonatomic) NSString *goldCoin;
@property (retain,nonatomic) NSString *approve_content;
@property (retain,nonatomic) NSString *nickname;
@property (retain,nonatomic) NSString *waist;
@property (retain,nonatomic) NSString *expire_time;
@property (retain,nonatomic) NSString *city;
@property (retain,nonatomic) NSString *job;
@property (retain,nonatomic) NSString *sexName;
@property (retain,nonatomic) NSString *typeName;
@property (retain,nonatomic) NSString *introduction;
@property (retain,nonatomic) NSString *skinid;
@property (retain,nonatomic) NSString *sysmsgcount;
@end


@class SettingMessage;
/**
 *  私信的配置信息
 */
@interface Setting : BaseJsonModel

@property (retain,nonatomic) SettingMessage *message;

@end

/**
 *  私信的配置信息
 */
@interface SettingMessage : BaseJsonModel

@property (retain,nonatomic) NSString *message_reward_is_on;  //设置私信打赏
@property (retain,nonatomic) NSString *message_reward;  //打赏金币
@property (retain,nonatomic) NSArray *is_forever_uids_list;

@end

/**
 *  私信配置提示语
 */
@interface MessageSettingDesc : BaseJsonModel

@property (retain,nonatomic) NSString *desc;

@end

/**
 *  私信配置信息
 */
@interface MessageEnable : BaseJsonModel

@property (retain,nonatomic) NSString *status;//是否可以使用私信－－ 0:可以使用 －－1:不可以使用
@property (retain,nonatomic) NSString *msg;

@end

@interface MessageRankRewardItem : BaseJsonModel

@property (assign,nonatomic) int level;
@property (assign,nonatomic) int min;
@property (assign,nonatomic) int max;

@end

/**
 *  首页弹窗视图配置信息
 */
@interface PopupItem : BaseJsonModel

@property (retain,nonatomic) NSString *type;
@property (retain,nonatomic) NSString *need;
@property (retain,nonatomic) NSString *value;   //图片链接
@property (retain,nonatomic) NSString *action;


@end

@protocol PhotosItem;
@interface AlbumsItem : BaseJsonModel

@property (retain,nonatomic) NSString *desc;
@property (retain,nonatomic) NSString *authorId;
@property (retain,nonatomic) NSString *style;
@property (retain,nonatomic) NSString *styleName;
@property (retain,nonatomic) NSString *defaultValue;
@property (retain,nonatomic) NSString *numPhotoes;
@property (retain,nonatomic) NSString *albumType;
@property (retain,nonatomic) NSString *title;
@property (retain,nonatomic) NSString *cover;
@property (retain,nonatomic) NSString *albumId;
@property (retain,nonatomic) NSArray<PhotosItem> *photos;
@property (retain,nonatomic) NSString *typeName;
@property (retain,nonatomic) NSArray *content;

@end

@interface PhotosItem : BaseJsonModel

@property (retain,nonatomic) NSString *photoId;
@property (retain,nonatomic) NSString *favoriteCount;
@property (retain,nonatomic) NSString *view_number;
@property (retain,nonatomic) NSString *width;
@property (retain,nonatomic) NSString *url;
@property (retain,nonatomic) NSString *likeCount;
@property (retain,nonatomic) NSString *title;
@property (retain,nonatomic) NSString *createLine;
@property (retain,nonatomic) NSString *commentCount;
@property (retain,nonatomic) NSString *height;
@property (retain,nonatomic) NSString *total_reward;
@property (retain,nonatomic) NSString *sequence;

@end



