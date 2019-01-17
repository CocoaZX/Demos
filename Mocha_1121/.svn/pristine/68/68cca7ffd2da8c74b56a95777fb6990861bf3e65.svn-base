/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "ChatViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "SRRefreshView.h"
#import "DXChatBarMoreView.h"
#import "DXRecordView.h"
#import "DXFaceView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatSendHelper.h"
#import "MessageReadManager.h"
#import "MessageModelManager.h"
#import "EaseMob.h"
#import "EMAlertView.h"
#import "UIViewController+HUD.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"
#import "DXChatBarMoreView.h"
#import "ChatViewController+Category.h"
#import "EMChatManagerDelegate.h"
#import "EMCDDeviceManager.h"
#import "IChatManagerDelegate.h"
#import "LocationViewController.h"
#import "EMCDDeviceManagerDelegate.h"
#import "YuePaiDetailViewController.h"
#import "StartYuePaiViewController.h"
#import "ChatDetailViewController.h"
#import "ChatDetailGroupViewController.h"
#import "MemberCenterController.h"
#import "SQCStringUtils.h"
#import "DaShangGoodsView.h"
//coredata数据库
#import "ChatUserInfo.h"
#import "CoreDataManager.h"

#import "PhotoViewDetailController.h"
//金币充值
#import "JinBiViewController.h"



#define KPageCount 20
#define KHintAdjustY    50

@interface ChatViewController ()<UITableViewDataSource,
                                UITableViewDelegate,
UINavigationControllerDelegate,
                                UIImagePickerControllerDelegate,
                                LocationViewDelegate,
                                SRRefreshDelegate,
                                IChatManagerDelegate,
                                DXChatBarMoreViewDelegate,
                                DXMessageToolBarDelegate,
                                EMCDDeviceManagerDelegate,
                                UIAlertViewDelegate,ChangeForZoomImgViewDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    BOOL _isScrollToBottom;
    
}

@property (nonatomic) BOOL isChatGroup;

@property (nonatomic) EMConversationType conversationType;

//第三方：下拉刷新视图
@property (strong, nonatomic) SRRefreshView *slimeView;
//提供默认的录音，表情，更多按钮的附加页面
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;

@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) MessageReadManager *messageReadManager;//message阅读的管理者

//导航栏上详情按钮
@property (strong, nonatomic) UIButton *rightBtn;

//会话管理者
@property (strong, nonatomic) EMConversation *conversation;

@property (strong, nonatomic) NSDate *chatTagDate;

//@property (strong, nonatomic) NSMutableArray *messages;
@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;
@property (nonatomic) BOOL isKicked;

@property (strong, nonatomic) UILabel *titleLabel;

//聊天提示视图
@property(nonatomic,strong)UIView *alertView;

//聊天限制提醒
@property(nonatomic,strong)UIWindow *notificationWindow;
//打赏视图
@property (nonatomic,strong)DaShangGoodsView *dashang;



//单聊对方的信息
@property(nonatomic,strong)NSDictionary *chatterDic;
//是否可以聊天
@property(nonatomic,strong)NSDictionary *messageEnable;

@end

@implementation ChatViewController


#pragma mark 视图初始化设置相关
- (instancetype)initWithChatter:(NSString *)chatter isGroup:(BOOL)isGroup
{
    EMConversationType type = isGroup ? eConversationTypeGroupChat : eConversationTypeChat;
    self = [self initWithChatter:chatter conversationType:type];
    if (self) {
    }
    
    return self;
}

//传入消息接收者的chatter
- (instancetype)initWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _conversationType = type;
        _messages = [NSMutableArray array];
        
        //根据接收者的username获取当前会话的管理者
        //此方法获取会话的顺序如下:
        //1. 查找内存会话列表中的会话;
        //2. 如果没找到, 试图从数据库中查找此条会话;
        //3. 如果仍没找到, 创建一个新的会话, 加到会话列表中, 并触发didUpdateConversationList:回调
        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter
                                                                    conversationType:type];
        [_conversation markAllMessagesAsRead:YES];
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self registerBecomeActive];
    self.view.backgroundColor = COLOR(248, 248, 248);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout =  UIRectEdgeNone;
    }
    
    //单聊,会话对方的头像和昵称
    if (_conversation.conversationType==eConversationTypeChat) {
        _conversation.ext = @{@"name":getSafeString(self.title),@"headUrl":getSafeString(self.toHeaderURL)};
        
    }
    
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitGroup) name:@"ExitGroup" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(insertCallMessage:) name:@"insertCallMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callOutWithChatter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleCallNotification:) name:@"callControllerClose" object:nil];
    //点击放大图片
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeForZoomImgView:) name:@"ChangeForZoomImgView" object:nil];
    //打赏成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatVCForDaShang:) name:@"refreshChatVCForDaShang" object:nil];
 
    
    _messageQueue = dispatch_queue_create("easemob.com", NULL);
    //默认没有滑动到底部
    _isScrollToBottom = NO;
    
    
    //设置导航栏按钮
    [self setupBarButtonItem];
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.slimeView];
    [self.view addSubview:self.chatToolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    //设置输入框的中的文字
    if(_preparedTxt.length != 0){
        self.chatToolBar.inputTextView.text = _preparedTxt;
    }
    //添加手势，隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
   
    
    if (_conversationType == eConversationTypeChatRoom)
    {
        [self joinChatroom:_chatter];
    }
    
    //    [self addTitleView];
    
    
    //添加导航栏右侧聊天详情按钮
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    rightBtn.clipsToBounds = YES;
    if (_conversation.conversationType==eConversationTypeChat){
        [rightBtn setImage:[UIImage imageNamed:@"personChat"] forState:UIControlStateNormal];
    }else{
        [rightBtn setImage:[UIImage imageNamed:@"groupChatDetailicon"]forState:UIControlStateNormal];
    }
    [rightBtn addTarget:self action:@selector(rightItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //没有聊天记录的就显示警告视图
    if ([[_conversation loadAllMessages] count] ==0) {
        //需要显示警示视图
        [self showAlertView];

    }
    
}


- (void)setupBarButtonItem
{
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self.navigationItem setLeftBarButtonItem:backItem];
    
    //    if (self.isChatGroup) {
    //        UIButton *detailButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    //        [detailButton setImage:[UIImage imageNamed:@"group_detail"] forState:UIControlStateNormal];
    //        [detailButton addTarget:self action:@selector(showRoomContact:) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:detailButton];
    //    }
    //    else{
    //        UIButton *clearButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    //        [clearButton setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    //        [clearButton addTarget:self action:@selector(removeAllMessages:) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    //    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //如果是单聊，刷新对方信息
    if (_conversation.conversationType==eConversationTypeChat) {
        //刷新单聊对方信息
        [self refreshFriendInfoToDB];
    }

     UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    if (!_isScrollToBottom) {
        [self scrollViewToBottom:NO];
    }
    else{
        _isScrollToBottom = YES;
    }
    self.isInvisible = NO;
    _rightBtn.userInteractionEnabled = YES;
    //刷新本地存储的自己的头像
    //[self refreshMyHeadImg];
    //通过会话管理者获取已收发消息
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO];
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    self.isInvisible = YES;
    _isScrollToBottom = YES;

}

- (void)dealloc
{
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#warning 以下第一行代码必须写，将self从ChatManager的代理中移除
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EaseMob sharedInstance].callManager removeDelegate:self];
    if (_conversation.conversationType == eConversationTypeChatRoom && !_isKicked)
    {
        //退出聊天室，删除会话
        NSString *chatter = [_chatter copy];
        [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatter completion:^(EMChatroom *chatroom, EMError *error){
            [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:YES];
        }];
    }
    
     //移除通知
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ChangeForZoomImgView" object:nil];
    //打赏单元格
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"refreshChatVCForDaShang" object:nil];

    
}



