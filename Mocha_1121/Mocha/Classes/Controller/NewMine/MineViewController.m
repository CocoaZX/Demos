//
//  MineViewController.m
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "MineViewController.h"
#import "NewHeaderInfoView.h"
#import "McMsgListViewController.h"
#import "McCommitListViewController.h"
#import "SystemMessageViewController.h"
#import "MokaMyActivityController.h"
#import "McSettingViewController.h"
#import "NewTimeLineViewController.h"
#import "MyWalletViewController.h"
#import "YuePaiListViewController.h"
#import "MemberCenterController.h"

#import "MyAcutionListController.h"
//test
#import "BulidPhotoAlbumController.h"

//自定义单元格
#import "MineTableCell.h"

@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSourceArray;

@property (strong, nonatomic) NewHeaderInfoView *headerView;

@property (strong, nonatomic) NSString *sysmsgcount;

@property (strong, nonatomic) NSString *newaccountlogcount;

@property (strong, nonatomic) NSString *newcommentscount;

@property (strong, nonatomic) NSString *memberURL;

@end

@implementation MineViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"me", nil);
    self.sysmsgcount = @"0";
    self.dataSourceArray = @[].mutableCopy;
    
    //初始化数据
    [self _initDataSource];
    //设置表视图
    [self _initTableView];
    //设置导航栏
    [self setNavigationBar];
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLoadDataChatView) name:@"refreshLoadDataChatView" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshThisChatView) name:@"refreshThisChatView" object:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    BOOL isBangDing = UserDefaultGetBool(@"bangding");
    if (!isBangDing) {
        [self.customTabBarController hidesTabBar:NO animated:NO];
     }
    [self requestUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    
}



- (void)_initDataSource{
    //我的模卡
    //    NSMutableDictionary *sectionOne = @{@"sectionTitle":@"  时间",
    //                                        @"cellTitles":@[@"我的模卡"].mutableCopy,
    //                                        @"cellDetails":@[@""].mutableCopy}.mutableCopy;
    NSString *activityStr = NSLocalizedString(@"MyActivity", nil);
    NSString *shootingStr = NSLocalizedString(@"MyShooting", nil);
    NSString *auctionStr = NSLocalizedString(@"MyAuction", nil);
    NSString *orderStr = NSLocalizedString(@"MyOrder", nil);
    
    NSMutableDictionary *sectionTwo =  @{@"sectionTitle":@"  时间",
                                         @"cellTitles":@[activityStr].mutableCopy,
                                         @"cellDetails":@[@""].mutableCopy}.mutableCopy;
    
    
    BOOL isAppearYuePai = UserDefaultGetBool(ConfigYuePai);
    if (isAppearYuePai) {
        sectionTwo =  @{@"sectionTitle":@"  时间",
                        @"cellTitles":@[activityStr,shootingStr,auctionStr,orderStr].mutableCopy,
                        @"cellDetails":@[@"",@"",@"", @""].mutableCopy}.mutableCopy;
    }else
    {
        
    }
    NSString *chatStr = NSLocalizedString(@"chat", nil);
    NSString *commentStr = NSLocalizedString(@"Comment", nil);
    NSString *notifyStr = NSLocalizedString(@"notify", nil);
    
    
    NSMutableDictionary *sectionThree =  @{@"sectionTitle":@"  时间",
                                           @"cellTitles":@[chatStr,commentStr,notifyStr].mutableCopy,
                                           @"cellDetails":@[@"",@"",@""].mutableCopy}.mutableCopy;
    
    
    
    NSMutableDictionary *sectionFour = nil;
    NSString *walletStr = NSLocalizedString(@"wallet", nil);
    NSString *memberCenterStr = NSLocalizedString(@"MemberCenter", nil);
    
    BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
    if (isAppearDaShang) {
        sectionFour = @{@"sectionTitle":@"  时间",
                        @"cellTitles":@[walletStr].mutableCopy,
                        @"cellDetails":@[@""].mutableCopy}.mutableCopy;
        
    }else
    {
    }
    
    
    
    //是否显示会员
    BOOL isAppearBuyMember = UserDefaultGetBool(ConfigShang);
    if (isAppearBuyMember) {
        if (isAppearDaShang) {
            sectionFour = @{@"sectionTitle":@"  时间",
                            @"cellTitles":@[walletStr,memberCenterStr].mutableCopy,
                            @"cellDetails":@[@"",@""].mutableCopy}.mutableCopy;
            
        }else
        {
            sectionFour = @{@"sectionTitle":@"  时间",
                            @"cellTitles":@[memberCenterStr].mutableCopy,
                            @"cellDetails":@[@""].mutableCopy}.mutableCopy;
        }
        
        
    }else
    {
        
    }
    
    // [self.dataSourceArray addObject:sectionOne];
    if (sectionFour) {
        [self.dataSourceArray addObject:sectionFour];
    }
    
    [self.dataSourceArray addObject:sectionThree];
    [self.dataSourceArray addObject:sectionTwo];

}


