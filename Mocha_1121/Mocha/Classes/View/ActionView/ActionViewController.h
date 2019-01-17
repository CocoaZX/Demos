//
//  ActionViewController.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/14.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ActionDelegate <NSObject>;

- (void)actionViewClickWithTag:(int)index;

@end
@interface ActionViewController : UIViewController

@property (nonatomic, assign) id <ActionDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *namesArray;

@end
