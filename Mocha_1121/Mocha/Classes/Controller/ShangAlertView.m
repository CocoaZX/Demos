//
//  ShangAlertView.m
//  Mocha
//
//  Created by yfw－iMac on 15/10/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ShangAlertView.h"

@implementation ShangAlertView






+ (ShangAlertView *)getShangView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"ShangAlertView" owner:self options:nil];
    ShangAlertView *view = array[0];
    return view;
}




@end