//刷新自己的头像和title
//确认是否可以聊天
- (void)refreshFriendInfoToDB{
    NSString *uid = [NSString stringWithFormat:@"%@",self.chatter];
    if (!uid) {
        return;
    }
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data) {
        //获取新的昵称
        NSString  *nickName = [data[@"data"] objectForKey:@"nickname"];
        NSString *headImg = [data[@"data"] objectForKey:@"head_pic"];
        //获取是否可以聊天的信息反馈
        //取出私信的字段
        NSDictionary *messageEnable = data[@"data"][@"messageEnable"];
        self.chatterDic = data[@"data"];
        self.messageEnable = messageEnable;
        //NSString *status = messageEnable[@"status"];
        //NSInteger statusNum = [status integerValue];
        //NSString *msg = messageEnable[@"msg"];
        
        @try {
            ChatUserInfo *chatUser = [self getUserWithMessageUserName:uid];
            if (!chatUser) {
                //如果不存在这样的用户
                chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
                chatUser.chatId =uid;
                chatUser.nickName = nickName;
                chatUser.headPic = headImg;
                [[CoreDataManager shareInstance] saveManagerObj:chatUser];
            }else{
                chatUser.nickName = nickName;
                chatUser.headPic = headImg;
                [[CoreDataManager shareInstance] updateManagerObj:chatUser];
            }
            //更新title
            self.title = chatUser.nickName;
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
    } failed:^(NSError *error) {
        //
    }];
}




#pragma mark 响应处理
//点击导航栏右侧按钮,进入聊天详情界面
- (void)rightItemClick:(UIButton *)btn{
    _rightBtn.userInteractionEnabled = NO;
    //设置参数
    if (_conversation.conversationType==eConversationTypeChat) {
        //进入单聊详情
        ChatDetailViewController *chatDetailVC = [[ChatDetailViewController alloc] init];
        chatDetailVC.headerPic = _toHeaderURL;
        chatDetailVC.mokaID = _chatter;
        chatDetailVC.mokaNumber = self.mokaNumber;
        chatDetailVC.name = self.title;
        chatDetailVC.chatVC = self;
        [self.navigationController pushViewController:chatDetailVC animated:YES];
    }else{
        //进入组详情
        ChatDetailGroupViewController *chatDetailGropuVC = [[ChatDetailGroupViewController alloc] init];
        chatDetailGropuVC.chatter = _chatter;
        chatDetailGropuVC.chatVC =self;
        chatDetailGropuVC.subject = self.title;
        [self.navigationController pushViewController:chatDetailGropuVC animated:YES];
    }
}

//弹出警示视图
- (void)showAlertView{
    if (_alertView == nil) {
        //一个全屏的视图：为了响应触摸事件，隐藏
        _alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
         _alertView.backgroundColor = [UIColor clearColor];
        
        //背景图
        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(30,  kDeviceHeight -220, kDeviceWidth - 60, 100)];
        messageView.backgroundColor = [UIColor clearColor];
        [_alertView addSubview:messageView];
        
        //显示文字面板
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, messageView.width, 100)];
        labelView.backgroundColor = [UIColor colorWithRed: 224/255.0 green:84/255.0 blue:96/255.0 alpha:1];
        labelView.layer.cornerRadius = 5;
        labelView.layer.masksToBounds = YES;
        [messageView addSubview:labelView];
        
        
        //取文案
        //设置打赏的提示说明
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
        NSString *chat_title = [descriptionDic objectForKey:@"chat_title"];
        NSString *chat_desc = [descriptionDic objectForKey:@"chat_desc"];
        if(chat_title.length == 0){
            chat_title  = @"请注意个人隐私";
        }
        if (chat_desc.length == 0) {
            chat_desc = @"聊天时不要泄露个人隐私，对方身份不确定时请不要告知对方手机，微信等个人信息，广告，欺骗，粗鲁行为将会受到严厉处罚";
        }
        
        //标题Lable
        UILabel *titlelLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, labelView.width-10, 20)];
        titlelLabel.text = chat_title;
        titlelLabel.backgroundColor = [UIColor clearColor];
        titlelLabel.font = [UIFont boldSystemFontOfSize:18];
        titlelLabel.textColor = [UIColor whiteColor];
        [labelView addSubview:titlelLabel];
        
        //提示内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, labelView.width, 20)];
        contentLabel.text =chat_desc;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:15];
        CGFloat height = [SQCStringUtils getStringHeight:contentLabel.text width:labelView.width-20 font:15];
        contentLabel.frame = CGRectMake(10, titlelLabel.bottom +5, labelView.width-20, height);
        contentLabel.textColor = [UIColor whiteColor];
        [labelView addSubview:contentLabel];
        labelView.height = 10 +titlelLabel.height + 5 +contentLabel.height +10;
        
        //三角形
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((labelView.width-36)/2,labelView.bottom,14,7)];
        imageView.image = [UIImage imageNamed:@"alertImg"];
        [messageView addSubview:imageView];
        
        //重置messge的大小
        CGFloat totalHeight = labelView.height +imageView.height;
        messageView.frame = CGRectMake(30, self.view.frame.size.height - 46 - 64 -totalHeight ,kDeviceWidth - 60,totalHeight);
        [messageView addSubview:imageView];
        [self.view addSubview:_alertView];
        //单击手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
        [_alertView addGestureRecognizer: singleTap];
    }
    
}
//单指点击,隐藏提示
- (void)singleTapAction:(UITapGestureRecognizer *)tap{
    [_alertView removeFromSuperview];
    //记录下次进入，不再展示警告视图
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nofirstChat"];
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)back
{
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EaseMob sharedInstance].chatManager removeConversationByChatter:_conversation.chatter deleteMessages:NO append2Chat:YES];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)handleCallNotification:(NSNotification *)notification
{
    id object = notification.object;
    if ([object isKindOfClass:[NSDictionary class]]) {
        //开始call
        self.isInvisible = YES;
    }
    else
    {
        //结束call
        self.isInvisible = NO;
    }
}




- (void)setIsInvisible:(BOOL)isInvisible
{
    _isInvisible =isInvisible;
    if (!_isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
}


#pragma mark 聊天室
- (void)saveChatroom:(EMChatroom *)chatroom
{
    NSString *chatroomName = chatroom.chatroomSubject ? chatroom.chatroomSubject : @"";
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[[EaseMob sharedInstance].chatManager loginInfo] objectForKey:@"username" ]];
    NSMutableDictionary *chatRooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
    if (![chatRooms objectForKey:chatroom.chatroomId])
    {
        [chatRooms setObject:chatroomName forKey:chatroom.chatroomId];
        [ud setObject:chatRooms forKey:key];
        [ud synchronize];
    }
}

- (void)joinChatroom:(NSString *)chatroomId
{
    [self showHudInView:self.view hint:NSLocalizedString(@"chatroom.joining",@"Joining the chatroom")];
    __weak typeof(self) weakSelf = self;
    [[EaseMob sharedInstance].chatManager asyncJoinChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
        if (weakSelf)
        {
            ChatViewController *strongSelf = weakSelf;
            [strongSelf hideHud];
            if (error && (error.errorCode != EMErrorChatroomJoined))
            {
                [strongSelf showHint:[NSString stringWithFormat:@"加入%@失败", chatroomId]];
            }
            else
            {
                [strongSelf saveChatroom:chatroom];
            }
        }
#warning 逻辑有问题
        else
        {
            if (!error || (error.errorCode == EMErrorChatroomJoined))
            {
                [[EaseMob sharedInstance].chatManager asyncLeaveChatroom:chatroomId completion:^(EMChatroom *chatroom, EMError *error){
                    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatroomId deleteMessages:YES append2Chat:YES];
                }];
            }
        }
    }];
}





