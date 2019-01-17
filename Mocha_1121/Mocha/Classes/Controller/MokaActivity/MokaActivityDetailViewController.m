//
//  MokaActivityDetailViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaActivityDetailViewController.h"
#import "NewActivityCommentTableViewCell.h"
#import "MokaActivityDetailHeadView.h"
#import "MokaPayViewContorller.h"
#import "MJRefresh.h"
#import "ActivityDetailImageCell.h"
#import "ActivityDetailMemberCell.h"
#import "ChatViewController.h"


@interface MokaActivityDetailViewController ()<
    UITextViewDelegate,
    UITextFieldDelegate,
    UIActionSheetDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIAlertViewDelegate>

//视图布局相关===============
@property (strong, nonatomic)UITableView *tableView;
//表头视图
@property (strong, nonatomic) MokaActivityDetailHeadView *headerView;
//评论视图
@property (strong, nonatomic) UIView *commentView;
@property (strong, nonatomic) UITextView *inputTextView;
//报名按钮
@property (strong, nonatomic) UIButton *bottomButton;
//留言视图
@property (strong,nonatomic)UIView *liuYanView;
//填写众筹费用的window
@property (strong,nonatomic)UIWindow *zhongChouWindow;


//数据相关=================
//请求得到的活动详情数据
@property (strong,nonatomic)NSDictionary *eventDiction;
//关于活动的图片数组
@property (strong,nonatomic)NSArray *imageURLs;
//评论数组
@property (strong, nonatomic) NSMutableArray *dataArray;

//上次请求评论数据的标识
@property (copy, nonatomic) NSString *lastIndex;
@property (nonatomic,assign)NSInteger pageSize;

//发布活动的用户id
@property (copy, nonatomic) NSString *publisherUid;
@property (copy, nonatomic) NSString *headerURL;
@property (copy, nonatomic) NSString *userName;
@property (copy, nonatomic) NSString *userType;
//@property (copy, nonatomic) NSString *ispublisher;


//回复相关===========
@property (assign, nonatomic) BOOL isReplay;
@property (copy,nonatomic) NSString *replayName;
@property (copy, nonatomic) NSString *commentId;

//当前用户是否是发布者
@property (assign,nonatomic)BOOL isPublisher;

@end

@implementation MokaActivityDetailViewController

#pragma mark - 视图加载与刷新

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _vcTitle;
    //获取评论数据时保存的lastIndex
    self.lastIndex = @"0";
    self.dataArray = @[].mutableCopy;
    self.headerURL = @"";
    self.userName = @"";
    self.userType = @"";
    self.pageSize = 10;
    //键盘监听
    [self addKeyBoardNotification];

    //初始化视图
    [self _initViews];
}


- (void)_initViews{
    //表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 -44) style:UITableViewStyleGrouped];
    [self.view addSubview:_tableView];
    //_tableView.backgroundColor = [UIColor orangeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator =NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //_tableView.separatorColor = [UIColor purpleColor];
    //头视图和尾视图
    _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.001)];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 0.001)];
 
    //是否显示第三方,导航栏分享按钮
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 7, 45, 30)];
        [rightButton setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
        
        [rightButton setTitle:@"推荐" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [rightButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [rightButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
        
        [rightButton addTarget:self action:@selector(shareMethod) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;

//        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
//        [rightButton setImage:[UIImage imageNamed:@"moreButtonBack"] forState:UIControlStateNormal];
//        [rightButton addTarget:self action:@selector(shareMethod) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//        [self.navigationItem setRightBarButtonItem:rightItem];
    }
    
    //初始化评论视图
    [self initComentView];
    //初始化报名按钮
    [self initBaomingButton];
    //添加刷新视图
    [self addFooter];

    //设置通知
    //点击了评论按钮
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appearCommentView:) name:@"appearCommentView" object:nil];
    //改变底部报名的按钮
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector (didchangeBaoming) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏底部标签栏
    [self.customTabBarController hidesTabBar:YES animated:NO];
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //显示底部按钮
    self.bottomButton.frame = CGRectMake(0, kScreenHeight- 64 -44, kScreenWidth, 44);
    [self requestEventInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}





//添加底部刷新视图
- (void)addFooter
{
    __weak typeof(self) vc = self;
    // 添加上拉刷新尾部控件
    [_tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestManagerComments];
    }];
}


