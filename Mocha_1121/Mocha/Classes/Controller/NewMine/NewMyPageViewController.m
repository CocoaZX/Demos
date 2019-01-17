//
//  NewMyPageViewController.m
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewMyPageViewController.h"
#import "NewPersonalOneTableViewCell.h"
#import "NewPersonalHeaderView.h"
#import "NewMokaCardTableViewCell.h"
#import "McReportViewController.h"
#import "PersonPageViewModel.h"
#import "McPersonalData.h"
#import "McPersonalDataViewController.h"
#import "ReadPlistFile.h"
#import "ChatViewController.h"
#import "StartYuePaiViewController.h"
#import "MyMokaCardViewController.h"
#import "McSettingViewController.h"
#import "BuildNewMcTableViewCell.h"
#import "NewMyPageDelegateDatasource.h"
#import "AddLabelViewController.h"
#import "NewMyPagePhotographerDataSource.h"
#import "MemberCenterController.h"
#import "ChatUserInfo.h"
#import "CoreDataManager.h"
#import "GuideView.h"
//自定义window
static UIWindow *customWindow = nil;
static UIWindow *shareWindow = nil;

@interface NewMyPageViewController ()<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
    NSDictionary *feetDict;
    UIImage *image;
    UITapGestureRecognizer *tap;
    
    //触发手势之后，将要隐藏的视图
    NSString *willlHiddenViewName;
    float height;
    CGRect imageRect;//背景放大

}

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) PersonPageViewModel *viewModel;

@property (copy, nonatomic) NSString *jieshao;

@property (copy, nonatomic) NSString *jingyan;

@property (copy, nonatomic) NSString *gongzuoshi;

@property (copy, nonatomic) NSString *isModel;

@property (copy, nonatomic) NSString *isfollow;

@property (copy, nonatomic) NSString *currentHeaderURL;

@property (strong, nonatomic) NSDictionary *albums;

@property (strong, nonatomic) NSMutableArray *albumsArray;

@property (strong, nonatomic) NSMutableArray *photoAlbumsArray;

//服务器返回数据，用户的相册
@property (strong,nonatomic)NSMutableArray *xiangCeArray;

@property (strong, nonatomic) NSMutableArray *taoxiArray;

@property (copy, nonatomic) NSString *albumcount;

@property (nonatomic, strong) UIActionSheet *moreSheet;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *guanzhuButton;

@property (assign, nonatomic) BOOL isBlack;

//当前是否为本人
@property (assign , nonatomic) BOOL isMaster;

@property (nonatomic, strong) McPersonalData *personalData;

//模卡数组
@property (nonatomic , strong) NSMutableArray *moKaMutArr;

//执行加黑和移除所需要的参数：中间变量
@property (nonatomic,strong)NSDictionary *addBlackParams;

//私信是否可以使用
@property (nonatomic,strong)NSDictionary *messageEnable;

//点击cell上下载按钮
@property (nonatomic,strong)UIButton *downLoadBtn;

@property (nonatomic, strong) NewMyPageDelegateDatasource *delegateDatasource;

@property (nonatomic, strong) NewMyPagePhotographerDataSource *photographerDatasource;

@property (nonatomic, strong) UIBarButtonItem *editItem;
@property (nonatomic, strong) UIBarButtonItem *shareItem;

@property (nonatomic, strong) NSMutableDictionary *informationDic;

//购买会员
@property(nonatomic,strong)UIWindow *BuyMemberWindow;

@end

@implementation NewMyPageViewController

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
}

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = getSafeString(self.currentTitle);

    //初始化一些本界面需要的参数
    self.isModel = @"0";
    self.jieshao = @"";
    
    //设置代理
    self.tableView.delegate = self.delegateDatasource;
    self.tableView.dataSource = self.delegateDatasource;
    self.tableView.backgroundColor = [UIColor colorWithRed:245/256.0 green:245/256.0 blue:245/256.0 alpha:1.0];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }
    
    //代理
    self.delegateDatasource = [[NewMyPageDelegateDatasource alloc] init];
    self.delegateDatasource.controller = self;
    
    self.photographerDatasource = [[NewMyPagePhotographerDataSource alloc]init];
    self.photographerDatasource.controller = self;
    
    
    self.headerView = [NewPersonalHeaderView getNewPersonalHeaderView];
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.supCon = self;
    //头视图上的模卡名片
    self.headerView.MokaCardView.hidden = YES;
    
    
    height = self.headerView.size.height;
    imageRect = self.headerView.backgroundImageView.frame;
    
    
    //当前不是自己的界面，显示底部面板
    if (![self isMySelfPage]) {
        if (!self.bottomView) {
            [self addGuanZhuView];
        }
    }

    //初始化弹出得actionSheet
    //区分两种情况：自己和非自己
    //1.非自己
    self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                 delegate:self
                                        cancelButtonTitle:@"取消"
                                   destructiveButtonTitle:nil
                                        otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"加入黑名单", @"举报", nil];
    
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    //1.1审核环境下，进入的是对方的主页,不显示第三方
    if (!isAppearThirdLogin) {
        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"加入黑名单", @"举报", nil];
    }

    
    //2.如果是本人，没有加入黑名单等选项
    if ([self isMySelfPage]) {
        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"编辑", nil];
    }

    //接收分享之后的通知，显示分享成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertSuccess) name:@"SharedSuccess" object:nil];
    
}



- (void)resetDelegateDatasourceData
{
    //模特
    self.tableView.delegate = self.photographerDatasource;
    self.tableView.dataSource = self.photographerDatasource;
    //底部：经验等信息
    self.photographerDatasource.dataArray = self.dataArray;
    self.photographerDatasource.isModel = self.isModel;
    self.photographerDatasource.isModel = @"1";
    //都按照模特的样式显示模卡
    self.photographerDatasource.viewModel = self.viewModel;
    
    //1.专题
    self.photographerDatasource.taoxiArray = self.taoxiArray;
    //2.moka数组
    self.photographerDatasource.albumsArray = self.albumsArray;
    self.photographerDatasource.photoAlbumsArray = self.photoAlbumsArray;
    self.photographerDatasource.moKaMutArr = self.moKaMutArr;
    //3.相册
    self.photographerDatasource.xiangCeArray = self.xiangCeArray;
    
    self.photographerDatasource.isMaster = self.isMaster;
    self.photographerDatasource.jieshao = self.jieshao;
    self.photographerDatasource.jingyan = self.jingyan;
    self.photographerDatasource.gongzuoshi = self.gongzuoshi;
    self.photographerDatasource.albumcount = self.albumcount;
    self.photographerDatasource.mokaNumber = self.mokaNumber;
    self.photographerDatasource.currentUid = self.currentUid;
    self.photographerDatasource.currentName = self.currentName;
    self.photographerDatasource.currentTitle = self.currentTitle;
    
}

- (void)showAlertSuccess
{
    [LeafNotification showInController:self withText:@"分享成功"];
}

//判断是否主人态
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.moKaMutArr = nil;
    self.dataArray = nil;
    
    self.dataArray = @[].mutableCopy;
    self.albumsArray = @[].mutableCopy;
    self.photoAlbumsArray = @[].mutableCopy;
    self.xiangCeArray = @[].mutableCopy;
    self.taoxiArray = @[].mutableCopy;

    self.navigationController.navigationBarHidden = NO;
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if ([self isMySelfPage]) {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        //是本人
        _isMaster = YES;
        if ([_isModel isEqualToString:@"0"]) {
            if (isAppearThirdLogin) {
                //显示第三方功能，存在分享按钮
                self.navigationItem.rightBarButtonItems = @[self.shareItem,self.editItem];
             }else
            {
                self.navigationItem.rightBarButtonItems = @[self.editItem];
            }
        }
        [self requestMokaList];
    }else
    {
        self.navigationItem.rightBarButtonItem = self.shareItem;
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-40);
        _isMaster = NO;
        if (!self.bottomView) {
            [self addGuanZhuView];
            
        }
        
     }
    //请求个人信息
    [self requestUserInfo];
}

-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SharedSuccess" object:nil];
}

