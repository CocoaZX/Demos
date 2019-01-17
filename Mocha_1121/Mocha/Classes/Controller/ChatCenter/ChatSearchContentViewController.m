//
//  ChatSearchContentViewController.m
//  Templete
//
//  Created by MagicFox on 15/7/8.
//  Copyright (c) 2015年 Bangko. All rights reserved.
//

#import "ChatSearchContentViewController.h"
#import "EMSearchDisplayController.h"
#import "EMSearchBar.h"
#import "ChatListCell.h"
#import "APIUserPlugin.h"
#import "EaseMob.h"
#import "ChatViewController.h"
#import "NSJSONSerialization+RFKit.h"
#import "API.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "ChatManager.h"

@interface ChatSearchContentViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (weak, nonatomic) IBOutlet UIView *navView;

@property (nonatomic, strong) UISearchBar           *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) NSMutableArray        *dataSource;

@end

@implementation ChatSearchContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    
    // Do any additional setup after loading the view.
    [self.navBarView addSubview:self.searchBar];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 3, 40, 40)];
    //    [backButton setTitle:@"back" forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"Button-arrow-left-1"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.navBarView addSubview:backButton];
    [self searchController];
    
}

- (void)backMethod:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UISearchBar *)searchBar
{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(35, 0, kScreenWidth-35, 44)];
        //        _searchBar.barTintColor = RGBACOLOR(69, 145, 253, 1);
        _searchBar.tintColor = [UIColor colorWithRGBHex:0x523F98];
        [_searchBar setBackgroundImage:[UIImage new]];
        _searchBar.delegate = self;
        _searchBar.translucent = YES;
        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
        //        _searchBar.searchTextPositionAdjustment = ;
        [_searchBar setPositionAdjustment:UIOffsetMake(10, 0) forSearchBarIcon:UISearchBarIconSearch];
        [_searchBar setImage:[UIImage imageNamed:@"searchbarIcon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
        
    }
    
    return _searchBar;
}



- (EMSearchDisplayController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[EMSearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        _searchController.delegate = self;
        _searchController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        __weak ChatSearchContentViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            if (indexPath.row < [self.dataSource count]) {
                id obj = [weakSelf.dataSource objectAtIndex:indexPath.row];
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
                else{
                    MessageModel *model = (MessageModel *)obj;
                    NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
                    EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                    if (cell == nil) {
                        cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                        cell.backgroundColor = [UIColor clearColor];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    cell.messageModel = model;
                    
                    return cell;
                }
            }
            
            return nil;

        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            NSObject *obj = [weakSelf.dataSource objectAtIndex:indexPath.row];
            if ([obj isKindOfClass:[NSString class]]) {
                return 40;
            }
            else{
                return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(MessageModel *)obj];
            }
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            
        }];
    }
    
    return _searchController;
}



#pragma mark - UISearchBarDelegate



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self performSelector:@selector(delayChangeFrame_cancel) withObject:nil afterDelay:0.3];
    return YES;
}

- (void)delayChangeFrame_cancel
{
    self.searchBar.frame = CGRectMake(35, 0, kScreenWidth-35, 44);
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [self performSelector:@selector(delayChangeFrame) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(delayChangeFrame) withObject:nil afterDelay:1];

    return YES;
}

- (void)delayChangeFrame
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.searchBar.frame = CGRectMake(35, 0, kScreenWidth-35, 44);

    });
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self sousuolianxirenWithString:searchBar.text];
}


//搜索联系人
- (void)sousuolianxirenWithString:(NSString *)content
{
    APIUserPlugin *userPlugin = [API user];


    NSString *thisAccount = [NSString stringWithFormat:@"%@",userPlugin.account];
    
//    NSDictionary *dict = @{
//                           @"from_user_id":thisAccount,
//                           @"to_user_id":self.to_userid?self.to_userid:@"",
//                           @"content":content?content:@"",
//
//                           };
    
    NSDictionary *dict = @{
                           @"from_user_id":@"15821405288",
                           @"to_user_id":@"1434622748233",
                           @"content":@"来根烟"
                           
                           };

    [self APITestWithPara:dict path:APINameGetChatContent];
}


- (NSMutableDictionary *)basePara {
    return [@{@"head"   :@{},
              @"message":@{} }mutableCopy];
}

- (void)APITestWithPara:(NSDictionary *)para
                   path:(NSString *)path {
    NSMutableDictionary *tmp = [NSMutableDictionary dictionaryWithDictionary:[self basePara]];
    [tmp setObject:para forKey:@"message"];
    NSString *jsonString = [NSJSONSerialization stringWithJSONObject:tmp options:0 error:nil];
    NSDictionary *dict = @{ @"requ_package":jsonString
                            };
    RFAPIControl *cn = [[RFAPIControl alloc] initWithIdentifier:path loadingMessage:@"加载中"];
    cn.forceLoad = NO;
    cn.message.modal = YES;
    [[API sharedInstance]requestWithName:path parameters:dict controlInfo:cn success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        JSONResponseBase *base = nil;
        if ([responseObject isKindOfClass:[JSONModel class]]) {
            base = (JSONResponseBase *)responseObject;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"kTestAPIResponseNotification" object:nil userInfo:@{@"response" : base}];
        }else {
            [self.dataSource removeAllObjects];
            NSString *string = [operation responseString];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithString:string usingEncoding:NSUTF8StringEncoding allowLossyConversion:YES options:0 error:nil];
            NSString *flag = [NSString stringWithFormat:@"%@",dict[@"head"][@"flag"]];
            if ([flag isEqualToString:@"1"]) {
                NSArray *array = dict[@"message"][@"entities"];
                APIUserPlugin *userPlugin = [API user];
                NSString *thisAccount = [NSString stringWithFormat:@"%@",userPlugin.account];
                

                for (int i=0; i<array.count; i++) {
                    NSDictionary *diction = array[0];
                    NSString *from_user_id = [NSString stringWithFormat:@"%@",diction[@"from_user_id"]];
                    
                    MessageModel *model = [[MessageModel alloc] init];
                    if ([from_user_id isEqualToString:thisAccount]) {
                        model.isSender = YES;
                        
                    }
                    model.nickName = from_user_id;
                    model.type = eMessageBodyType_Text;
                    model.messageType = eMessageTypeChat;
                    model.headImageURL = [NSURL URLWithString:@""];
                    model.content = [NSString stringWithFormat:@"%@",diction[@"msg"]];
                    
                    [self.dataSource addObject:model];
                    
                }
                self.searchController.resultsSource = self.dataSource;
                [self.searchController.searchResultsTableView reloadData];
            }else
            {
                self.searchController.resultsSource = @[].mutableCopy;
                [self.searchController.searchResultsTableView reloadData];
                
                [API showErrorStatus:dict[@"head"][@"err_message"]];
                
            }
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTestAPIResponseNotification" object:nil userInfo:@{@"response" : error}];
        [API showErrorStatus:[error description]];
    } completion:^(AFHTTPRequestOperation *operation) {
        
    }];
}


@end