#pragma mark - 评论视图
- (void)initComentView
{
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    commentView.backgroundColor = [UIColor clearColor];
    
    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    background.backgroundColor = [UIColor blackColor];
    background.alpha = 0.5;
    [commentView addSubview:background];
    float theY = 260;
    NSLog(@"%f",kScreenWidth);
    if (kScreenWidth==320) {
        theY = 102;
    }else if(kScreenWidth==375)
    {
        theY = 202;
    }
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, kScreenWidth, 150)];
    whiteView.tag = 200;
    whiteView.backgroundColor = [UIColor whiteColor];
    //关闭
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"eventDetail-msg-cancel"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(10, 10, 22, 23)];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    //发送
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"eventDetail-msg-confirm"] forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(kScreenWidth-50, 12, 30,21)];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sendButton];
    //标题
    UILabel *commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    commentTitle.text = @"我要留言";
    commentTitle.textAlignment = NSTextAlignmentCenter;
    commentTitle.backgroundColor = [UIColor clearColor];
    commentTitle.textColor = [UIColor grayColor];
    commentTitle.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:commentTitle];
    //输入框
    UITextView *inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth-20, 90)];
    inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputTextView.layer.borderWidth = 1;
    inputTextView.textColor = [UIColor lightGrayColor];
    inputTextView.font = [UIFont systemFontOfSize:15];
    inputTextView.clipsToBounds = YES;
    inputTextView.delegate = self;
    //输入框提示文字
    UILabel *inputDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, inputTextView.width-5, 30)];
    inputDescLabel.text = @"对活动有疑问可以在这里留言";
    inputDescLabel.tag = 1000;
    inputDescLabel.font = [UIFont systemFontOfSize:15];
    inputDescLabel.textColor = [UIColor lightGrayColor];
    [inputTextView addSubview:inputDescLabel];
    
    [whiteView addSubview:inputTextView];
    self.inputTextView = inputTextView;
    [commentView addSubview:whiteView];
    self.commentView = commentView;
}


- (void)closeCommentView:(id)sender
{
    NSLog(@"closeCommentView");
    self.inputTextView.text = @"";
    [self.inputTextView resignFirstResponder];
    self.commentView.hidden = YES;
}

