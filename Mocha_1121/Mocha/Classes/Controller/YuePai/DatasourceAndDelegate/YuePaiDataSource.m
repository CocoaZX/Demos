//
//  YuePaiDataSource.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/16.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiDataSource.h"
#import "YuePaiTableViewCell.h"
#import "YuePaiTwoTableViewCell.h"
#import "YuePaiPayViewController.h"
#import "YuePaiDetailViewController.h"
#import "PingJiaViewController.h"
#import "PingjiaListViewController.h"

@implementation YuePaiDataSource


#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.isNeedPay) {
        YuePaiTwoTableViewCell *cell = nil;
        NSString *identifier = @"YuePaiTwoTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [YuePaiTwoTableViewCell getYuePaiTwoTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.supCon = (YuePaiListViewController *)self.controller;
        cell.currentIndex = (int)indexPath.row;
        cell.payMethod = ^(int index){
            if (index==500) {
                [self showDetailViewController:self.dataArray[indexPath.row]];

            }else if (index==400) {
                [self showDetailViewController:self.dataArray[indexPath.row]];
                
            }else if (index==300) {
                [self showPingLunViewController:self.dataArray[indexPath.row]];
                
            }else if (index==600) {
                [self showPingLunListViewController:self.dataArray[indexPath.row]];
                
            }else
            {
                [self showPayViewController:self.dataArray[index]];

            }
            
        };
        [cell setData:self.dataArray[indexPath.row]];
        return cell;
    }else
    {
        YuePaiTableViewCell *cell = nil;
        NSString *identifier = @"YuePaiTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [YuePaiTableViewCell getYuePaiTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.supCon = (YuePaiListViewController *)self.controller;
        [cell setData:self.dataArray[indexPath.row]];
        return cell;
    }
    

    return nil;
}

- (void)showPayViewController:(NSDictionary *)diction
{
    YuePaiPayViewController *pay = [[YuePaiPayViewController alloc] initWithNibName:@"YuePaiPayViewController" bundle:[NSBundle mainBundle]];
    pay.diction = diction;
    pay.isNeedPay = self.isNeedPay;
    [self.controller.navigationController pushViewController:pay animated:YES];
    
}

- (void)showDetailViewController:(NSDictionary *)diction
{
    YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
    detail.covenant_id = getSafeString(diction[@"covenant_id"]);
    detail.isNeedPay = self.isNeedPay;
    [self.controller.navigationController pushViewController:detail animated:YES];
    
    
}

- (void)showPingLunViewController:(NSDictionary *)diction
{
    PingJiaViewController *detail = [[PingJiaViewController alloc] initWithNibName:@"PingJiaViewController" bundle:[NSBundle mainBundle]];
    detail.isDingdan = NO;
    detail.diction = diction;
    [self.controller.navigationController pushViewController:detail animated:YES];
}

- (void)showPingLunListViewController:(NSDictionary *)diction
{
    BOOL isJieShou = NO;
    NSString *uid = getSafeString(diction[@"uid"]);
    if ([uid isEqualToString:getCurrentUid()]) {
        isJieShou = NO;
        
    }else
    {
        isJieShou = YES;
    }
    PingjiaListViewController *detail = [[PingjiaListViewController alloc] initWithNibName:@"PingjiaListViewController" bundle:[NSBundle mainBundle]];
    detail.isJieShou = isJieShou;
    detail.covenant_id = diction[@"covenant_id"];
    [self.controller.navigationController pushViewController:detail animated:YES];
    
    
}

@end
