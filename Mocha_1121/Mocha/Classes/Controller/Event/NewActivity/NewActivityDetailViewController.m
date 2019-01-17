//
//  NewActivityDetailViewController.m
//  Mocha
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewActivityDetailViewController.h"
#import "NewActivityCommentTableViewCell.h"
#import "NewActivityDetailHeaderView.h"
#import "MJRefresh.h"

@interface NewActivityDetailViewController ()<UITextViewDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) NewActivityDetailHeaderView *headerView;

@property (copy, nonatomic) NSString *lastIndex;

@property (copy, nonatomic) NSString *headerURL;

@property (copy, nonatomic) NSString *userName;

@property (copy, nonatomic) NSString *userType;

@property (copy, nonatomic) NSString *ispublisher;

@property (copy, nonatomic) NSString *userID;

@property (strong, nonatomic) UIView *commentView;

@property (strong, nonatomic) UITextView *inputTextView;

@property (assign, nonatomic) BOOL isReplay;

@property (copy, nonatomic) NSString *commentId;

@property (strong, nonatomic) UIButton *bottomButton;

@property (nonatomic,assign)NSInteger pageSize;

@end

@implementation NewActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"活动详情";
    //获取评论数据时保存的lastIndex
    self.lastIndex = @"0";
    self.dataArray = @[].mutableCopy;
    self.headerURL = @"";
    self.userName = @"";
    self.userType = @"";
    
    self.pageSize = 10;
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"moreButtonBack"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(shareMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    //是否显示第三方登陆
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        [self.navigationItem setRightBarButtonItem:rightItem];
        
    }else
    {
        
    }
    //弹出评论视图
    [self initComentView];
    //报名按钮
    [self initBaomingButton];
    
    //通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appearCommentView:) name:@"appearCommentView" object:nil];
    
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector (didchangeBaoming) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    //表视图
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44);
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //请求数据
    [self requestEventInfo];
    //添加刷新视图
    [self addFooter];
}



#pragma mark 视图刷新
//添加底部刷新视图
- (void)addFooter
{
     __weak typeof (self) vc = self;
    // 添加上拉刷新尾部控件
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        [vc requestManagerComments];
    }];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //显示导航栏
    self.navigationController.navigationBarHidden = NO;
    //显示底部按钮
    self.bottomButton.frame = CGRectMake(0, kScreenHeight- 64 -44, kScreenWidth-0, 44);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

- (void)didchangeBaoming
{
    self.bottomButton.frame = CGRectMake(0, kScreenHeight-108, kScreenWidth-0, 44);

}

- (void)initBaomingButton
{
    UIButton *bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kScreenHeight-108, kScreenWidth-0, 44)];
    [bottomButton setTitle:@"报名" forState:UIControlStateNormal];
    bottomButton.titleLabel.font = [UIFont systemFontOfSize:15];
    bottomButton.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    [bottomButton addTarget:self action:@selector(baomingMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bottomButton];
    self.bottomButton = bottomButton;
}