#pragma mark 导航栏上的按钮
//分享：显示选择框
-(void)sharPersonInformation{
    [self.moreSheet showInView:self.view];
}

//设置
- (void)doIntoSettingMore:(id)sender
{
    [self loadPersonalData];
    McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
    personalVC.personalData = self.personalData;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (UIBarButtonItem *)shareItem
{
    if (!_shareItem) {
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setBtn setFrame:CGRectMake(0, 7, 45, 30)];
        [setBtn setTitle:@"推荐" forState:UIControlStateNormal];
        setBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [setBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [setBtn setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
        [setBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        [setBtn addTarget:self action:@selector(sharPersonInformation) forControlEvents:UIControlEventTouchUpInside];
        _shareItem = [[UIBarButtonItem alloc]initWithCustomView:setBtn];
        
    }
    return _shareItem;
}

//导航栏编辑
- (UIBarButtonItem *)editItem
{
    if (!_editItem) {
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [setBtn setFrame:CGRectMake(0, 0, 25, 30)];
        [setBtn setImage:[UIImage imageNamed:@"editPerson"] forState:UIControlStateNormal];
        [setBtn addTarget:self action:@selector(doIntoSettingMore:) forControlEvents:UIControlEventTouchUpInside];
        _editItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
        
    }
    return _editItem;
}

#pragma mark - 关注，私信，约拍
- (void)addGuanZhuView
{
    int width = (kScreenWidth-2)/3;
    BOOL isAppearYuePai = UserDefaultGetBool(ConfigYuePai);
    if (isAppearYuePai) {
        //显示约拍
    }else
    {
        
        width = (kScreenWidth-1)/2;
    }
    
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight-104, kScreenWidth, 44)];
    buttomView.backgroundColor =[UIColor colorForHex:kLikeRedColor];
    self.bottomView = buttomView;
    //关注按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, width, 44)];
    [leftButton setBackgroundColor:[UIColor colorForHex:kLikeRedColor]];
    [leftButton setTitle:@"关注" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(guanzhuMethod:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:leftButton];
    self.guanzhuButton = leftButton;
    //私信按钮
    UIButton *centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [centerButton setFrame:CGRectMake(width+1, 0, width, 44)];
    [centerButton setBackgroundColor:[UIColor colorForHex:kLikeRedColor]];
    [centerButton setTitle:@"私信" forState:UIControlStateNormal];
    [centerButton addTarget:self action:@selector(sixinMethod:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:centerButton];
    //约拍按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(width*2+2, 0, width+0.5, 44)];
    [rightButton setBackgroundColor:[UIColor colorForHex:kLikeRedColor]];
    [rightButton setTitle:@"约拍" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(yuepai:) forControlEvents:UIControlEventTouchUpInside];
    if (isAppearYuePai) {
        
        [buttomView addSubview:rightButton];
        
    }
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(width, 0, 1, 44)];
    lineView.backgroundColor = [UIColor whiteColor];
    [buttomView addSubview:lineView];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(width*2+1, 0, 1, 44)];
    lineView2.backgroundColor = [UIColor whiteColor];
    [buttomView addSubview:lineView2];
    
    [self.view addSubview:self.bottomView];
}




- (void)guanzhuMethod:(UIButton *)sender
{
    
    if (isLogin()) {
        NSString *currentUid = currentUID();
        NSString *targetUid = getSafeString(self.currentUid);
        NSDictionary *params = [AFParamFormat formatFollowParams:currentUid toUid:targetUid];
        
        NSString *title = sender.titleLabel.text;
        if ([title isEqualToString:@"已关注"]) {
            [AFNetwork followCancel:params  success:^(id data){
                if ([data[@"status"] integerValue] == kRight) {
                    [self showMessage:data[@"msg"]];

                    [sender setTitle:@"关注" forState:UIControlStateNormal];
                    if (self.informationDic) {
                        NSString *fensiNum = [NSString stringWithFormat:@"%@",getSafeString(_informationDic[@"fensiNum"])];
                        NSInteger fensNumInter = [fensiNum integerValue];
                        fensNumInter -= 1;
                        fensiNum = [NSString stringWithFormat:@"%ld",(long)fensNumInter];
                        [_informationDic setValue:fensiNum forKey:@"fensiNum"];
                        [self.headerView initViewWithData:_informationDic];
                        //发送取消关注通知,个人列表的关注刷新
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"cancelLikeNotification" object:targetUid];
                        
                    }
                }
                else if([data[@"status"] integerValue] == kReLogin){  //******************** 应该不会出现这种情况吧
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }else
                {
                    [self showMessage:data[@"msg"]];
                    
                }
                
            }failed:^(NSError *error){
                
            }];
        }else
        {

            [AFNetwork followAdd:params  success:^(id data){
                if ([data[@"status"] integerValue] == kRight) {
                    [self showMessage:data[@"msg"]];
                    [sender setTitle:@"已关注" forState:UIControlStateNormal];
                    if (self.informationDic) {
                        NSString *fensiNum = [NSString stringWithFormat:@"%@",getSafeString(_informationDic[@"fensiNum"])];
                        NSInteger fensNumInter = [fensiNum integerValue];
                        fensNumInter += 1;
                        fensiNum = [NSString stringWithFormat:@"%ld",(long)fensNumInter];
                        [_informationDic setValue:fensiNum forKey:@"fensiNum"];
                        [self.headerView initViewWithData:_informationDic];
                    }

                }
                else if([data[@"status"] integerValue] == kReLogin){
                    [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                    [USER_DEFAULT synchronize];
                    [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                }else{
                    [self showMessage:data[@"msg"]];
                    
                }
                
            }failed:^(NSError *error){
                
            }];
        }
    }
    
}

- (void)sixinMethod:(UIButton *)sender
{
     //本界面是从聊天详请界面来的，单聊界面进来的
    if([self.sourceVCName isEqualToString:@"chatDetailVC"]){
        NSArray *vcs = [self.navigationController viewControllers];
        //重新调回原来的界面
        [self.navigationController popToViewController:vcs[vcs.count-1-1-1] animated:YES];
        return;
    }
    
    //本界面是从聊天界面进入的
    if ([self.sourceVCName isEqualToString:@"chatVC"]) {
        if(!self.isGroupChat){
            //如果是单聊，点击私信仍然要回到原来的聊天界面
            
            //[self.navigationController popViewControllerAnimated:YES];
            [self popToChatVC];
            return;
        }else{
            //如果是群聊，点击进入成员的个人主页，此情况下点击私信需要创建新的聊天
        }
    }
    //否则新创建聊天界面，进行如下步骤
    
    //NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //取出私信的字段
    NSString *status = self.messageEnable[@"status"];
    NSInteger statusNum = [status integerValue];
    NSString *msg = self.messageEnable[@"msg"];
    
    switch (statusNum) {
        case  6219:
        case  kRight:
        {
            //0可以私信
            //异步登陆账号
            [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                              completion:
             ^(NSDictionary *loginInfo, EMError *error) {
                 
                 if (loginInfo && !error) {
                     //获取群组列表
                     [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
                     
                     //设置是否自动登录
                     [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
                     
                     //将2.1.0版本旧版的coredata数据导入新的数据库
                     EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
                     if (!error) {
                         error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
                     }
                     
                     //发送自动登陆状态通知
                     [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
                 }
                 else
                 {
                     //NSLog(@"登陆错误%@",error.description);
                 }
             } onQueue:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
                ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.currentUid conversationType:eConversationTypeChat];
                chatController.title = getSafeString(self.currentTitle);
                if ([self.sourceVCName isEqualToString:@"chatVC"]) {
                    chatController.title  = self.title;
                }
                chatController.fromHeaderURL = getSafeString(fromHeaderURL);
                chatController.toHeaderURL = getSafeString(self.currentHeaderURL);
                [self.navigationController pushViewController:chatController animated:YES];
                
            });

            break;
        }
        case kReLogin:
        {
            //需要登陆
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            break;
        }
        case  6218:
        {   //需要绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            break;
        }
        case  1:
        {
            //提示不能私信
            [LeafNotification showInController:self withText:msg];
            break;
        }
        case  6220:
        {
            //提示不能私信
            //[LeafNotification showInController:self withText:msg];
            //显示开通会员的弹窗提示
            [self showBuyMemberWindow];
            break;
        }
        default:
            break;
    }
    
    
}

- (void)yuepai:(UIButton *)sender
{
    if ([self isLogin]) {
        if ([self isBangDing]) {
            StartYuePaiViewController *yuepai = [[StartYuePaiViewController alloc] initWithNibName:@"StartYuePaiViewController" bundle:[NSBundle mainBundle]];
            yuepai.receiveUid = self.currentUid;
            yuepai.receiveName = self.currentName;
            yuepai.receiveHeader = self.currentHeaderURL;
            [self.navigationController pushViewController:yuepai animated:YES];
            
        }
    }
}

//请求moka数据
-(void)requestMokaList{
    NSString *cuid = self.currentUid;
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"uid":cuid,@"album_type":@"1"}];
    [AFNetwork getMokaList:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //模卡数组
            NSArray *dataArr = data[@"data"];
            for (id obj in dataArr) {
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    if ([obj[@"albumType"] isEqualToString:@"1"]) {
                        [self.moKaMutArr addObject:obj];
                    }
                }
            }
            [self resetDelegateDatasourceData];

        }else if([data[@"status"] integerValue] == kReLogin){
            [self showMessage:data[@"msg"]];

        }
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showMessage:@"当前网络不太顺畅哟"];

    }];
}

