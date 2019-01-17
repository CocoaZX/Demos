//
//  ChatListViewController.m
//  Templete
//
//  Created by sun on 15/6/15.
//  Copyright (c) 2015年 Bangko. All rights reserved.
//

#import "ChatListViewController.h"
#import "EaseMob.h"
#import "MessageModel.h"
#import "MessageModelManager.h"
#import "DAContextMenuCell.h"
#import "ChatViewController.h"
#import "ChatManager.h"

@interface ChatListViewController ()<IChatManagerDelegate>

@property (nonatomic, strong) NSMutableArray *chatArray;


@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.chatArray = @[].mutableCopy;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDataSourceWithCancelSearch) name:@"refreshDataSourceWithCancelSearch" object:nil];

}

- (void)refreshDataSourceWithCancelSearch
{
    [self performSelector:@selector(refreshDelay) withObject:nil afterDelay:0.8];
    
}

- (void)refreshDelay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSIndexPath *tmpIndexpath=[NSIndexPath indexPathForRow:self.chatArray.count-1 inSection:0];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:tmpIndexpath, nil] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        

    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self refreshDataSource];

    [self registerNotifications];

}

- (void)addTitleView
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 44)];
    titleView.backgroundColor = UIColorRGBA(60, 164, 253, 1);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-120, 40)];
    label.center = CGPointMake(kScreenWidth/2, 22);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    label.textColor = [UIColor whiteColor];
    label.text = @"liang lin";
    [titleView addSubview:label];
    [self.view addSubview:titleView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refreshDataSource
{
    [self.chatArray removeAllObjects];
    
    NSMutableArray *array = [self loadDataSource];

    int index = 0;
    for (int i=0; i<array.count; i++) {
        EMConversation *obj1 = array[i];
        NSString *chatter = BKUserObjectForKey(BKKeyForHuanToTop);
        if ([obj1.chatter isEqualToString:chatter]) {
            index = i;
            break;
        }
    }
    
    //置顶
    if (array.count>0) {
        [array insertObject:array[index] atIndex:0];
        [array removeObjectAtIndex:index+1];
        
    }
    
    //移除没有内容的会话
    for (int i=0; i<array.count; i++) {
        EMConversation *obj1 = array[i];
        MessageModel *cellModel = [MessageModelManager modelWithMessage:obj1.latestMessage];
        if (cellModel.username) {
            [self.chatArray addObject:obj1];
        }
    }
    
    [self.tableView reloadData];

}

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EaseMob sharedInstance].chatManager conversations];
    
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
//    for (int i=0; i<15; i++) {
//        [ret addObject:sorte[0]];
//    }
    return ret;
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark * Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatArray.count;
//    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMConversation *conversation = [self.chatArray objectAtIndex:indexPath.row];
    MessageModel *cellModel = [MessageModelManager modelWithMessage:conversation.latestMessage];

    NSString *titleStr = [NSString stringWithFormat:@"%@",cellModel.username?cellModel.username:@""];
    EMMessage *message = conversation.latestMessage;
    titleStr = message.ext[@"userName"]?message.ext[@"userName"]:@"";
    NSString *descriptionTpye = [NSString stringWithFormat:@"%ld",(long)cellModel.type];
    NSString *descriptionString = @"[图片]";
    if ([descriptionTpye isEqualToString:@"1"]) {
        descriptionString = [NSString stringWithFormat:@"%@",cellModel.content];

    }
    
    static NSString *CellIdentifier = @"ChatListCell";
    DAContextMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.titleLabel.text = titleStr;
    cell.descriptionLabel.text = descriptionString;
    cell.isCenter = YES;
    cell.isLeft = NO;
    cell.isRight = NO;
    cell.shouldDisplayContextMenuView_right = NO;
    cell.shouldDisplayContextMenuView_left = NO;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95.;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.chatArray objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.chatter;
    if (conversation.conversationType != eConversationTypeChat) {
        if ([[conversation.ext objectForKey:@"groupSubject"] length])
        {
            title = [conversation.ext objectForKey:@"groupSubject"];
        }
        else
        {
            NSArray *groupArray = [[EaseMob sharedInstance].chatManager groupList];
            for (EMGroup *group in groupArray) {
                if ([group.groupId isEqualToString:conversation.chatter]) {
                    title = group.groupSubject;
                    break;
                }
            }
        }
    }
    NSString *chatter = conversation.chatter;
    chatController = [[ChatViewController alloc] initWithChatter:chatter conversationType:conversation.conversationType];
    chatController.delelgate = self;
    chatController.title = title;
    [self.navigationController pushViewController:chatController animated:YES];
}

#pragma mark * DAContextMenuCell delegate

- (void)contextMenuCellDidSelectDeleteOption:(DAContextMenuCell *)cell
{
    EMConversation *conversation = [self.chatArray objectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [[EaseMob sharedInstance].chatManager removeConversationByChatter:conversation.chatter deleteMessages:YES append2Chat:YES];
    [super contextMenuCellDidSelectDeleteOption:cell];
    [self.chatArray removeObjectAtIndex:[[self.tableView indexPathForCell:cell] row]];
    [self.tableView deleteRowsAtIndexPaths:@[[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)contextMenuCellDidSelectMoreOption:(DAContextMenuCell *)cell
{
    NSIndexPath *indexpath = [self.tableView indexPathForCell:cell];
    EMConversation *conversation = [self.chatArray objectAtIndex:indexpath.row];
    BKUserObjectSetForKey(conversation.chatter, BKKeyForHuanToTop);
    [self.chatArray insertObject:self.chatArray[indexpath.row] atIndex:0];
    [self.chatArray removeObjectAtIndex:indexpath.row+1];
    [cell backToCenter];
    NSIndexPath *topIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView moveRowAtIndexPath:indexpath toIndexPath:topIndex];
}

@end