- (void)_initTableView{
    //tableView及HeadView
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64 - 40);
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64 -kTabBarHeight);
    }
    self.headerView = [NewHeaderInfoView getNewHeaderInfoView];
    self.headerView.supCon = self;
    self.tableView.tableHeaderView = self.headerView;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }

    //首先使用沙盒中用户信息显示头像等,避免在无网状态下显示空
    [self.headerView initHeadViewWithMokaValue];
    
}



- (void)setNavigationBar{
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 50, 44)];
    NSString *title = NSLocalizedString(@"setting", nil);
    [rightButton setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"设置"]) {
        rightButton.frame = CGRectMake(40, 0, 44, 44);
    }
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(settingMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    [self.navigationItem setLeftBarButtonItem:nil];
    
}



//移除通知
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshLoadDataChatView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshThisChatView" object:nil];
}










#pragma mark - 数据刷新

//刷新头部视图
- (void)refreshLoadDataChatView
{
    [self requestUserInfo];
}

//数显tableView
- (void)refreshThisChatView
{
    [self.tableView reloadData];
}



#pragma mark - 获取数据
//请求网络更新用户信息
- (void)requestUserInfo
{
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
     NSDictionary *params = [AFParamFormat formatGetUserInfoParams:cuid];
    [AFNetwork getUserInfo:params success:^(id data){
        NSLog(@"%@",data);
        if ([data[@"status"] integerValue] == kRight) {
            //UserInfo *info = [[UserInfo alloc] initWithDictionary:data error:NULL];
            //重新设置表头视图
            [self setUpHeaderViewWith:data[@"data"]];
            //打开会员中心的链接
             self.memberURL = getSafeString(data[@"data"][@"ucUrl"]);

            NSDictionary *diction = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
            NSMutableDictionary *userDic = diction.mutableCopy;
            NSString *isShowVideo = getSafeString(data[@"data"][@"is_show_video"]) ;
            NSString *typeName = getSafeString(data[@"data"][@"typeName"]) ;

            if (isShowVideo.length == 0 || !isShowVideo) {
                isShowVideo = @"0";
            }
            [userDic setObject:isShowVideo forKey:@"is_show_video"];
            [userDic setObject:typeName forKey:@"typeName"];

            [USER_DEFAULT setObject:userDic.copy forKey:MOKA_USER_VALUE];
//            [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] setObject:data[@"data"][@"is_show_video"] forKey:@"is_show_video"];
            
            //保存服务器需要在当前App显示的视图设置
            NSDictionary *serviceAlertDiction = data[@"data"][@"popup"];
            NSLog(@"serviceAlertDiction:%@",serviceAlertDiction);
            if(serviceAlertDiction){
                [self requestAndSaveNotificationImage:serviceAlertDiction];
                [USER_DEFAULT setObject:serviceAlertDiction forKey:@"serviceAlertDiction"];
                [USER_DEFAULT synchronize];
            }
         }else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
         [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

//请求网络之后设置视图
- (void)setUpHeaderViewWith:(NSDictionary *)diction
{
    NSString *headerUrl = [NSString stringWithFormat:@"%@",getSafeString(diction[@"head_pic"])];
    NSString *name = [NSString stringWithFormat:@"%@",getSafeString(diction[@"nickname"])];
    NSString *sex = [NSString stringWithFormat:@"    %@",getSafeString(diction[@"sexName"])];
    NSString *userType = [NSString stringWithFormat:@"%@",getSafeString(diction[@"typeName"])];
    NSString *dongtai = [NSString stringWithFormat:@"%@",getSafeString(diction[@"trendscount"])];
    NSString *guanzhu = [NSString stringWithFormat:@"%@",getSafeString(diction[@"followcount"])];
    NSString *fensi = [NSString stringWithFormat:@"%@",getSafeString(diction[@"fanscount"])];
    
    //改为只显示市
//    NSString *address = [NSString stringWithFormat:@"%@ %@",getSafeString(diction[@"provinceName"]),getSafeString(diction[@"cityName"])];
    NSString *address = [NSString stringWithFormat:@"%@",getSafeString(diction[@"cityName"])];
    
    
    //新系统信息
    self.sysmsgcount = [NSString stringWithFormat:@"%@",getSafeString(diction[@"sysmsgcount"])];
    [USER_DEFAULT setObject:self.sysmsgcount forKey:@"unreadSystemMessage"];
    [USER_DEFAULT synchronize];
    
    self.newaccountlogcount = [NSString stringWithFormat:@"%@",getSafeString(diction[@"newaccountlogcount"])];
    
    //新评论
    self.newcommentscount = [NSString stringWithFormat:@"%@",getSafeString(diction[@"newcommentscount"])];
    [USER_DEFAULT setObject:self.newcommentscount forKey:@"unreadCommentCount"];
    [USER_DEFAULT synchronize];
    //更新未读消息数字
    [self.customTabBarController setupUnreadMessageCount];
    
    NSString *newFansCount = getSafeString(diction[@"newfanscount"]);
    NSDictionary *data = @{@"headerUrl":headerUrl,
                           @"name":name,
                           @"sex":sex,
                           @"userType":userType,
                           @"dongtai":dongtai,
                           @"guanzhu":guanzhu,
                           @"fensi":fensi,
                           @"newFansCount":newFansCount,
                           @"address":address};
    
    [self.headerView initViewWithData:data withDic:diction];
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
    //获取将要显示的内容
    NSArray *cells = self.dataSourceArray[indexPath.section][@"cellTitles"];
    NSArray *details = self.dataSourceArray[indexPath.section][@"cellDetails"];
    
    BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
    NSInteger sec0 = 0;
    NSInteger sec1 = 1;
    NSInteger sec2 = 2;
    
    if (isAppearDaShang) {
        sec0 = 0;
        sec1 = 1;
        sec2 = 2;
    }else{
        sec0 = 678;
        sec1 = 0;
        sec2 = 1;
    }
    
    
    //修改部分
    //0.我的钱包
    if(indexPath.section == sec0){
        if (indexPath.row==0) {
            MineTableCell *cell = (MineTableCell *)[self getCellWithTable:tableView isCustomCell:YES];
            cell.textLabel.text = getSafeString(cells[indexPath.row]);
            cell.detailTextLabel.text = getSafeString(details[indexPath.row]);
            if ([self.newaccountlogcount intValue]==0) {
                cell.badgeLabel.hidden  =YES;
                cell.redView.hidden = YES;
            }else
            {
                cell.badgeLabel.hidden  = YES;
                cell.redView.hidden = NO;
            }
            
            return cell;
        }else{
            UITableViewCell *cell = [self getCellWithTable:tableView isCustomCell:NO];
            cell.textLabel.text = getSafeString(cells[indexPath.row]);
            cell.detailTextLabel.text = getSafeString(details[indexPath.row]);
            return cell;
        }
        
    }
    
//    //1.
//    else if (indexPath.section == 1){
//        UITableViewCell *cell = [self getCellWithTable:tableView isCustomCell:NO];
//        cell.textLabel.text = getSafeString(cells[indexPath.row]);
//        cell.detailTextLabel.text = getSafeString(details[indexPath.row]);
//        return cell;
//     }
    
    //2.私信、评论、通知
    else if (indexPath.section == sec1){
        MineTableCell *cell = (MineTableCell *)[self getCellWithTable:tableView isCustomCell:YES];
        cell.textLabel.text = getSafeString(cells[indexPath.row]);
        cell.detailTextLabel.text = getSafeString(details[indexPath.row]);
         //私信
        if (indexPath.row==0) {
            NSArray *conversations = [[[EaseMob sharedInstance] chatManager] conversations];
            NSInteger unreadCount = 0;
            for (EMConversation *conversation in conversations) {
                unreadCount += conversation.unreadMessagesCount;
            }
            if(unreadCount>0)
            {
                cell.badgeLabel.hidden = NO;
                cell.redView.hidden = YES;
                cell.badgeLabel.text = [NSString stringWithFormat:@"%i",(int)unreadCount];
                //设置未读数
                /*
                 if (unreadCount < 9) {
                    cell.badgeLabel.font = [UIFont systemFontOfSize:13];
                }else if(unreadCount > 9 && unreadCount < 99){
                    cell.badgeLabel.font = [UIFont systemFontOfSize:12];
                }else{
                    cell.badgeLabel.font = [UIFont systemFontOfSize:10];
                    cell.badgeLabel.text = @"99+";
                }
                */
                
             }else
            {
                cell.badgeLabel.hidden = YES;
                cell.redView.hidden = YES;
             }
        }
        //评论
        if (indexPath.row==1) {
            if ([self.newcommentscount integerValue]==0) {
                cell.badgeLabel.hidden  =YES;
                cell.redView.hidden = YES;
             }else
            {
                cell.redView.hidden = YES;
                cell.badgeLabel.hidden = NO;
                cell.badgeLabel.text = self.newcommentscount;
                
             }
        }
        //通知
        if (indexPath.row==2) {
            
            if ([self.sysmsgcount isEqualToString:@"0"]) {
                cell.badgeLabel.hidden  =YES;
                cell.redView.hidden = YES;
             }else
            {
                cell.badgeLabel.hidden  =NO;
                cell.badgeLabel.text = self.sysmsgcount;
                cell.redView.hidden = YES;
                
             }
        }
        return cell;
    }
    //3.我的活动，我的约拍：2row
    else if (indexPath.section == sec2){
        UITableViewCell *cell = [self getCellWithTable:tableView isCustomCell:NO];
        cell.textLabel.text = getSafeString(cells[indexPath.row]);
        cell.detailTextLabel.text = getSafeString(details[indexPath.row]);
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
    NSInteger sec0 = 0;
    NSInteger sec1 = 1;
    NSInteger sec2 = 2;
    
    if (isAppearDaShang) {
        sec0 = 0;
        sec1 = 1;
        sec2 = 2;
    }else{
        sec0 = 678;
        sec1 = 0;
        sec2 = 1;
    }
    
    //0.我的模卡
    if(indexPath.section == 999){
        //进入我的模卡
        NSString *userName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        [self.navigationController pushViewController:newMyPage animated:YES];
    }
    //1.我的钱包
    else if (indexPath.section == sec0){
        switch (indexPath.row) {
            case 0:     //我的钱包
            {
                MyWalletViewController *listVC = [[MyWalletViewController alloc] initWithNibName:@"MyWalletViewController" bundle:nil];
                
                
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
            case 1:     //会员中心
            {
                
                MemberCenterController *listVC = [[MemberCenterController alloc] initWithNibName:@"MemberCenterController" bundle:nil];
                
                listVC.linkUrl = self.memberURL;
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    //2.私信、评论、通知
    else if (indexPath.section == sec1){
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
    //3.我的活动
    else if (indexPath.section == sec2){
        switch (indexPath.row) {
            case 0: //我的活动
            {
                 MokaMyActivityController *myListVC = [[MokaMyActivityController alloc] init];
                [self.navigationController pushViewController:myListVC animated:YES];
                
            }
                break;
                
            case 1: //我的约拍
            {
                YuePaiListViewController *listVC = [[YuePaiListViewController alloc] initWithNibName:@"YuePaiListViewController" bundle:nil];
                listVC.isNeedPay = NO;
                [self.navigationController pushViewController:listVC animated:YES];
                
            }
                break;
            case 2: //我的竞拍
            {
                MyAcutionListController *myAcutionListVC = [[MyAcutionListController alloc] initWithNibName:@"MyAcutionListController" bundle:nil];
                [self.navigationController pushViewController:myAcutionListVC animated:YES];
            }
                break;

            case 3://套系
            {
                YuePaiListViewController *listVC = [[YuePaiListViewController alloc] initWithNibName:@"YuePaiListViewController" bundle:nil];
                listVC.isNeedPay = NO;
                listVC.isTaoXi = YES;
                [self.navigationController pushViewController:listVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}


//获取单元格
- (UITableViewCell *)getCellWithTable:(UITableView *)tableView isCustomCell:(BOOL)isCustomCell{
    
    if (!isCustomCell) {
        //如果是普通单元格
        NSString *identifier = @"ActivityCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;

    }else{
        //需要使用自定义单元格
        NSString *mineCellID  = @"MineTableCellID";
        MineTableCell *cell = [tableView dequeueReusableCellWithIdentifier:mineCellID];
        if (cell == nil) {
            cell = [[MineTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:mineCellID];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         }
        //恢复初始化
        cell.badgeLabel.hidden = YES;
        cell.redView.hidden =YES;
        return cell;
    }
}








#pragma mark - 请求首页弹窗需要的图片
- (void)requestAndSaveNotificationImage:(NSDictionary *)diction{
    NSString *imgStr = diction[@"value"];
    if (imgStr.length == 0) {
        return;
    }
    
     NSString *jpg = [NSString stringWithFormat:@"@1e_%@w_1c_0i_1o_90Q_1x.jpg",[NSNumber numberWithInteger:kDeviceWidth*2]];
    NSString *completeString =[NSString stringWithFormat:@"%@%@",imgStr,jpg];
    UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:completeString];
    if (cachedImage) {
        //已经存在就不再下载图片
    }else{
        //没有缓存过此图片，将广告页图片缓存到本地
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:completeString] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            //
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //
        }];
    }
}


@end