//请求个人信息数据
- (void)requestUserInfo
{
    NSString *cuid = self.currentUid;
    if (!self.viewModel) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:cuid];
    [AFNetwork getUserInfo:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([data[@"status"] integerValue] == kRight) {
             self.viewModel = [[PersonPageViewModel alloc] initWithDiction:data[@"data"]];
            
            //判断此人是否已经被拉黑
            self.isBlack = [getSafeString(data[@"data"][@"isblack"]) boolValue];
            if (self.isBlack) {
                [self changeActionView];
            }

            //整理封装数据
            NSString *bannar = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"bannar"])];
            NSString *headerURL = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"head_pic"])];
            NSString *mokaNum = [NSString stringWithFormat:@"MOKA号: %@",getSafeString(data[@"data"][@"num"])];
            NSString *userType = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"typeName"])];
            NSString *sex = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"sexName"])];
            NSString *citys = [NSString stringWithFormat:@"%@-%@",getSafeString(data[@"data"][@"provinceName"]),getSafeString(data[@"data"][@"cityName"])];
            NSString *dongtai = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"trendscount"])];
            NSString *nickname = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"nickname"])];
            NSString *uid = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"id"])];
            NSString *guanzhu = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"followcount"])];
            NSString *fensi = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"fanscount"])];
            NSString *isModel = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"type"])];
            NSString *vip = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"vip"])];
            NSString *member = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"member"])];
            NSString *newFansCount = getSafeString(data[@"data"][@"newfanscount"]);
            NSString *approve_content = [NSString stringWithFormat:@"%@", getSafeString(data[@"data"][@"approve_content"])];
            //身价
            NSString *rank = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"rank"])];
            NSString *currLevel = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"currLevel"])];
            NSString *rankUrl = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"rankUrl"])];

            self.currentHeaderURL = headerURL;
            self.title = nickname;
            self.currentTitle = nickname;
            self.mokaNumber = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"num"])];
            self.isfollow = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"isfollow"])];
            //私信限制参数
            self.messageEnable = data[@"data"][@"messageEnable"];
            self.currentName = nickname;
            self.isModel = isModel;
            
            NSDictionary *diction = @{@"headerURL":headerURL,
                                      @"bannar":bannar,
                                      @"mokaNum":mokaNum,
                                      @"userType":userType,
                                      @"sex":sex,
                                      @"citys":citys,
                                      @"dongtaiNum":dongtai,
                                      @"guanzhuNum":guanzhu,
                                      @"nickname":nickname,
                                      @"isModel":isModel,
                                      @"vip":vip,
                                      @"uid":uid,
                                      @"fensiNum":fensi,
                                      @"member":member,
                                      @"rank":rank,
                                      @"currLevel":currLevel,
                                      @"rankUrl":rankUrl,
                                      @"newFansCount":newFansCount,@"approve_content":approve_content};
            //介绍
            self.jieshao = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"introduction"])];
            if (self.jieshao.length == 0) {
                self.jieshao = [NSString stringWithFormat:@"还没有写个人介绍哦"];
            }
            //经验
            self.jingyan = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"workhistory"])];
            if (self.jingyan.length == 0) {
                self.jingyan = [NSString stringWithFormat:@"还没有写工作经验哦"];
            }
            
            //工作室“”
            self.gongzuoshi = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"studio"])];
            
            //介绍，经验，工作室
            if (self.jieshao.length>=1) {
                [self.dataArray addObject:@"5"];
            }
            
            if (self.jingyan.length>=1) {
                [self.dataArray addObject:@"5"];
            }
            //摄影师才显示工作室的介绍
            if (self.gongzuoshi.length>=1 && ![self.isModel isEqualToString:@"1"]) {
                [self.dataArray addObject:@"5"];
            }
            
            //显示的影集的个数
            self.albumcount = [NSString stringWithFormat:@"%@",getSafeString(data[@"data"][@"albumcount"])];
            if (self.albumcount.length == 0) {
                self.albumcount = [NSString stringWithFormat:@"还没有影集"];
            }
            
            //取得所有相册
            NSArray *albums = data[@"data"][@"albums"];
            if (albums.count>0) {
                self.albums = albums[0];
            }
            for (NSDictionary *dic in albums) {
                //套系
                if ([dic[@"albumType"] isEqualToString:@"3"]) {
                    NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithDictionary:dic];
                    [mutDic setObject:uid forKey:@"uid"];
                    [mutDic setObject:headerURL forKey:@"headerURL"];
                    [mutDic setObject:nickname forKey:@"nickname"];
                    [mutDic setObject:mokaNum forKey:@"mokaNum"];
                    [mutDic setObject:sex forKey:@"sex"];
                    [mutDic setObject:citys forKey:@"citys"];
                    [mutDic setObject:vip forKey:@"vip"];
                    [mutDic setObject:bannar forKey:@"bannar"];
                    [mutDic setObject:userType forKey:@"userType"];
                    [mutDic setObject:rank forKey:@"rank"];
                    [mutDic setObject:approve_content forKey:@"approve_content"];
                    [mutDic setObject:currLevel forKey:@"currLevel"];
                    [self.taoxiArray addObject:mutDic];
                }else if([dic[@"albumType"] isEqualToString:@"1"]){
                    //模特和摄影师拥有的所有相册
                    [self.albumsArray addObject:dic];
                    [self.photoAlbumsArray addObject:dic];
                }else if([dic[@"albumType"] isEqualToString:@"2"]){
                    [self.xiangCeArray addObject:dic];
                }
            }
          
            //判断动态模卡
            NSDictionary *dynamic = data[@"data"][@"dynamic"];
            if (dynamic) {
            NSMutableDictionary *dynamicDic = [NSMutableDictionary dictionaryWithDictionary:dynamic];
                [dynamicDic setObject:@"dynamicMOKA" forKey:@"type"];

                //加入到相册的数组中
                 [self.xiangCeArray insertObject:dynamicDic atIndex:0];
            }
            
            
            //使用数据初始化头视图
            [self.headerView initViewWithData:diction];
            self.informationDic = [NSMutableDictionary dictionaryWithDictionary:diction];
            
            if ([self.isfollow isEqualToString:@"1"]) {
                [self.guanzhuButton setTitle:@"已关注" forState:UIControlStateNormal];
            }
           
            //当前为自己，重置弹出的选择框
            if ([self isMySelfPage]) {
                //重置了actionSheet的显示
                [self resetActionSheet];
            }
            
            //本人不存在套系时，增加一个提示创建套系的单元格
            if (!self.taoxiArray.count && self.isMaster) {
                [self.taoxiArray addObject:[NSDictionary dictionaryWithObjects:@[uid] forKeys:@[@"uid"]]];
            }
            
            //本人不存在moka时，增加一个提示创建模卡的单元格
            if (self.albumsArray.count == 0 && self.isMaster) {
                [self.albumsArray addObject:[NSDictionary dictionaryWithObjects:@[uid] forKeys:@[@"uid"]]];
            }
            
            //执行到此处，如果是本人，工作室和模卡的数量一定不是0
            //如果此处的总和是0,一定是查看别人的主页，而且对方的相册
            //也是空的
            //所以在此处给一个空的单元格提示
            //使用的空模卡的提示单元格
            if((self.taoxiArray.count +self.albumsArray.count + self.xiangCeArray.count) == 0){
                [self.albumsArray addObject:[NSDictionary dictionaryWithObjects:@[uid] forKeys:@[@"uid"]]];
            }
            
            //在审核环境下，不会出现关于套系相关的内容
            BOOL isAppearTaoXi = [USER_DEFAULT boolForKey:ConfigShang];
            if (!isAppearTaoXi) {
                self.taoxiArray = @[].mutableCopy;
                self.xiangCeArray = @[].mutableCopy;
            }
            
            //重置代理并刷新单元格
            [self resetDelegateDatasourceData];
            [self.tableView reloadData];
            
            if ([self isMySelfPage]) {
                //显示功能引导视图_个人主页身价
                [self showGuideViewPersonPage];
            }else{
                //显示功能引导视图_个人主页约拍
                [self showMokaGuideViewPersionPageYuePai];
            }
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [self showMessage:data[@"msg"]];
        }else if([data[@"status"] integerValue] == kDelete || [data[@"status"] integerValue] == kForbid || [data[@"status"] integerValue] == kForbidden){
            
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:data[@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alertV.tag = 300;
            [alertV show];
        }
       //更新一下头像，昵称等信息，这里是为了更新本地聊天信息数据库
       //及时更新聊天界面里的头像和昵称
       [self updateChatInfoToDB];
      
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showMessage:@"当前网络不太顺畅哟"];
    }];
}

