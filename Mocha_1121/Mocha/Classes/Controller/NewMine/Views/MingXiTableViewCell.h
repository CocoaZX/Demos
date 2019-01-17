//
//  MingXiTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 15/10/20.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MingXiTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;






+ (MingXiTableViewCell *)getMingXiTableViewCell;







@end
