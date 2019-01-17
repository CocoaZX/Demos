//
//  McSeachResultTableViewController.m
//  Mocha
//
//  Created by renningning on 14-12-16.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McSetAccountViewController.h"
#import "McSearchTableViewCell.h"
#import "MJRefresh.h"
#import "McEditPwdViewController.h"

@interface McSetAccountViewController ()

@property (nonatomic, retain) NSArray *dataArray;

@end

NSString *const McTableViewCellIdentifier = @"McTableViewCell";

@implementation McSetAccountViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = @"账号设置";
    
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"topBar3"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    _dataArray = @[@"绑定手机",@"修改密码"]; //,@"退出当前账号"
    
//    [self loadSubViews];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    headerView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    self.tableView.tableHeaderView = headerView;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:McTableViewCellIdentifier];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubViews
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(20, CGRectGetHeight(self.view.frame)/2, CGRectGetWidth(self.view.frame) - 40, 40)];
    [btn setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSignOut:) forControlEvents:UIControlEventTouchUpInside];
    [btn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setCornerRadius:20.0];
    [btn.layer setMasksToBounds:YES];
    [self.tableView addSubview:btn];
}

#pragma mark action
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark private
//action
- (void)doSignOut:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];


    NSDictionary *params = [AFParamFormat formatSignOutParams:nil];
    [AFNetwork loginOut:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[EaseMob sharedInstance].chatManager asyncLogoffWithUnbindDeviceToken:YES];
        [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        [(AppDelegate *)[UIApplication sharedApplication].delegate showMainViewController];
        return ;
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

    }];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;//
}

/*

*/
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:McTableViewCellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:McTableViewCellIdentifier];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.section];
    
    
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        UILabel *bangDingLab = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth - 100, 0, 90, cell.height)];
        bangDingLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
        bangDingLab.textAlignment = NSTextAlignmentRight;
        bangDingLab.font = [UIFont systemFontOfSize:16.0];
        
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (isBangDing) {
            bangDingLab.text = @"已绑定";
        }else{
            bangDingLab.text = @"点击绑定";
        }
        [cell addSubview:bangDingLab];
    }
    if(indexPath.section == 1){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
        {
            McEditPwdViewController *setVC = [[McEditPwdViewController alloc] init];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
        case 0:
        {
            BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
            if (!isBangDing) {
                [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            }
        }
            break;
            
            
        default:
            break;
    }
    
}

//判断是否绑定手机
-(void)cellAddSubViewInCell:(UITableViewCell *)cell{
    UILabel *bangDingLab = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth - 100, 0, 100, cell.height)];
    bangDingLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    bangDingLab.font = [UIFont systemFontOfSize:16.0];
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    if (mobile.length<2) {
        bangDingLab.text = @"点击绑定";
    }else{
        bangDingLab.text = @"已绑定";
    }
    [cell addSubview:bangDingLab];
}



@end