//导航栏上的的视图：titleView------弃用
//- (void)addTitleView
//{
//    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    topView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:topView];
//    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
//    titleView.backgroundColor = COLOR(60, 164, 253);
//    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 40, 40)];
////    [backButton setTitle:@"back" forState:UIControlStateNormal];
//    [backButton setImage:[UIImage imageNamed:@"Button-arrow-left-1"] forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [titleView addSubview:backButton];
//    UIButton *searchButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-60, 4, 40, 40)];
//    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
////    [searchButton setImage:[UIImage imageNamed:@"searchbarIcon"] forState:UIControlStateNormal];
//    [searchButton addTarget:self action:@selector(searchMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [titleView addSubview:searchButton];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-120, 40)];
//    label.center = CGPointMake(kScreenWidth/2, 22);
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:16];
//    label.textColor = [UIColor whiteColor];
//    label.text = self.conversation.chatter;
//    self.titleLabel = label;
//    [titleView addSubview:label];
//    [self.view addSubview:titleView];
//}


//- (void)searchMethod:(id)sender
//{
//    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"part3" bundle:[NSBundle mainBundle]];
//    ChatSearchContentViewController *search = [storyBoard instantiateViewControllerWithIdentifier:@"ChatSearchContentViewController"];
//    search.to_userid = self.chatter;
//    [self.navigationController pushViewController:search animated:YES];
//}


#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - 表视图代理方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

//返回单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"%@",_chatter);
    //NSLog(@"%@",[[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"]);
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        //显示时间单元格
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            timeCell.textLabel.text = (NSString *)obj;
            return timeCell;
        }
        //显示聊天消息的单元格
        else{
            MessageModel *model = (MessageModel *)obj;
            //注意：聊天头像为nil的时候，这里又重新取了一次数据
            if (model.headImageURLString == nil || model.headImageURLString.length == 0) {
                ChatUserInfo *chatUser = [self getUserWithMessageUserName:model.username];
                if (!chatUser) {
                    //从消息扩展中获取昵称和头像
                    EMMessage *message =model.message;
                    NSString *extNickName= [message.ext objectForKey:@"userName"];
                    NSString *extHeadPic = [message.ext objectForKey:@"headerURL"];
                    //如果不存在这样的用户
                    chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
                    chatUser.chatId =model.username;
                    chatUser.nickName = extNickName;
                    chatUser.headPic = extHeadPic;
                    [[CoreDataManager shareInstance] saveManagerObj:chatUser];
                }
                //最终数据是从数据库中获得的，设置头像和昵称
                model.nickName = chatUser.nickName;
                model.headImageURLString = chatUser.headPic;
            }
            //创建自定义单元格
            NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
            EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            if (cell == nil) {
                cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.supCon = self;
            cell.chatteid = self.chatter;
            cell.messageModel = model;
            
            //不是自己发的消息
            if (!model.isSender) {
                //单聊
                if (_conversation.conversationType==eConversationTypeChat) {
                    _conversation.ext = @{@"name":getSafeString(self.title),@"headUrl":getSafeString(model.headImageURLString)};
                }
            }
            return cell;
        }
    }
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];

    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    }
    else{
        return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
    }
}

#pragma mark - 滑动视图代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_slimeView) {
        [_slimeView scrollViewDidScroll];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_slimeView) {
        [_slimeView scrollViewDidEndDraging];
    }
    [self keyBoardHidden];
}

#pragma mark - 下拉刷新slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    //隐藏键盘
    [self keyBoardHidden];
    _chatTagDate = nil;
    //取出当前消息列表中的第一条数据，以这一条数据来作为时间点获取之前的数据
    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        [self loadMoreMessagesFrom:firstMessage.timestamp count:KPageCount append:YES];
    }
    [_slimeView endRefresh];
}

#pragma mark - 手势识别GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[MessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.type];
        }
    }
}

- (void)reloadData{
    _chatTagDate = nil;
    self.dataSource = [[self formatMessages:self.messages] mutableCopy];
    [self.tableView reloadData];
    
    //回到前台时
    if (!self.isInvisible)
    {
        NSMutableArray *unreadMessages = [NSMutableArray array];
        for (EMMessage *message in self.messages)
        {
            if ([self shouldAckMessage:message read:NO])
            {
                [unreadMessages addObject:message];
            }
        }
        if ([unreadMessages count])
        {
            [self sendHasReadResponseForMessages:unreadMessages];
        }
        
        [_conversation markAllMessagesAsRead:YES];
    }
    
    
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    //点击图片单元格
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    //约拍
    else if ([eventName isEqualToString:kRouterEventYuepaiBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    //点击打赏的单元格:进入照片详情
    else if ([eventName isEqualToString:
        @"kRouterEventDashangBubbleTapEventName"]){
        [self chatImageCellBubblePressed:model];
    }
    //点打赏金币
    else if ([eventName isEqualToString:
@"kRouterEventGoldCoinBubbleTapEventName"]){
        [self chatImageCellBubblePressed:model];
    }
    //点击了地址单元格
    else if ([eventName isEqualToString:kRouterEventLocationBubbleTapEventName]){
        [self chatLocationCellBubblePressed:model];
    }
    //点击重发消息
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        
        if(![self chatIsAviliable]){
            //显示打赏视图
            [self showNotificationWindow:nil];
            return;
        }
        
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        MessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.status != eMessageDeliveryState_Failure) && (messageModel.status != eMessageDeliveryState_Pending))
        {
            return;
        }
        id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
        [chatManager asyncResendMessage:messageModel.message progress:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
        [self chatVideoCellPressed:model];
    }
}




- (void)ChangeForZoomImgView:(NSNotification *)notification{
    NSDictionary *userInfo = notification.object;
    //点击聊天的图片之后，图片放大，然后执行此方法
    MessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    [self chatImageCellBubblePressed:model];

}


