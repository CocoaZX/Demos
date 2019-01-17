//
//  ManageActivityViewController.h
//  Mocha
//
//  Created by sun on 15/8/28.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface ManageActivityViewController : McBaseViewController

@property (nonatomic, copy) NSString *eventId;
@property (nonatomic, copy) NSString *status;

- (void)refreshView;

@end
