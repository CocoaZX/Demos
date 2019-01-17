//
//  NcResetPwdViewController.m
//  Mocha
//
//  Created by renningning on 14-11-27.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditPwdViewController.h"
#import "TextFieldTableViewCell.h"
#import "NotificationManager.h"

@interface McEditPwdViewController ()

@property (nonatomic, retain) NSMutableArray *passwordArray;

@end

@implementation McEditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"修改密码";
    
    self.view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"topBar3"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorForHex:kLikeRedColor]forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 60, 40)];
    [button.titleLabel setFont:kFont16];
    [button addTarget:self action:@selector(savePassword) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    
    self.passwordArray = [NSMutableArray arrayWithArray:@[@"旧密码",@"新密码",@"确认新密码"]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    headerView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    self.tableView.tableHeaderView = headerView;
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark action
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)savePassword
{
    NSString *oldPassw = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text;
    NSString *newPassw = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField.text;
    NSString *updatePass = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField.text;
    
    
    if ([oldPassw length] <= 0 || [newPassw length] <= 0 || [updatePass length] <= 0) {
        [LeafNotification showInController:self withText:@"请输入密码"];

//        [NotificationManager notificationWithMessage:@"请输入密码"];
        return;
    }
    
    if (![newPassw isEqualToString:updatePass]) {
        [LeafNotification showInController:self withText:@"新密码前后不一致"];

//        [NotificationManager notificationWithMessage:@"新密码前后不一致"];
        return;
    }
    
    //新版本不需要传手机号了
//    NSString *mobile = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"mobile"];
    
    NSDictionary *parmas = [AFParamFormat formatUpdatePwdWithMobile:nil oldPwd:oldPassw newPwd:newPassw];
    [AFNetwork changePassword:parmas success:^(id data){
        [self updatePwdDone:data];
    }failed:^(NSError *error){
        
    }];
    
}

- (void)updatePwdDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        [LeafNotification showInController:self withText:@"密码修改成功"];

//        [NotificationManager notificationWithMessage:@"密码修改成功"];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.5];
    }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
    }
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [_passwordArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"password";
    
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setTitleLabelHidden:YES];
    [cell setDetailLabelHidden:YES];
    [cell setValueWithPlaceholder:[_passwordArray objectAtIndex:indexPath.row]];
    [cell setSecureTextEntry:YES];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.view.frame), 20)];
    label.text = @"    密码范围为6位～16位 ";//忘记密码?
    label.textColor = [UIColor colorForHex:kLikeGrayColor];
    label.font = kFont14;
    
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40;
}


@end
