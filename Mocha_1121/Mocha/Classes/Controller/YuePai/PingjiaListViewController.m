//
//  PingjiaListViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/1/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "PingjiaListViewController.h"
#import "YuePaiPingLunTableViewCell.h"

@interface PingjiaListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *dataArray;

@end

@implementation PingjiaListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"评价详情";
    
    [self getServiceData];
}

- (void)getServiceData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *covenant_id = getSafeString(self.covenant_id);
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id}];

    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiPingLunList success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {

            self.dataArray = data[@"data"];
            [self.mainTableView reloadData];
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];

}



#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 135;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YuePaiPingLunTableViewCell *cell = nil;
    NSString *identifier = @"YuePaiPingLunTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [YuePaiPingLunTableViewCell getYuePaiPingLunTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    cell.isJieShou = self.isJieShou;
    [cell setDataWithDic:self.dataArray[indexPath.row]];
    
    return cell;
}




@end
