//
//  McTagStylesViewController.m
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McTagStylesViewController.h"

@interface McTagStylesViewController ()
{
    NSString *currentSelectedStr;
    NSMutableArray *currentArray;
}
@property (nonatomic, assign) NSInteger ctype;

@property (nonatomic, strong) NSDictionary *plistDict;

@property (nonatomic, strong) NSArray *contentArray;

@end

@implementation McTagStylesViewController

- (instancetype)initWithType:(int)type
{
    self = [super init];
    if (self) {
        self.ctype = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(searchPersonalData) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    currentArray = [NSMutableArray array];
    
    [self loadDataWithFile];
}


#pragma mark private
- (void)loadDataWithFile
{
    
    switch (_ctype) {
        
        case McFiltersTypeWorkTags:
        {
            self.navigationItem.title = @"工作标签";
            //path 读取当前程序定义好的文件
            NSString *path = [[NSBundle mainBundle] pathForResource:@"workTags" ofType:@"plist"];
            self.plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
            self.contentArray = [NSArray arrayWithArray:[_plistDict allValues]];
            
            NSArray *arr = [_filterData.workTags componentsSeparatedByString:@","];
            currentArray = [NSMutableArray arrayWithArray:arr];
            
        }
            break;
            
        case McFiltersTypeFigureTags:
        {
            self.navigationItem.title = @"形象标签";
            NSString *path = [[NSBundle mainBundle] pathForResource:@"workStyle" ofType:@"plist"];
            self.plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
            self.contentArray = [NSArray arrayWithArray:[_plistDict allValues]];
            
            NSArray *arr = [_filterData.figureTags componentsSeparatedByString:@","];
            currentArray = [NSMutableArray arrayWithArray:arr];
        }
            break;
        default:
            break;
    }
}

- (void)searchPersonalData
{
    NSMutableString *strId = [NSMutableString stringWithString:@""];
    NSMutableString *strMutable = [NSMutableString stringWithString:@""];
    if ([currentArray count] > 0) {
        for (NSString *value in currentArray) {
            if ([strMutable isEqualToString:@""]) {
                [strMutable appendString:value];
            }
            else {
                [strMutable appendFormat:@",%@",value];
            }
            
            NSString *key = [[_plistDict allKeysForObject:value] objectAtIndex:0];
            if ([strId isEqualToString:@""]) {
                [strId appendString:key];
            }
            else {
                [strId appendFormat:@",%@",key];
            }
        }
        
    }
    
    switch (_ctype){
        case McFiltersTypeWorkTags:{
            [_paramsDictionary setValue:strId forKey:@"worktags"];
            _filterData.workTags = strMutable;
        }
            break;
        case McFiltersTypeFigureTags:{
            [_paramsDictionary setValue:strId forKey:@"workstyle"];
            _filterData.figureTags = strMutable;
        }
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
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
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    for (NSString *value in currentArray) {
        if ([value isEqualToString:str]) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }
    
    return cell;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSString *value = [self.contentArray objectAtIndex:indexPath.row];
    
    for (NSString * selected in currentArray) {
        if ([selected isEqualToString:value]) {
            [currentArray removeObject:selected];
            [tableView reloadData];
            return;
        }
    }
    
    switch (_ctype) {
        case McFiltersTypeWorkTags:
            if([currentArray count] >= 5){
                
                [LeafNotification showInController:self withText:@"工作标签选择不能超过5个"];
                [tableView reloadData];
                return;
            }
            break;
        case McFiltersTypeFigureTags:
            if([currentArray count] >= 5){
                [LeafNotification showInController:self withText:@"形象标签选择不能超过5个"];
                [tableView reloadData];
                return;
            }
            break;
        default:
            break;
    }
    
    [currentArray addObject:value];
    [tableView reloadData];
    
    
}

@end
