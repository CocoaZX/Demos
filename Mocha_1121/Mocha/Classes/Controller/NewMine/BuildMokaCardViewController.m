//
//  BuildMokaCardViewController.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BuildMokaCardViewController.h"
#import "BuildMokaTableViewCell.h"
#import "BuildDetailViewController.h"

@interface BuildMokaCardViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation BuildMokaCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    // Do any additional setup after loading the view from its nib.
    self.title = @"新建模卡";
    self.dataArray = @[@{@"image":@"jingdianshituback",@"type":@"4",@"name":@"新式 1+9(推荐)"},
                       @{@"image":@"newyijialiu",@"type":@"6",@"name":@"新式1+6(推荐)"},
                       @{@"image":@"newsanshangsanxia",@"type":@"9",@"name":@"新式6图(推荐)"},
                       @{@"image":@"jiugonggeback",@"type":@"3",@"name":@"9宫格"},
                       @{@"image":@"newyijiaba",@"type":@"7",@"name":@"新式1+8"},
                       @{@"image":@"xinshiwutuback",@"type":@"2",@"name":@"新式5图"},
                       @{@"image":@"jingdianwutyback",@"type":@"1",@"name":@"经典5图"},
                       @{@"image":@"newliutu",@"type":@"8",@"name":@"经典6图"},
                       @{@"image":@"newbatu",@"type":@"5",@"name":@"经典8图"},
                       @{@"image":@"xinshi4jia1",@"type":@"10",@"name":@"新式4加1"},
                       @{@"image":@"xinshi3jia1jia3",@"type":@"11",@"name":@"新式3加1加3"},
                       @{@"image":@"jianyueqitu",@"type":@"12",@"name":@"简约7图"},
                       @{@"image":@"jianyuewutu",@"type":@"13",@"name":@"简约5图"},
                       @{@"image":@"xinshi1jia4",@"type":@"14",@"name":@"新式1加4"},
                       ].mutableCopy;
    //去除tableview cell左侧的空白
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset: UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins: UIEdgeInsetsZero];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = kScreenWidth - 70;
    switch (indexPath.row) {
        case 0:
            height = 40;
            break;
        case 1:
            height = kScreenWidth - 40;//1+9
            break;
        case 4:
            height = kScreenWidth + 40;//九宫格
            break;
        case 9:
            height = kScreenWidth - 30;
            break;
        case 14:
            height = kScreenWidth - 70 - 25;
            break;
        default:
            break;
    }
    return height + 15;//加cell底部的灰条
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstStep"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstStep"];
        }
        cell.selectionStyle = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor colorWithRed:110/256.0 green:110/256.0 blue:110/256.0 alpha:0.1];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = @"第一步:选择一个模卡样式";
        cell.textLabel.textColor = [UIColor colorWithRed:110/256.0 green:110/256.0 blue:110/256.0 alpha:0.8];
        return cell;
    }
    BuildMokaTableViewCell *cell = nil;
    NSString *identifier = @"BuildMokaTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [BuildMokaTableViewCell getBuildMokaTableViewCellWith:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    float height = kScreenWidth - 70;
    switch (indexPath.row) {
        case 1://1+9
            height = kScreenWidth - 40;
            break;
        case 4://9宫格
            height = kScreenWidth + 40;
            break;
        case 9:
            height = kScreenWidth - 30;
            break;
        default:
            height = kScreenWidth - 70;
            break;
    }
    [cell initViewWithData:self.dataArray[indexPath.row - 1]];
    cell.backgroundImage.frame = CGRectMake(0, 0, kScreenWidth-0, height-40);
    cell.contentView.frame = CGRectMake(0, 0, kScreenWidth, height);
    if (indexPath.row == 14) {
        cell.grayView.hidden = YES;
    }else{
        cell.grayView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
//        if (uid) {
//            BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
//            if (!isBangDing) {
//                //显示绑定
//                [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
//                return;
//            }
//        }else{
//            //显示登陆
//            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
//            return;
//        }
    
    if ([self isFailForCheckLogInStatus]) {
        return;
    }
    
    
    if (indexPath.row != 0) {
    NSString *album_type = @"1"; // 1模特卡、2相册
    NSString *title = @"test";
    NSString *style = self.dataArray[indexPath.row - 1][@"type"]; //样式:0无（用于相册）,1五图经典,2新式五图,3经典九图,4经典十图,5八图,6一加六,7一加八,8六图,9上三下三
    NSString *description = @"testdescription";
    
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:@{@"album_type":album_type,@"style":style,@"title":title,@"description":description}];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [AFNetwork createAlbum:params success:^(id data){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            
            UserDefaultSetBool(YES, @"isHiddenTabbar");
            [USER_DEFAULT synchronize];
            
            BuildDetailViewController *newActivity = [[BuildDetailViewController alloc] initWithNibName:@"BuildDetailViewController" bundle:[NSBundle mainBundle]];
            newActivity.albumid = [NSString stringWithFormat:@"%@",data[@"data"][@"albumId"]];
//            newActivity.mokaType = [NSString stringWithFormat:@"%@",data[@"data"][@"style"]];
            newActivity.mokaType = [NSString stringWithFormat:@"%@",style];
//            newActivity.isEditing = NO;
            [self.navigationController pushViewController:newActivity animated:YES];
            
        }
        else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        
       [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
    }];
    }
    
}

@end