- (void)sendCommentView:(id)sender
{
    NSLog(@"sendCommentView");
    NSString *inputDescTxt = @"";
    NSString *commentContent = @"";
    //主人回复
    if (_isReplay) {
        inputDescTxt = [NSString stringWithFormat:@"@%@",_replayName];
        commentContent = [NSString stringWithFormat:@"%@ %@",inputDescTxt,self.inputTextView.text];
    }else{
        inputDescTxt = @"对活动有疑问可以在这里留言";
        commentContent = [NSString stringWithFormat:@"%@",self.inputTextView.text];
    }
    /*
    if ([_inputTextView.text isEqualToString:inputDescTxt]) {
        _inputTextView.text = @"";
        _inputTextView.textColor =  [UIColor blackColor];
        [LeafNotification showInController:self withText:@"请输入评论内容"];
        return;
    }
     */
    if (_inputTextView.text.length == 0){
        _inputTextView.textColor =  [UIColor blackColor];
        [LeafNotification showInController:self withText:@"内容不能为空,请输入"];
        return;
    }
    
    NSString *uid = [USER_DEFAULT objectForKey:MOKA_USER_VALUE][@"id"];
    
    //1.评论
    NSDictionary * dict = [AFParamFormat formatEventCommentParams:_eventId uid:uid content:commentContent];
    
    //2.回复
    if (self.isReplay) {
        dict = [AFParamFormat formatEventCommentParams:_eventId uid:uid content:self.inputTextView.text commentId:self.commentId];
    }
    
    [AFNetwork eventComment:dict success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            [self closeCommentView:nil];
            self.lastIndex = @"0";
            [self requestManagerComments];
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)appearCommentView:(NSDictionary *)diction
{
    
    if ([self isFailForCheckLogInStatus]) {
        return;
    }
    
//    //判断是否登陆和绑定
//    if (getCurrentUid()){
//        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
//        if (!isBangDing) {
//            //显示绑定
//            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
//            return;
//        }
//    }else{
//        //显示登陆
//        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
//        return;
//    }
    
    //可以评论
    NSString *isReplay = [NSString stringWithFormat:@"%@",getSafeString(diction[@"replay"])];
    
    //区分提示文字
    NSString *inputDescTxt = @"";
    if ([isReplay isEqualToString:@"0"]) {
        //留言
        self.isReplay = NO;
        self.replayName = @"";
        inputDescTxt = @"对活动有疑问可以在这里留言";
    }else
    {   //回复：只有当前是发布者才能回复
        self.isReplay = YES;
        self.replayName = diction[@"replayName"];
        self.commentId =  [NSString stringWithFormat:@"%@",getSafeString(diction[@"commentid"])];
        inputDescTxt = [NSString stringWithFormat:@"@%@",diction[@"replayName"]] ;
    }
    
    UILabel *inputDescLabel = [_inputTextView viewWithTag:1000];
    inputDescLabel.hidden = NO;
    inputDescLabel.text = inputDescTxt;
    self.inputTextView.text = @"";
    //显示输入框
    [UIView animateWithDuration:1.0  animations:^{
        [self.view addSubview:self.commentView];
        self.commentView.hidden = NO;
    }];
    

    self.inputTextView.textColor = [UIColor lightGrayColor];
    [self.inputTextView becomeFirstResponder];
}

#pragma mark - 报名按钮
- (void)initBaomingButton
{
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-64-44, kScreenWidth-0, 44)];
    [bottomButton setTitle:@"报名" forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    bottomButton.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    [bottomButton addTarget:self action:@selector(baomingMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    self.bottomButton = bottomButton;
    self.bottomButton.hidden = YES;
}

- (void)didchangeBaoming
{
    self.bottomButton.frame = CGRectMake(0, kScreenHeight-64 - 44, kScreenWidth-0, 44);
}


//更新按钮的显示
- (void)updateButton:(NSDictionary *)diction
{
    self.bottomButton.hidden = NO;
    [self.bottomButton setTitle:getSafeString(diction[@"statusName"]) forState:UIControlStateNormal];
    //操作码
    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(diction[@"optionCode"])];
    NSInteger optionNum = [optionCode integerValue];
 
    switch (optionNum) {
        case 1:
        {
            //立即报名
            [self.bottomButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
            break;
        }
        case 3:
        {
            //参加众筹：我要参与
            [self.bottomButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
            break;
        }
        case 0:
        {
            //不需要任何操作(正向):已报名
            [self.bottomButton setBackgroundColor:RGB(157, 198, 83)];
            break;
        }
        case -1:
        {
            //不需要任何操作(反向):报名已截止，活动已结束
            [self.bottomButton setBackgroundColor:[UIColor lightGrayColor]];
            break;
        }
        case 2:
        {
            //评价活动
            [self.bottomButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
            break;
        }
        default:
        {
            [self.bottomButton setBackgroundColor:RGB(157, 198, 83)];
            break;
        }
    }

 }

- (void)baomingMethod
{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
    }
    
    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(self.eventDiction[@"optionCode"])];
    NSInteger optionNum = [optionCode integerValue];
    //通告类型的处理
    switch (optionNum) {
        case 1:
        {
            //立即报名
            [[[UIAlertView alloc] initWithTitle:@"" message:@"确定报名?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
            break;
        }
        case 3:
        {
            //输入众筹金额
            [self showZhongChouWindow];
            break;
        }
        case -1:
        {
            //不需要任何操作(反向)
            break;
        }
        case 0:
        {
            //不需要任何操作(正向)
            break;
        }
        case 2:
        {
            //评价活动
            break;
        }
        default:
            break;
    }
 }

#pragma mark 进入群聊
- (void)pushToChat
{
    NSString *groupId = getSafeString(_eventDiction[@"id"]);
    NSString *title = getSafeString(_eventDiction[@"title"]);
    
    ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:groupId isGroup:YES];
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}



#pragma mark - 选择众筹金额
- (void)showZhongChouWindow{
    if(_zhongChouWindow == nil){
        _zhongChouWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight)];
        _zhongChouWindow.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:_zhongChouWindow.bounds];
        backView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        backView.alpha = 0.9;
        [_zhongChouWindow addSubview:backView];
        
        //距离左右边距
        CGFloat horizonalPadding = 20;
        //距离上边的距离
        CGFloat verticalPadding = 0;
        //子视图的距离左右的宽度
        CGFloat leftPadding = 10;
        //子视图距离上面的距离
        CGFloat topPadding = 20;
        //按钮的宽高度
        CGFloat buttonWidth = 80;
        //输入框高度
        CGFloat txtFieldHeight = 50;
        if([CommonUtils getRuntimeClassIsIphone]){
            if(kDeviceWidth<375){
                verticalPadding = 50;
                topPadding = 8;
                buttonWidth = 50;
                txtFieldHeight = 40;
                
            }else{
                verticalPadding = 200;
                topPadding = 20;
                buttonWidth = 80;
                txtFieldHeight = 50;
            }
        }else{
            verticalPadding = 50;
            topPadding = 8;
            buttonWidth = 50;
            txtFieldHeight = 40;
        }

        //子视图的宽度
        CGFloat subViewWidth = kDeviceWidth -horizonalPadding *2 -leftPadding *2 ;

        //提示文字
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
        //此界面是众筹的支付界面
        NSString *event_smoney = [descriptionDic objectForKey:@"event_smoney"];
        if(event_smoney.length == 0){
            event_smoney  =  @"请确定你要支持的众筹金额，你也可以填写其他众筹金额，以获得相应的回报，报名成功之后将进入众筹群组";
        }
        NSString *zhongChouTxt =event_smoney;
        //计算文字的高度
        CGFloat txtHeight = [SQCStringUtils getCustomHeightWithText:zhongChouTxt viewWidth:subViewWidth textSize:16];
        //创建视图
        UIView *zhongChouView = [[UIView alloc] initWithFrame:CGRectMake(horizonalPadding, verticalPadding, kDeviceWidth -horizonalPadding *2, 400)];
        zhongChouView.backgroundColor = [CommonUtils colorFromHexString:@"#FFFFFF"];
        [_zhongChouWindow addSubview:zhongChouView];
        //1.标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, topPadding,subViewWidth, 30)];
        titleLabel.text = @"选择众筹金额";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:20];
        titleLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
        [zhongChouView addSubview:titleLabel];
        //2.提示文字
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftPadding, titleLabel.bottom + topPadding,subViewWidth,txtHeight)];
        detailLabel.text = zhongChouTxt;
        detailLabel.numberOfLines = 0;
        detailLabel.font = [UIFont systemFontOfSize:16];
        [zhongChouView addSubview:detailLabel];
        //3.输入金额
        UITextField *zhongChoufeeTxtField = [[UITextField alloc] initWithFrame:CGRectMake(leftPadding, detailLabel.bottom +topPadding, subViewWidth, txtFieldHeight)];
        zhongChoufeeTxtField.tag = 103;
        zhongChoufeeTxtField.delegate = self;
        zhongChoufeeTxtField.keyboardType = UIKeyboardTypeNumberPad;
        zhongChoufeeTxtField.textAlignment = NSTextAlignmentCenter;
        zhongChoufeeTxtField.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        zhongChoufeeTxtField.text = _eventDiction[@"paymentNumber"];
        //zhongChoufeeTxtField.layer.cornerRadius = 5;
        //zhongChoufeeTxtField.layer.masksToBounds = YES;
        [zhongChouView addSubview:zhongChoufeeTxtField];
        //"元"
        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(zhongChoufeeTxtField.right-txtFieldHeight, 0 , txtFieldHeight, txtFieldHeight)];
        yuanLabel.text = @"元";
        yuanLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackTextColor];
        yuanLabel.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        yuanLabel.textAlignment = NSTextAlignmentCenter;
        [zhongChoufeeTxtField addSubview:yuanLabel];
        
        //4.取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftPadding +20, zhongChoufeeTxtField.bottom +topPadding, buttonWidth, buttonWidth)];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancleBtn.tag = 100;
        cancleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [cancleBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackTextColor] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(zhongChouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [zhongChouView addSubview:cancleBtn];
        //确定按钮
        UIButton *sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(subViewWidth -leftPadding -20 -buttonWidth, zhongChoufeeTxtField.bottom +topPadding, buttonWidth, buttonWidth)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        sureBtn.tag = 101;
        sureBtn.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        sureBtn.layer.cornerRadius = buttonWidth/2;
        sureBtn.layer.masksToBounds = YES;
        [sureBtn addTarget:self action:@selector(zhongChouBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [zhongChouView addSubview:sureBtn];
        //重新制定viewframe
        CGFloat height = sureBtn.bottom +topPadding;
        zhongChouView.frame = CGRectMake(horizonalPadding,verticalPadding, subViewWidth +leftPadding *2, height);
        
        //点击其他地方消失键盘
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissZhongChouKeyBoard)];
        [_zhongChouWindow addGestureRecognizer: singleTap];

    }
    
    //显示视图
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _zhongChouWindow.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
        _zhongChouWindow.hidden = NO;
     } completion:^(BOOL finished) {
     }];

}

