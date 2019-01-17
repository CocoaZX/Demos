//
//  YuePaiDelegate.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiDelegate.h"
#import "YuePaiDetailViewController.h"


@implementation YuePaiDelegate






- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isNeedPay) {
        return 305;
        
    }else
    {
        return 250;
        
    }
    return 0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
    detail.covenant_id = getSafeString(self.dataArray[indexPath.row][@"covenant_id"]);
    detail.isNeedPay = self.isNeedPay;
    detail.isTaoXi = self.isTaoXi;
    [self.controller.navigationController pushViewController:detail animated:YES];
    
}



















@end
