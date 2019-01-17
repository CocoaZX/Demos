//
//  McMainFeedViewController.h
//  Mocha
//
//  Created by XIANPP on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McMainFeedViewController : McBaseViewController

@property (nonatomic , copy)NSString *currentUid;
@property (nonatomic , copy)NSString *currentTitle;
@property (nonatomic,assign) BOOL isNeedReload;


@end
