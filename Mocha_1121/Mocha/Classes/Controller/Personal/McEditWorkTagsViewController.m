//
//  McEditWorkTagsViewController.m
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McEditWorkTagsViewController.h"
#import "ReadPlistFile.h"

@interface McEditWorkTagsViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSString *selectedStr;
    NSMutableArray *currentArray;
}

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *plistDict;
@property (nonatomic, strong) NSMutableDictionary *selectDict;
@property (nonatomic, assign) McPersonalType personalType;

@end

@implementation McEditWorkTagsViewController

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
    self.contentArray = [NSArray array];
    self.plistDict = [NSDictionary dictionary];
    self.selectDict = [NSMutableDictionary dictionary];
    currentArray = [NSMutableArray array];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight) style:UITableViewStyleGrouped];//- kNavHeight
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    [self.view addSubview:_tableView];
    
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

#pragma mark private
- (void)loadDataWithFile
{
    //path 读取当前程序定义好的文件
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"workTags" ofType:@"plist"];
//    self.plistDict = [NSDictionary dictionaryWithContentsOfFile:path];
//    self.contentArray = [NSArray arrayWithArray:[_plistDict allValues]];

    switch (_personalType) {
        case McPersonalTypeWorkTags:
        {
            self.navigationItem.title = @"工作标签";
            
            self.plistDict = [ReadPlistFile readWorkTags];
            self.contentArray = [self.plistDict allValues];
            
            if ([_personalData.workLabel length] > 0) {
                NSArray *oldArrIds = [_personalData.workLabel componentsSeparatedByString:@" "];
                for (NSString *value in oldArrIds) {
                    if ([value length] > 0) {
                        [currentArray addObject:value];
                    }
                }
//                currentArray = [NSMutableArray arrayWithArray:oldArrIds];
            }
            
            
        }
            break;
            //McPersonalTypeWorkStyle
        case McPersonalTypeFigureTags:
        {
            self.navigationItem.title = @"形象标签";
            
            self.plistDict = [ReadPlistFile readWorkStyles];
            self.contentArray = [self.plistDict allValues];
           
            if ([_personalData.figureLabel length] > 0) {
                NSArray *oldArrIds = [_personalData.figureLabel componentsSeparatedByString:@" "];
                for (NSString *value in oldArrIds) {
                    if ([value length] > 0) {
                        [currentArray addObject:value];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
    
    
    
    
}

- (void)modifyAction:(id)sender
{
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    
    NSMutableString *strId = [NSMutableString stringWithString:@""];
    NSMutableString *strMutable = [NSMutableString stringWithString:@""];
    if ([currentArray count] > 0) {
        for (NSString *value in currentArray) {
            if ([strMutable isEqualToString:@""]) {
                [strMutable appendString:value];
            }
            else {
                [strMutable appendFormat:@" %@",value];
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
    selectedStr = strMutable;
    
    switch (_personalType){
        case McPersonalTypeWorkTags:{
            [dict setValue:strId forKey:@"worktags"];
            _personalData.workLabel = selectedStr;
        }
            break;
        case McPersonalTypeFigureTags:{
            [dict setValue:strId forKey:@"workstyle"];
            _personalData.figureLabel = selectedStr;
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
        [LeafNotification showInController:self withText:result[@"msg"]];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [LeafNotification showInController:self withText:result[@"msg"]];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

//UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SelectRowAtIndexPath");
    
    NSString *value = [self.contentArray objectAtIndex:indexPath.row];
    
    for (NSString * selected in currentArray) {
        if ([selected isEqualToString:value]) {
            [currentArray removeObject:selected];
            [tableView reloadData];
            
            return;
        }
    }
    
    switch (_personalType) {
        case McPersonalTypeWorkTags:
            if([currentArray count] >= 7){
                
                [LeafNotification showInController:self withText:@"工作标签选择不能超过7个"];
                [tableView reloadData];
                return;
            }
            break;
        case McPersonalTypeFigureTags:
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