//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(MessageModel *)model
{
    id <IEMFileMessageBody> body = [model.message.messageBodies firstObject];
    EMAttachmentDownloadStatus downloadStatus = [body attachmentDownloadStatus];
    if (downloadStatus == EMAttachmentDownloading) {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMAttachmentDownloadFailure)
    {
        [self showHint:NSLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EaseMob sharedInstance].chatManager asyncFetchMessage:model.message progress:nil];
        
        return;
    }
    
    // 播放音频
    if (model.type == eMessageBodyType_Voice) {
        //发送已读回执
        if ([self shouldAckMessage:model.message read:YES])
        {
            [self sendHasReadResponseForMessages:@[model.message]];
        }
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [self.messageReadManager prepareMessageAudioModel:model updateViewCompletion:^(MessageModel *prevAudioModel, MessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.chatVoice.localPath completion:^(NSError *error) {
                [weakSelf.messageReadManager stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}

// 位置的bubble被点击
-(void)chatLocationCellBubblePressed:(MessageModel *)model
{
    _isScrollToBottom = NO;
    LocationViewController *locationController = [[LocationViewController alloc] initWithLocation:CLLocationCoordinate2DMake(model.latitude, model.longitude)];
    [self.navigationController pushViewController:locationController animated:YES];
    
}

- (void)chatVideoCellPressed:(MessageModel *)model{
    EMVideoMessageBody *videoBody = (EMVideoMessageBody*)model.messageBody;
    if (videoBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
    {
        NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
        if (localPath && localPath.length > 0)
        {
            //发送已读回执
            if ([self shouldAckMessage:model.message read:YES])
            {
                [self sendHasReadResponseForMessages:@[model.message]];
            }
            [self playVideoWithVideoPath:localPath];
            return;
        }
    }
    
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingVideo", @"downloading video...")];
    [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
        [weakSelf hideHud];
        if (!error) {
            //发送已读回执
            if ([weakSelf shouldAckMessage:model.message read:YES])
            {
                [weakSelf sendHasReadResponseForMessages:@[model.message]];
            }
            NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
            if (localPath && localPath.length > 0) {
                [weakSelf playVideoWithVideoPath:localPath];
            }
        }else{
            [weakSelf showHint:NSLocalizedString(@"message.videoFail", @"video for failure!")];
        }
    } onQueue:nil];
}

- (void)playVideoWithVideoPath:(NSString *)videoPath
{
    _isScrollToBottom = NO;
    NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
    MPMoviePlayerViewController *moviePlayerController = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
    [moviePlayerController.moviePlayer prepareToPlay];
    moviePlayerController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    [self presentMoviePlayerViewControllerAnimated:moviePlayerController];
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(MessageModel *)model
{
    NSDictionary *dic = model.message.ext;
    if (dic.allKeys.count>0) {
        NSString *type = getSafeString(dic[@"objectType"]);
        //约拍
        if ([type isEqualToString:@"4"]) {
            YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc] initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
            detail.covenant_id = getSafeString(dic[@"objectId"]);
            
            [self.navigationController pushViewController:detail animated:YES];
        //打赏图片详情
        }else if ([type isEqualToString:@"2"]) {
            NSDictionary *extdic = model.message.ext;
            NSString *photoId = extdic[@"photoId"];
                PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
                [detailVc requestWithPhotoId:photoId uid:model.message.to];
                [self.navigationController pushViewController:detailVc animated:YES];
        }
        //金币打赏
        else if ([type isEqualToString:@"3"]) {
            NSDictionary *extdic = model.message.ext;
            NSInteger rewardType =[extdic[@"rewardType"] integerValue];
            NSString *objectId = extdic[@"objectId"];
            switch (rewardType) {
                case 1:
                {
                    //视频
                    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
                    [detailVc requestWithVideoId:objectId uid:model.message.to];
                    [self.navigationController pushViewController:detailVc animated:YES];
                    break;
                }
                case 2:
                {   //图片
                    PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
                    [detailVc requestWithPhotoId:objectId uid:model.message.to];
                    [self.navigationController pushViewController:detailVc animated:YES];
                    break;
                }
                case 3:
                {   //对人的打赏
                    
                    break;
                }
                default:
                    break;
            }

        }
        //套系
        else if ([type isEqualToString:@"10"]){
            YuePaiDetailViewController *detail = [[YuePaiDetailViewController alloc]
            initWithNibName:@"YuePaiDetailViewController" bundle:[NSBundle mainBundle]];
            detail.isTaoXi = YES;
            detail.covenant_id = getSafeString(dic[@"objectId"]);
            [self.navigationController pushViewController:detail animated:YES];
        }
        //套系
        else if ([type isEqualToString:@"3"]){
            NSDictionary *dic  = model.message.ext;
            //打赏类型
            NSString *rewardType = dic[@"rewardType"];
            if ([rewardType isEqualToString:@"1"]) {
                //视频
                
            }else if([rewardType isEqualToString:@"2"]){
                //图片
                NSString *photoId = dic[@"objectId"];
                PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
                [detailVc requestWithPhotoId:photoId uid:model.message.to];
                [self.navigationController pushViewController:detailVc animated:YES];
            }else if([rewardType isEqualToString:@"3"]){
                //对人的打赏
            }
     }
    }
    __weak ChatViewController *weakSelf = self;
    id <IChatManager> chatManager = [[EaseMob sharedInstance] chatManager];
    if ([model.messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)model.messageBody;
        if (imageBody.thumbnailDownloadStatus == EMAttachmentDownloadSuccessed) {
            //大图下载成功
            if (imageBody.attachmentDownloadStatus == EMAttachmentDownloadSuccessed)
            {
                //发送已读回执
                if ([self shouldAckMessage:model.message read:YES])
                {
                    [self sendHasReadResponseForMessages:@[model.message]];
                }
                NSString *localPath = model.message == nil ? model.localPath : [[model.message.messageBodies firstObject] localPath];
                if (localPath && localPath.length > 0) {
                    UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                    if (image)
                    {
                        //[self.messageReadManager showBrowserWithImages:@[image]];
                    }
                    else
                    {
                        NSLog(@"Read %@ failed!", localPath);
                    }
                    return ;
                }
            }
            //执行下载大图
            [weakSelf showHudInView:weakSelf.view hint:NSLocalizedString(@"message.downloadingImage", @"downloading a image...")];
            [chatManager asyncFetchMessage:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                [weakSelf hideHud];
                if (!error) {
                    //发送已读回执
                    if ([weakSelf shouldAckMessage:model.message read:YES])
                    {
                        [weakSelf sendHasReadResponseForMessages:@[model.message]];
                    }
                    NSString *localPath = aMessage == nil ? model.localPath : [[aMessage.messageBodies firstObject] localPath];
                    if (localPath && localPath.length > 0) {
                        UIImage *image = [UIImage imageWithContentsOfFile:localPath];
                        weakSelf.isScrollToBottom = NO;
                        if (image)
                        {
                            //[weakSelf.messageReadManager showBrowserWithImages:@[image]];
                        }
                        else
                        {
                            NSLog(@"Read %@ failed!", localPath);
                        }
                        return ;
                    }
                }
                [weakSelf showHint:NSLocalizedString(@"message.imageFail", @"image for failure!")];
            } onQueue:nil];
        }else{
            //获取缩略图
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
                
            } onQueue:nil];
        }
    }else if ([model.messageBody messageBodyType] == eMessageBodyType_Video) {
        //获取缩略图
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)model.messageBody;
        if (videoBody.thumbnailDownloadStatus != EMAttachmentDownloadSuccessed) {
            [chatManager asyncFetchMessageThumbnail:model.message progress:nil completion:^(EMMessage *aMessage, EMError *error) {
                if (!error) {
                    [weakSelf reloadTableViewDataWithMessage:model.message];
                }else{
                    [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
                }
            } onQueue:nil];
        }
    }
}

#pragma mark - IChatManagerDelegate

-(void)didSendMessage:(EMMessage *)message error:(EMError *)error
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:message.messageId])
             {
                 model.message.deliveryState = message.deliveryState;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)didReceiveHasReadResponse:(EMReceipt*)receipt
{
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         if ([obj isKindOfClass:[MessageModel class]])
         {
             MessageModel *model = (MessageModel*)obj;
             if ([model.messageId isEqualToString:receipt.chatId])
             {
                 model.message.isReadAcked = YES;
                 *stop = YES;
             }
         }
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.chatter isEqualToString:message.conversationChatter])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[MessageModel class]]) {
                    MessageModel *model = (MessageModel *)object;
                    if ([message.messageId isEqualToString:model.messageId]) {
                        MessageModel *cellModel = [MessageModelManager modelWithMessage:message];
                        if ([self->_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
                            NSString *showName = [self->_delelgate nickNameWithChatter:model.username];
                            cellModel.nickName = showName?showName:cellModel.username;
                        }else {
                            cellModel.nickName = cellModel.username;
                        }
                        if (_conversation.conversationType==eConversationTypeChat) {
                            _conversation.ext = @{@"name":getSafeString(cellModel.username),@"headUrl":getSafeString(self.toHeaderURL)};
                            
                        }
                        
                        if ([self->_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
                            cellModel.headImageURL = [NSURL URLWithString:[self->_delelgate avatarWithChatter:cellModel.username]];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                        });
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message error:(EMError *)error{
    if (!error) {
        id<IEMFileMessageBody>fileBody = (id<IEMFileMessageBody>)[message.messageBodies firstObject];
        if ([fileBody messageBodyType] == eMessageBodyType_Image) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Video){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody messageBodyType] == eMessageBodyType_Voice){
            if ([fileBody attachmentDownloadStatus] == EMAttachmentDownloadSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}



#pragma mark 收到消息
-(void)didReceiveMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        //[self downloadMessageAttachments:message];
        [self addMessage:message];
        if ([self shouldAckMessage:message read:NO])
        {
            [self sendHasReadResponseForMessages:@[message]];
        }
        if ([self shouldMarkMessageAsRead])
        {
            [self markMessagesAsRead:@[message]];
        }
    }
    
    
    
}

-(void)didReceiveCmdMessage:(EMMessage *)message
{
    if ([_conversation.chatter isEqualToString:message.conversationChatter]) {
        [self showHint:NSLocalizedString(@"receiveCmd", @"receive cmd message")];
    }
}

- (void)didReceiveMessageId:(NSString *)messageId
                    chatter:(NSString *)conversationChatter
                      error:(EMError *)error
{
    if (error && [_conversation.chatter isEqualToString:conversationChatter]) {
        
        __weak ChatViewController *weakSelf = self;
        for (int i = 0; i < self.dataSource.count; i ++) {
            id object = [self.dataSource objectAtIndex:i];
            if ([object isKindOfClass:[MessageModel class]]) {
                MessageModel *currentModel = [self.dataSource objectAtIndex:i];
                EMMessage *currMsg = [currentModel message];
                if ([messageId isEqualToString:currMsg.messageId]) {
                    currMsg.deliveryState = eMessageDeliveryState_Failure;
                    MessageModel *cellModel = [MessageModelManager modelWithMessage:currMsg];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [weakSelf.tableView beginUpdates];
                        [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                        [weakSelf.tableView endUpdates];
                        
                    });
                    
                    break;
                }
            }
        }
    }
}




//接收到离线非透传消息的回调
- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
{
    //安全判断，离线消息不存在就直接无操作返回
    if (![offlineMessages count])
    {
        return;
    }
    
    //在聊天界面里（相对于：在后台或者不在聊天界面）
    if ([self shouldMarkMessageAsRead])
    {   //标记为已读
        [_conversation markAllMessagesAsRead:YES];
    }
    
    _chatTagDate = nil;
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:[self.messages count] + [offlineMessages count] append:NO];
}

