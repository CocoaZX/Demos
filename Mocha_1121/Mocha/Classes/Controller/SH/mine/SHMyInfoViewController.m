//
//  SHMyInfoViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "SHMyInfoViewController.h"
#import "NewHeaderInfoView.h"
#import "McMsgListViewController.h"
#import "McCommitListViewController.h"
#import "SystemMessageViewController.h"
#import "NewMyActivityViewController.h"
#import "McSettingViewController.h"
#import "NewTimeLineViewController.h"
#import "MyWalletViewController.h"
#import "YuePaiListViewController.h"

@interface SHMyInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NewHeaderInfoView *headerView;

@property (strong, nonatomic) NSString *sysmsgcount;

@property (strong, nonatomic) NSString *newaccountlogcount;

@property (strong, nonatomic) NSString *newcommentscount;

@end

@implementation SHMyInfoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.customTabBarController hidesTabBar:NO animated:NO];
    [self requestUserInfo];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.customTabBarController hidesTabBar:YES animated:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"我";
    self.sysmsgcount = @"0";
    self.dataSourceArray = @[].mutableCopy;
    NSMutableDictionary *sectionOne = @{@"sectionTitle":@"  时间",
                                        @"cellTitles":@[@"我的模卡"].mutableCopy,
                                        @"cellDetails":@[@""].mutableCopy}.mutableCopy;
    
    NSMutableDictionary *sectionTwo =  @{@"sectionTitle":@"  时间",
                                         @"cellTitles":@[@"我的活动"].mutableCopy,
                                         @"cellDetails":@[@""].mutableCopy}.mutableCopy;
    
    NSMutableDictionary *sectionThree =  @{@"sectionTitle":@"  时间",
                                           @"cellTitles":@[@"私信&群聊",@"评论",@"通知"].mutableCopy,
                                           @"cellDetails":@[@"",@"",@""].mutableCopy}.mutableCopy;
    
    NSMutableDictionary *sectionFour = nil;
    
    BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
    if (isAppearDaShang) {
        sectionFour = @{@"sectionTitle":@"  时间",
                        @"cellTitles":@[@"我的钱包"].mutableCopy,
                        @"cellDetails":@[@""].mutableCopy}.mutableCopy;
        
    }else
    {
        
        
    }
    
    BOOL isAppearYuePai = UserDefaultGetBool(ConfigYuePai);
    if (isAppearYuePai) {
        sectionTwo =  @{@"sectionTitle":@"  时间",
                        @"cellTitles":@[@"我的活动",@"我的约拍"].mutableCopy,
                        @"cellDetails":@[@"",@""].mutableCopy}.mutableCopy;
        
    }else
    {
        
        
    }
    
    [self.dataSourceArray addObject:sectionOne];
    [self.dataSourceArray addObject:sectionTwo];
    [self.dataSourceArray addObject:sectionThree];
    if (sectionFour) {
        [self.dataSourceArray addObject:sectionFour];

    }
    
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.headerView = [NewHeaderInfoView getNewHeaderInfoView];
    self.headerView.supCon = self;
    self.tableView.tableHeaderView = self.headerView;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 44, 44)];
    [rightButton setTitle:@"设置" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(settingMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem setLeftBarButtonItem:nil];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoadDataChatView) name:@"refreshLoadDataChatView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshThisChatView) name:@"refreshThisChatView" object:nil];
}

- (void)refreshLoadDataChatView
{
    [self requestUserInfo];
}

- (void)refreshThisChatView
{
    [self.tableView reloadData];
}

- (void)requestUserInfo
{
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:cuid];
    [AFNetwork getUserInfo:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            [self setUpHeaderViewWith:data[@"data"]];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        //[LeafNotification showInController:self withText:error.description];
        [LeafNotification showInController:self withText:@"网络连接失败"];
        
    }];
    
    
}

- (void)setUpHeaderViewWith:(NSDictionary *)diction
{
    NSString *headerUrl = [NSString stringWithFormat:@"%@",normaliseString(diction[@"head_pic"])];
    NSString *name = [NSString stringWithFormat:@"%@",normaliseString(diction[@"nickname"])];
    NSString *sex = [NSString stringWithFormat:@"    %@",normaliseString(diction[@"sexName"])];
    NSString *userType = [NSString stringWithFormat:@"%@",normaliseString(diction[@"typeName"])];
    NSString *dongtai = [NSString stringWithFormat:@"%@",normaliseString(diction[@"trendscount"])];
    NSString *guanzhu = [NSString stringWithFormat:@"%@",normaliseString(diction[@"followcount"])];
    NSString *fensi = [NSString stringWithFormat:@"%@",normaliseString(diction[@"fanscount"])];
    self.sysmsgcount = [NSString stringWithFormat:@"%@",normaliseString(diction[@"sysmsgcount"])];
    self.newaccountlogcount = [NSString stringWithFormat:@"%@",normaliseString(diction[@"newaccountlogcount"])];
    self.newcommentscount = [NSString stringWithFormat:@"%@",normaliseString(diction[@"newcommentscount"])];
    
    NSDictionary *data = @{@"headerUrl":headerUrl,
                           @"name":name,
                           @"sex":sex,
                           @"userType":userType,
                           @"dongtai":dongtai,
                           @"guanzhu":guanzhu,
                           @"fensi":fensi};
    
    [self.headerView initViewWithData:data];
    [self.tableView reloadData];
}

//点击设置按钮
- (void)settingMethod
{
    NSLog(@"settingMethod");
    McSettingViewController *setVC = [[McSettingViewController alloc] init];
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
    [self.navigationController pushViewController:setVC animated:YES];
    
}

