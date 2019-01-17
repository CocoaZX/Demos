//
//  McMsgContent.h
//  Mocha
//
//  Created by renningning on 14-12-13.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface McMsgContent : NSObject

@property (nonatomic, retain) NSString *uid;
@property (nonatomic, retain) NSString *toUserId;
@property (nonatomic, retain) NSString *headPic;
@property (nonatomic, retain) NSString *content;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, assign) NSInteger msgType;
@property (nonatomic, assign) NSInteger msgFrom;//0为自己，1为好友
@property (nonatomic, retain) NSString *msgId;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