- (void)dismissZhongChouKeyBoard{
    UITextField *zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
    [zhongChoufeeTxtField resignFirstResponder];
}

- (void)zhongChouBtnClick:(UIButton *)btn{
    UITextField *zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
    [zhongChoufeeTxtField resignFirstResponder];
    if (btn.tag == 100) {
        //点击取消，隐藏金额视图的显示
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _zhongChouWindow.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
        } completion:^(BOOL finished) {
            _zhongChouWindow = nil;

        }];
    }else if(btn.tag == 101){
        //判断金额是否符合要求
        zhongChoufeeTxtField = [_zhongChouWindow viewWithTag:103];
        //填入的金额
        CGFloat feeTxtNum = [zhongChoufeeTxtField.text floatValue];
        //需要的金额
        CGFloat zhongChouMoney = [_eventDiction[@"paymentNumber"] floatValue];
        
        if(zhongChouMoney == 0){
            _zhongChouWindow.alpha = 0;
            _zhongChouWindow = nil;
            if(feeTxtNum == 0){
                //众筹的要求金额是0，填入的金额为0,不需要跳转到支付界面
                //直接报名活动
                [self requestForBaoMing:YES];
            }else{
                //使用填入的金额支付
                [self enterToMokaPayVC:zhongChoufeeTxtField.text];
            }
        }else{
            //需要的金额大于0
            if (feeTxtNum>zhongChouMoney ||feeTxtNum ==zhongChouMoney) {
                _zhongChouWindow.alpha = 0;
                _zhongChouWindow = nil;
                //支付大于或等于众筹的金额
                [self enterToMokaPayVC:zhongChoufeeTxtField.text];
            }else{
                //金额不够
                //[LeafNotification showInController:self withText:@"不能小于众筹金额"];
                NSString *alertTxt = [NSString stringWithFormat:@"不能小于众筹金额%@元",_eventDiction[@"paymentNumber"]];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:alertTxt delegate:self cancelButtonTitle:nil otherButtonTitles: @"确定", nil];
                alertView.tag = 666;
                [alertView  show];
                
            }
        }
    }
}




