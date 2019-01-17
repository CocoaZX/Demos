//
//  McBaseFeedViewController.h
//  Mocha
//
//  Created by renningning on 15/5/15.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McBaseListViewController.h"

enum {
    McFeedActionTypeDetail,
    McFeedActionTypeComment,
    McFeedActionTypePhotoDetail,
    McFeedActionTypePersonCenter
    
}McFeedActionType;

@protocol McBaseFeedControllerDelegate <NSObject>

- (void)doTouchUpActionWithDict:(NSDictionary *)itemDict actionType:(NSInteger)type;

@end

@interface McBaseFeedViewController : McBaseListViewController


@property (nonatomic, assign) id<McBaseFeedControllerDelegate> feedDelegate;

@end
