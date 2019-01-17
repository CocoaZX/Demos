//
//  ChatCenterViewController.m
//  Templete
//
//  Created by 小猪猪 on 15/6/18.
//  Copyright (c) 2015年 Bangko. All rights reserved.
//

#import "ChatCenterViewController.h"
#import "EaseMob.h"
#import "NSJSONSerialization+RFKit.h"
#import "API.h"
#import "ChatManager.h"
#import "APITest.h"
#import "EMSearchBar.h"
#import "ChatListCell.h"
#import "RealtimeSearchUtil.h"
#import "EMConversation.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "EMSearchDisplayController.h"
#import "ConvertToCommonEmoticonsHelper.h"
@interface ChatCenterViewController ()<UISearchBarDelegate,UISearchDisplayDelegate>

@property (nonatomic, strong) UISearchBar           *searchBar;

@property (strong, nonatomic) EMSearchDisplayController *searchController;

@property (strong, nonatomic) NSMutableArray        *dataSource;


@end

@implementation ChatCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];

    // Do any additional setup after loading the view.
    [self.navBarView addSubview:self.searchBar];
    [self searchController];
    
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
        _searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, kScreenWidth, 44)];
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
        
        __weak ChatCenterViewController *weakSelf = self;
        [_searchController setCellForRowAtIndexPathCompletion:^UITableViewCell *(UITableView *tableView, NSIndexPath *indexPath) {
            static NSString *CellIdentifier = @"ChatListCell";
            ChatListCell *cell = (ChatListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[ChatListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            NSDictionary *diction = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];

            cell.name = diction[@"name"];
            cell.placeholderImage = [UIImage imageNamed:@"chatListCellHead.png"];

            if (indexPath.row % 2 == 1) {
                cell.contentView.backgroundColor = UIColorRGBA(246, 246, 246, 1);
            }else{
                cell.contentView.backgroundColor = [UIColor whiteColor];
            }
            return cell;
        }];
        
        [_searchController setHeightForRowAtIndexPathCompletion:^CGFloat(UITableView *tableView, NSIndexPath *indexPath) {
            return [ChatListCell tableView:tableView heightForRowAtIndexPath:indexPath];
        }];
        
        [_searchController setDidSelectRowAtIndexPathCompletion:^(UITableView *tableView, NSIndexPath *indexPath) {
            
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [weakSelf.searchController.searchBar endEditing:YES];
            
            NSDictionary *diction = [weakSelf.searchController.resultsSource objectAtIndex:indexPath.row];

            APIUserPlugin *userPlugin = [API user];
            NSString *name = [NSString stringWithFormat:@"%@",diction[@"user_id"]];
            NSString *thisAccount = [NSString stringWithFormat:@"%@",userPlugin.account];
            if ([name isEqualToString:thisAccount]) {
                [API showErrorStatus:@"自己不能跟自己聊"];

            }else
            {
                EMError *error = nil;
                [[EaseMob sharedInstance].chatManager registerNewAccount:diction[@"user_id"] password:[ChatManager shareChatManager].huanxinPassword error:&error];
                ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:diction[@"user_id"] conversationType:eConversationTypeChat];
                chatVC.title = diction[@"name"];
                [weakSelf.navigationController pushViewController:chatVC animated:YES];
                
            }
        }];
    }
    
    return _searchController;
}



#pragma mark - UISearchBarDelegate



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDataSourceWithCancelSearch" object:nil];
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self sousuolianxirenWithString:searchBar.text];
}


//搜索联系人
- (void)sousuolianxirenWithString:(NSString *)mobile
{
    NSDictionary *dict = @{
                           @"user_id":mobile,
                           };
    [self APITestWithPara:dict path:APINameGetChatPeople];
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
                NSString *name = dict[@"message"][@"user_info"][@"user_name"]?dict[@"message"][@"user_info"][@"user_name"]:@"";
                NSString *user_id = dict[@"message"][@"user_info"][@"user_id"]?dict[@"message"][@"user_info"][@"user_id"]:@"";
                NSDictionary *diction = @{@"name":name,@"user_id":user_id};
                [self.dataSource addObject:diction];
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
