//
//  McHotFeedViewController.h
//  Mocha
//
//  Created by renningning on 15/4/22.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

//#import "McBaseListViewController.h"
#import "McBaseFeedViewController.h"

extern NSString * const MCDoChatActionNotification;

@interface McHotFeedViewController : McBaseFeedViewController

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UINavigationController *superNVC;

- (void)requestGetList;

@end