//根据需求，改变ActionView是否要显示第三方功能
- (void)changeActionView
{
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        if (self.isBlack) {
            self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"加入黑名单", @"举报", nil];
        }
        
    }else
    {
        if (self.isBlack) {
            self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"从黑名单中移除", @"举报", nil];
        }
        
    }

}

- (void)loadPersonalData
{
    NSDictionary *dataDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if (!_personalData) {
        _personalData = [[McPersonalData alloc] init];
    }
    _personalData.nickName = dataDict[@"nickname"];
    _personalData.headUrl = dataDict[@"head_pic"];
    NSString *sexStr = dataDict[@"sex"];
    
    if ([sexStr intValue] == 1) {
        _personalData.sex = @"男";
    }
    else if([sexStr intValue] == 2){
        _personalData.sex = @"女";
    }
    else{
        _personalData.sex = @"";
    }
    _personalData.authentication = dataDict[@"authentication"];
    _personalData.job = [jobDict valueForKey:dataDict[@"job"]];
    _personalData.major = [majorDict valueForKey:dataDict[@"major"]];
    _personalData.height = dataDict[@"height"];
    _personalData.weight = dataDict[@"weight"];
    _personalData.age = [dataDict[@"birth"] isEqualToString:@"0000-00-00"]?@"":dataDict[@"birth"];
    _personalData.area = [NSString stringWithFormat:@"%@%@",getSafeString(dataDict[@"provinceName"]) ,getSafeString(dataDict[@"cityName"])];
    _personalData.bust = dataDict[@"bust"];
    _personalData.waist = dataDict[@"waist"];
    _personalData.hips = dataDict[@"hipline"];
    _personalData.measurements = [dataDict[@"bust"] integerValue]> 0?[NSString stringWithFormat:@"%@-%@-%@",dataDict[@"bust"],dataDict[@"waist"],dataDict[@"hipline"]]:@"";
    _personalData.signName = dataDict[@"mark"];
    _personalData.leg = dataDict[@"leg"];
    _personalData.workExperience = dataDict[@"workhistory"];
    _personalData.introduction = dataDict[@"introduction"];
    _personalData.desiredSalary = dataDict[@"payment"];
    
}

#pragma mark - 显示引导视图
- (void)showGuideViewPersonPage{
    BOOL show = [GuideView needShowGuidViewWithGuideViewType:MokaGuideViewPeronPage];
    if (show) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        [guideView showGuidViewWithConditionType:MokaGuideViewPeronPage];
    }
}

- (void)showMokaGuideViewPersionPageYuePai{
    BOOL show = [GuideView needShowGuidViewWithGuideViewType:MokaGuideViewPersionPageYuePai];
    if (show) {
        GuideView *guideView = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        [guideView showGuidViewWithConditionType:MokaGuideViewPersionPageYuePai];
    }
}

