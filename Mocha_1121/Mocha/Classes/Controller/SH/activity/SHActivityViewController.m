//
//  SHActivityViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "SHActivityViewController.h"
#import "NewActivityTableViewCell.h"
#import "NewActivityFilterViewController.h"
#import "ReleaseActivityViewController.H"
#import "ActivityFilterModel.h"
#import "MJRefresh.h"
#import "NewActivityDetailViewController.h"

@interface SHActivityViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *activityListTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *lastIndex;

@property (strong, nonatomic) UITextField *searchTextfield;

@property (assign, nonatomic) BOOL isAllowPublish;

@property (assign, nonatomic) BOOL isSendOrderIndex;

@property (copy, nonatomic) NSString *alertMessage;

@property (strong, nonatomic) NewActivityFilterViewController *filter;

@end

@implementation SHActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"精选活动";
    self.dataArray = @[].mutableCopy;
    self.lastIndex = @"0";
    self.isAllowPublish = YES;
    self.isSendOrderIndex = NO;
    self.alertMessage = @"";
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [leftButton setTitle:@"筛选" forState:UIControlStateNormal];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [leftButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(filterMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(publishMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    self.activityListTableView.contentInset = UIEdgeInsetsMake(55, 0, 0, 0);
    [self addHeader];
    [self addFooter];
    [self requestGetEventList];
    self.activityListTableView.tableHeaderView = [self getHeaderView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterActivity) name:@"filterActivity" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.searchTextfield resignFirstResponder];
    
    [self.customTabBarController hidesTabBar:NO animated:NO];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:YES animated:YES];
    
    [self.searchTextfield resignFirstResponder];
    
}

- (UIView *)getHeaderView
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-0, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIView *backV = [[UIView alloc] initWithFrame:CGRectMake(0, 15, kScreenWidth-0, 38)];
    backV.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:backV];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, 20, 20)];
    imgView.image = [UIImage imageNamed:@"event-search"];
    [backV addSubview:imgView];
    
    UITextField *textfield = [[UITextField alloc] initWithFrame:CGRectMake(36, -3, kScreenWidth-60, 44)];
    textfield.borderStyle = UITextBorderStyleNone;
    textfield.returnKeyType = UIReturnKeySearch;
    textfield.font = [UIFont systemFontOfSize:13];
    textfield.delegate = self;
    textfield.placeholder = @"搜索";
    [backV addSubview:textfield];
    self.searchTextfield = textfield;
    
    return headerView;
}


- (void)filterMethod
{
    NSLog(@"filterMethod");
    if (!self.filter) {
        self.filter = [[NewActivityFilterViewController alloc] initWithNibName:@"NewActivityFilterViewController" bundle:[NSBundle mainBundle]];
    }
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    ;
    [self.navigationController pushViewController:self.filter animated:YES];
}

- (void)publishMethod
{
    NSLog(@"publishMethod");
    if (self.isAllowPublish) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            //判断登录情况
            ReleaseActivityViewController *signupVC = [[ReleaseActivityViewController alloc] init];
            
            UserDefaultSetBool(NO, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
            [self.navigationController pushViewController:signupVC animated:YES];
            
        }else
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            
        }
    }else
    {
        [LeafNotification showInController:self withText:self.alertMessage];
        [self performSelector:@selector(appearLoginView) withObject:nil afterDelay:1.0];
    }
    
}

- (void)appearLoginView
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        
        
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        
    }
    
}

#pragma mark Refresh
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    [self.activityListTableView addHeaderWithCallback:^{
        vc.lastIndex = @"0";
        self.searchTextfield.text = @"";
        [vc requestGetEventList];
        
    }];
    [self.activityListTableView headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [self.activityListTableView addFooterWithCallback:^{
        self.searchTextfield.text = @"";
        
        [vc requestGetEventList];
        
    }];
}

- (void)endRefreshing
{
    if ([self.activityListTableView isHeaderRefreshing]) {
        [self.activityListTableView headerEndRefreshing];
    }
    if ([self.activityListTableView isFooterRefreshing]) {
        [self.activityListTableView footerEndRefreshing];
    }
}


