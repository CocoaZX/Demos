//
//  McMsgListViewController.m
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McMsgListViewController.h"
#import "McMsgListTableViewCell.h"
#import "MJRefresh.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "NSDate+Category.h"
#import "ChatListCell.h"
#import "ChatViewController.h"
#import "AFNetwork.h"
#import "JSONKit.h"

#import "ChatUserInfo.h"
#import "CoreDataManager.h"

@interface McMsgListViewController ()

@property (nonatomic, retain) NSMutableArray *listArray;

@property (nonatomic, retain) NSString *msgString;

@property (nonatomic, retain) UILabel *footerLabel;

//聊天用户信息字典
@property (nonatomic,strong)NSMutableDictionary *userDic;


@end

@implementation McMsgListViewController

#pragma mark 视图的加载和生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"chat", nil);
    self.view.backgroundColor = [UIColor whiteColor];
    
    _listArray = [NSMutableArray array];
    
    _footerLabel = [[UILabel alloc] init];
    _footerLabel.frame = CGRectMake(0, 0, kScreenWidth, 30);
    _footerLabel.textAlignment = NSTextAlignmentCenter;
    _footerLabel.font = kFont14;
    _footerLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    self.tableView.tableFooterView = _footerLabel;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addHeader];
    //[self addFooter];
    //有新消息时，刷新会话列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshConversationCount) name:@"refreshThisChatView" object:nil];
}

//刷新会话列表
- (void)refreshConversationCount{
    //如果未读消息变化，请求新的数据并刷新
    [self.tableView reloadData];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
 
    self.listArray = [self loadDataSource];
    [self.tableView reloadData];
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshThisChatView" object:nil];
}

//加载聊天记录
- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    //获取当前登录用户的会话列表,并加载到内存中，会更新UI
    NSMutableArray *conversations = [NSMutableArray arrayWithArray: [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES]];
    @try {
        NSMutableArray *tempArray = [NSMutableArray array];
        for (EMConversation *conversation in conversations) {
            if (conversation.chatter.length ==0) {
                [tempArray addObject:conversation];
            }
        }
        for (EMConversation *conversation in tempArray) {
            [conversations removeObject:conversation];
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"错误：%@",exception);
    }
    @finally {
        
    }

    
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    
//    //如果有系统消息，需要特殊处理
//    NSDictionary *extDic = lastMessage.ext;
//    if ([[extDic objectForKey:@"objectType"] isEqualToString:@"0"]) {
//        //取出所有的消息
//        NSArray *allMessages = [conversation loadAllMessages];
//        if (allMessages.count>2) {
//        lastMessage = allMessages[allMessages.count -2];
//        }
//    }
    
    if (lastMessage) {
        id<IEMMessageBody> messageBody = lastMessage.messageBodies.lastObject;
        switch (messageBody.messageBodyType) {
            case eMessageBodyType_Image:{
                ret = NSLocalizedString(@"message.image1", @"[image]");
            } break;
            case eMessageBodyType_Text:{
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
                
                //约拍和打赏都是以txt形式发送，这里判断是使用扩展字段来区分
                //如果是接受约拍的消息
                NSDictionary *ext = lastMessage.ext;
                NSString *objectType = getSafeString([ext objectForKey:@"objectType"]) ;
                if([objectType isEqualToString:@"4"]){
                    //约拍类型
                    NSString *step = getSafeString([ext objectForKey:@"step"]);
                    if ([step isEqualToString:@"2"]) {
                        NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
                        NSString *login = [userInfo objectForKey:kSDKUsername];
                        NSString *sender = (lastMessage.messageType == eMessageTypeChat) ? lastMessage.from : lastMessage.groupSenderName;
                        BOOL isSender = [login isEqualToString:sender] ? YES : NO;
                        
                        if (isSender) {
                            //这条消息是我发送的，我是接受者
                            ret = lastMessage.ext[@"tips"];
                        }else{
                            ret = lastMessage.ext[@"to_tips"];
                        }
                    }
                }else if ([objectType isEqualToString:@"3"]){
                    //金币打赏默认msg是提示升级，为了兼顾旧版本
                    //但是要显示在列表中的消息是真正的打赏的信息
                    ret = lastMessage.ext[@"rewardTxt"];
                }

            } break;
            case eMessageBodyType_Voice:{
                ret = NSLocalizedString(@"message.voice1", @"[voice]");
            } break;
            case eMessageBodyType_Location: {
                ret = NSLocalizedString(@"message.location1", @"[location]");
            } break;
            case eMessageBodyType_Video: {
                ret = NSLocalizedString(@"message.video1", @"[video]");
            } break;
            case eMessageBodyType_YuePai: {
                ret = @"[约拍]";
            } break;
            case eMessageBodyType_DaShang: {
                ret = @"[打赏]";
            } break;

            default: {
            } break;
        }
    }
    
    return ret;
}

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    
//    //如果有系统消息，需要特殊处理
//    NSDictionary *extDic = lastMessage.ext;
//    if ([[extDic objectForKey:@"objectType"] isEqualToString:@"0"]) {
//        //取出所有的消息
//        NSArray *allMessages = [conversation loadAllMessages];
//        if (allMessages.count>2) {
//            lastMessage = allMessages[allMessages.count -2];
//        }
//    }
    
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}