#pragma mark - 直接报名和支付报名
//普通报名不需要传入pay_ingo参数，
//若众筹的最低金额为0，用户输入为0,不需要进入支付界面，但是此时必须传入支付参数
//但是此时的参数是NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":@"0"};
//报名请求
-(void)requestForBaoMing:(BOOL)needPayInfo{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //活动ID
    NSString *eventId = [NSString stringWithFormat:@"%@",_eventDiction[@"id"]];
    [mDic setObject:eventId forKey:@"id"];
    if(needPayInfo){
        NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":@"0"};
        //json格式
        NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
        [mDic setObject:pay_info forKey:@"pay_info"];
    }else{
        
    }
    [mDic setObject:@"3" forKey:@"optionCode"];
    //完善参数
    NSDictionary *params = [AFParamFormat formatEventSignUpParams:mDic];
    //报名
    [AFNetwork postRequeatDataParams:params path:PathEventSignUp success:^(id data) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        NSLog(@"报名并且支付：%@",data);
        NSInteger statusNum = [data[@"status"] integerValue];
        switch (statusNum) {
            case kRight:
            {
                //报名成功
                //[LeafNotification showInController:self withText:data[@"msg"]];
                //[self requestEventInfo];
                //进入群聊
                NSString *title = [NSString stringWithFormat:@"报名成功，请进入活动群聊"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = 667;
                [alertView show];
                break;
            }
            case kReLogin:
            {
                //登陆
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
                break;
            }
            case 6218:
            {   //绑定
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
                break;
            }
            default:{
                [LeafNotification showInController:self withText:data[@"msg"]];
                break;
            }
        }
        
    } failed:^(NSError *error) {
        NSLog(@"requesetForBaoMing错误：%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}




- (void)enterToMokaPayVC:(NSString *)needMoney{
    _zhongChouWindow.alpha = 0;
    _zhongChouWindow = nil;
    //跳转到支付界面
    MokaPayViewContorller *mokaPayVC = [[MokaPayViewContorller alloc] init];
    mokaPayVC.payType = @"zhongChou";
    mokaPayVC.vcTitlte = @"确认报名";
    mokaPayVC.needAllMoney = needMoney;
    mokaPayVC.themeStr =[NSString stringWithFormat:@"%@",_eventDiction[@"title"]];
    mokaPayVC.dataDic = _eventDiction;
    [self.navigationController pushViewController:mokaPayVC animated:YES];
}





#pragma mark - 导航栏上分享
- (void)shareMethod
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"朋友圈",@"QQ好友", nil];
    [sheet showInView:self.view];
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = getSafeString(self.eventDiction[@"title"]);
    NSString *content = [NSString stringWithFormat:@"%@",self.eventDiction[@"content"]];
    //NSLog(@"选择分享按钮index：%ld",buttonIndex);
    switch (buttonIndex) {
        case 0:
        {
            //微信好友
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
            NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
            NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
            UIImage *headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:content header:headerImg shareURL:_eventId];

            break;
        }
        case 1:
        {
            //朋友圈
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
            NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
            NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
            UIImage *headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:content header:headerImg shareURL:_eventId];

            break;
        }
        case 2:
        {
            //qq空间
            NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
            NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
            NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            if (!imageData) {
                imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:content title:title imageData:imageData targetUrl:@"a" objectId:_eventId isTaoXi:NO];
            break;
        }
        default:
            break;
    }
}


