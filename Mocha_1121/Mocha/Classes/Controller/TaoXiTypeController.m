//
//  TaoXiTypeController.m
//  Mocha
//
//  Created by XIANPP on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiTypeController.h"

@interface TaoXiTypeController ()
@property (nonatomic , strong)NSArray *dataSource;
@end

@implementation TaoXiTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.navigationItem.title = @"专题分类";
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = rightItem;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = view;
    self.tableView.scrollEnabled = NO;
}

- (void)doBackAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"typeCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"typeCell"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    NSDictionary *dic = self.dataSource[indexPath.row];
    cell.textLabel.text = getSafeString(dic[@"value"]);
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    headerView.backgroundColor = [CommonUtils colorFromHexString:kLikeGrayReleaseColor];
    UILabel *label = [[UILabel alloc]initWithFrame:headerView.bounds];
    label.text = @"  准确的分类可以更好的推荐给相关顾客";
    label.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:label];
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"taoxiTypeChose" object:self.dataSource[indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        NSDictionary *langDic = [USER_DEFAULT objectForKey:@"lang_description"];
        NSArray *cameraArr = langDic[@"camera_set"];
        _dataSource = [NSArray arrayWithArray:cameraArr];
    }
    return _dataSource;
}


@end
