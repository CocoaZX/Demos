//
//  McMyFeedListViewController.h
//  Mocha
//
//  Created by renningning on 15/4/23.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

//#import "McBaseListViewController.h"
#import "McBaseFeedViewController.h"

extern NSString * const MCDoCommitActionNotification;

@interface McMyFeedListViewController : McBaseFeedViewController

@property (assign, nonatomic) BOOL isPersonDongTai;
@property (nonatomic, assign) BOOL isTabelViewStyle;

@property (copy, nonatomic) NSString *currentJuBaoUid;

@property (copy, nonatomic) NSString *currentUid;

@property (assign, nonatomic) BOOL isNeedToAppearBar;

@property (copy, nonatomic) NSString *currentTitle;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UINavigationController *superNVC;

@end

