//
//  McProvinceViewController.m
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McProvinceViewController.h"

#import "JSONKit.h"
#import "McCitysViewController.h"
#import "ActivityFilterModel.h"

@interface McProvinceViewController ()
{
    NSString *selectedStr;
}

@property (nonatomic, strong) NSArray *contentArray;

@end

#define addString @"不限"

@implementation McProvinceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadDataWithFile];
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
    
    NSArray *areaArray = [textFilesStr objectFromJSONString];
    NSMutableArray *mutaArr = [NSMutableArray array];
//    if (_editOrSearch == 2) {
//        NSDictionary *addCict = @{@"id":@"0",@"name":@"不限",@"citys":@[]};
//        [mutaArr addObject:addCict];
//        
//    }
    if (self.isbuxian) {
        NSDictionary *addCict = @{@"id":@"0",@"name":@"不限",@"citys":@[]};
        [mutaArr addObject:addCict];
    }else
    {
       
        
    }
    
    [mutaArr addObjectsFromArray:areaArray];
    self.contentArray = mutaArr;
    NSLog(@"areaArray:%@",areaArray);
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"ProvinceCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.row];
    NSString *strPrivince = cityDict[@"name"];
    cell.textLabel.text = strPrivince;
    [cell.textLabel setFont:kFont16];
    [cell.textLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    
    if ([strPrivince isEqualToString:@"不限"]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        
    }
    else{
        
       [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *cityDict = [_contentArray objectAtIndex:indexPath.row];
    NSString *strPrivince = cityDict[@"name"];
    
    [ActivityDataModel sharedInstance].province = getSafeString([NSString stringWithFormat:@"%@",cityDict[@"id"]]);
    [ActivityFilterModel sharedInstance].filterProvince = getSafeString([NSString stringWithFormat:@"%@",cityDict[@"id"]]);
    selectedStr = strPrivince;
    
    //如果选择了不限
    if([strPrivince isEqualToString:@"不限"]){
        [_paramsDictionary setValue:@"" forKey:@"province"];
        [_paramsDictionary setValue:@"" forKey:@"city"];
        _filterData.area = strPrivince;
        //如果是从首页的搜索界面进入的就不需要设置block了
        if ([self.sourceVCName isEqualToString:@"homeVC_search"]) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        
        self.returenBlock(@"不限");
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (self.personalData) {
        _personalData.area = strPrivince;

    }
    
    if (_editOrSearch == 3) {
        _eventInfo.area = strPrivince;
    }
    
    
    McCitysViewController *citysVC = [[McCitysViewController alloc] init];
    if (self.personalData) {
        citysVC.personalData = _personalData;
        
    }
    citysVC.filterData = _filterData;
    citysVC.eventInfo = _eventInfo;
    
    //判断是否需要block块
    if ([self.sourceVCName isEqualToString:@"homeVC_search"]) {
    }else{
        citysVC.returenBlock = self.returenBlock;
    }
    citysVC.isbuxian = self.isbuxian;
    citysVC.sourceVCName = self.sourceVCName;
    
    citysVC.contentDictionnary = cityDict;
    citysVC.paramsDictionary = _paramsDictionary;
    citysVC.editOrSearch = _editOrSearch;
    [self.navigationController pushViewController:citysVC animated:YES];
    
    
    
}

- (void)setCallBack:(ChangeFinishBlock)block
{
    self.returenBlock = block;
    
}



@end