#pragma mark add
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addHeaderWithCallback:^{
        vc.listArray = [vc loadDataSource];
        [vc.tableView reloadData];
        [vc performSelector:@selector(resetState) withObject:nil afterDelay:1.0];
        
    }];
//    [self.tableView headerBeginRefreshing];
}

- (void)resetState
{
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
    }
    
}


//弃用
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.tableView addFooterWithCallback:^{
        [vc requestGetMsgGroups];
    }];
}

#pragma mark Request
//弃用
- (void)requestGetMsgGroups
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:uid forKey:@"uid"];
//    [dict setValue:@"0" forKey:@"lastindex"];
    NSDictionary *param = [AFParamFormat formatMsgListOrGroupsParams:dict];
    
    [AFNetwork msgGetGroups:param success:^(id data){
        [self getMsgGroupsDone:data];
    }failed:^(NSError *error){
        
    }];
    
}
//弃用
- (void)getMsgGroupsDone:(id)data
{
    if([data[@"status"] integerValue] == kRight){
        _listArray = data[@"data"];//
        _msgString = @"";
        [self.tableView reloadData];
    }
    if ([data[@"status"] integerValue] == kReLogin) {
        _msgString = @"请重新登录";
    }
    _footerLabel.text = _msgString;
    
    if ([self.tableView isHeaderRefreshing]) {
        [self.tableView headerEndRefreshing];
    }
    if ([self.tableView isFooterRefreshing]) {
        [self.tableView footerEndRefreshing];
    }
}

