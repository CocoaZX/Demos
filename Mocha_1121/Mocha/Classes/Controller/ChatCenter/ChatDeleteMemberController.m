//
//  ChatDeleteMemberController.m
//  Mocha
//
//  Created by zhoushuai on 16/1/4.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ChatDeleteMemberController.h"
#import "ChatDeleteTableViewCell.h"
@interface ChatDeleteMemberController ()<UIAlertViewDelegate>

@end

@implementation ChatDeleteMemberController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.title  = @"移除群成员";
    
     //要删除的ids
    _deleteMemberIds = [NSMutableArray array];
     //初始化视图
    [self _initViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


//初始化视图
- (void)_initViews{
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setFrame:CGRectMake(0, 0, 50, 30)];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
     [cancleBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:cancleBtn];
    self.navigationItem.leftBarButtonItem = leftItem;

    //右侧的按钮
    UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [deleteBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:deleteBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //表视图
    _tableView = [[UITableView  alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //得到群组中的所有用户，去除群主自己
    _members = [NSMutableArray arrayWithArray:[_dataDic objectForKey:@"members"]];
    NSString *uid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    for (NSDictionary *dic in _members) {
        NSString *uidd = [dic objectForKey:@"id"];
        if ([uidd isEqualToString:uid]) {
            [_members removeObject:dic];
            return;
        }
    }
    
    NSLog(@"%@",_members);
    [_tableView reloadData];
}


#pragma mark UITableViewDelegate
//返回行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _members.count;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"chatDeleteCell";
    ChatDeleteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatDeleteTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
    cell.dataDic = _members[indexPath.row];
    cell.sourceVC = self;
    return cell;
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatDeleteTableViewCell  *cell = [tableView cellForRowAtIndexPath:indexPath];
    //判断是否已经在删除数据组中
    if ([_deleteMemberIds containsObject:cell.userID]) {
        //如果已经在数据中，就从数据中移除
        cell.checkImgView.image = [UIImage imageNamed:@"check"];
        [_deleteMemberIds removeObject:cell.userID];
        
    }else{
        //如果不在数据中，就加入到删除数组中
        cell.checkImgView.image = [UIImage imageNamed:@"checked"];
        [_deleteMemberIds addObject:cell.userID];
        
    }

}



//覆写父类的方法：返回
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//删除群成员
- (void)deleteAction:(UIButton *)btn{
    if (_deleteMemberIds.count==0) {
        [LeafNotification showInController:self withText:@"你还没有选择要删除的成员"];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除群成员" message:@"删除成员后将自动拒绝其活动报名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定 ", nil];
    [alertView show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        NSLog(@"要删除的id%@",_deleteMemberIds);
        //处理json字符串
//        NSMutableString *mStr = [NSMutableString string];
//        for (int i = 0; i<_deleteMemberIds.count; i++){
//            NSString *tempString = [NSString stringWithFormat:@"\"%@\",",_deleteMemberIds[i]];
//            [mStr appendString:tempString];
//        }
//        NSRange range = {mStr.length-1,1};
//        [mStr deleteCharactersInRange:range];
//        [mStr insertString:@"[" atIndex:0];
//        [mStr insertString:@"]" atIndex:mStr.length];
//        NSLog(@"要删除的id的json形式：%@",mStr);
        [self deleteChatMembers];
        
    }
}



- (void)deleteChatMembers
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //转化为jsono数据
     NSString *memberIdJson = [self JSONStringWithDic:_deleteMemberIds];
    
    NSMutableDictionary *mDic= [NSMutableDictionary dictionary];
    
    [mDic setValue:[_dataDic objectForKey:@"groupId"] forKey:@"groupid"];
    [mDic setValue:memberIdJson forKey:@"uids"];
    NSDictionary *params = [AFParamFormat formatChatForTrenParams:mDic];
    //请求网络
    [AFNetwork getChatMembersDelete:params success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];
            [self performSelector:@selector(doBackAction:) withObject:nil afterDelay:1];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
      [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}



//转化为json数据
- (NSString*)JSONStringWithDic:(NSArray *)diction
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:diction
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


@end