#pragma mark - uiactionsheet
//分享
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet==self.moreSheet) {
        
        BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
        NSString *uid = currentUID();

        if (isAppearThirdLogin) {
            NSString *uid = currentUID();
            if ([uid isEqualToString:self.currentUid]) {
                switch (buttonIndex) {
                    case 3://编辑资料
                    {
                        if ([uid isEqualToString:self.currentUid]) {
                            [self loadPersonalData];
                            McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
                            personalVC.personalData = self.personalData;
                            [self.navigationController pushViewController:personalVC animated:NO];
                        }
                        
                    }
                        break;
                    case 2://QQ好友
                    {
                        //NSString *url = self.currentHeaderURL;
                        //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                        UIImage *headerImg = self.headerView.headerImageView.image;
                        NSData *imageData = UIImageJPEGRepresentation(headerImg, 1);

                        if (!imageData) {
                            imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
                        }
                        
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:self.viewModel.shareDesc title:self.viewModel.shareTitle imageData:imageData targetUrl:@"u" objectId:self.currentUid isTaoXi:NO];
                    }
                        break;
                    case 1://推荐微信好友
                    {
                        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
                        UIImage *headerImg = self.headerView.headerImageView.image;
                        if (!headerImg) {
                            headerImg = [UIImage imageNamed:@"AppIcon"];
                        }
                        NSString *shareURL = [self.viewModel getShareURLWithUid:self.currentUid];
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:self.viewModel.shareTitle desc:self.viewModel.shareDesc header:headerImg URL:shareURL uid:self.currentUid isTaoXi:NO];
                    }
                        break;
                    case 0://推荐微信朋友圈
                    {
                        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
                        UIImage *headerImg = self.headerView.headerImageView.image;
                        if (!headerImg) {
                            headerImg = [UIImage imageNamed:@"AppIcon"];
                        }
                        NSString *shareURL = [self.viewModel getShareURLWithUid:self.currentUid];
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:self.viewModel.shareTitle desc:self.viewModel.shareDesc header:headerImg URL:shareURL uid:self.currentUid isTaoXi:NO];
                    }
                        break;
                    default:
                        break;
                }
                
                
            }else
            {
                switch (buttonIndex) {
                    case 5://编辑资料
                    {
                        if ([uid isEqualToString:self.currentUid]) {
                            [self loadPersonalData];
                            McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
                            personalVC.personalData = self.personalData;
                            [self.navigationController pushViewController:personalVC animated:NO];
                        }
                    }
                        break;
                    case 4://举报
                    {
                        if ([self isLogin]) {
                            MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
                            report.targetUid = self.currentUid;
                            [self.navigationController pushViewController:report animated:YES];
                        }
                    }
                        break;
                    case 3://加入黑名单
                    {
                        if ([self isLogin]) {
                            NSString *targetId = self.currentUid;
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"to_uid":targetId}];
                            NSDictionary *params = [AFParamFormat formatAddBlackInfoParams:dict];
                            
                            if(self.isBlack)
                            {
                                [AFNetwork addRemoveBlackInfo:params success:^(id data){
                                    NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
                                    if ([state isEqualToString:@"0"]) {
                                        [self showMessage:@"移除黑名单成功。"];

                                        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"取消"
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"加入黑名单", @"举报", nil];
                                        self.isBlack = NO;
                                    }else if ([state isEqualToString:@"202"]) {
                                        [self showMessage:@"不在黑名单。"];
                                    }else
                                    {
                                        [self showMessage:data[@"msg"]];
                                    }
                                }failed:^(NSError *error){
                                    NSLog(@"error:%@",error);
                                }];
                            }else
                            {
                                [AFNetwork addBlackInfo:params success:^(id data){
                                    NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
                                    if ([state isEqualToString:@"0"]) {
                                        [self showMessage:@"加入黑名单成功。"];
                                        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"取消"
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"从黑名单中移除", @"举报", nil];
                                        self.isBlack = YES;
                                    }else if ([state isEqualToString:@"202"]) {
                                        [self showMessage:@"已添加黑名单。"];
                                    }else
                                    {
                                        [self showMessage:data[@"msg"]];
                                    }
                                }failed:^(NSError *error){
                                    NSLog(@"error:%@",error);
                                }];
                            }
                        }
                    }
                        break;
                    case 2://QQ好友
                    {
                        NSString *url = self.currentHeaderURL;
                        
                        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                        if (!imageData) {
                            imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
                        }
                        
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:self.viewModel.shareDesc title:self.viewModel.shareTitle imageData:imageData targetUrl:@"u" objectId:self.currentUid isTaoXi:NO];
                    }
                        break;
                    case 1://推荐微信好友
                    {
                        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
                        UIImage *headerImg = self.headerView.headerImageView.image;
                        if (!headerImg) {
                            headerImg = [UIImage imageNamed:@"AppIcon"];
                        }
                        NSString *shareURL = [self.viewModel getShareURLWithUid:self.currentUid];
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:self.viewModel.shareTitle desc:self.viewModel.shareDesc header:headerImg URL:shareURL uid:self.currentUid isTaoXi:NO];
                    }
                        break;
                        
                    case 0://推荐微信朋友圈
                    {
                        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
                        UIImage *headerImg = self.headerView.headerImageView.image;
                        if (!headerImg) {
                            headerImg = [UIImage imageNamed:@"AppIcon"];
                        }
                        NSString *shareURL = [self.viewModel getShareURLWithUid:self.currentUid];
                        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:self.viewModel.shareTitle desc:self.viewModel.shareDesc header:headerImg URL:shareURL uid:self.currentUid isTaoXi:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
                
                
            }
            
            
        }else
        {
            if ([uid isEqualToString:self.currentUid]) {
                switch (buttonIndex) {
                    case 0://编辑资料
                    {
                        [self loadPersonalData];
                        McPersonalDataViewController *personalVC = [[McPersonalDataViewController alloc] init];
                        personalVC.personalData = self.personalData;
                        [self.navigationController pushViewController:personalVC animated:NO];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            }else
            {
                switch (buttonIndex) {
                    case 1://举报
                    {
                        if ([self isLogin]) {
                            MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];
                            report.targetUid = self.currentUid;
                            [self.navigationController pushViewController:report animated:YES];
                        }
                    }
                        break;
                    case 0://加入黑名单
                    {
                        if ([self isLogin]) {
                            NSString *targetId = self.currentUid;
                            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"to_uid":targetId}];
                            NSDictionary *params = [AFParamFormat formatAddBlackInfoParams:dict];
                            if(self.isBlack)
                            {
                                [AFNetwork addRemoveBlackInfo:params success:^(id data){
                                    //NSLog(@"data:%@",data);
                                    NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
                                    if ([state isEqualToString:@"0"]) {
                                        [self showMessage:@"移除黑名单成功。"];

                                        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"取消"
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"加入黑名单", @"举报", nil];
                                        self.isBlack = NO;
                                    }else if ([state isEqualToString:@"202"]) {
                                        [self showMessage:@"不在黑名单。"];
                                    }else
                                    {
                                        [self showMessage:data[@"msg"]];
                                    }
                                }failed:^(NSError *error){
                                    NSLog(@"error:%@",error);
                                }];
                            }else
                            {
                                [AFNetwork addBlackInfo:params success:^(id data){
                                    //NSLog(@"data:%@",data);
                                    NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
                                    if ([state isEqualToString:@"0"]) {
                                        [self showMessage:@"加入黑名单成功。"];

                                        self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                                     delegate:self
                                                                            cancelButtonTitle:@"取消"
                                                                       destructiveButtonTitle:nil
                                                                            otherButtonTitles:@"从黑名单中移除", @"举报", nil];
                                        self.isBlack = YES;
                                    }else if ([state isEqualToString:@"202"]) {
                                        [self showMessage:@"已添加黑名单。"];
                                    }else
                                    {
                                        [self showMessage:data[@"msg"]];
                                    }
                                }failed:^(NSError *error){
                                    NSLog(@"error:%@",error);
                                }];
                            }
                        }
                    }
                        break;
                    default:
                        break;
                }
                
                
            }
            
        }
        
    }
}


#pragma mark - 私信上限制开通会员
- (void)showBuyMemberWindow{
    if (_BuyMemberWindow == nil) {
        //创建window
        _BuyMemberWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _BuyMemberWindow.backgroundColor = [UIColor clearColor];
        _BuyMemberWindow.hidden = NO;
        _BuyMemberWindow.windowLevel = UIWindowLevelStatusBar;
        
        //设置黑色背景
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        backView.backgroundColor = [CommonUtils colorFromHexString:kLikeBlackColor];
        backView.alpha = 0.7;
        [_BuyMemberWindow addSubview:backView];
        
        
        //中间视图的宽高度
        CGFloat lefttingPadding = 30;
        CGFloat horizontalPadding = 20;
        CGFloat mainViewWidth = kDeviceWidth -30*2;
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectZero];
        mainView.backgroundColor = [UIColor whiteColor];
        [_BuyMemberWindow addSubview:mainView];
        
        //获取文案
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description1" ];
        NSString *alterTitle = @"达到发送私信数量上限制";
        NSString *descTxt = @"开通会员后可以继续发送，还有更多会员专属特权等你体验！";
        NSString *tempStr = [descriptionDic objectForKey:@"chat_tip"];
        if (tempStr.length != 0) {
            alterTitle = tempStr;
        }
        tempStr = [descriptionDic objectForKey:@"chat_content1"];
        if (tempStr.length != 0) {
            descTxt = tempStr;
        }
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalPadding, 30, mainViewWidth -horizontalPadding*2,horizontalPadding)];
        titleLabel.textColor = [CommonUtils colorFromHexString:@"#Feb660"];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:18];
        titleLabel.text = alterTitle;
        [mainView addSubview:titleLabel];
        
        //内容
        CGFloat descHeight= [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:mainViewWidth -horizontalPadding *2 textSize:16];
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalPadding, titleLabel.bottom + 20, mainViewWidth -horizontalPadding *2, descHeight +10)];
        descLabel.numberOfLines = 0;
        descLabel.font = [UIFont systemFontOfSize:16];
        descLabel.text =descTxt;
        [mainView addSubview:descLabel];
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, descLabel.bottom +20, mainViewWidth /2, 50)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
        cancleBtn.tag = 1000;
        [cancleBtn addTarget:self action:@selector(buyMemberAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cancleBtn];
        
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainViewWidth/2, descLabel.bottom +20, mainViewWidth/2, 50)];
        [sureBtn setTitle:@"开通会员" forState:UIControlStateNormal];
        sureBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
        [sureBtn setTitleColor:[CommonUtils colorFromHexString:@"#Feb660"]forState:UIControlStateNormal];
        sureBtn.tag = 1001;
        [sureBtn addTarget:self action:@selector(buyMemberAction:) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:sureBtn];
        
        //取消和确定按钮分割线
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(mainViewWidth/2, cancleBtn.top, 1, 50)];
        lineLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        [mainView addSubview:lineLabel];

        CGFloat mainViewHeight = sureBtn.bottom;
        mainView.frame = CGRectMake(lefttingPadding, (kDeviceHeight -mainViewHeight)/2,mainViewWidth,mainViewHeight);
        mainView.layer.cornerRadius = 3;
        mainView.layer.masksToBounds = YES;
    }
    
    //执行动画
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //线条拉伸
    } completion:^(BOOL finished) {
        
    }];
    
}