#pragma mark - TableViewDelegate & TableViewDatasource
//返回单元格
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identify = @"chatListCell";
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identify];
    }
    
    //获取会话对象
    EMConversation *conversation = [self.listArray objectAtIndex:indexPath.row];
    //设置单聊单元格
    if (conversation.conversationType == eConversationTypeChat) {
        cell.isQunLiao = NO;
        cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];
        NSString *theUid = conversation.chatter;
        //从数据库中取出信息
        ChatUserInfo *user = [self getUserWithMessageUserName:theUid];
        BOOL isaviable = NO;
        if (user) {
            if(user.nickName.length>0 &&user.headPic.length>0){
                isaviable =YES;
            }
         }
        if (isaviable) {
            cell.name = user.nickName;
            cell.imgUrlString = user.headPic;
        }else{
            //没有从数据库中获取到信息就通过网路查询
            NSDictionary *params = [AFParamFormat formatGetUserInfoParams:theUid];
            NSString *pathAll = [NSString stringWithFormat:@"%@%@%@",DEFAULTURL,PathGetUserInfo,[AFNetwork getCompleteURLWithParams:params]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
                NSMutableURLRequest *request=[NSMutableURLRequest  requestWithURL:[NSURL URLWithString:pathAll]];
                [request setHTTPMethod:@"POST"];
                NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                NSDictionary *diction = [NSDictionary dictionary];
                //获取不到字典信息，显示错误信息
                @try {
                    //请求网络
                    diction=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
                     //回到刷新UI
                    dispatch_async(dispatch_get_main_queue(), ^{
                    //创建新的数据库对象
                     ChatUserInfo *newUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
                     newUser.chatId  = theUid;
                     newUser.nickName = [NSString stringWithFormat:@"%@",diction[@"data"][@"nickname"]];
                     newUser.headPic  = [NSString stringWithFormat:@"%@",diction[@"data"][@"head_pic"]];
                    [[CoreDataManager shareInstance] saveManagerObj:newUser];
                    //设置单元格
                    //cell.imageURL = [NSURL URLWithString:newUser.headPic];
                    cell.imgUrlString = newUser.headPic;
                    cell.name = newUser.nickName;
                    });
                    }
                @catch (NSException *exception) {
                    //[LeafNotification showInController:self withText:@"网络请求获取用户信息失败"];
                    return;
                }
                @finally {
                 }
             });
         }
        
    }
    //设置群聊单元格
    else{
        NSString *imageName = @"groupPublicHeader";
        if (![conversation.ext objectForKey:@"groupSubject"] || ![conversation.ext objectForKey:@"isPublic"])
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
               if ([group.groupId isEqualToString:conversation.chatter]) {
                   //私有群和公开群
                   imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                    //保存ext中
                    NSMutableDictionary *ext = [NSMutableDictionary dictionaryWithDictionary:conversation.ext];
                    [ext setObject:group.groupSubject forKey:@"groupSubject"];
                    [ext setObject:[NSNumber numberWithBool:group.isPublic] forKey:@"isPublic"];
                    conversation.ext = ext;
                    break;
                }
            }
         }
         //imageName = @"groupPublicHeader";
        cell.isQunLiao = YES;
        cell.placeholderImage = [UIImage imageNamed:imageName];
        cell.name = [conversation.ext objectForKey:@"groupSubject"];
    }
    //设置最近的聊天记录，时间，未读消息
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

//选中单元格：点击会话列表进入聊天界面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
    if (isBangDing) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        EMConversation *conversation = [self.listArray objectAtIndex:indexPath.row];
        //聊天对象的用户名
        NSString *title = [conversation.ext objectForKey:@"name"];
        
        //进入群聊的设置
        if (conversation.conversationType != eConversationTypeChat) {
            //设置群聊主题
            if ([[conversation.ext objectForKey:@"groupSubject"] length])
            {
                title = [conversation.ext objectForKey:@"groupSubject"];
            }
            else
            {   //所加入和创建的群组列表, 群组对象
                NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:conversation.chatter]) {
                        //设置聊天界面的title为当前群的主题
                        title = group.groupSubject;
                        break;
                    }
                }
            }
        }
        //设置群id
        NSString *chatter = conversation.chatter;
        //获取当前单元格
        ChatListCell *cell = (ChatListCell *)[tableView cellForRowAtIndexPath:indexPath];

        //进入群聊界面
        if (conversation.conversationType==eConversationTypeGroupChat) {
            ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:chatter isGroup:YES];
            chatController.title = title;
            [self.navigationController pushViewController:chatController animated:YES];
        }
        //进入单聊界面
        else
        {
            NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
            ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:eConversationTypeChat];
            //视图title
            chatController.title = cell.name;
            chatController.fromHeaderURL = getSafeString(fromHeaderURL);
            //对方头像
            //chatController.toHeaderURL = cell.imageURL.description;
            chatController.toHeaderURL = cell.imgUrlString;
            [self.navigationController pushViewController:chatController animated:YES];
                //本人头像
        }
        
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
     }

}


//删除会话
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //删除记录
        EMConversation *conversation = [self.listArray objectAtIndex:indexPath.row];
        [[EaseMob sharedInstance].chatManager
         removeConversationByChatter:conversation.chatter deleteMessages:YES append2Chat:YES];
        //NSLog(@"%d", indexPath.row);
        [_listArray removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationTop];
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





@end