#pragma mark - tableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSourceArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *cells = self.dataSourceArray[section][@"cellTitles"];
    return cells.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 20.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ActivityCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSArray *cells = self.dataSourceArray[indexPath.section][@"cellTitles"];
    NSArray *details = self.dataSourceArray[indexPath.section][@"cellDetails"];
    
    //修改部分
    //0.我的模卡
    if(indexPath.section == 0){
        cell.textLabel.text = normaliseString(cells[indexPath.row]);
        cell.detailTextLabel.text = normaliseString(details[indexPath.row]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //1.我的活动,我的约拍
    else if (indexPath.section == 1){
        cell.textLabel.text = normaliseString(cells[indexPath.row]);
        cell.detailTextLabel.text = normaliseString(details[indexPath.row]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //2.私信、评论、通知
    else if (indexPath.section == 2){
        cell.textLabel.text = normaliseString(cells[indexPath.row]);
        cell.detailTextLabel.text = normaliseString(details[indexPath.row]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //私信
        if (indexPath.row==0) {
            NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
            NSInteger unreadCount = 0;
            for (EMConversation *conversation in conversations) {
                unreadCount += conversation.unreadMessagesCount;
            }
            if(unreadCount>0)
            {
                UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-57, 17, 20, 20)];
                [badgeLabel setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
                [badgeLabel.layer setCornerRadius:10];
                [badgeLabel.layer setMasksToBounds:YES];
                badgeLabel.font = [UIFont systemFontOfSize:12];
                badgeLabel.text = [NSString stringWithFormat:@"%i",(int)unreadCount];
                badgeLabel.textAlignment = NSTextAlignmentCenter;
                badgeLabel.textColor = [UIColor whiteColor];
                [badgeLabel setHidden:NO];
                [cell addSubview:badgeLabel];
            }else
            {
                UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-57, 15, 25, 25)];
                [badgeLabel setBackgroundColor:[UIColor whiteColor]];
                [badgeLabel.layer setCornerRadius:10];
                [badgeLabel.layer setMasksToBounds:YES];
                badgeLabel.font = [UIFont systemFontOfSize:12];
                badgeLabel.text = [NSString stringWithFormat:@"%i",(int)unreadCount];
                badgeLabel.textAlignment = NSTextAlignmentCenter;
                badgeLabel.textColor = [UIColor whiteColor];
                [badgeLabel setHidden:NO];
                [cell addSubview:badgeLabel];
            }
        }
        //评论
        if (indexPath.row==1) {
            if ([self.newcommentscount intValue]==0) {
                UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-46, 21, 15, 15)];
                redView.backgroundColor = [UIColor whiteColor];
                redView.layer.cornerRadius = 5;
                redView.clipsToBounds = YES;
                [cell addSubview:redView];
            }else
            {
                UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-45, 22, 10, 10)];
                redView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
                redView.layer.cornerRadius = 5;
                redView.clipsToBounds = YES;
                [cell addSubview:redView];
            }
        }
        //通知
        if (indexPath.row==2) {
            if ([self.sysmsgcount isEqualToString:@"0"]) {
                UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-46, 21, 15, 15)];
                redView.backgroundColor = [UIColor whiteColor];
                redView.layer.cornerRadius = 5;
                redView.clipsToBounds = YES;
                [cell addSubview:redView];
            }else
            {
                UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-45, 22, 10, 10)];
                redView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
                redView.layer.cornerRadius = 5;
                redView.clipsToBounds = YES;
                [cell addSubview:redView];
            }
        }
    }
    //3.我的钱包
    else if (indexPath.section == 3){
        cell.textLabel.text = normaliseString(cells[indexPath.row]);
        cell.detailTextLabel.text = normaliseString(details[indexPath.row]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([self.newaccountlogcount intValue]==0) {
            UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-46, 21, 15, 15)];
            redView.backgroundColor = [UIColor whiteColor];
            redView.layer.cornerRadius = 5;
            redView.clipsToBounds = YES;
            [cell addSubview:redView];
        }else
        {
            UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-45, 22, 10, 10)];
            redView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
            redView.layer.cornerRadius = 5;
            redView.clipsToBounds = YES;
            [cell addSubview:redView];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    //0.我的模卡
    if(indexPath.section == 0){
        //进入我的模卡
        NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        [self.navigationController pushViewController:newMyPage animated:YES];
    }
    //1.我的活动,我的约拍
    else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0: //我的活动
            {
                NewMyActivityViewController *listVC = [[NewMyActivityViewController alloc] initWithNibName:@"NewMyActivityViewController" bundle:nil];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
                
            }
                break;
                
            case 1: //我的约拍
            {
                YuePaiListViewController *listVC = [[YuePaiListViewController alloc] initWithNibName:@"YuePaiListViewController" bundle:nil];
                
                listVC.isNeedPay = NO;
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
                
            default:
                break;
        }
        
    }
    //2.私信、评论、通知
    else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:     //私信
            {
                McMsgListViewController *listVC = [[McMsgListViewController alloc] init];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
            case 1:     //评论
            {
                McCommitListViewController *listVC = [[McCommitListViewController alloc] init];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
                
            }
                break;
            case 2:     //通知
            {
                SystemMessageViewController *listVC = [[SystemMessageViewController alloc] initWithNibName:@"SystemMessageViewController" bundle:nil];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    //3.我的钱包
    else if (indexPath.section == 3){
        switch (indexPath.row) {
            case 0:     //我的钱包
            {
                MyWalletViewController *listVC = [[MyWalletViewController alloc] initWithNibName:@"MyWalletViewController" bundle:nil];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}






@end