//手势关闭"打开通知"的引导视图
- (void)buyMemberAction:(UIButton *)btn{
    if (btn.tag == 1000) {
        [self hiddenBuyMemberWindow];
    }else{
        MemberCenterController *memberVC = [[MemberCenterController alloc] initWithNibName:@"MemberCenterController" bundle:nil];
        //获取服务器配置
        NSString *webUrl = [USER_DEFAULT objectForKey:@"webUrl"];
        NSString *shareURL;
        if(webUrl.length >0){
            //http://yzh.web.mokacool.com/ucenter/order?uid=98894",
            shareURL = [NSString stringWithFormat:@"%@/ucenter/order?uid=%@",webUrl,getCurrentUid()];
        }
        memberVC.linkUrl = shareURL;
        [self.navigationController pushViewController:memberVC animated:YES];
        [self hiddenBuyMemberWindow];
    }

}

//进入打赏金币的界面
- (void)hiddenBuyMemberWindow{
    //隐藏window并且清除
    [UIView animateWithDuration:0.5 animations:^{
        _BuyMemberWindow.alpha = 0;
    } completion:^(BOOL finished) {
        _BuyMemberWindow.hidden = NO;
        _BuyMemberWindow =nil;
    }];
}

#pragma mark - 点击模卡cell上的分享
//点击了分享按钮
-(void)sharedMcWithImage:(UIImage *)cellImage width:(CGFloat)width height:(CGFloat)height{
    //如果shareWindow存在就不再创建了
    image = cellImage;
    if (shareWindow) {
        shareWindow.hidden = NO;
        //如果是已经存在这个对象就上移显示
        [UIView animateWithDuration:0.5 animations:^{
            shareWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            shareWindow.alpha = 1;
        }];
        return;
    }
    //创建window
    shareWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,kDeviceHeight*2, kDeviceWidth, kDeviceHeight)];
    shareWindow.alpha = 0;
    shareWindow.backgroundColor = [UIColor clearColor];
    //设置黑色背景
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    [shareWindow addSubview:backView];
    
    //设置手势属性
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenShareWindow)];
    [shareWindow addGestureRecognizer: singleTap];

    //显示window
    [UIView animateWithDuration:0.5 animations:^{
        shareWindow.hidden = NO;
        shareWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        shareWindow.alpha = 1;
        [self showShareButtonsToShareWindwow];
    } completion:^(BOOL finished) {

    }];
    
}

//隐藏了分享的窗口视图
- (void)hiddenShareWindow{
    //显示分享按钮
    int time = 0;
    for(int i = 0 ;i < 4; i++){
        UIButton *btn = (UIButton *)[shareWindow viewWithTag:2000+i];
        UILabel *titleLabel = (UILabel *)[shareWindow viewWithTag:3000 +i];
        
        [UIView animateWithDuration:0.3 animations:^{
            //延迟动画的调用
            [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
            [UIView setAnimationDelay:time * 0.08];
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 1;
            btn.top = kDeviceHeight/3 -100;

            titleLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
            titleLabel.alpha = 1;
            titleLabel.top = btn.bottom +5;

        } completion:^(BOOL finished) {
            //shareWindow.frame = CGRectMake(0, kDeviceHeight *2, kDeviceWidth, kDeviceHeight);
            //shareWindow.hidden = YES;
            //shareWindow = nil;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 btn.transform = CGAffineTransformMakeScale(1, 1);
                                 btn.alpha = 1;
                                 btn.top = kDeviceHeight;
                                 
                                 titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                                 titleLabel.alpha = 1;
                                 titleLabel.top = btn.bottom +5;
                             }];
        }];
        time ++;
    }

    [UIView animateWithDuration:2 animations:^{
        shareWindow.alpha = 0;
    } completion:^(BOOL finished) {
        shareWindow.frame = CGRectMake(0, kDeviceHeight *2, kDeviceWidth, kDeviceHeight);
        shareWindow.hidden = YES;
        shareWindow = nil;
    }];
}


//显示在分享window上的按钮
- (void)showShareButtonsToShareWindwow{
        NSArray *imageArr = @[[UIImage imageNamed:@"ShareToWX"],[UIImage imageNamed:@"ShareToWXP"],[UIImage imageNamed:@"ShareToWB"],[UIImage imageNamed:@"ShareToQQ"]];
        NSArray *titleArr = @[@"微信",@"朋友圈",@"新浪微博",@"QQ",@""];
        //创建分享按钮和显示标签
        CGFloat buttonWidth = 70;
        CGFloat spaceWidth = (kDeviceWidth - buttonWidth*4)/5;
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth*(i+1)+buttonWidth *i, kDeviceHeight/3 * 2, buttonWidth, buttonWidth)];
           
            btn.tag = 2000 +i;
            [btn addTarget:self action:@selector(sharImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius = buttonWidth/2;
            btn.layer.masksToBounds = YES;
            if (i < 4) {
                [btn setImage:imageArr[i] forState:UIControlStateNormal];
            }
            if (i == 4) {
                btn.frame = CGRectMake(15 , kDeviceHeight/3, kDeviceWidth - 30, buttonWidth / 2);
                btn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
                btn.layer.cornerRadius = 5;
                UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth/4, 5 , 30, 30)];
                showImageView.center = CGPointMake(kDeviceWidth / 2 - 70, 16);
                showImageView.image = [UIImage imageNamed:@"ShareToShow"];
                [btn addSubview:showImageView];
                UILabel *sharLabel = [[UILabel alloc]initWithFrame:CGRectMake(showImageView.right + 5, 3 , kDeviceWidth, 30)];
                sharLabel.text = [NSString stringWithFormat:@"分享到我的秀"];
                sharLabel.textColor = [UIColor whiteColor];
                [btn addSubview:sharLabel];
            }
            [shareWindow addSubview:btn];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.left, btn.bottom +5, btn.width, 20)];
            titleLabel.text = titleArr[i];
            titleLabel.tag = 3000 + i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor whiteColor];
            [shareWindow addSubview:titleLabel];
        }
    
    //显示分享按钮
    for(int i = 0 ;i <4; i++){
        UIButton *btn = (UIButton *)[shareWindow viewWithTag:2000+i];
        UILabel *titleLabel = (UILabel *)[shareWindow viewWithTag:3000 +i];
        //当前视图缩小为原来的0.5倍
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        btn.alpha = 0;
        btn.top = kDeviceHeight;
        
        titleLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        titleLabel.alpha = 0;
        titleLabel.top = btn.bottom +5;

        
        [UIView animateWithDuration:0.3 animations:^{
            //延迟动画的调用
            [UIView setAnimationDelay:i * 0.08];
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            btn.alpha = 1;
            btn.top = kDeviceHeight/2.5 - 30;
            if (i == 4) {
                btn.top = kDeviceHeight/2.5 - 50;
            }
            titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            titleLabel.alpha = 1;
            titleLabel.top = btn.bottom +5;

        } completion:^(BOOL finished) {
            //让视图从1.2--》1
            [UIView animateWithDuration:0.5
                             animations:^{
                                btn.transform = CGAffineTransformMakeScale(1, 1);
                                 btn.alpha = 1;
                                 btn.top = kDeviceHeight/2.5;
                                 if (i == 4) {
                                     btn.top = kDeviceHeight/2.5 - 50;
                                 }
                                 titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                                 titleLabel.alpha = 1;
                                 titleLabel.top = btn.bottom + 5;
                             }];
        }];
    }
}