//更新按钮的显示
- (void)updateButton:(NSDictionary *)diction
{
    [self.bottomButton setTitle:getSafeString(diction[@"statusName"]) forState:UIControlStateNormal];
    
    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(diction[@"optionCode"])];
    if ([optionCode isEqualToString:@"1"]) { //立即报名
        [self.bottomButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    }else if([optionCode isEqualToString:@"2"]) //评价活动
    {
        [self.bottomButton setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
        
    }else if([optionCode isEqualToString:@"-1"]) //已报名 不可点击
    {
        [self.bottomButton setBackgroundColor:[UIColor lightGrayColor]];
        
    }else
    {
        [self.bottomButton setBackgroundColor:RGB(157, 198, 83)];
        
    }
}

- (void)baomingMethod
{
    NSString *optionCode = [NSString stringWithFormat:@"%@",getSafeString(self.eventDiction[@"optionCode"])];
    if ([optionCode isEqualToString:@"1"]) { //立即报名
        [[[UIAlertView alloc] initWithTitle:@"" message:@"确定报名?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil] show];
        return;
        
        
    }else if([optionCode isEqualToString:@"2"]) //评价活动
    {
        
        
        
    }else if([optionCode isEqualToString:@"-1"]) //已报名 不可点击
    {
        
        
    }else
    {
        
        
    }
    
}

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
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"eventDetail-msg-cancel"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(10, 10, 22, 23)];
    [closeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:closeButton];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setBackgroundImage:[UIImage imageNamed:@"eventDetail-msg-confirm"] forState:UIControlStateNormal];
    [sendButton setFrame:CGRectMake(kScreenWidth-50, 12, 30,21)];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendCommentView:) forControlEvents:UIControlEventTouchUpInside];
    [whiteView addSubview:sendButton];
    
    UILabel *commentTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, kScreenWidth, 40)];
    commentTitle.text = @"我要留言";
    commentTitle.textAlignment = NSTextAlignmentCenter;
    commentTitle.backgroundColor = [UIColor clearColor];
    commentTitle.textColor = [UIColor grayColor];
    commentTitle.font = [UIFont systemFontOfSize:15];
    [whiteView addSubview:commentTitle];
    
    UITextView *inputTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 50, kScreenWidth-20, 90)];
    inputTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    inputTextView.layer.borderWidth = 1;
    inputTextView.textColor = [UIColor lightGrayColor];
    inputTextView.font = [UIFont systemFontOfSize:15];
    inputTextView.clipsToBounds = YES;
    inputTextView.delegate = self;
    inputTextView.text = @"对活动有疑问可以在这里留言";
    [whiteView addSubview:inputTextView];
    self.inputTextView = inputTextView;
    [commentView addSubview:whiteView];
    self.commentView = commentView;
}

- (void)closeCommentView:(id)sender
{
    NSLog(@"closeCommentView");
    [self.inputTextView resignFirstResponder];
    self.commentView.hidden = YES;
}

- (void)sendCommentView:(id)sender
{
    NSLog(@"sendCommentView");
    NSString *uid = [USER_DEFAULT objectForKey:MOKA_USER_VALUE][@"id"];
    NSDictionary * dict = [AFParamFormat formatEventCommentParams:_eventId uid:uid content:self.inputTextView.text];
    if (self.isReplay) {
        dict = [AFParamFormat formatEventCommentParams:_eventId uid:uid content:self.inputTextView.text commentId:self.commentId];
    }
    [AFNetwork eventComment:dict success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            [self.inputTextView resignFirstResponder];
            self.commentView.hidden = YES;
            self.lastIndex = @"0";
            [self requestManagerComments];
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    }failed:^(NSError *error){
        
    }];
    

}

- (void)appearCommentView:(NSNotification *)data
{
    NSLog(@"appearCommentView   = %@",data);
    
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

    //可以评论
    NSDictionary *diction = data.userInfo;
     NSString *isReplay = [NSString stringWithFormat:@"%@",getSafeString(diction[@"replay"])];
    NSString *commentid = [NSString stringWithFormat:@"%@",getSafeString(diction[@"commentid"])];
    
    if ([isReplay isEqualToString:@"0"]) {
        self.isReplay = NO;
    }else
    {
        self.isReplay = YES;
        self.commentId = commentid;
    }
    
    [UIView animateWithDuration:1.0  animations:^{
        [self.view addSubview:self.commentView];
        self.commentView.hidden = NO;
    }];
    
    
    self.inputTextView.textColor = [UIColor lightGrayColor];
    self.inputTextView.text = @"对活动有疑问可以在这里留言";
    [self.inputTextView becomeFirstResponder];
}

- (void)shareMethod
{
    NSLog(@"share");
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"微信好友",@"朋友圈",@"QQ好友", nil];
    [sheet showInView:self.view];
    
}

