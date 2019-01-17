//
//  JingPaiPartOneTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReleaseJingPaiViewController.h"

@interface JingPaiPartOneTableViewCell : UITableViewCell<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) ReleaseJingPaiViewController *releaseController;

+ (JingPaiPartOneTableViewCell *)getJingPaiPartOneTableViewCell;


@end
