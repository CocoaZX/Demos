//
//  PhotoEngine.h
//  Mocha
//
//  Created by 小猪猪 on 15/1/4.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^saveFinishCallBack)(BOOL success, NSError *error);

@interface PhotoEngine : NSObject

+ (void)savePhotoInfoWithArray:(NSArray *)photos uid:(NSString *)uid block:(saveFinishCallBack)block;

+ (void)deletePhotoWithPid:(NSString *)pid;

+ (void)clearAllPhotoData;


+ (NSArray *)changeSetToArray:(NSSet *)sets;

@end