#pragma mark- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = @"MOKA活动通告";
    NSString *content = [NSString stringWithFormat:@"活动内容:%@",self.eventDiction[@"content"]];
    if (buttonIndex==0) {
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
        NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
        NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
        NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
        UIImage *headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (!headerImg) {
            headerImg = [UIImage imageNamed:@"AppIcon"];
        } 
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:content header:headerImg shareURL:_eventId];
        
    }else if (buttonIndex==1)
    {
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
        NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
        NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
        NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
        UIImage *headerImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
        if (!headerImg) {
            headerImg = [UIImage imageNamed:@"AppIcon"];
        }
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentTitle:title desc:content header:headerImg shareURL:_eventId];
        
    }
    else if (buttonIndex == 2){
        
        NSString *iconUrl = self.eventDiction[@"publisher"][@"head_pic"];
        NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
        NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        if (!imageData) {
            imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
        }
        
        [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQIsQzone:NO decription:content title:title imageData:imageData targetUrl:@"a" objectId:_eventId isTaoXi:NO];
    }
}


#pragma mark - uialertview delegate
//点击报名之后弹出的提示
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"%ld",(long)buttonIndex);
    if (buttonIndex==1) {
        NSString *eventId = self.eventId;
        NSDictionary *params = [AFParamFormat formatEventSignUpParams:eventId];
        [AFNetwork eventSignUp:params success:^(id data){
            if ([data[@"status"] integerValue] == kRight) {
                [LeafNotification showInController:self withText:data[@"msg"]];
                [self.bottomButton setBackgroundColor:[UIColor lightGrayColor]];
                [self.bottomButton setTitle:@"已报名" forState:UIControlStateNormal];
                [self requestEventInfo];
                // [self performSelector:@selector(pushToChat) withObject:nil afterDelay:1.0];
            }else if([data[@"status"] integerValue] == kReLogin){
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }else if([data[@"status"] integerValue] == 6218){
                
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            }else {
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            
        }];
    }
}

#pragma mark request
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
            self.eventDiction = itemDict;
            self.headerURL = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"head_pic"]];
            self.userName = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"nickname"]];
            self.userType = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"user_type"]];
            self.ispublisher = [NSString stringWithFormat:@"%@",itemDict[@"ispublisher"]];
            //发布者的uid
            NSString *pid = [NSString stringWithFormat:@"%@",itemDict[@"publisher"][@"uid"]];
            NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
            NSString *uid = [NSString stringWithFormat:@"%@",dic[@"id"]];
            self.userID = pid;
            if ([pid isEqualToString:uid]) {
                //自己就是发布者
                self.isMamager = YES;
            
            }else
            {
                self.isMamager = NO;
                
            }
            
            [self requestManagerComments];
            self.headerView = [NewActivityDetailHeaderView getNewActivityDetailHeaderView];
            [self.headerView initViewWithData:itemDict];
            self.headerView.supCon = self;
            [self updateButton:itemDict];
            self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight- 64 -44);
            
            self.tableView.tableHeaderView = self.headerView;
            
            if ([self.ispublisher isEqualToString:@"1"]) {
                self.bottomButton.hidden = YES;
                self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
             }
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
         }
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        NSLog(@"评论列表：%@",data);
        if([data[@"status"] integerValue] == kRight){
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                
                if([_lastIndex isEqualToString:@"0"]){
                    [_dataArray removeAllObjects];
                    [_dataArray addObjectsFromArray:arr];
                    
                }else{
                    [_dataArray addObjectsFromArray:arr];
                    
                }
            }
            
             self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            [self.tableView reloadData];
        }
    }failed:^(NSError *error){
         [_tableView footerEndRefreshing];
    }];
    
}

#pragma mark - textview delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    NSString *titleString = @"对活动有疑问可以在这里留言";
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if ([@"\n" isEqualToString:text] == YES) {
        [self.inputTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [NewActivityCommentTableViewCell getHeightWithDiction:self.dataArray[indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewActivityCommentTableViewCell *cell = nil;
    NSString *identifier = @"NewActivityCommentTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [NewActivityCommentTableViewCell getNewActivityCommentCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.currentUid = self.userID;
    cell.replayHeaderURL = self.headerURL;
    cell.replayName = self.userName;
    cell.replayUserType = self.userType;
    cell.supCon = self;
    [cell setDataWithDiction:self.dataArray[indexPath.row]];
    
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.headerView;
//}


@end
