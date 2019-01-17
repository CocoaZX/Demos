//
//  McEditPersonalViewController.m
//  Mocha
//
//  Created by renningning on 14-11-28.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditPersonalViewController.h"
#import "JSONKit.h"
#import "ReadPlistFile.h"

@interface McEditPersonalViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSString *selectedStr;
    NSString *selectedId;
}

@property (nonatomic, assign) McPersonalType personalType;
@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *plistDict;

@end

@implementation McEditPersonalViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.personalType = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"编辑";
    
    self.contentArray = [NSArray array];
    self.plistDict = [NSDictionary dictionary];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    [self loadDataWithFile];
    
    if(_personalType == McPersonalTypeSex){
        [self loadBarButtonItem];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark private
- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)modifyAction:(id)sender
{
    if (_personalType == McPersonalTypeSex) {

        return;
    }
    
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    switch (_personalType){
        case McPersonalTypeSex:{
            if ([selectedStr isEqual:@"男"]) {
                [dict setValue:@"1" forKey:@"sex"];
            }
            else if ([selectedStr isEqual:@"女"]) {
                [dict setValue:@"2" forKey:@"sex"];
            }
            else{
                [dict setValue:@"0" forKey:@"sex"];
            }
            
        }
            break;
        case McPersonalTypeFoot:
        {
            [dict setValue:selectedId forKey:@"foot"];
        }
            break;
        case McPersonalTypeHair:
        {
            [dict setValue:selectedId forKey:@"hair"];
        }
            break;
        case McPersonalTypeJob:
        {
            [dict setValue:selectedId forKey:@"job"];
        }
            break;
        case McPersonalTypeMajor:
        {
            [dict setValue:selectedId forKey:@"major"];
        }
            break;
            
        default:
            break;
    }
    
    
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){
        [self modifyDoneAction:data];
    }failed:^(NSError *error){
        
    }];
    
}

- (void)modifyDoneAction:(id)result
{
    if ([result[@"status"] integerValue] == kRight) {
        [LeafNotification showInController:self withText:@"修改成功"];
        [self modifySucess];
        if (_personalType == McPersonalTypeSex) {
            [self.navigationController popViewControllerAnimated:NO];
        }
        return;
    }
    [LeafNotification showInController:self withText:result[@"msg"]];
    
}

- (void)modifySucess
{
    switch (_personalType) {
        case McPersonalTypeSex:
            _personalData.sex = selectedStr;
            break;
        case McPersonalTypeHair:
            _personalData.hair = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:key]) {
                    selectedId = _plistDict[key];
                    break;
                }
            }
            break;
        case McPersonalTypeArea:
            _personalData.area = selectedStr;
            break;
        case McPersonalTypeJob:{
            _personalData.job = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:[_plistDict objectForKey:key]]) {
                    selectedId = key;
                    break;
                }
            }
        }
            break;
        case McPersonalTypeMajor:{
            _personalData.major = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:[_plistDict objectForKey:key]]) {
                    selectedId = key;
                    break;
                }
            }
        }
            break;
        case McPersonalTypeFoot:
            _personalData.feetCode = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:key]) {
                    selectedId = _plistDict[key];
                    break;
                }
            }
            break;
        default:
            break;
    }
}

- (void)loadBarButtonItem
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(modifyOtherAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;

}

- (void)modifyOtherAction:(id)sender
{
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    switch (_personalType){
        case McPersonalTypeSex:{
            if ([selectedStr isEqual:@"男"]) {
                [dict setValue:@"1" forKey:@"sex"];
            }
            else if ([selectedStr isEqual:@"女"]) {
                [dict setValue:@"2" forKey:@"sex"];
            }
            else{
                [dict setValue:@"0" forKey:@"sex"];
            }
            
        }
            break;
        
            
        default:
            break;
    }
    
    
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){
        [self modifyDoneAction:data];
    }failed:^(NSError *error){
        
    }];

}

#pragma mark load
- (void)loadDataWithFile
{
    switch (_personalType) {
        case McPersonalTypeSex:{
            self.navigationItem.title = @"性别";
            self.contentArray = @[@"男",@"女"];
            selectedStr = _personalData.sex;
        }
            break;
        case McPersonalTypeFoot:
        {
            self.navigationItem.title = @"脚码";
            self.plistDict = [ReadPlistFile readFeets];
            self.contentArray = [ReadPlistFile sortedArrayAscending:[self.plistDict allKeys]];
            selectedStr = _personalData.feetCode;
        }
            break;
        case McPersonalTypeHair:
        {
            self.navigationItem.title = @"头发";

            self.plistDict = [ReadPlistFile readHairs];
            self.contentArray = [ReadPlistFile sortedKeysFrom:self.plistDict];
            selectedStr = _personalData.hair;
        }
            break;
        case McPersonalTypeJob:
        {
            self.navigationItem.title = @"职业";
            
            self.plistDict = [ReadPlistFile readProfession];
            self.contentArray = [self.plistDict allValues];
            selectedStr = _personalData.job;
        }
            break;
            
        case McPersonalTypeMajor:
        {
            self.navigationItem.title = @"专业";
            
            self.plistDict = [ReadPlistFile readMajor];
            self.contentArray = [self.plistDict allValues];
            selectedStr = _personalData.major;
        }
            break;

        default:
            break;
    }
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"personalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSString *str = [self.contentArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = str;
    [cell.textLabel setFont:kFont16];
    [cell.textLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    if ([str isEqualToString:selectedStr]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    else{
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSString *text = @"";
    if (_personalType == McPersonalTypeSex) {
        text = @"一旦设置，不能修改，请谨慎选择";
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 20)];
    label.text = text;
    label.font = kFont14;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorForHex:kLikeLightRedColor];
    return label;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    selectedStr = [_contentArray objectAtIndex:indexPath.row];
    
    switch (_personalType) {
        case McPersonalTypeSex:
//            _personalData.sex = selectedStr;
            break;
        case McPersonalTypeHair:
//            _personalData.hair = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:key]) {
                    selectedId = _plistDict[key];
                    break;
                }
            }
            break;
        case McPersonalTypeArea:
//            _personalData.area = selectedStr;
            break;
        case McPersonalTypeJob:{
//            _personalData.job = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:[_plistDict objectForKey:key]]) {
                    selectedId = key;
                    break;
                }
            }
        }
            break;
        case McPersonalTypeMajor:{
//            _personalData.major = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:[_plistDict objectForKey:key]]) {
                    selectedId = key;
                    break;
                }
            }
        }
            break;
        case McPersonalTypeFoot:
//            _personalData.feetCode = selectedStr;
            for (NSString *key in [_plistDict allKeys]) {
                if ([selectedStr isEqualToString:key]) {
                    selectedId = _plistDict[key];
                    break;
                }
            }
            break;
        default:
            break;
    }
    [tableView reloadData];
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self modifyAction:nil];
}


@end
