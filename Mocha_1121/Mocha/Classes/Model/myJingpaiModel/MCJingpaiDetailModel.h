//
//  MCJingpaiDetailModel.h
//  Mocha
//
//  Created by TanJian on 16/4/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseJsonModel.h"


@interface MCJingpaiPublisher :BaseJsonModel

@property(nonatomic,copy)NSString *member;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *head_pic;
@property(nonatomic,copy)NSString *user_type;
@property(nonatomic,copy)NSString *vip;
@property(nonatomic,strong)NSDictionary *setting;


@end

@interface MCLastAuctorInfo : BaseJsonModel

@property(nonatomic,copy)NSString *member;
@property(nonatomic,copy)NSString *uid;
@property(nonatomic,copy)NSString *mobile;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *head_pic;
@property(nonatomic,copy)NSString *user_type;
@property(nonatomic,copy)NSString *vip;
@property(nonatomic,strong)NSDictionary *setting;


@end



#pragma mark mainModel
//mainModel
@interface MCJingpaiDetailModel : BaseJsonModel

@property(nonatomic,copy)NSDictionary *video_url;
@property(nonatomic,copy)NSString *auction_number;
//@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *opCode;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,strong)NSArray *tags;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,strong)NSArray *img_urls;
@property(nonatomic,copy)NSString *log_status;
@property(nonatomic,copy)NSString *up_range;
@property(nonatomic,copy)NSString *last_price;
@property(nonatomic,copy)NSString *last_income;
@property(nonatomic,copy)NSString *view_number;
@property(nonatomic,strong)NSMutableArray *likeusers;
@property(nonatomic,copy)NSString *auction_id;
@property(nonatomic,strong)MCJingpaiPublisher *publisher;
@property(nonatomic,strong)MCLastAuctorInfo *last_auctor;
@property(nonatomic,strong)NSArray *comments;
@property(nonatomic,strong)NSArray *auctors;
@property(nonatomic,copy)NSString *initial_price;
@property(nonatomic,copy)NSString *auction_description;
@property(nonatomic,copy)NSString *opName;
@property(nonatomic,copy)NSString *currentTimestamp;
@property(nonatomic,copy)NSString *start_time;
@property(nonatomic,copy)NSString *end_time;
@property(nonatomic,copy)NSString *isLike;

@end