//离线非透传消息接收完成的回调
- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages
{
    if ([self shouldMarkMessageAsRead])
    {
        [_conversation markAllMessagesAsRead:YES];
    }
    if (![offlineMessages count])
    {
        return;
    }
    _chatTagDate = nil;
    //如果存在离线消息，就重新请求消息列表，将离线消息加载进来
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:[self.messages count] + [offlineMessages count] append:NO];
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf scrollViewToBottom:NO];
        });
    });
}

//- (void)didReceiveOfflineMessages:(NSArray *)offlineMessages
//{
//    if (![offlineMessages count])
//    {
//        return;
//    }
//    if ([self shouldMarkMessageAsRead])
//    {
//        [_conversation markAllMessagesAsRead:YES];
//    }
//    _chatTagDate = nil;
//    [self loadMoreMessages];
//    __weak typeof(self) weakSelf = self;
//    dispatch_async(_messageQueue, ^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [weakSelf scrollViewToBottom:NO];
//        });
//    });
//}

- (void)group:(EMGroup *)group didLeave:(EMGroupLeaveReason)reason error:(EMError *)error
{
    if (self.isChatGroup && [group.groupId isEqualToString:_chatter]) {
        [self.navigationController popToViewController:self animated:NO];
        [self.navigationController popViewControllerAnimated:NO];
    }
}

- (void)didInterruptionRecordAudio
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
    
    [self stopAudioPlayingWithChangeCategory:YES];
}

- (void)groupDidUpdateInfo:(EMGroup *)group error:(EMError *)error
{
    if (!error && self.isChatGroup && [_chatter isEqualToString:group.groupId])
    {
        self.title = group.groupSubject;
    }
}

#pragma mark - IChatManagerDelegate 登录状态变化

- (void)didLoginFromOtherDevice
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

- (void)didRemovedFromServer
{
    if ([self.imagePicker.mediaTypes count] > 0 && [[self.imagePicker.mediaTypes objectAtIndex:0] isEqualToString:(NSString *)kUTTypeMovie]) {
        [self.imagePicker stopVideoCapture];
    }
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    // 隐藏键盘
    [self keyBoardHidden];
    
    // 弹出照片选择
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"isShowPicker"];
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:NSLocalizedString(@"message.simulatorNotSupportCamera", @"simulator does not support taking picture")];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage,(NSString *)kUTTypeMovie];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    self.isInvisible = YES;
#endif
}

- (void)moreViewLocationAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    LocationViewController *locationController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
    locationController.delegate = self;
    [self.navigationController pushViewController:locationController animated:YES];

    
    
}


- (void)moreViewAudioCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeAudio]}];
}

- (void)moreViewVideoCallAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callOutWithChatter" object:@{@"chatter":self.chatter, @"type":[NSNumber numberWithInt:eCallSessionTypeVideo]}];
}

//发起约拍
- (void)moreViewYuePaiAction:(DXChatBarMoreView *)moreView{
    [self keyBoardHidden];
    [self yuePaiAction];
    
}

- (void)moreViewDaShangAction:(DXChatBarMoreView *)moreView{
    [self keyBoardHidden];
    [self daShangAction];
}



#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.tableView.frame;
        rect.origin.y = 0;
        rect.size.height = self.view.frame.size.height - toHeight;
        self.tableView.frame = rect;
    }];
    [self scrollViewToBottom:NO];
}

- (void)didSendText:(NSString *)text
{
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    __weak typeof(self) weakSelf = self;
    [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
        if (!error) {
            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                                                       displayName:@"audio"];
            voice.duration = aDuration;
            [weakSelf sendAudioMessage:voice];
        }else {
            [weakSelf showHudInView:self.view hint:@"录音时间太短了"];
            weakSelf.chatToolBar.recordButton.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf hideHud];
                weakSelf.chatToolBar.recordButton.enabled = YES;
            });
        }
    }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        // video url:
        // file:///private/var/mobile/Applications/B3CDD0B2-2F19-432B-9CFA-158700F4DE8F/tmp/capture-T0x16e39100.tmp.9R8weF/capturedvideo.mp4
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:chatVideo];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:^{
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
        }];
        [self sendImageMessage:orgImage];
    }
    self.isInvisible = NO;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"isShowPicker"];
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - MenuItem actions
- (void)copyMenuAction:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.content;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        MessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableIndexSet *indexs = [NSMutableIndexSet indexSetWithIndex:_longPressIndexPath.row];
        [_conversation removeMessage:model.message];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [indexs addIndex:_longPressIndexPath.row - 1];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        
        [self.dataSource removeObjectsAtIndexes:indexs];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (BOOL)isChatGroup
{
    return _conversationType != eConversationTypeChat;
}


- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    MessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}


#pragma mark 获取聊天数据
//加载聊天记录
- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        //如果确实获取了消息
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            //需要追加消息到以前的数组中
            if (append)
            {   //将新搜到的消息插入到原消息数组中
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            //不需要追加消息到以前的数组中
            else
            {
                weakSelf.messages = [messages mutableCopy];
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
            }
            
            //刷新表视图，滑到最底端
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] ;
                //[weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                if(append){
                    
                }else{
                    /*
                    if (weakSelf.isScrollToBottom) {
                        //talbeView已经滑动到地段
                    }else{
                        [weakSelf scrollViewToBottom:NO];
                    }
                     */
                    [weakSelf scrollViewToBottom:NO];


                }
                
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (EMMessage *message in messages)
            {
                [weakSelf downloadMessageAttachments:message];
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        }
    });
}


//在请求得到消息的数组之后，下载与消息相关的附加属性
- (void)downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
            //[weakSelf.tableView reloadData];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    if ([messageBody messageBodyType] == eMessageBodyType_Image) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Video)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载缩略图
            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
        }
    }
    else if ([messageBody messageBodyType] == eMessageBodyType_Voice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.attachmentDownloadStatus > EMAttachmentDownloadSuccessed)
        {
            //下载语言
            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
        }
    }
}




//格式化消息，封装数据模型，构建新的消息数组
- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            //timestamp是消息发送或接收时间
            //这条消息的时间
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            //间隔时间戳
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                //将这个时间格式化显示
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            //将message对象封装为model对象
            MessageModel *model = [MessageModelManager modelWithMessage:message];
            
            //从消息扩展中获取昵称和头像
            NSString *extNickName= [message.ext objectForKey:@"userName"];
            NSString *extHeadPic = [message.ext objectForKey:@"headerURL"];
            
            //消息的头像和昵称都要从数据库中取
            //查询是否存在此用户的信息
            ChatUserInfo *chatUser = [self getUserWithMessageUserName:model.username];
            if (!chatUser) {
                //创建对象存在数据库中
                chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
                chatUser.chatId = model.username;
                chatUser.nickName = extNickName;
                chatUser.headPic = extHeadPic;
                [[CoreDataManager shareInstance] saveManagerObj:chatUser];
            }else{
                //用户存在，但是有更新，就更新数据库
//                 if (![chatUser.nickName isEqualToString:extNickName] ||![chatUser.headPic isEqualToString:extHeadPic]) {
//                    chatUser.nickName = extNickName;
//                    chatUser.headPic = extHeadPic;
//                    [[CoreDataManager shareInstance] updateManagerObj:chatUser];
//                }
            }
            //最终数据是从数据库中获得的，设置头像和昵称
            model.nickName = chatUser.nickName;
            model.headImageURLString = chatUser.headPic;
             //加入到消息模型数组
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}


