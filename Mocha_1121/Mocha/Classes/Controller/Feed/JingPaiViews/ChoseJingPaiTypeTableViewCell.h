//
//  ChoseJingPaiTypeTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoseJingPaiTypeTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@property (weak, nonatomic) IBOutlet UIImageView *redRightImageView;


@property (weak, nonatomic) IBOutlet UIView *backView;



+ (ChoseJingPaiTypeTableViewCell *)getChoseJingPaiTypeTableViewCell;






@end
