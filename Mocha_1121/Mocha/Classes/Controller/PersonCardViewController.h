//
//  PersonCardViewController.h
//  Mocha
//
//  Created by XIANPP on 15/12/11.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewMyPageViewController.h"
@interface PersonCardViewController : UIViewController


@property (nonatomic , copy)NSString *curruid;

@property (nonatomic , copy)NSString *nickName;

@property (nonatomic , copy)NSString *mokaNum;

@property (nonatomic , strong)NewMyPageViewController *supViewController;
@end
