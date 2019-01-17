//
//  MyMokaCardViewController.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "MyMokaCardViewController.h"
#import "MyMokaTableViewCell.h"
#import "BuildMokaCardViewController.h"


@interface MyMokaCardViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;



@property (weak, nonatomic) IBOutlet UIButton *buildMoka;


@end

@implementation MyMokaCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.dataArray = @[].mutableCopy;
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }
    
    self.tableView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableState) name:@"refreshTableState" object:nil];
}

- (void)refreshTableState
{
    [self requestMyMokaData];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if ([uid isEqualToString:self.currentUid]) {
        self.title = @"我的模卡";
        self.buildMoka.hidden = NO;
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-54);
        self.buildMoka.frame = CGRectMake(10, kScreenHeight-44-74, kScreenWidth-20, 44);

    }else
    {
        self.title = [NSString stringWithFormat:@"%@的模卡",self.currentTitle];
        self.buildMoka.hidden = YES;
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);

    }
    [self requestMyMokaData];

}

- (IBAction)buildNewMoka:(id)sender {
    NSLog(@"buildNewMoka");
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    BuildMokaCardViewController *build = [[BuildMokaCardViewController alloc] initWithNibName:@"BuildMokaCardViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:build animated:YES];
    
}

- (void)requestMyMokaData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *cuid = self.currentUid;
    
    
    NSDictionary *params = [AFParamFormat formatGetUserMokaListParams:cuid];
    [AFNetwork getMokaList:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([data[@"status"] integerValue] == kRight) {
            NSArray *dataArr = data[@"data"];
            self.dataArray = [NSMutableArray arrayWithArray:dataArr];
            [self. tableView reloadData];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];

       [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = 373;
    NSDictionary *diction = self.dataArray[indexPath.row];
    NSString *style = [NSString stringWithFormat:@"%@",diction[@"style"]];
    int indexP = [style intValue];
    switch (indexP) {
        case 1:
            height = kScreenWidth-60;
            break;
        case 2:
            height = kScreenWidth-60;
            break;
        case 3:
            height = kScreenWidth+30;
            break;
        case 4:
            height = kScreenWidth-30;
            break;
        default:
            break;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMokaTableViewCell *cell = nil;
    NSString *identifier = @"MyMokaTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MyMokaTableViewCell getMyMokaTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    float height = 360;
    
    NSDictionary *diction = self.dataArray[indexPath.row];
    NSString *style = [NSString stringWithFormat:@"%@",diction[@"style"]];
    int indexP = [style intValue];
    switch (indexP) {
        case 1:
            height = kScreenWidth-100;
            break;
        case 2:
            height = kScreenWidth-100;
            break;
        case 3:
            height = kScreenWidth-5;
            break;
        case 4:
            height = kScreenWidth-70;
            break;
        default:
            break;
    }
    cell.supCon = self;
    cell.currentUid = self.currentUid;
    cell.cardView.frame = CGRectMake(0, 0, kScreenWidth-20, height);

    [cell initViewWithData:self.dataArray[indexPath.row]];
    
    return cell;
}
//#pragma mark tableViewDelegate
//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 20)];
//    grayView.backgroundColor = [UIColor colorForHex:kLikeGrayColor];
//    return grayView;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    return 20;
//}



@end
