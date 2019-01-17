//
//  McSeachViewController.m
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McSeachViewController.h"

#import "McEditAreaViewController.h"
#import "McProvinceViewController.h"
#import "McFiltersDetailViewController.h"
#import "McSeachConditions.h"
#import "McTagStylesViewController.h"

#import "McSeachShowCollectionViewController.h"

@interface McSeachViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>
{
    NSArray *searchConditions;
}

@property (nonatomic, retain) UISearchBar *seachConditionBar;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UITextField *textField;

@property (nonatomic, retain) UITableView *tableView;

@property (nonatomic, strong) McSeachConditions *filterData;
@property (nonatomic, strong) NSMutableDictionary *paramsDictionary;

@end

@implementation McSeachViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.navigationItem.title = NSLocalizedString(@"search", nil);

    //中间变量，存放参数
    if (!_filterData) {
        _filterData = [[McSeachConditions alloc] init];
    }
    _paramsDictionary = [NSMutableDictionary dictionaryWithCapacity:0];

    //添加搜索框
    [self loadHeaderView];
    
    //数据源
    NSArray *sectionArrOne = @[@"性别",@"地区",@"年龄",@"身高",@"体重",@"职业"] ;
    //NSArray *sectionArrTwo = @[@"胸围",@"腰围",@"臀围",@"脚码",@"腿长",@"头发"];
    //NSArray *sectionArrThree = @[@"职业",@"工作标签",@"形象标签",@"期望薪水"];
    //searchConditions = @[sectionArrOne,sectionArrTwo,sectionArrThree];
    searchConditions = @[sectionArrOne];

    //表视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height  - kNavHeight - 80)];
    //- kTabBarHeight
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    self.tableView.scrollEnabled = YES;
    self.tableView.tableHeaderView = _headerView;
    
    //底部搜索按钮
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height  - kNavHeight - 80,self.view.frame.size.width, 80)];//- kTabBarHeight
    footerView.backgroundColor = [UIColor whiteColor];
    UIButton *fliterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fliterBtn setFrame:CGRectMake(40, 20, self.view.frame.size.width - 80, 40)];
    [fliterBtn.titleLabel setFont:kFont14];
    [fliterBtn setTitle:@"开始搜索" forState:UIControlStateNormal];
    [fliterBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [fliterBtn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
    [fliterBtn.layer setBorderWidth:1.0];
    [fliterBtn.layer setCornerRadius:20.0];
    [fliterBtn addTarget:self action:@selector(doFliterConfitions:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:fliterBtn];
    
    [self.view addSubview:_tableView];
    [self.view addSubview:footerView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.tableView reloadData];
}


#pragma mark
- (void)loadHeaderView
{
    UISearchBar * searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 60)];
    searchBar.backgroundColor = [UIColor clearColor];
    NSLog(@"%@",searchBar.subviews);
    for (UIView *subview in searchBar.subviews) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    searchBar.delegate = self;
    searchBar.barStyle = UIBarStyleDefault;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    searchBar.placeholder = @"请输入昵称或MOKA号";
    searchBar.keyboardType =  UIKeyboardTypeDefault;
    
    self.seachConditionBar = searchBar;
    //======暂时未用

    //顶部搜索框
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 80)];
    headerView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    self.headerView = headerView;
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 20, kDeviceWidth-20, 40)];
    textField.font = kFont16;
    textField.textColor = [UIColor colorForHex:kLikeBlackColor];
    textField.delegate = self;
    textField.placeholder = @"请输入昵称或MOKA号";
    textField.clearsOnBeginEditing = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.returnKeyType = UIReturnKeyDone;
    textField.backgroundColor = [UIColor whiteColor];
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    self.textField = textField;
    
    [_headerView addSubview:_textField];
}
#pragma mark request
//发送网络请求
- (void)doFliterConfitions:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lng = Longitude;
    [_paramsDictionary setValue:[NSNumber numberWithDouble:lat] forKey:@"latitude"];
    [_paramsDictionary setValue:[NSNumber numberWithDouble:lng]  forKey:@"longitude"];
    [_paramsDictionary setValue:_textField.text forKey:@"nickname"];
    NSDictionary *params = [AFParamFormat formatSearchMochaParams:_paramsDictionary];
    [AFNetwork searchInfo:params success:^(id data){
        [self doFliterDone:data];
    }failed:^(NSError *error){
        
    }];
}