//格式化处理消息
-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    //时间标签
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    //将消息对象封装为model对象
    MessageModel *model = [MessageModelManager modelWithMessage:message];
    
    //从消息扩展中获取昵称和头像
    NSString *extNickName= [message.ext objectForKey:@"userName"];
    NSString *extHeadPic = [message.ext objectForKey:@"headerURL"];
    
    //消息的头像和昵称都要从数据库中取
    //查询是否存在此用户的信息
    ChatUserInfo *chatUser = [self getUserWithMessageUserName:model.username];
    if (!chatUser) {
        //如果不存在这样的用户
        chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
        chatUser.chatId =model.username;
        chatUser.nickName = extNickName;
        chatUser.headPic = extHeadPic;
        [[CoreDataManager shareInstance] saveManagerObj:chatUser];
    }
    //最终数据是从数据库中获得的，设置头像和昵称
    model.nickName = chatUser.nickName;
    model.headImageURLString = chatUser.headPic;
    if (model) {
        [ret addObject:model];
    }
    return ret;
}



-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        //格式化消息
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        [self.tableView setContentOffset:offset animated:animated];
    }
}

- (void)showRoomContact:(id)sender
{
    [self.view endEditing:YES];
    if (self.conversationType == eConversationTypeGroupChat) {
        
    }
    else if (self.conversationType == eConversationTypeChatRoom)
    {
        
        
    }
}

- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
        [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (self.isChatGroup && [groupId isEqualToString:_conversation.chatter]) {
            [_conversation removeAllMessages];
            [_messages removeAllObjects];
            _chatTagDate = nil;
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:NSLocalizedString(@"message.noMessage", @"no messages")];
        }
    }
    else{
        __weak typeof(self) weakSelf = self;
        
        [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                                message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                        completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                            if (buttonIndex == 1) {
                                [weakSelf.conversation removeAllMessages];
                                [weakSelf.messages removeAllObjects];
                                weakSelf.chatTagDate = nil;
                                [weakSelf.dataSource removeAllObjects];
                                [weakSelf.tableView reloadData];
                            }
                        } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                      otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(MessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"copy", @"Copy") action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:NSLocalizedString(@"delete", @"Delete") action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == eMessageBodyType_Text) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}

- (void)exitGroup
{
    [self.navigationController popToViewController:self animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)insertCallMessage:(NSNotification *)notification
{
    id object = notification.object;
    if (object) {
        EMMessage *message = (EMMessage *)object;
        [self addMessage:message];
    }
}

//进入后台
- (void)applicationDidEnterBackground
{
    //取消触摸录音键
    [_chatToolBar cancelTouchRecord];
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead:YES];
}

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.messageType != eMessageTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    id<IEMMessageBody> body = [message.messageBodies firstObject];
    if (((body.messageBodyType == eMessageBodyType_Video) ||
         (body.messageBodyType == eMessageBodyType_Voice) ||
         (body.messageBodyType == eMessageBodyType_Image)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) || self.isInvisible)
    {
        return NO;
    }
    
    return YES;
}


- (EMMessageType)messageType
{
    EMMessageType type = eMessageTypeChat;
    switch (_conversationType) {
        case eConversationTypeChat:
            type = eMessageTypeChat;
            break;
        case eConversationTypeGroupChat:
            type = eMessageTypeGroupChat;
            break;
        case eConversationTypeChatRoom:
            type = eMessageTypeChatRoom;
            break;
        default:
            break;
    }
    return type;
}

#pragma mark - public

- (void)hideImagePicker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
    self.isInvisible = NO;
}

#pragma mark - 发送消息 - send message
//发送文字或者图片表情
-(void)sendTextMessage:(NSString *)textMessage
{
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSDictionary *diction = @{@"em_apns_ext":@{@"em_push_title":[NSString stringWithFormat:@"%@:%@",getSafeString(name),textMessage]},
                              @"userName":getSafeString(name),
                              @"headerURL":getSafeString(headerURL)};
    EMMessage *tempMessage;
    if ([self chatIsAviliable]) {
        tempMessage = [ChatSendHelper
                       sendTextMessageWithString:textMessage
                       toUsername:self.chatter
                       messageType:[self messageType]
                       requireEncryption:NO
                       ext:diction];
    }else{
        //发送失败的文字
        tempMessage = [ChatSendHelper
                       failSendTextMessageWithString:textMessage
                       toUsername:self.chatter
                       messageType:[self messageType]
                       requireEncryption:NO
                       ext:diction];
        [self showNotificationWindow:nil];
        [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[tempMessage] forChatter:_chatter append2Chat:YES];
    }
    
    [self addMessage:tempMessage];
}

//发送图片
-(void)sendImageMessage:(UIImage *)image
{
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSDictionary *diction = @{@"em_apns_ext":@{@"em_push_title":[NSString stringWithFormat:@"%@:[图片]",getSafeString(name)]},
                             @"userName":getSafeString(name),
                              @"headerURL":getSafeString(headerURL)};
    EMMessage *tempMessage ;
    if ([self chatIsAviliable]) {
        tempMessage= [ChatSendHelper
                sendImageMessageWithImage:image
                               toUsername:self.chatter
                              messageType:[self messageType]
                        requireEncryption:NO
                                      ext:diction];
    }else{
        //发送失败的图片
        tempMessage= [ChatSendHelper failSendImageMessageWithImage:image
                               toUsername:self.chatter
                              messageType:[self messageType]
                        requireEncryption:NO
                                      ext:diction];
        [self showNotificationWindow:nil];
        [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[tempMessage] forChatter:_chatter append2Chat:YES];
    }
    
    [self addMessage:tempMessage];
}



-(void)sendAudioMessage:(EMChatVoice *)voice
{
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSDictionary *diction = @{@"em_apns_ext":@{@"em_push_title":[NSString stringWithFormat:@"%@:一条语音",getSafeString(name)]},
                              @"userName":getSafeString(name),
                              @"headerURL":getSafeString(headerURL)};
    EMMessage *tempMessage;
    if ([self chatIsAviliable]) {
        tempMessage= [ChatSendHelper sendVoice:voice
                                                toUsername:_conversation.chatter
                                               messageType:[self messageType]
                                         requireEncryption:NO ext:diction];
    }else{
        //发送失败的语音
        tempMessage= [ChatSendHelper failSendVoice:voice
                                    toUsername:_conversation.chatter
                                   messageType:[self messageType]
                             requireEncryption:NO ext:diction];
        [self showNotificationWindow:nil];
        [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[tempMessage] forChatter:_chatter append2Chat:YES];

    }
    [self addMessage:tempMessage];
}


-(void)sendVideoMessage:(EMChatVideo *)video
{
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSDictionary *diction = @{@"em_apns_ext":@{@"em_push_title":[NSString stringWithFormat:@"%@:一条视频",getSafeString(name)]},
                              @"userName":getSafeString(name),
                              @"headerURL":getSafeString(headerURL)};
    EMMessage *tempMessage;
    if ([self chatIsAviliable]) {
        tempMessage= [ChatSendHelper sendVideo:video
                                    toUsername:_conversation.chatter
                                   messageType:[self messageType]
                             requireEncryption:NO ext:diction];
    }else{
        //发送失败的视频
        tempMessage= [ChatSendHelper failSendVideo:video
                                    toUsername:_conversation.chatter
                                   messageType:[self messageType]
                             requireEncryption:NO ext:diction];
        [self showNotificationWindow:nil];
        [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[tempMessage] forChatter:_chatter append2Chat:YES];
    }
    [self addMessage:tempMessage];
}





- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
        }
    });
}

- (void)markMessagesAsRead:(NSArray*)messages
{
    EMConversation *conversation = _conversation;
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            [conversation markMessageWithId:message.messageId asRead:YES];
        }
    });
}


#pragma mark - LocationViewDelegate
//发送地理位置的消息
-(void)sendLocationLatitude:(double)latitude longitude:(double)longitude andAddress:(NSString *)address
{
    
    NSString *name = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    NSString *headerURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
    NSDictionary *diction = @{@"em_apns_ext":@{@"em_push_title":[NSString stringWithFormat:@"%@:一个位置",getSafeString(name)]},
                              @"userName":getSafeString(name),
                              @"headerURL":getSafeString(headerURL)};
//    NSLog(@"地理位置信息：%@",diction);
    
    EMMessage *locationMessage;
    if ([self chatIsAviliable]) {
        locationMessage = [ChatSendHelper sendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter messageType:[self messageType] requireEncryption:NO ext:diction];
    }else{
        locationMessage = [ChatSendHelper failSendLocationLatitude:latitude longitude:longitude address:address toUsername:_conversation.chatter messageType:[self messageType] requireEncryption:NO ext:diction];
        [self showNotificationWindow:nil];
        [[EaseMob sharedInstance].chatManager insertMessagesToDB:@[locationMessage] forChatter:_chatter append2Chat:YES];
    }

    //[self addMessage:locationMessage];
}


#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}

#pragma mark  聊天室：EMChatManagerChatroomDelegate

- (void)chatroom:(EMChatroom *)chatroom occupantDidJoin:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:@"%@加入%@", username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)chatroom:(EMChatroom *)chatroom occupantDidLeave:(NSString *)username
{
    CGRect frame = self.chatToolBar.frame;
    [self showHint:[NSString stringWithFormat:@"%@离开%@", username, chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
}

- (void)beKickedOutFromChatroom:(EMChatroom *)chatroom reason:(EMChatroomBeKickedReason)reason
{
    if ([_chatter isEqualToString:chatroom.chatroomId])
    {
        _isKicked = YES;
        CGRect frame = self.chatToolBar.frame;
        [self showHint:[NSString stringWithFormat:@"被踢出%@", chatroom.chatroomId] yOffset:-frame.size.height + KHintAdjustY];
        [self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - 设置服务提醒,打赏金币
//注册通知之后会显示用户引导视图
- (void)showNotificationWindow:(NSDictionary *)diction{
    //其他原因，不能聊天
    NSString *status = self.messageEnable[@"status"];
    NSInteger statusNum = [status integerValue];
    if(statusNum == 1){
        NSString *msg = self.messageEnable[@"msg"];
        [LeafNotification showInController:self withText:msg];
        return;
    }
    
    //中间视图的宽高度
    CGFloat lefttingPadding = 30;
    CGFloat horizontalPadding = 20;
    CGFloat mainViewWidth = kDeviceWidth -30*2;
    //CGFloat mainViewHeight  = 0;
    if (_notificationWindow == nil) {
        //创建window
        _notificationWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _notificationWindow.backgroundColor = [UIColor clearColor];
        _notificationWindow.hidden = NO;
        _notificationWindow.windowLevel = UIWindowLevelStatusBar;
        
        //设置黑色背景
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
        backView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.5;
        [_notificationWindow addSubview:backView];
        
        
        UIView *mainView = [[UIView alloc] initWithFrame:CGRectZero];
        mainView.tag = 1000;
        mainView.backgroundColor = [UIColor whiteColor];
        [_notificationWindow addSubview:mainView];
        
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(mainViewWidth - 10- 30, 5, 30, 30)];
        [cancleBtn setImage:[UIImage imageNamed: @"close2"] forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(closeServiceAlertView) forControlEvents:UIControlEventTouchUpInside];
        [mainView addSubview:cancleBtn];
        
        
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
        //获取文案
        NSString *alterTitle = @"打赏之后 ,无限畅聊";
        NSString *descTxt = @"对方开启了打赏之后接受私信 ,你需要先打赏对方才能发送消息";
        NSString *tempStr = [descriptionDic objectForKey:@"chat_tip"];
        if (tempStr.length != 0) {
            alterTitle = tempStr;
        }
        tempStr = [descriptionDic objectForKey:@"chat_content"];
        if (tempStr.length != 0) {
            descTxt = tempStr;
        }
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(horizontalPadding, cancleBtn.bottom +5, mainViewWidth -horizontalPadding*2,horizontalPadding)];
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
        
        //打赏按钮
        UIControl *daShangCtrl = [[UIControl alloc] initWithFrame:CGRectMake((mainViewWidth -160)/2, descLabel.bottom +20, 160, 40)];
        daShangCtrl.backgroundColor = [CommonUtils colorFromHexString:@"#eeeae4"];
        [mainView addSubview:daShangCtrl];
        
        UILabel *colorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        colorLabel.backgroundColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
        colorLabel.layer.cornerRadius = 20;
        colorLabel.layer.masksToBounds = YES;
        [daShangCtrl addSubview:colorLabel];
        
//        [UIView beginAnimations:@"exchangeView" context:nil];
        UILabel *daShangCountLable = [[UILabel alloc] initWithFrame:CGRectMake(colorLabel.right, 0, 120, 40)];
        daShangCountLable.textAlignment = NSTextAlignmentCenter;
        daShangCountLable.text = [NSString stringWithFormat:@"打赏%@个",_chatterDic[@"setting"][@"message"][@"message_reward"]];
        [daShangCtrl addSubview:daShangCountLable];
        
        daShangCtrl.layer.cornerRadius = 20;
        daShangCtrl.layer.masksToBounds =YES;
        [daShangCtrl addTarget:self action:@selector(requestDaShangForChat) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat mainViewHeight = daShangCtrl.bottom +20;
        mainView.frame = CGRectMake(lefttingPadding, (kDeviceHeight -mainViewHeight)/2,mainViewWidth,mainViewHeight);
        mainView.layer.cornerRadius = 5;
        mainView.layer.masksToBounds = YES;

      }
    //执行动画
    UIView *mainView = [_notificationWindow viewWithTag:1000];
    //mainViewHeight = mainView.height;
    //mainView.frame = CGRectMake(kDeviceWidth/2, kDeviceHeight/2, 1, 1);
    /*
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        mainView.frame = CGRectMake(lefttingPadding-10, (kDeviceHeight -mainViewHeight)/2 -10,mainViewWidth +20,mainViewHeight+20);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            mainView.frame = CGRectMake(lefttingPadding, (kDeviceHeight -mainViewHeight)/2,mainViewWidth,mainViewHeight);
        }];
    }];
    */
    CABasicAnimation *forwardAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    forwardAnimation.duration =0.5;
    forwardAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.5f :1.7f :0.6f :0.85f];
    forwardAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    forwardAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [mainView.layer addAnimation:forwardAnimation forKey:@"test"];
}

//手势关闭"打开通知"的引导视图
- (void)closeServiceAlertView{
    UIView *mainView = [_notificationWindow viewWithTag:1000];
    CABasicAnimation *reverseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    reverseAnimation.duration = 0.5;
    reverseAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4f :0.15f :0.5f :-0.7f];
    reverseAnimation.fromValue = [NSNumber numberWithFloat:1.0f];
    reverseAnimation.toValue = [NSNumber numberWithFloat:0.0f];
    //使rocket留在最终状态，设置removedOnCompletion为No以防止它被自动移除
    reverseAnimation.fillMode =  kCAFillModeForwards;
    reverseAnimation.removedOnCompletion = NO;
    [mainView.layer addAnimation:reverseAnimation forKey:@"test"];
    
    //隐藏window并且清除
    [UIView animateWithDuration:0.6 animations:^{
        _notificationWindow.alpha = 0;
        
    } completion:^(BOOL finished) {
        _notificationWindow.hidden = NO;
        _notificationWindow =nil;
    }];

}


//进入打赏金币的界面
- (void)requestDaShangForChat{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    //对方uid
    [mDic setObject:_chatter forKey:@"photoid"];
    //类型
    [mDic setObject:@"12" forKey:@"object_type"];
    //支付的金额
    NSString *goldCoin = _chatterDic[@"setting"][@"message"][@"message_reward"];
    NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":goldCoin};
    NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
    [mDic setObject:pay_info forKey:@"pay_info"];
    NSDictionary *params = [AFParamFormat formatTempleteParams:mDic];
    
    [AFNetwork postRequeatDataParams:params path:PathUserReward success:^(id data) {
//        NSLog(@"data:%@",data);
        NSDictionary *dic = data[@"data"];
        
        //首先获取messageEnable
        NSDictionary *messageDic = dic[@"messageEnable"];
        NSInteger statusNum = 0;
        NSString *msg = @"";
        
        if (messageDic) {
            //存在这样的字典
            statusNum = [messageDic[@"status"] integerValue];
            if (statusNum == 0) {
                //如果通过了聊天限制，更新字典
                _messageEnable = messageDic;
            }
            msg = messageDic[@"msg"];
        }else{
            //不存在字典
            statusNum = [dic[@"status"] integerValue];
            if(statusNum == 0){
                NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
                [mDic setObject:dic[@"status"] forKey:@"status"];
                [mDic setObject:msg forKey:@"msg"];
                //更新聊天判断字典
                _messageEnable = mDic;
            }
            msg = dic[@"msg"];

        }
        
//        if (_messageEnable) {
//            statusNum = [_messageEnable[@"status"] integerValue];
//            msg = _messageEnable[@"msg"];
//            
//        }else{
//            //不存在statusNum
//            statusNum = [dic[@"status"] integerValue];
//            msg = dic[@"msg"];
//        }
        //_messageEnable = data[@"data"][@"messageEnable"];
        [self closeServiceAlertView];
        
        switch (statusNum) {
            case 0:
            {
                //可以聊天
                //[LeafNotification showInController:self withText:_messageEnable[@"msg"]];
                //发送一条打赏消息
                [self sendDaShangGoldCoinMessage:goldCoin];
                 break;
            }
            case 2:
            {   //金币不够
                [self closeServiceAlertView];
                //提示是否购买
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"金币打赏" message:@"您的账户金币不足,快去充值吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
                [alertView show];
                break;
            }
            case 1:
            {   //其他原因不能聊天
                [LeafNotification showInController:self withText:msg];
                 break;
            }
  
            default:
                break;
        }
       
    } failed:^(NSError *error) {
        NSLog(@"%@",error);
        [self closeServiceAlertView];
    }];

}

//金币不够，购买会员
- (void)skipPageForBuyMemberCenter{
    JinBiViewController *jinBiVC = [[JinBiViewController alloc] init];
    [self.navigationController pushViewController:jinBiVC animated:YES];

}

- (void)sendDaShangGoldCoinMessage:(NSString *)goldCoin{
     //构建一个data字典，放在环信中
    NSMutableDictionary *chatMutDic = [NSMutableDictionary dictionary];
    NSString *fromUid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    [chatMutDic setObject:fromUid forKey:@"from"];
    [chatMutDic setObject:_chatter forKey:@"target"];
    NSString *msgTxt = NSLocalizedString(@"message.cantShowGoldMessage", @"");
    [chatMutDic setObject:msgTxt forKey:@"msg"];
    
    //扩展字典
    NSMutableDictionary *extdic = [NSMutableDictionary dictionary];
    //打赏对象:ID
    [extdic setObject:_chatter forKey:@"objectId"];
    //打赏对象:视频1 图片2 人3
    [extdic setObject:@"3" forKey:@"rewardType"];
    //自定义消息类型：
    [extdic setObject:@(3) forKey:@"objectType"];
    //打赏金币个数
    [extdic setObject:goldCoin forKey:@"money"];
    [extdic setObject:[NSString stringWithFormat:@"送了%@个金币",goldCoin] forKey:@"rewardTxt"];
    //[extdic setObject:_name forKey:@"username"];
    [chatMutDic setObject:extdic forKey:@"ext"];
    
    EMMessage *message = [ChatManager sendDaShangSuccessMessage:chatMutDic];
    [self addMessage:message];
}



#pragma mark - UIAlertDelegate(金币不够是否跳转兑换)
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
    }else{
        //跳转到充值界面
        [self skipPageForBuyMemberCenter ];
    }
}



