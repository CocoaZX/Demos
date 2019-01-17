//
//  WatchedViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/11.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface WatchedViewController : McBaseViewController

@property (nonatomic, strong) NSMutableArray *watchedArray;
@property (weak, nonatomic) IBOutlet UITableView *watchTableView;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) NSString *selfTitle;

@property (nonatomic, assign) BOOL isAllowDelete;

- (void)setWatchedDataWithUid:(NSString *)uid;



@end
