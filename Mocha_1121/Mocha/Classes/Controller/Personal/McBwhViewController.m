//
//  McBwhViewController.m
//  Mocha
//
//  Created by renningning on 14-12-1.
//  Copyright (c) 2014年 renningning. All rights reserved.
//bwh即胸围bust、腰围waist、臀围hips三者的合称

#import "McBwhViewController.h"
#import "TextFieldTableViewCell.h"
#import "SQCStringUtils.h"

@interface McBwhViewController () <UITableViewDataSource,UITableViewDelegate>
{
    NSArray *placeholderArray;
    NSArray *bwhArray;
}

@property (nonatomic, strong) NSArray *contentArray;
@property (nonatomic, retain) UITableView *tableView;

@end

@implementation McBwhViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"三围";
    
    self.contentArray = @[@"胸围",@"腰围",@"臀围"];
    placeholderArray = @[@"请输入胸围",@"请输入腰围",@"请输入臀围"];
    
    bwhArray = @[_personalData.bust?_personalData.bust:@"",_personalData.waist?_personalData.waist:@"",_personalData.hips?_personalData.hips:@""];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(0.0f, 8.0f, 50.0f, 30.0f)];
    [button setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor clearColor];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [button addTarget:self action:@selector(modifyAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;

    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self.tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:_tableView];
    
    
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

#pragma mark Private
- (void)modifyAction:(id)sender
{
    NSString *bust = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]).textField.text;
    NSString *waist = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]]).textField.text;
    NSString *hips = ((TextFieldTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]]).textField.text;
    
    _personalData.bust = bust;
    _personalData.waist = waist;
    _personalData.hips = hips;
    _personalData.measurements = [NSString stringWithFormat:@"%@-%@-%@",bust,waist,hips];
    
    if (![self isPureWithString:bust]) {
        return;
    }
    if (![self isPureWithString:waist]) {
        return;
    }
    if (![self isPureWithString:hips]) {
        return;
    }
    
    if ([bust length] <= 0 || [waist length] <= 0 || [hips length] <= 0) {
        [LeafNotification showInController:self withText:@""];
        return;
    }
    
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    [dict setValue:bust forKey:@"bust"];
    [dict setValue:waist forKey:@"waist"];
    [dict setValue:hips forKey:@"hipline"];
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data){
        [self updatePasswordDoneAction:data];
    }failed:^(NSError *error){
        
    }];
}

- (void)updatePasswordDoneAction:(NSDictionary *)result
{
    [LeafNotification showInController:self withText:result[@"msg"]];
    if ([result[@"status"] intValue] == kRight) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
}

- (BOOL)isPureWithString:(NSString *)text
{
    if( ![SQCStringUtils isPureInt:text] || ![SQCStringUtils isPureFloat:text])
    {
        [LeafNotification showInController:self withText:@"警告:含非法字符，请输入纯数字！"];
        return NO;
    }
    if ([text floatValue] > 120 || [text floatValue] < 50) {
        [LeafNotification showInController:self withText:@"请看参考信息,需符合实际情况"];
        return NO;
    }
    
    return YES;
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"personalCell";
    TextFieldTableViewCell *cell = (TextFieldTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setTitleLabelHidden:NO];
    [cell setTitleText:[_contentArray objectAtIndex:indexPath.row]];
    [cell setValueWithPlaceholder:[placeholderArray objectAtIndex:indexPath.row]];
    [cell setDetailText:@"厘米"];
//    [cell setDetailLabelKeyboardType:UIKeyboardTypeNumberPad];
    cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    if ([bwhArray count] > 0) {
        NSString * str = [bwhArray objectAtIndex:indexPath.row];
        cell.textField.text = [str integerValue]>0 ?str:@"";
    }
    
    return cell;
}

//UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 60)];
    label.text = @"  加V后，三围不能修改，请慎重填写 \n  请看参考信息：三围一般为50-120厘米";
    label.font = kFont14;
//    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.textColor = [UIColor colorForHex:kLikeGrayColor];
    return label;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 60;
}


@end