#pragma mark request
- (void)requestGetEventList
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setObject:@"" forKey:@"city"];
    [dict setObject:@"" forKey:@"sex"];
    [dict setObject:@"" forKey:@"province"];
    [dict setObject:@"" forKey:@"user_type"];
    [dict setObject:@"20" forKey:@"pagesize"];
    [dict setObject:@"" forKey:@"payment"];
    [dict setObject:@"" forKey:@"order"];
    if (self.isSendOrderIndex) {
        [dict setValue:self.lastIndex forKey:@"orderindex"];
        
    }else
    {
        [dict setValue:self.lastIndex forKey:@"lastindex"];
        
    }
    
    
    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork eventGetList:param success:^(id data){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endRefreshing];
            
        });
        if ([data[@"status"] integerValue] == kRight) {
            id diction = data[@"createEnable"];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = data[@"createEnable"];
                self.alertMessage = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                NSString *allow = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([allow isEqualToString:@"1"]) {
                    self.isAllowPublish = YES;
                }else
                {
                    self.isAllowPublish = NO;
                }
            }
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if ([self.lastIndex isEqualToString:@"0"]) {
                    self.dataArray = [NSMutableArray arrayWithArray:arr];
                    
                }else
                {
                    [self.dataArray addObjectsFromArray:arr];
                }
                if (data[@"lastindex"]) {
                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                    self.isSendOrderIndex = NO;
                    
                }else
                {
                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"orderindex"]];
                    self.isSendOrderIndex = YES;
                }
                [self.activityListTableView reloadData];
            }else{
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                    
                }
                
            }
            
        }else if([data[@"status"] integerValue] == kReLogin){
            
            NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
            if (message.length>0) {
                [LeafNotification showInController:self withText:message];
                
            }
        }
        
        
    }failed:^(NSError *error){
        [self endRefreshing];
        //[LeafNotification showInController:self withText:error.description];
        [LeafNotification showInController:self
                                  withText:@"网络连接失败"];
        
    }];
}


- (void)filterActivity
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *paramDic = @{}.mutableCopy;
    
    NSString *city = [ActivityFilterModel sharedInstance].filterCity;
    if([city isEqualToString:@"0"])
    {
        city = @"";
    }
    
    NSString *province = [ActivityFilterModel sharedInstance].filterProvince;
    if([province isEqualToString:@"0"])
    {
        province = @"";
    }
    
    NSString *sex = [ActivityFilterModel sharedInstance].filterSex;
    NSString *user_type = [ActivityFilterModel sharedInstance].filterShenFen;
    NSString *payment = [ActivityFilterModel sharedInstance].filterFeiYong;
    NSString *order = [ActivityFilterModel sharedInstance].filterPaiXu;
    [paramDic setObject:@"" forKey:@"city"];
    [paramDic setObject:@"" forKey:@"sex"];
    [paramDic setObject:@"0" forKey:@"lastindex"];
    [paramDic setObject:@"" forKey:@"province"];
    [paramDic setObject:@"" forKey:@"user_type"];
    [paramDic setObject:@"20" forKey:@"pagesize"];
    [paramDic setObject:@"" forKey:@"payment"];
    [paramDic setObject:@"" forKey:@"order"];
    if (city.length>0) {
        [paramDic setObject:city forKey:@"city"];
        
    }
    if (province.length>0) {
        [paramDic setObject:province forKey:@"province"];
        
    }
    if (sex.length>0) {
        [paramDic setObject:sex forKey:@"sex"];
        
    }
    if (user_type.length>0) {
        [paramDic setObject:user_type forKey:@"user_type"];
        
    }
    if (payment.length>0) {
        [paramDic setObject:payment forKey:@"payment"];
        
    }
    if (order.length>0) {
        [paramDic setObject:order forKey:@"order"];
        
    }
    
    NSDictionary *param = [AFParamFormat formatSearchActivityParams:paramDic];
    
    [AFNetwork searchActivity:param success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self endRefreshing];
        
        [[ActivityFilterModel sharedInstance] clearData];
        
        if ([data[@"status"] integerValue] == kRight) {
            id diction = data[@"createEnable"];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = data[@"createEnable"];
                self.alertMessage = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                NSString *allow = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([allow isEqualToString:@"1"]) {
                    self.isAllowPublish = YES;
                }else
                {
                    self.isAllowPublish = NO;
                }
            }
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                [self.dataArray removeAllObjects];
                self.dataArray = [NSMutableArray arrayWithArray:arr];
                self.lastIndex = @"0";
                [self.activityListTableView reloadData];
            }else{
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                    
                }
            }
            
        }else if([data[@"status"] integerValue] == kReLogin){
            
            [LeafNotification showInController:self withText:data[@"msg"]];
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[ActivityFilterModel sharedInstance] clearData];
        
        [LeafNotification showInController:self withText:error.description];
        
        
    }];
    
}