#pragma mark - 判断是否可以发送消息
- (BOOL)chatIsAviliable{
    //群聊不判断
    if(_conversation.conversationType==eConversationTypeGroupChat){
        return YES;
    }
    
    NSString *status = self.messageEnable[@"status"];
    NSInteger statusNum = [status integerValue];
    NSString *msg = self.messageEnable[@"msg"];
    //statusNum = 6219;
    switch (statusNum) {
        case  kRight:
        {
            return true;
            break;
        }
        case  6219:
        {   [self keyBoardHidden];
            //提示不能私信
            //[LeafNotification showInController:self withText:msg];
            //显示打赏界面
            //[self showNotificationWindow:nil];
            return NO;
            break;
        }
        case  1:
        {
            //提示不能私信(其他原因)
            [LeafNotification showInController:self withText:msg];
            return NO;
            break;
        }

        /*
        case kReLogin:
        {
            //需要登陆
            //[(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            return NO;
            break;
        }
        case  6218:
        {   //需要绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return NO;
            break;
        }
         */
        default:
            break;
    }
    return YES;

}



#pragma mark - 事件处理方法
- (void)yuePaiAction{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            StartYuePaiViewController *yuepai = [[StartYuePaiViewController alloc] initWithNibName:@"StartYuePaiViewController" bundle:[NSBundle mainBundle]];
            yuepai.receiveUid = self.chatter;
            yuepai.receiveName = getSafeString(self.title);
            yuepai.receiveHeader = getSafeString(self.toHeaderURL);
            [self.navigationController pushViewController:yuepai animated:YES];
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
        }
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
    }
}


- (void)daShangAction{
    if ([self isFailForCheckLogInStatus]) {
        return;
    }
    
    NSString *targetUid = _chatter;
    
    self.dashang= [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dashang.superController = self;
    self.dashang.currentPhotoId = _chatter;
    self.dashang.animationType = @"dashangWithNoAnimation";
    self.dashang.dashangType = @"17";
    self.dashang.targetUid = targetUid;
    
    [self.dashang setUpviews];
    [self.dashang addToWindow];
}


//打赏别人之后，刷新单元格
- (void)refreshChatVCForDaShang:(NSNotification *)notification{
    EMMessage *message = notification.object;
    [self addMessage:message];
}






#pragma mark - getter方法

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor grayColor];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor grayColor];
    }
    
    return _slimeView;
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - self.chatToolBar.frame.size.height) style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = COLOR(248, 248, 248);
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //添加长按手势，复制或者删除消息
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
    }
    
    return _tableView;
}
//设置聊天的工具栏
- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        NSLog(@"_chatToolBar.frame:%@",NSStringFromCGRect(_chatToolBar.frame));
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        _chatToolBar.chatVC = self;
        ChatMoreType type = self.isChatGroup == YES ? ChatMoreTypeGroupChat : ChatMoreTypeChat;
        _chatToolBar.moreView = [[DXChatBarMoreView alloc] initWithFrame:CGRectMake(0, (kVerticalPadding * 2 + kInputTextViewMinHeight), _chatToolBar.frame.size.width, 80) typw:type];
        _chatToolBar.moreView.backgroundColor = COLOR(240, 242, 247);
        _chatToolBar.moreView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        
        //_chatToolBar.inputTextView.text= @"sadfasdf";
    }
    
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.modalPresentationStyle= UIModalPresentationOverFullScreen;
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (MessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [MessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}



@end
