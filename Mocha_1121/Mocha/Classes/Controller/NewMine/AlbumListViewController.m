//
//  AlbumListViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/9/6.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "AlbumListViewController.h"
#import "AlbumTableViewCell.h"
#import "AlbumDetailViewController.h"
#import "BuildAlbumViewController.h"

@interface AlbumListViewController ()


@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (assign, nonatomic) BOOL isAppearButton;

@property (assign, nonatomic) BOOL isAllowDelete;

@property (copy, nonatomic) NSString *albumid;

@end

@implementation AlbumListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[].mutableCopy;
   
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([uid isEqualToString:self.currentUid]) {
        self.title = @"我的摄影集";
        self.submitButton.hidden = NO;
        self.submitButton.frame = CGRectMake(10, kScreenHeight-114, kScreenWidth-20, 44);
        self.isAllowDelete = YES;

    }else
    {
        self.title = [NSString stringWithFormat:@"%@的摄影集",self.currentName];
        self.submitButton.hidden = YES;
        self.isAllowDelete = NO;

    }
    
    [self requestMyMokaData];

}



- (IBAction)buildAlbum:(id)sender {
    NSLog(@"buildAlbum");
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    BuildAlbumViewController *detail = [[BuildAlbumViewController alloc] initWithNibName:@"BuildAlbumViewController" bundle:[NSBundle mainBundle]];

    [self.navigationController pushViewController:detail animated:YES];
}

- (void)requestMyMokaData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *cuid = self.currentUid;
    
    
    NSDictionary *params = [AFParamFormat formatGetUserMokaListParams:cuid];
    [AFNetwork getMokaList:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            NSString *allow = [NSString stringWithFormat:@"%@",data[@"createEnable"]];
            if ([allow isEqualToString:@"1"]) {
                self.isAppearButton = YES;
            }else
            {
                self.isAppearButton = NO;

            }
            if (self.isAppearButton) {
                self.submitButton.hidden = NO;
                
            }else
            {
                self.submitButton.hidden = YES;
                
            }
            NSArray *dic = data[@"data"];
            self.dataArray = [NSMutableArray array];
            if ((NSNull *)dic != [NSNull null]) {
                for (id obj in data[@"data"]) {
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        if (![obj[@"albumType"] isEqualToString:@"3"]) {
                            [self.dataArray addObject:obj];
                        }
                    }
                }
            }
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if ([uid isEqualToString:self.currentUid]) {
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight- 50 - 64);
            }else
            {
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
            }

            [self.tableView reloadData];
        }
        else if([data[@"status"] integerValue] == kReLogin){
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
    return 147;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AlbumTableViewCell *cell = nil;
    NSString *identifier = @"AlbumTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [AlbumTableViewCell getAlbumTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell initWithDiction:self.dataArray[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *diction = self.dataArray[indexPath.row];
    NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"title"]];
    NSString *albumid = [NSString stringWithFormat:@"%@",diction[@"albumId"]];
    AlbumDetailViewController *detail = [[AlbumDetailViewController alloc] initWithNibName:@"AlbumDetailViewController" bundle:[NSBundle mainBundle]];
    detail.currentTitle = nameString;
    detail.albumid = albumid;
    detail.currentUid = self.currentUid;
    [self.navigationController pushViewController:detail animated:YES];
    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.isAllowDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *diction = self.dataArray[indexPath.row];

    self.albumid = [NSString stringWithFormat:@"%@",diction[@"albumId"]];

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":self.albumid}];
        [AFNetwork getDeleteAlbum:params success:^(id data){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            if ([data[@"status"] integerValue] == kRight) {
                [self requestMyMokaData];
                
            }
            else if([data[@"status"] integerValue] == kReLogin){
                [LeafNotification showInController:self withText:data[@"msg"]];
            }else if ([data[@"status"] integerValue] == 1){
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
            
            
        }failed:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            
        }];
    }
    
    
}


@end
