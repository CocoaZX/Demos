//
//  SystemMessageViewController.m
//  Mocha
//
//  Created by 小猪猪 on 15/2/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageTableViewCell.h"
#import "UIScrollView+MJRefresh.h"
#import "YuePaiDetailViewController.h"
#import "SystemUrlViewController.h"
#import "SystemContentViewController.h"
#import "MCJingpaiDetailController.h"
#import "PhotoViewDetailController.h"

#import "MokaActivityDetailViewController.h"

@interface SystemMessageViewController ()

@property (nonatomic, strong) NSMutableArray *sysMessageArray;

@property (nonatomic, strong) UILabel *headerLabel;

@property (nonatomic, strong) NSString *lastIndex;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"systemNotify", nil);
    self.lastIndex = @"";
    [self addTableHeaderView];
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    [self getSystemMessageList];
    [self addHeader];
    self.mainTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
}

- (void)addTableHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    headerView.backgroundColor = RGB(240, 240, 240);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.textColor = [UIColor lightGrayColor];
    titleLabel.text = @"全部系统消息：";
    [headerView addSubview:titleLabel];
    self.headerLabel = titleLabel;
    self.mainTableView.tableHeaderView = headerView;
}

- (void)getSystemMessageList
{
    NSMutableDictionary *diction = @{}.mutableCopy;
    [diction setObject:self.lastIndex forKey:@"lastindex"];
    [diction setObject:@"20" forKey:@"pagesize"];
    NSDictionary *params = [AFParamFormat formatSystemMessageParams:diction];
    [AFNetwork getSystemMessageList:params success:^(id data){
        NSLog(@"%@",data);
        self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
        NSArray *dataArray = data[@"data"];
        self.headerLabel.text = [NSString stringWithFormat:@"全部系统消息(%lu)：",(unsigned long)dataArray.count];
        self.sysMessageArray = [NSMutableArray arrayWithArray:dataArray];
        [self.mainTableView reloadData];
        [self.mainTableView headerEndRefreshing];
        [self.mainTableView footerEndRefreshing];
        [SingleData shareSingleData].isAppearRedPoint = NO;
    }failed:^(NSError *error){
        
    }];
}

#pragma mark private

- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [self.mainTableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        vc.lastIndex = @"";
        [self getSystemMessageList];
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sysMessageArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float finalHeight = 50;
    NSDictionary *diction = self.sysMessageArray[indexPath.row];

    NSString *content = diction[@"content"];
    
    CGFloat height = [CommonUtils sizeFromText:content textFont:kFont15 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kScreenWidth - 30, MAXFLOAT)].height;
    
    if (height > 0) {
        finalHeight = finalHeight + height;
    }else
    {
        finalHeight = 60;
    }
    
    return finalHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"SystemMessageTableViewCell";
    SystemMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SystemMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *diction = self.sysMessageArray[indexPath.row];
//    NSLog(@"%@",diction );
    cell.dataDic = diction;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //新系统消息
    SystemMessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *diction = self.sysMessageArray[indexPath.row];
    NSString *type = [NSString stringWithFormat:@"%@",diction[@"type"]];
    if ([type isEqualToString:@"1"]) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
//            //新聊天消息
//            McChatRoomViewController *chatVC = [[McChatRoomViewController alloc] initWithOtherUserId:diction[@"nid"] isReadMsg:YES];
//            //        chatVC.headPic = diction[@"head_pic"];
//            //        chatVC.title = diction[@"nickname"];
//            [self.navigationController pushViewController:chatVC animated:YES];
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            
        }
        
    }
    else if ([type isEqualToString:@"2"])
    {
        //个人主页
        NSString *userName = @"";
        NSString *uid = diction[@"nid"];
        
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        [self.customTabBarController hidesTabBar:YES animated:NO];
        
        [self.navigationController pushViewController:newMyPage animated:YES];
    
    }
    else if ([type isEqualToString:@"3"])
    {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

        //照片详情页
        PhotoViewDetailController *photoDetailVC = [[PhotoViewDetailController alloc] init];
        [photoDetailVC requestWithPhotoId:diction[@"nid"] uid:uid];
        [self.navigationController pushViewController:photoDetailVC animated:YES];
    }
    else if ([type isEqualToString:@"11"])
    {
        //视频
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
        [detailVc requestWithVideoId:diction[@"nid"] uid:uid];
        [self.navigationController pushViewController:detailVc animated:YES];
    }

    else if ([type isEqualToString:@"4"])
    {
        //URL（Web页面）
        SystemUrlViewController *urlcontrol = [[SystemUrlViewController alloc] initWithNibName:@"SystemUrlViewController" bundle:[NSBundle mainBundle]];
        urlcontrol.urlString = [NSString stringWithFormat:@"%@",diction[@"url"]];
        urlcontrol.title = [NSString stringWithFormat:@"%@",diction[@"title"]];
        [self.navigationController pushViewController:urlcontrol animated:YES];
        
    }else if ([type isEqualToString:@"5"])
    {
        //活动详情
        MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
        mokaDetailVC.eventId = getSafeString(diction[@"nid"]);
        //判断当前活动类型
        NSString *type = diction[@"type"];
        if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
            mokaDetailVC.vcTitle = @"通告详情";
        }else if([type isEqualToString:@"5"]){
            mokaDetailVC.vcTitle = @"众筹活动";
        }else if ([type isEqualToString:@"6"]){
            mokaDetailVC.vcTitle = @"活动海报";
        }
        
        [self.navigationController pushViewController:mokaDetailVC animated:YES];
    }
    else if ([type isEqualToString:@"6"])
    {
        
        SystemContentViewController *contentcontrol = [[SystemContentViewController alloc] initWithNibName:@"SystemContentViewController" bundle:[NSBundle mainBundle]];
        contentcontrol.contentStr = [NSString stringWithFormat:@"%@",diction[@"content"]];
        contentcontrol.titleStr = [NSString stringWithFormat:@"%@",diction[@"title"]];
        [self.navigationController pushViewController:contentcontrol animated:YES];
    }else if ([type isEqualToString:@"7"])
    {
        //约拍详情
        YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
        detail.covenant_id = getSafeString(diction[@"nid"]);
        detail.isNeedPay = NO;
        [self.navigationController pushViewController:detail animated:YES];
    }
    else if ([type isEqualToString:@"10"]){
        //套系详情
        YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
        detail.covenant_id = getSafeString(diction[@"nid"]);
        detail.isNeedPay = NO;
        detail.isTaoXi = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else if ([type isEqualToString:@"15"]){
        //竞拍详情
        
        MCJingpaiDetailController *jingpaiDetailVC = [[MCJingpaiDetailController alloc]init];
        NSDictionary *diction = self.sysMessageArray[indexPath.row];
        
        
        jingpaiDetailVC.jingpaiID = getSafeString(diction[@"nid"]);
//
//        if ([getSafeString(model.info.opCode) isEqualToString:@"0"] ) {
//            jingpaiDetailVC.isOnAuction = YES;
//        }else{
//            jingpaiDetailVC.isOnAuction = NO;
//        }

        [self.navigationController pushViewController:jingpaiDetailVC animated:YES];
    }
}
 
 
@end
