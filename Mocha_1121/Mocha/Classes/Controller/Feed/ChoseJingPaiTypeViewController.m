//
//  ChoseJingPaiTypeViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ChoseJingPaiTypeViewController.h"
#import "ChoseJingPaiTypeTableViewCell.h"
#import "McWebViewController.h"


@interface ChoseJingPaiTypeViewController ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *statusArray;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation ChoseJingPaiTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞拍类型";
    self.statusArray = @[].mutableCopy;
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSArray *dataARr = descriptionDic[@"auction_type"];
    self.dataArray = dataARr.mutableCopy;
    for (int i=0; i<self.dataArray.count; i++) {
        [self.statusArray addObject:@"0"];
    }
    self.mainTableView.backgroundColor = NewbackgroundColor;

    //导航栏上的搜索功能
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"jingpai_info"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(doJumpInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

}


- (void)doJumpInfoVC:(UIButton *)sender
{
    LOG_METHOD;
    NSDictionary *dict = [USER_DEFAULT valueForKey:@"webUrlsDic"];
    NSString *urlString = getSafeString(dict[@"auction_rule"]);
    McWebViewController *webVC = [[McWebViewController alloc] init];
    webVC.webUrlString = urlString;
    webVC.needAppear = YES;
    webVC.title = @"发布竞拍";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)setTypeBlock:(ChangeJingPaiType)block
{
    self.blockBack = block;
    
}



#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoseJingPaiTypeTableViewCell *cell = nil;
    NSString *identifier = @"ChoseJingPaiTypeTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [ChoseJingPaiTypeTableViewCell getChoseJingPaiTypeTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    NSDictionary *diction = self.dataArray[indexPath.row];
    cell.titleLabel.text = getSafeString(diction[@"auction_type_name"]);
    NSString *status = self.statusArray[indexPath.row];
    if ([status isEqualToString:@"0"]) {
        cell.redRightImageView.hidden = YES;
    }else
    {
        cell.redRightImageView.hidden = NO;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    for (int i=0; i<self.statusArray.count; i++) {
        [self.statusArray replaceObjectAtIndex:i withObject:@"0"];

    }
    NSString *status = self.statusArray[indexPath.row];
    if ([status isEqualToString:@"0"]) {
        status = @"1";
    }else
    {
        status = @"0";
    }
    [self.statusArray replaceObjectAtIndex:indexPath.row withObject:status];
    [tableView reloadData];

    self.blockBack(self.dataArray[indexPath.row]);
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