- (void)searchTitleFilter
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.dataArray removeAllObjects];
    
    NSMutableDictionary *paramDic = @{}.mutableCopy;
    NSString *keywords = normaliseString(self.searchTextfield.text);
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)keywords, NULL, NULL,  kCFStringEncodingUTF8 ));
    [paramDic setObject:encodedString forKey:@"keywords"];
    [paramDic setObject:@"" forKey:@"city"];
    [paramDic setObject:@"" forKey:@"sex"];
    
    [paramDic setObject:@"" forKey:@"province"];
    [paramDic setObject:@"" forKey:@"user_type"];
    [paramDic setObject:@"20" forKey:@"pagesize"];
    [paramDic setObject:@"" forKey:@"payment"];
    [paramDic setObject:@"" forKey:@"order"];
    if (self.isSendOrderIndex) {
        [paramDic setValue:self.lastIndex forKey:@"orderindex"];
        
    }else
    {
        [paramDic setValue:self.lastIndex forKey:@"lastindex"];
        
    }
    NSDictionary *param = [AFParamFormat formatSearchActivityParams:paramDic];
    
    [AFNetwork searchActivity:param success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self endRefreshing];
        
        [[ActivityFilterModel sharedInstance] clearData];
        
        if ([data[@"status"] integerValue] == kRight) {
            id diction = data[@"createEnable"];
            if ([diction isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = data[@"createEnable"];
                self.alertMessage = [NSString stringWithFormat:@"%@",dic[@"msg"]];
                NSString *allow = [NSString stringWithFormat:@"%@",dic[@"status"]];
                if ([allow isEqualToString:@"1"]) {
                    self.isAllowPublish = YES;
                }else
                {
                    self.isAllowPublish = NO;
                }
            }
            NSArray *arr = data[@"data"];
            if ([arr count] > 0) {
                if ([self.lastIndex isEqualToString:@"0"]) {
                    self.dataArray = [NSMutableArray arrayWithArray:arr];
                    
                }else
                {
                    [self.dataArray addObjectsFromArray:arr];
                }
                if (data[@"lastindex"]) {
                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
                    self.isSendOrderIndex = NO;
                    
                }else
                {
                    self.lastIndex = [NSString stringWithFormat:@"%@",data[@"orderindex"]];
                    self.isSendOrderIndex = YES;
                }
                [self.activityListTableView reloadData];
                [self.searchTextfield resignFirstResponder];
            }else{
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                    
                }else
                {
                    [LeafNotification showInController:self withText:@"搜索结果为空"];
                    [self.searchTextfield resignFirstResponder];
                    
                }
            }
            
        }else if([data[@"status"] integerValue] == kReLogin){
            
            [LeafNotification showInController:self withText:data[@"msg"]];
            
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [[ActivityFilterModel sharedInstance] clearData];
        
        [LeafNotification showInController:self withText:error.description];
        
        
    }];
    
}

#pragma mark - textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.text.length>0)
    {
        self.lastIndex = @"0";
        [self searchTitleFilter];
    }
    
    return YES;
}


#pragma mark - uiscrollview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchTextfield resignFirstResponder];
    
}



#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewActivityTableViewCell *cell = nil;
    NSString *identifier = @"NewActivityTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [NewActivityTableViewCell getNewActivityCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (self.dataArray.count>indexPath.row) {
        [cell setCelldataWithDiction:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserDefaultSetBool(NO, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    NewActivityDetailViewController *newActivity = [[NewActivityDetailViewController alloc] initWithNibName:@"NewActivityDetailViewController" bundle:[NSBundle mainBundle]];
    ;
    newActivity.eventId = normaliseString(self.dataArray[indexPath.row][@"id"]);
    [self.navigationController pushViewController:newActivity animated:YES];
    
}


















@end
