//
//  McEditAreaViewController.m
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditAreaViewController.h"
#import "JSONKit.h"

@interface McEditAreaViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSString *selectedStr;
    NSString *selectedProvinceId;
    NSString *selectCityId;
}

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation McEditAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"地区";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
    [self loadDataWithFile];
    
    if (_editOrSearch == 1){
        selectedStr = _personalData.area;
    }else if(_editOrSearch == 2){
        selectedStr = _filterData.area;
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

#pragma mark load
- (void)loadDataWithFile
{
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
    NSString *textFilesStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    // If there are no results, something went wrong
    
    if (textFilesStr == nil) {
        
        // an error occurred
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
        
    }
    NSArray * areaArray = [textFilesStr objectFromJSONString];
//    selectedStr = _personalData.area;
    self.contentArray = areaArray;
    NSLog(@"areaArray:%@",areaArray);
}

- (void)saveArea
{
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    [dict setValue:selectedProvinceId forKey:@"province"];
    [dict setValue:selectCityId forKey:@"city"];
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){
        [self saveDataDone:data];
    }failed:^(NSError *error){
        
    }];
    
    
}

- (void)saveDataDone:(id)result
{
    [LeafNotification showInController:self withText:result[@"msg"]];
    if ([result[@"status"] integerValue] == kRight) {
        _personalData.area = selectedStr;
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"modify:%@",result);
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *cityDict = [_contentArray objectAtIndex:section];
    NSArray *arr = cityDict[@"citys"];
    return [arr count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
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
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.section];
    NSArray *arr = cityDict[@"citys"];
    NSString *strPrivince = cityDict[@"name"];
    NSString *strCity = [[arr objectAtIndex:indexPath.row] valueForKey:@"name"];
    NSString *str = [NSString stringWithFormat:@"%@%@",strPrivince,strCity];
    
    cell.textLabel.text = strCity;
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [[_contentArray objectAtIndex:section] valueForKey:@"name"];
}

//UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.section];
    NSArray *arr = cityDict[@"citys"];
    selectedProvinceId = cityDict[@"id"];
    NSString *strPrivince = cityDict[@"name"];
    NSString *strCity = [[arr objectAtIndex:indexPath.row] valueForKey:@"name"];
    selectedStr = [NSString stringWithFormat:@"%@%@",strPrivince,strCity];
    selectCityId = [arr objectAtIndex:indexPath.row][@"id"];
    
    [tableView reloadData];
   
//    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    if (_editOrSearch == 1) {
        [self saveArea];
    }
    else if (_editOrSearch == 2){
        _filterData.area = selectedStr;
        [_paramsDictionary setValue:selectedProvinceId forKey:@"province"];
        [_paramsDictionary setValue:selectCityId forKey:@"city"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_editOrSearch == 3){
        
        
    }
    

}

@end