#pragma mark - uialertview delegate
//点击报名之后弹出的提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    switch (alertView.tag) {
        case 666:
        {
            //填写众筹金额不够
            break;
         }
        case 667:
        {
            //报名成功，提示进入群聊
            [self pushToChat];
            break;
        }
        default:{
            //普通类型的报名
            if (buttonIndex==1) {
                [self requestForBaoMing:NO];
            }
            break;
        }
    }
}







#pragma mark 请求活动详情数据
- (void)requestEventInfo
{
    //重置评论的最后标记
    self.lastIndex = @"0";
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *param = [AFParamFormat formatEventInfoParams:_eventId];
    [AFNetwork eventInfo:param success:^(id data){
        NSLog(@"活动详情：%@",data);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
        
        if([data[@"status"] integerValue] == kRight){
            NSDictionary *itemDict = data[@"data"];
            //总体数据
            self.eventDiction = itemDict;
            //作为回复时候用到的信息
            self.headerURL = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"head_pic"]];
            self.userName = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"nickname"]];
            self.userType = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"user_type"]];
           self.publisherUid = itemDict[@"publisher"][@"uid"];
            
            //图片数组
            id imgArr = itemDict[@"img"];
            if (![imgArr isKindOfClass:[NSArray class]]) {
                imgArr = @[].mutableCopy;
            }
            _imageURLs = imgArr;
    
            //判断当前用户是否是活动发布者
            if ([itemDict[@"ispublisher"] isEqualToString:@"1"]) {
                self.isPublisher = YES;
            }else{
                self.isPublisher = NO;
            }
            
            //判断当前活动类型
            
            NSString *type = itemDict[@"type"];
            if ([type isEqualToString:@"4"]||[type isEqualToString:@"1"]) {
                _typeNum  = 1;
                self.title = @"通告详情";
            }else if([type isEqualToString:@"5"]){
                _typeNum = 2;
                self.title = @"众筹活动";
            }else if([type isEqualToString:@"6"]){
                _typeNum = 3;
                self.title = @"活动海报";
            }

            
            //请求评论数据
            [self requestManagerComments];
            
            //根据新数据重新设置头视图
            self.headerView = [[MokaActivityDetailHeadView alloc] init];
            self.headerView.typeNum = self.typeNum;
            self.headerView.dataDic = itemDict;
            self.headerView.superVC = self;
            _tableView.tableHeaderView = self.headerView;
            
            //刷新表视图
            [_tableView reloadData];

             //更新报名按钮的状态
            [self updateButton:itemDict];
            
            //由于报名按钮的变化调整表视图的高度
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kDeviceHeight-64 -44);
            if (self.isPublisher) {
                //如果是活动的发布者,不显示报名按钮
                self.bottomButton.hidden = YES;
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight -64);
            }
         }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
     
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}



