//
//  ChatDetailGroupViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ChatDetailGroupViewController.h"
#import "ChatDetailOneTableCell.h"
#import "ChatDetailTwoTableCell.h"
#import "ChatDetailThreeTableCell.h"
#import "MokaActivityDetailViewController.h"
#import "McReportViewController.h"
#import "MCJuBaoViewController.h"

@interface ChatDetailGroupViewController ()<UIAlertViewDelegate>

@end

@implementation ChatDetailGroupViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天详情";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //添加底部(退出群聊)视图
    UIView *footerview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 80)];
    UIButton *exitGroupBtn  =[[UIButton alloc] initWithFrame:CGRectMake(10, 20, kDeviceWidth - 20, 50)];
    [exitGroupBtn addTarget:self action:@selector(exitGroupBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [exitGroupBtn setTitle:@"退出群聊" forState:UIControlStateNormal];
    exitGroupBtn.backgroundColor = [UIColor colorWithRed: 224/255.0 green:84/255.0 blue:96/255.0 alpha:1];    [footerview addSubview:exitGroupBtn];
    self.tableView.tableFooterView = footerview;
    
    //视图选项
    _chatArr = @[@[@""],@[@""], @[@"清空聊天记录"],@[@"群消息免打扰"],@[@"举报"]];
    
    //群主成员
    _members = [NSMutableArray array];
    
}


//视图将要显示的时候
- (void)viewWillAppear:(BOOL)animated{
    //请求数据
    [self loadData];
    [super viewWillAppear:animated];
}



#pragma mark 表视图代理：UITableViewDelegate

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
        //群介绍
        ChatDetailOneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:deatilOneCellID];
        if (cell == nil) {
            cell = [[ChatDetailOneTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deatilOneCellID];
        }
        cell.isChatGroup = YES;
        //群主题
        cell.titleLab.text =_dataDic[@"data"][@"groupName"] ;
        //群费用
        cell.detailLab.text = [NSString stringWithFormat:@"费用: %@",getSafeString(_dataDic[@"data"][@"payment"])];
        return cell;
        
    }else if(indexPath.section ==1 &&indexPath.row == 0){
        //群成员
        ChatDetailThreeTableCell *cell = [[ChatDetailThreeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        
        //成员数组
        //cell.memberArr = _members;
        //视图控制器
        cell.chatDetailGroupVC = self;
        cell.dataDic = [self.dataDic objectForKey:@"data"];
        //cell.groupID = _chatter;
        //判断是否是群主
        return cell;
        
    }else if(indexPath.section ==3 &&indexPath.row == 0){
        //消息免打扰
        ChatDetailTwoTableCell *cell = [[ChatDetailTwoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.textLabel.text = @"群消息免打扰";
        cell.chatGropupVC = self;
//        //是不是群主：群主必须开启
//        NSNumber *isOwer = _dataDic[@"data"][@"isOwer"];
//        cell.isOwer = [isOwer integerValue];
        //设置群号
        cell.groupID = _chatter;
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
    }else if(indexPath.section == 1){
    
    CGFloat cellwidth = (kDeviceWidth-(10*6))/5;
    NSArray *members = [_dataDic objectForKey:@"data"][@"members"];
    int count =(int) members.count;
    //群主多了一个删除按钮
    BOOL isOwner = NO;
    NSString *idd = [members[0] objectForKey:@"id"];
    NSString *uid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    if ([uid isEqualToString:idd]) {
        isOwner = YES;
    }else{
        isOwner = NO;
    }
    if (isOwner) {
        //是群主
        count++;
    }
        
    //计算行数
    int row = 0;
    if ((count % 5) == 0) {
        row = count/5;
    }else{
        row = count/5 +1;
    }
    return row * (cellwidth + 10)+10+30 ;
        
    }else{
        return 60;
    }
}

//组视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
    //[label setBackgroundColor:[CommonUtils colorFromHexString:kLikeLightGrayColor]];
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
    if (indexPath.section ==0) {
        //进入活动详情
        MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
        mokaDetailVC.eventId = getSafeString(_dataDic[@"data"][@"eventId"]);
        /*
        //判断当前活动类型
        NSString *type = _dataDic[@"data"][@"type"];
        if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
            mokaDetailVC.vcTitle = @"通告详情";
        }else if([type isEqualToString:@"5"]){
            mokaDetailVC.vcTitle = @"众筹活动";
        }else if ([type isEqualToString:@"6"]){
            mokaDetailVC.vcTitle = @"海报活动";
        }
        */
        [self.navigationController pushViewController:mokaDetailVC animated:YES];
    }else if (indexPath.section == 2){
        //清空聊天记录
        EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_chatter
                                                                                   conversationType:eConversationTypeChat];
        BOOL clearOK = [conversation removeAllMessages];
        if (clearOK) {
            [self.chatVC.dataSource removeAllObjects];
            [self.chatVC.tableView reloadData];
            [LeafNotification showInController:self withText:@"清空聊天记录成功"];
        }else{
            [LeafNotification showInController:self withText:@"清空聊天记录失败"];
        }
    }else if (indexPath.section == 4){
        //举报
        MCJuBaoViewController *jubao = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
        jubao.groupID = _chatter;
        [self.navigationController pushViewController:jubao animated:YES];
        
//        McReportViewController *report = [[McReportViewController alloc] init];
//        report.groupID = _chatter;
//        [self.navigationController pushViewController:report animated:YES];
    }
}


#pragma mark 请求活动详情数据
- (void)loadData{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:_chatter forKey:@"groupid"];
    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork eventInfoWithGroupID:param success:^(id data) {
//         NSLog(@"%@",data);
        if([data[@"status"] integerValue] == kRight){
            //获取外层字典
            _dataDic = data;
            //获取所有成员
            _members = [_dataDic objectForKey:@"data"][@"members"];
            [self.tableView reloadData];
        }
    } failed:^(NSError *error) {
        NSLog(@"eventInfoWithGroupID:%@",error);
    }];

}



#pragma mark - 退出群聊
- (void)exitGroupBtnClick:(UIButton *)btn{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您将要退出群聊" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        
    }else{
        //发送退出群聊的请求
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
        [dict setValue:_chatter forKey:@"groupid"];
        NSDictionary *params = [AFParamFormat formatEventListParams:dict];
        
        [AFNetwork exitChatGroupWithPost:params success:^(id data) {
//            NSLog(@"退出群聊data：%@",data);
            //准备退出群聊详情界面
            [self prepareBack];
            NSString *msg = [data objectForKey:@"msg"];
            [LeafNotification showInController:self withText:msg];
            [self performSelector:@selector(popToOrignalPage) withObject:nil afterDelay:1.3];
        } failed:^(NSError *error) {
            [LeafNotification showInController:self withText:@"操作失败"];
        }];
    }
}

//执行pop之前的一些操作
- (void)prepareBack{
    //添加遮罩视图，不能再次点击界面上的其他操作
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:view];
    
    //退出群聊之前，移除其中的聊天界面，退出群聊之后就不在显示聊天界面

    NSMutableArray *controllers = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id viewController = self.navigationController.childViewControllers[i];
        if ([viewController isKindOfClass:[ChatViewController class]]) {
            [controllers removeObject:viewController];
        }
    }
    [self.navigationController setViewControllers:controllers];
}

- (void)popToOrignalPage{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