//点击分享按钮后响应
-(void)sharImage:(UIButton *)sender{
    switch (sender.tag) {
            //微信
        case 2000:
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:nil];
            [self hiddenShareWindow];
            [self hiddenCustomWindow];
        }
            break;
        case 2001:
            //微信朋友圈
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"模卡"];
             [self hiddenShareWindow];
             [self hiddenCustomWindow];
        }
            break;
        case 2002:
            //新浪
        {
             [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToSinaWithPic:image];
             [self hiddenShareWindow];
             [self hiddenCustomWindow];
         }
            break;
        case 2003:
            //qq
        {
            NSData *imageData = UIImagePNGRepresentation(image);
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQWithImageDataReallyData:imageData previewImage:image title:@"分享" description:nil];
             [self hiddenShareWindow];
             [self hiddenCustomWindow];
        }
            break;
        case 2004:
            //分享到秀
        {
            NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
            if (uid) {
                AddLabelViewController *addLVC = [[AddLabelViewController alloc]init];
                addLVC.currentImage = image;
                [self hiddenShareWindow];
                [self hiddenCustomWindow];
                [self presentViewController:addLVC animated:YES completion:^{
                    
                }];
            }else{
                [self hiddenShareWindow];
                [self hiddenCustomWindow];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
        }
        break;
    }
}

#pragma mark - 点击模卡cell上的下载
-(void)downloadMcWithImage:(UIImage *)cellImage width:(CGFloat)width height:(CGFloat)mokaHeight withButton:(UIButton *)btn{
    //此时点击屏幕，需要隐藏window
    //如果customWindow存在就不再创建了
    _downLoadBtn = btn;
    image = cellImage;
    CGFloat pictureHeight = mokaHeight;
    willlHiddenViewName = @"customWindow";

    if (customWindow) {
         customWindow.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            customWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
            customWindow.alpha = 1;
        }];
        BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
        if (isAppearThirdLogin) {
            [self addShareBtnToCustomWindow];
        }
        return;
    }
    //创建window
    customWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0,kDeviceHeight*2, kDeviceWidth, kDeviceHeight)];
    //显示window
    customWindow.hidden = NO;
    customWindow.alpha = 0;
    //设置手势属性
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
    [customWindow addGestureRecognizer: singleTap];
    customWindow.backgroundColor = [UIColor clearColor];
    customWindow.windowLevel = UIWindowLevelStatusBar;
    
    //背景视图
    UIView *backView = [[UIView alloc] initWithFrame:customWindow.bounds];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    backView.tag = 112;
    [customWindow addSubview:backView];
    
    CGFloat viewHeight = (kDeviceHeight -35 - pictureHeight -10 -kDeviceWidth/8  -25)/2;

    //添加标题
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100)/2,viewHeight +5 ,100 , 25)];
    titleLable.text = @"分享模特卡";
    titleLable.textColor = [UIColor whiteColor];
    titleLable.font = [UIFont systemFontOfSize:18];
    [customWindow addSubview:titleLable];
    //取消按钮
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
     [closeButton setImage:[UIImage imageNamed:@"photoBrowseCancel"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(kScreenWidth-60, viewHeight+5, 25, 25)];
    [closeButton addTarget:self action:@selector(viewTapAction) forControlEvents:UIControlEventTouchUpInside];
    [customWindow addSubview:closeButton];
    
    //添加模卡视图
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,closeButton.bottom +5, width, pictureHeight)];
    imageView.image = cellImage;
    [customWindow addSubview:imageView];
    
    //底部下载按钮
    UIButton *downLoadBtn = [[UIButton alloc] initWithFrame: CGRectMake(kDeviceWidth/5, imageView.bottom + 10 , kDeviceWidth/8, kDeviceWidth/8)];
    [downLoadBtn setImage:[UIImage imageNamed:@"downloadIcon"] forState:UIControlStateNormal];
    [downLoadBtn addTarget:self action:@selector(downloadAction) forControlEvents:UIControlEventTouchUpInside];
    //底部分享按钮
    UIButton *shareBtn = [[UIButton alloc] initWithFrame: CGRectMake(kDeviceWidth/3 * 2, imageView.bottom +10, kDeviceWidth/8, kDeviceWidth/8)];
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(addShareBtnToCustomWindow) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 666;
    [customWindow addSubview:downLoadBtn];
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        [customWindow addSubview:shareBtn];
    }else
    {
    }
    
    //添加下载和分享的提示按钮
    UILabel *downLoadLabel = [[UILabel alloc] initWithFrame:CGRectMake(downLoadBtn.left-20, downLoadBtn.bottom +5, downLoadBtn.width+40, 20)];
    downLoadLabel.text = @"本地相册";
    downLoadLabel.textAlignment = NSTextAlignmentCenter;
    downLoadLabel.font = [UIFont systemFontOfSize:14];
    downLoadLabel.textColor = [UIColor whiteColor];
    [customWindow addSubview:downLoadLabel];
    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(shareBtn.left, shareBtn.bottom +5, shareBtn.width, 20)];
    shareLabel.text = @"分享";
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = [UIFont systemFontOfSize:14];
    shareLabel.textColor = [UIColor whiteColor];
    if (isAppearThirdLogin) {
        [customWindow addSubview:shareLabel];
        
    }else
    {
        
    }
    //创建完window上的视图之后，执行动画显示customWindow
    [UIView animateWithDuration:0.5 animations:^{
        customWindow.alpha = 1;
        customWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    }];
}

//添加分享视图
- (void)addShareBtnToCustomWindow{
    //首先验证一下，是否已经创建过了分享按钮
    UIButton *button = [customWindow viewWithTag:2000];
    if (button == nil) {
        NSArray *imageArr = @[[UIImage imageNamed:@"ShareToWX"],[UIImage imageNamed:@"ShareToWXP"],[UIImage imageNamed:@"ShareToWB"],[UIImage imageNamed:@"ShareToQQ"]];
        NSArray *titleArr = @[@"微信",@"朋友圈",@"新浪微博",@"QQ",@""];
        //创建分享按钮和标签
        CGFloat buttonWidth = 70;
        CGFloat spaceWidth = (kDeviceWidth -buttonWidth*4)/5;
        for (int i = 0; i < 4; i ++) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth*(i+1)+buttonWidth *i, 0, buttonWidth, buttonWidth)];
            
            btn.tag = 2000 +i;
            [btn addTarget:self action:@selector(sharImage:) forControlEvents:UIControlEventTouchUpInside];
            btn.layer.cornerRadius = buttonWidth/2;
            btn.layer.masksToBounds = YES;
            if (i < 4) {
                [btn setImage:imageArr[i] forState:UIControlStateNormal];
            }
                 if (i == 4) {
                btn.frame = CGRectMake(15 , kDeviceHeight/2, kDeviceWidth - 30, buttonWidth / 2);
                btn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
                btn.layer.cornerRadius = 5;
                UIImageView *showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth/4, 2 , 30, 30)];
                showImageView.center = CGPointMake(kDeviceWidth / 2 - 70, 16);
                showImageView.image = [UIImage imageNamed:@"ShareToShow"];
                [btn addSubview:showImageView];
                UILabel *sharLabel = [[UILabel alloc]initWithFrame:CGRectMake(showImageView.right + 5, 3, kDeviceWidth, 30)];
                sharLabel.text = [NSString stringWithFormat:@"分享到我的秀"];
                sharLabel.textColor = [UIColor whiteColor];
                [btn addSubview:sharLabel];
            }
            [customWindow addSubview:btn];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(btn.left, btn.bottom +5, btn.width, 20)];
            titleLabel.text = titleArr[i];
            titleLabel.tag = 3000 + i;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:14];
            titleLabel.textColor = [UIColor whiteColor];
            [customWindow addSubview:titleLabel];
        }

    }
    UIButton * btn = [customWindow viewWithTag:2000];
    //将customWindow上的黑色视图插入到按钮的下面
    UIView *backView = [customWindow viewWithTag:112];
    [customWindow insertSubview:backView belowSubview:btn];
    
    //动画显示分享按钮

    for(int i = 0 ;i < 4; i++){
        UIButton *btn = (UIButton *)[customWindow viewWithTag:2000+i];
        UILabel *titleLabel = (UILabel *)[customWindow viewWithTag:3000 +i];
        //初始化，设定动画前的初值
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        btn.alpha = 0;
        btn.top = kDeviceHeight;
        
        titleLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        titleLabel.alpha = 0;
        titleLabel.top = btn.bottom +5;
        
        [UIView animateWithDuration:0.3 animations:^{
            //延迟动画的调用
            [UIView setAnimationDelay:i * 0.08];
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            btn.alpha = 1;
            btn.top = kDeviceHeight/2.5 - 30;
            if (i == 4) {
                btn.top = kDeviceHeight/2.5 - 50;
            }
            
            titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            titleLabel.alpha = 1;
            titleLabel.top = btn.bottom +5;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3
                             animations:^{
                                 btn.transform = CGAffineTransformMakeScale(1, 1);
                                 btn.alpha = 1;
                                 btn.top = kDeviceHeight/2.5;
                                 if (i == 4) {
                                     btn.top = kDeviceHeight/2.5 - 50;
                                 }
                                 
                                 titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                                 titleLabel.alpha = 1;
                                 titleLabel.top = btn.bottom +5;
                             }];
        }];
    }

    willlHiddenViewName = @"shareButtons";

}

