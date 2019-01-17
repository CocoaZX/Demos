//
//  VAMomentTemp.m
//  WXBBuilder
//
//  Created by zhanglang on 14-6-24.
//  Copyright (c) 2014年 上海上蓓网络科技有限公司. All rights reserved.
//

#import "VAMomentTemp.h"

@implementation VAMomentTemp

static VAMomentTemp *sharedSingleton;

- (void)dealloc {
	[self clear];
	self.photoArray = nil;
}

+ (VAMomentTemp *)sharedSingleton {
	if (sharedSingleton == nil) {
		@synchronized(self)
		{
			if (!sharedSingleton) {
				sharedSingleton = [[VAMomentTemp alloc] init];
				sharedSingleton.photoArray = [NSMutableArray array];
			}
		}
	}
	return sharedSingleton;
}

- (void)clear {
    self.title = nil;
    self.body = nil;
    self.date = nil;
    self.address = nil;

	[self.photoArray removeAllObjects];
}

@end
