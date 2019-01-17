//
//  McMsgContent.m
//  Mocha
//
//  Created by renningning on 14-12-13.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McMsgContent.h"

@implementation McMsgContent

@synthesize uid = _uid;
@synthesize toUserId = _toUserId;
@synthesize headPic = _headPic;
@synthesize content = _content;
@synthesize time = _time;
@synthesize msgType = _msgType;
@synthesize msgFrom = _msgFrom;
@synthesize msgId = _msgId;

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.content = dict[@"content"];
        self.time = dict[@"createline"];
        self.uid = dict[@"uid"];
        self.msgId = dict[@"id"];
        self.msgType = [dict[@"type"] integerValue];
        
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        if ([uid isEqualToString:self.uid]) {
            self.msgFrom = 0;
            self.headPic = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
        }
        else{
            self.msgFrom = 1;
            self.headPic = dict[@"head_pic"];
        }
        
    }
    return self;
}

@end
