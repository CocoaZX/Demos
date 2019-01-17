//
//  FansViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/12.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface FansViewController : McBaseViewController

@property (nonatomic, strong) NSMutableArray *watchedArray;
@property (weak, nonatomic) IBOutlet UITableView *fansTableView;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) NSString *selfTitle;


- (void)setFansDataWithUid:(NSString *)uid;

@end
