//
//  ChatDetailViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "ChatDetailOneTableCell.h"
//个人主页
#import "NewMyPageViewController.h"
//举报
#import "McReportViewController.h"
@interface ChatDetailViewController ()

@end

@implementation ChatDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天详情";
    //文字
    _chatArr = @[@[@""], @[@"清空聊天记录"],@[@"添加到黑名单"],@[@"举报"]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestUserInfo];
}


//请求数据
- (void)requestUserInfo
{
    NSString *uid = _mokaID;
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    //请求数据
    [AFNetwork getUserInfo:params success:^(id data) {
        if ([data[@"status"] integerValue] == kRight) {
            _isBlack = [data[@"data"][@"isblack"] boolValue];
            if (_isBlack) {
                _chatArr = @[@[@""], @[@"清空聊天记录"],@[@"从黑名单中移除"],@[@"举报"]];
            }else{
                _chatArr = @[@[@""], @[@"清空聊天记录"],@[@"添加到黑名单"],@[@"举报"]];
            }
            self.mokaNumber = data[@"data"][@"num"];
            self.headerPic = data[@"data"][@"head_pic"];
            [self.tableView reloadData];
        }

    } failed:^(NSError *error) {
    }];
}

#pragma mark UITableViewDelegate
//返回组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _chatArr.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *deatilOneCellID = @"deatilOneCellID";
    NSString *tableCellID = @"tableCellID";
    if (indexPath.section ==0 &&indexPath.row == 0) {
        ChatDetailOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:deatilOneCellID];
        if (cell == nil) {
            cell = [[ChatDetailOneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deatilOneCellID];
        }
        //给一个标识：这是单聊
        cell.isChatGroup = NO;
        //设置头像
        cell.headerPic = _headerPic;
        cell.titleLab.text = _name;
        cell.detailLab.text = [NSString stringWithFormat:@"MOKA号:%@",self.mokaNumber];
        return cell;
        
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID];
        if (cell == nil) {
            cell = [[UITableViewCell  alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text= _chatArr[indexPath.section][indexPath.row];
        return cell;
    }
    return nil;
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        return 80;
    }else{
        return 60;
    }
}

//组视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
    return label;
}

//组视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section ==0) {
        return 0;
    }else{
        return 20;
    }
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //点击第一个单元格
    if (indexPath.section ==0) {
        //进入个人主页
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.sourceVCName = @"chatDetailVC";
        newMyPage.currentTitle = _name;
        newMyPage.currentUid = _mokaID;
        [self.navigationController pushViewController:newMyPage animated:YES];
        
    }else if (indexPath.section == 1){
        //清空聊天记录
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_mokaID
                                                                    conversationType:eConversationTypeChat];
       BOOL clearOK = [conversation removeAllMessages];
       if (clearOK) {
            [self.chatVC.dataSource removeAllObjects];
           [self.chatVC.messages removeAllObjects];
            [self.chatVC.tableView reloadData];
            [LeafNotification showInController:self withText:@"清空聊天记录成功"];
        }else{
            [LeafNotification showInController:self withText:@"清空聊天记录失败"];
        }
    }else if (indexPath.section == 2){
        //屏蔽ta的消息:拉黑
        [self addBlackFriend];
    }else if (indexPath.section == 3){
        //举报
        [self juBao];
    }
}


//拉黑
- (void)addBlackFriend{
    NSString *alertTitle = @"";
    if(_isBlack){
        //从黑名单中移除
        alertTitle = @"确定从黑名单中移除吗";
    }else{
        alertTitle = @"确定加入黑名单吗";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

//举报
- (void)juBao{
    MCJuBaoViewController *jubao = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
    jubao.targetUid = _mokaID;
    [self.navigationController pushViewController:jubao animated:YES];
    
//    McReportViewController *report = [[McReportViewController alloc] init];
//    report.targetUid = _mokaID;
//    [self.navigationController pushViewController:report animated:YES];
}






#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:{
            //执行网络请求所需参数
            NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
            NSString *uid = [userDict valueForKey:@"id"];
            NSString *targetId = _mokaID;
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"to_uid":targetId}];
            NSDictionary *params = [AFParamFormat formatAddBlackInfoParams:dict];
            if (self.isBlack) {
                //从黑名单中移除
                [self actionForAddBlack:NO withParams:params];
            }else{
                //加入黑名单
                [self actionForAddBlack:YES withParams:params];
            }
            break;
        }
        default:
            break;
    }
}


//点击加入黑名单按或者移除黑名单时调用的方法
- (void)actionForAddBlack:(BOOL)add withParams:(NSDictionary *)params{
    if(!add)
    {//已经加入黑名单，从黑名单移除
        [AFNetwork addRemoveBlackInfo:params success:^(id data){
            //NSLog(@"移除黑名单data:%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state isEqualToString:@"0"]) {
                [LeafNotification showInController:self withText:@"移除黑名单成功"];
                _chatArr = @[@[@""], @[@"清空聊天记录"],@[@"加入黑名单"],@[@"举报"]];
                [self.tableView reloadData];
                self.isBlack = NO;
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            [LeafNotification showInController:self withText:@"操作失败"];
        }];
    }else
    {   //不在黑名单中，加入黑名单
        [AFNetwork addBlackInfo:params success:^(id data){
            //NSLog(@"加入黑名单data:%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state isEqualToString:@"0"]) {
                [LeafNotification showInController:self withText:@"加入黑名单成功"];
                _chatArr = @[@[@""], @[@"清空聊天记录"],@[@"从黑名单中移除"],@[@"举报"]];
                [self.tableView reloadData];
                self.isBlack = YES;
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            [LeafNotification showInController:self withText:@"操作失败"];
        }];
    }
}


@end
