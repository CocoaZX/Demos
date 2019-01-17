//
//  YouHuiQuanTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/20.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YouHuiQuanTableViewCell.h"

@implementation YouHuiQuanTableViewCell












+ (YouHuiQuanTableViewCell *)getYouHuiQuanTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"YouHuiQuanTableViewCell" owner:self options:nil];
    YouHuiQuanTableViewCell *cell = array[0];
    return cell;
}




@end