//customWindow上的手势
//根据类型选择隐藏customWindow还是window上的分享按钮
- (void)viewTapAction{
    if ([willlHiddenViewName isEqualToString:@"customWindow"]){
        //隐藏window并且清除
        [UIView animateWithDuration:0.5 animations:^{
        customWindow.frame = CGRectMake(0,kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
        } completion:^(BOOL finished) {
            customWindow.hidden = YES;
            customWindow = nil;
            _downLoadBtn.userInteractionEnabled = YES;
        }];
    }else if([willlHiddenViewName isEqualToString:@"shareButtons"]){
         //隐藏分享按钮
        //首先调整黑色背景视图
        UIView *backView = [customWindow viewWithTag:112];
        [customWindow insertSubview:backView atIndex:0];
        //隐藏按钮
        int time = 0;
        for(int i = 0 ;i < 4; i++){
            UIButton *btn = (UIButton *)[customWindow viewWithTag:2000+i];
            UILabel *titleLabel = (UILabel *)[customWindow viewWithTag:3000 +i];
            
            [UIView animateWithDuration:0.3 animations:^{
                //延迟动画的调用
                [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
                [UIView setAnimationDelay:time * 0.08];
                btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
                btn.alpha = 1;
                btn.top = kDeviceHeight/3 -100;
                
                titleLabel.transform = CGAffineTransformMakeScale(1.1, 1.1);
                titleLabel.alpha = 1;
                titleLabel.top = btn.bottom +5;
                
            } completion:^(BOOL finished) {
                //让视图从1.2--》1
                [UIView animateWithDuration:0.3
                                 animations:^{
                                     btn.transform = CGAffineTransformMakeScale(1, 1);
                                     btn.alpha = 1;
                                     btn.top = kDeviceHeight;
                                     
                                     titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                                     titleLabel.alpha = 1;
                                     titleLabel.top = btn.bottom +5;
                                 }];
            }];
            time ++;
        }
        //标记:下次触发屏幕将要隐藏customWindow
        willlHiddenViewName = @"customWindow";

    }
}

-(void)hiddenCustomWindow{
    [UIView animateWithDuration:0.5 animations:^{
        customWindow.frame = CGRectMake(0,kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
    } completion:^(BOOL finished) {
        customWindow.hidden = YES;
        customWindow = nil;
        _downLoadBtn.userInteractionEnabled = YES;
    }];
}

-(void)downloadAction{
    //保存图片到相册里
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //显示提示视图
    [MBProgressHUD showHUDAddedTo:customWindow animated:YES];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    [MBProgressHUD hideAllHUDsForView:customWindow animated:YES];

    [UIView animateWithDuration:0.5 animations:^{
        customWindow.frame = CGRectMake(0,kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
    } completion:^(BOOL finished) {
        customWindow.hidden = YES;
        customWindow = nil;
        _downLoadBtn.userInteractionEnabled = YES;
        //显示提示信息
        NSString *alertTitle = @"";
        if (error == nil) {
            //保存成功
            alertTitle = @"已经保存到相册";
        }else{
            alertTitle = @"保存到相册失败";
        }
         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        alertView.tag = 200;
        [alertView show];
    }];

}

#pragma mark - 黑名单的弹出视图
//在当前不是自己的情况下，请求完用户的信息后
//根据是否加入黑名单来重置加入黑名单的选项
- (void)resetActionSheet{
    
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        
        if ([self isMySelfPage]) {
            self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"编辑", nil];
            
        }else{
            if (self.isBlack) {
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"从黑名单中移除",@"举报", nil];
            }else{
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"加入黑名单",@"举报", nil];
            }
        }
        
    }else{
        
        if ([self isMySelfPage]) {
            self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"编辑", nil];
            
        }else{
            
            if (self.isBlack) {
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"从黑名单中移除",@"举报", nil];
            }else{
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"加入黑名单",@"举报", nil];
            }
            
        }
        
    }
}

//点击加入黑名单按或者移除黑名单时调用的方法
- (void)actionForAddBlack:(BOOL)add withParams:(NSDictionary *)params{
    if(!add)
    {//已经加入黑名单，从黑名单移除
        [AFNetwork addRemoveBlackInfo:params success:^(id data){
            NSLog(@"移除黑名单data:%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state isEqualToString:@"0"]) {
                [LeafNotification showInController:self withText:@"移除黑名单成功"];
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"加入黑名单", @"举报", nil];
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
            NSLog(@"加入黑名单data:%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state isEqualToString:@"0"]) {
                [LeafNotification showInController:self withText:@"加入黑名单成功"];
                self.moreSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",@"从黑名单中移除", @"举报", nil];
                self.isBlack = YES;
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            [LeafNotification showInController:self withText:@"操作失败"];
        }];
    }
}




#pragma mark - UIAlertViewDelegate
//确定要执行加入和移除黑名单
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //这里是下载按钮的响应
    if (alertView.tag == 200) {
        return;
    }
    
    if (alertView.tag == 300) {
        [self.navigationController popViewControllerAnimated:YES];
        return;

    }

    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            if (self.isBlack) {
                //从黑名单中移除
                [self actionForAddBlack:NO withParams:_addBlackParams];
            }else{
                //加入黑名单
                [self actionForAddBlack:YES withParams:_addBlackParams];
            }
            break;
        default:
            break;
    }
}



//更聊天用户数据
- (void)updateChatInfoToDB{
    if ([self.sourceVCName isEqualToString:@"chatVC"]) {
        //说明这是从聊天界面进入的那么可以更新一下此人的用户信息
        ChatUserInfo *chatUser = [self getUserWithMessageUserName:self.currentUid];
        if (!chatUser) {
            //创建对象存在数据库中
            chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
            chatUser.chatId = self.currentUid;
            chatUser.nickName = self.viewModel.userName;
            chatUser.headPic = self.viewModel.headerURL;
            [[CoreDataManager shareInstance] saveManagerObj:chatUser];
        }else{
            //用户存在，但是有更新，就更新数据库
            if (![chatUser.nickName isEqualToString:self.viewModel.userName] ||![chatUser.headPic isEqualToString:self.viewModel.headerURL]) {
                chatUser.nickName = self.viewModel.userName;
                chatUser.headPic = self.viewModel.headerURL;
                [[CoreDataManager shareInstance] updateManagerObj:chatUser];
            }
         }
    }
}

//从数据库中取出昵称和头像信息
- (ChatUserInfo *)getUserWithMessageUserName:(NSString *)username{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatId=%@",username];
    NSArray *users = [[CoreDataManager shareInstance] query:@"ChatUserInfo" predicate:predicate];
    
    if (users.count>0) {
        return users[0];
    }
    return nil;
}

//回到聊天界面pop
- (void)popToChatVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}


//判断当前的个人中心是否是自己
- (BOOL)isMySelfPage{
    //获取本地存放的uid
    NSString *uid = currentUID();
    //如果进入当前界面，弹出的选项如下
    if ([uid isEqualToString:getSafeString(self.currentUid)]) {
        return YES;
    }else{
        return NO;
    }
}

-(NSMutableArray *)moKaMutArr{
    if (!_moKaMutArr) {
        _moKaMutArr = [NSMutableArray array];
    }
    return _moKaMutArr;
}



@end
