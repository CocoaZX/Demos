//
//  ChoseJingPaiTypeViewController.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^ChangeJingPaiType)(NSArray *types);
typedef void (^ChangeJingPaiType)(NSDictionary *type);


@interface ChoseJingPaiTypeViewController : McBaseViewController

@property (copy, nonatomic) ChangeJingPaiType blockBack;

- (void)setTypeBlock:(ChangeJingPaiType)block;

@end
