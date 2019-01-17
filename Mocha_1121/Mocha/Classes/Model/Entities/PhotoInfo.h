//
//  PhotoInfo.h
//  Mocha
//
//  Created by 小猪猪 on 15/1/4.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PersonInfo;

@interface PhotoInfo : NSManagedObject

@property (nonatomic, retain) NSString * commentscount;
@property (nonatomic, retain) NSString * createline;
@property (nonatomic, retain) NSString * detail;
@property (nonatomic, retain) NSString * favoritecount;
@property (nonatomic, retain) NSString * height;
@property (nonatomic, retain) NSString * isfavorite;
@property (nonatomic, retain) NSString * islike;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * likecount;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * pid;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * tags;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * width;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *likeUsers;
@end

@interface PhotoInfo (CoreDataGeneratedAccessors)

- (void)addLikeUsersObject:(PersonInfo *)value;
- (void)removeLikeUsersObject:(PersonInfo *)value;
- (void)addLikeUsers:(NSSet *)values;
- (void)removeLikeUsers:(NSSet *)values;

@end