//处理网络请求，显示搜索结果
- (void)doFliterDone:(id)data
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    if([data[@"status"] integerValue] == kRight){
        if ([data[@"data"][@"user"] count] > 0) {
            [self.customTabBarController hidesTabBar:YES animated:NO];
            McSeachShowCollectionViewController *seachVC = [[McSeachShowCollectionViewController alloc] init];
            seachVC.dataArray = [NSMutableArray arrayWithArray:data[@"data"][@"user"]];
            seachVC.type = [data[@"data"][@"type"] integerValue];
            seachVC.lastIndex = [NSString stringWithFormat:@"%@",data[@"lastindex"]];
            seachVC.paramsDictionary = _paramsDictionary;
            [self.navigationController pushViewController:seachVC animated:YES];
            return;
        }
        [LeafNotification showInController:self withText:@"结果为空"];
    }
    
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self doFliterConfitions:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_textField resignFirstResponder];
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[searchConditions objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"searchell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSArray *conditionArr = [searchConditions objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    cell.textLabel.text = [conditionArr objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = _filterData.sex;
                break;
            case 1:
                cell.detailTextLabel.text = _filterData.area;
                break;
            case 2:
                cell.detailTextLabel.text = _filterData.age;
                break;
            case 3:
                cell.detailTextLabel.text = _filterData.height;
                break;
            case 4:
                cell.detailTextLabel.text = _filterData.weight;
                break;
            case 5:
                cell.detailTextLabel.text = _filterData.userType;
                break;
        }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = _filterData.bust;
                break;
            case 1:
                cell.detailTextLabel.text = _filterData.waist;
                break;
            case 2:
                cell.detailTextLabel.text = _filterData.hips;
                break;
            case 3:
                cell.detailTextLabel.text = _filterData.foot;
                break;
            case 4:
                cell.detailTextLabel.text = _filterData.leg;
                break;
            case 5:
                cell.detailTextLabel.text = _filterData.hair;
                break;
                
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = _filterData.job;
                break;
            case 1:
                cell.detailTextLabel.text = _filterData.workTags;
                break;
            case 2:
                cell.detailTextLabel.text = _filterData.figureTags;
                break;
            case 3:
                cell.detailTextLabel.text = _filterData.desiredSalary;
                break;
            default:
                break;
        }

    }

    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [searchConditions count];
}

//UITableViewDelegate
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_textField resignFirstResponder];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {   //选择性别
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeSex];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 1:
            {
                //选择省份
                McProvinceViewController *flitersVC = [[McProvinceViewController alloc] init];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                //设置了类型
                flitersVC.editOrSearch = 2;
                //设置了显示“不限”
                flitersVC.isbuxian  = YES;
                //触发原因
                flitersVC.sourceVCName = @"homeVC_search";
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 2:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeAge];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 3:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeHeight];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 4:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeWeight];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 5:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeUserType];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        switch (indexPath.row) {
            case 0:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeBust];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 1:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeWaist];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 2:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeHipline];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 3:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeFoot];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 4:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeLeg];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 5:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeHair];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
                
                
            default:
                break;
        }
    }
    else{
        switch (indexPath.row) {
            case 0:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeJob];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 1:
            {
                McTagStylesViewController *flitersVC = [[McTagStylesViewController alloc] initWithType:McFiltersTypeWorkTags];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 2:
            {
                McTagStylesViewController *flitersVC = [[McTagStylesViewController alloc] initWithType:McFiltersTypeFigureTags];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            case 3:
            {
                McFiltersDetailViewController *flitersVC = [[McFiltersDetailViewController alloc] initWithType:McFiltersTypeDesiredSalary];
                flitersVC.filterData = _filterData;
                flitersVC.paramsDictionary = _paramsDictionary;
                [self.navigationController pushViewController:flitersVC animated:NO];
            }
                break;
            
            default:
                break;
        }
    }
    
}

@end
