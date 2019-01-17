//
//  PhotoViewDetailController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"
#import "McMainFeedViewController.h"


@interface PhotoViewDetailController : McBaseViewController

@property (nonatomic, assign) BOOL isFromTimeLine;

@property (nonatomic, assign) BOOL isJumpToShang;

@property (nonatomic, retain) NSMutableDictionary *infoDict;

@property (nonatomic, strong) McMainFeedViewController *superVC;


//图片或者视频
- (void)requestWithPhotoId:(NSString *)pid uid:(NSString *)uid;

- (void)requestWithVideoId:(NSString *)vid uid:(NSString *)uid;


@end
