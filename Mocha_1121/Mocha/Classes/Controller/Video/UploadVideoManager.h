//
//  UploadVideoManager.h
//  Mocha
//
//  Created by yfw－iMac on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewController.h"

@interface UploadVideoManager : BaseViewController
{
    
    
}
@property (nonatomic, strong) NSMutableArray *playersArray;
@property (nonatomic, strong) NSMutableArray *playerFullButtonArray;

- (void)uploadWithVideo:(NSURL *)videoUrl block:(ChangeFinishBlock)block;

+ (instancetype)sharedInstance;

- (NSString *)getVideoUUid;

- (void)initState;



@end
