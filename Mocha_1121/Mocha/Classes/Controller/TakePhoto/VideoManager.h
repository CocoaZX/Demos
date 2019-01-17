//
//  VideoManager.h
//  Mocha
//
//  Created by sun on 15/8/12.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "QiniuSDK.h"

@interface VideoManager : NSObject

@property (strong, nonatomic) QNUploadManager *upManager;



- (void)uploadWithVideo:(NSURL *)videoUrl block:(ChangeFinishBlock)block;

+ (instancetype)sharedInstance;

- (NSString *)getVideoUUid;

@end