- (void)requestManagerComments
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:self.eventId forKey:@"id"];
    [dict setValue:self.lastIndex forKey:@"lastindex"];
    [dict setValue:[NSNumber numberWithInteger:_pageSize] forKey:@"pagesize"];
    
    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork eventCommentList:param success:^(id data){
        [_tableView footerEndRefreshing];
        //NSLog(@"评论列表：%@",data);
        if([data[@"status"] integerValue] == kRight){
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if([_lastIndex isEqualToString:@"0"]){
                    [_dataArray removeAllObjects];
                    [_dataArray addObjectsFromArray:arr];
                    
                }else{
                    [_dataArray addObjectsFromArray:arr];
                    
                }
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                [self.tableView reloadData];

            }
        }
    }failed:^(NSError *error){
        [_tableView footerEndRefreshing];
    }];
    
}




#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
//    NSString *inputDescTxt = @"";
//     if (_isReplay) {
//        inputDescTxt = [NSString stringWithFormat:@"@%@",_replayName];
//     }else{
//        inputDescTxt = @"对活动有疑问可以在这里留言";
//     }
//    if ([textView.text isEqualToString:inputDescTxt]) {
//        textView.text = @"";
//        textView.textColor = [UIColor blackColor];
//    }
    //输入的时候，收起提示文字
    UILabel *inputDescLabel = [_inputTextView viewWithTag:1000];
    inputDescLabel.hidden = YES;
    
    //换行情况下，收起键盘
    if ([@"\n" isEqualToString:text] == YES) {
        [self.inputTextView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - uitableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     if(section == 0){
        //图片数组
        return _imageURLs.count;
    }else if(section == 1){
        //报名情况
        return 1;
    }else if(section == 2){
        //评论数组
        return self.dataArray.count;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //图片类型的cell
    if (indexPath.section == 0) {
        ActivityDetailImageCell *cell = nil;
        NSString *identifier = @"ActivityDetailImageCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ActivityDetailImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.imgDic = _imageURLs[indexPath.row];
        return cell;
    }else if(indexPath.section == 1){
        //活动详情的Cell
        ActivityDetailMemberCell *cell = nil;
        NSString *identifier = @"ActivityDetailMemberCellID";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ActivityDetailMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
         }
        cell.typeNum = self.typeNum;
        cell.superVC = self;
        cell.dataDic = self.eventDiction;
        return cell;
        
    }else if(indexPath.section == 2){
        //评论单元格
        NewActivityCommentTableViewCell *cell = nil;
        NSString *identifier = @"NewActivityCommentTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [NewActivityCommentTableViewCell getNewActivityCommentCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        cell.currentUid = self.publisherUid;
        cell.replayHeaderURL = self.headerURL;
        cell.replayName = self.userName;
        cell.replayUserType = self.userType;
        cell.supCon = self;
        cell.dataDiction = self.dataArray[indexPath.row];
        //[cell setDataWithDiction:self.dataArray[indexPath.row]];
        return cell;
    }
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        NSDictionary *imgDic = _imageURLs[indexPath.row];
        CGFloat width = [[imgDic objectForKey:@"width"] floatValue] ;
        CGFloat height = [[imgDic objectForKey:@"height"] floatValue];
        CGFloat cellWidth =  kDeviceWidth - 20*2;
        CGFloat cellHeight = 0;
        //
        if (width == 0 ||height == 0) {
            cellHeight = cellWidth;
        }else{
            cellHeight = cellWidth*(height/width);
        }
        return  cellHeight +5;
        
    }else if(indexPath.section == 1){
        return  [ActivityDetailMemberCell getActivityDetailMemberCellHeight:_eventDiction];
    }else if(indexPath.section == 2){
    //评论单元格高度
     return [NewActivityCommentTableViewCell getHeightWithDiction:self.dataArray[indexPath.row]];
    }
    return 0;
}



- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        //创建留言视图
        return  [self get_liuYanView];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if (_eventDiction == nil) {
            return 0.01;
        }
        return 50;
    }else{
        return 0.01f;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}

//点击留言可回复留言
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 2){
        if (_isPublisher) {
        //当前是发布者，点击单元格是为了回复某人
        NSDictionary *dic = _dataArray[indexPath.row];
            @try {
              [self appearCommentView:@{@"replay":@"1",@"replayName":dic[@"nickname"],@"commentId":dic[@"id"]}];
            }
            @catch (NSException *exception) {
                NSLog(@"错误：%@",exception);
            }
            @finally {
                
            }
        }
    }
}

#pragma mark - 留言
- (UIView *)get_liuYanView{
    CGFloat leftPadding = 20;
     _liuYanView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    _liuYanView.backgroundColor = [CommonUtils colorFromHexString:@"#FFFFFF"];
    //灰色分割线
    UIView *lineOneView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, 0, kDeviceWidth -leftPadding *2, 0.5)];
    lineOneView.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    [_liuYanView addSubview:lineOneView];
    
     //图标
     UIImageView *liuYanImgView = [[UIImageView alloc] initWithFrame: CGRectMake(leftPadding,15, 20, 20)];
     liuYanImgView.image = [UIImage imageNamed:@"liuyan2"];
     [_liuYanView addSubview:liuYanImgView];
    
     //文字
     UILabel *liuYanTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(liuYanImgView.right +10, 10, 100, 30)];
     liuYanTxtLabel.text = @"留言";
     [_liuYanView addSubview:liuYanTxtLabel];
    
     //按钮
     UIButton *liuYanBtn = [[UIButton alloc] initWithFrame: CGRectMake(kDeviceWidth - leftPadding -90, 10, 90, 30)];
     [liuYanBtn setTitle:@"我要留言" forState:UIControlStateNormal];
     liuYanBtn.titleLabel.font = [UIFont systemFontOfSize:15];
     liuYanBtn.layer.cornerRadius = 10;
     liuYanBtn.layer.masksToBounds = YES;
     [liuYanBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
     liuYanBtn.backgroundColor =  [CommonUtils colorFromHexString:@"#D2CBA1"];;
     [liuYanBtn addTarget:self action:@selector(woyaoLiuYan:) forControlEvents:UIControlEventTouchUpInside];
     [_liuYanView addSubview:liuYanBtn];
    //灰色分割线
    UIView *lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(leftPadding, _liuYanView.bottom, kDeviceWidth -leftPadding * 2, 0.5)];
    lineTwoView.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    [_liuYanView addSubview:lineTwoView];

    return _liuYanView;
}


//我要留言
- (void)woyaoLiuYan:(id)btn {
    NSLog(@"woyaoLiuYan");
    [self appearCommentView:@{@"replay":@"0"}];
 }



#pragma mark - 键盘的监听
- (void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardNotificationAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

//键盘响应事件
- (void)keyBoardNotificationAction:(NSNotification *)notification{
    CGFloat keyBoard_topY = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y -64;
    //得到的坐标是是不计导航栏的
    NSLog(@"键盘的顶部高度(不计导航栏):%f",keyBoard_topY);
    
    //在详情输入框是第一响应者的情况下才做处理
    if (self.inputTextView.isFirstResponder) {
        UIView *whiteView = [self.commentView viewWithTag:200];
        [UIView animateWithDuration:0.3 animations:^{
             whiteView.frame = CGRectMake(0, keyBoard_topY -150, kDeviceWidth, 150);
        }completion:^(BOOL finished) {
            
         }];
    }
}


- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"appearCommentView" object:nil];
}


@end
