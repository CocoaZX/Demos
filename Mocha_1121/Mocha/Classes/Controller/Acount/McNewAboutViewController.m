//
//  McNewAboutViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/11/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McNewAboutViewController.h"
#import "McAboutViewController.h"
@interface McNewAboutViewController ()

@end

@implementation McNewAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于";
    //子标题数组
    _titileArr = @[@"MOKA介绍", @"给我评分",@"举报与投诉",@"用户协议"];

    self.tableView.scrollEnabled = NO;
    
    //重新设置taable的frame
    self.tableView.frame = CGRectMake(0, 0, kDeviceWidth, self.view.bounds.size.height - 64 -30);
    
    //设置多余部分无分割线
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    //底部标识
    UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kDeviceWidth, 20)];
    descriptionLabel.font = [UIFont systemFontOfSize:14];
    descriptionLabel.textColor =  [CommonUtils colorFromHexString:kLikeGrayColor];
    descriptionLabel.textAlignment = NSTextAlignmentCenter;
    descriptionLabel.text= @"北京模卡科技互动有限公司";
    [self.view addSubview:descriptionLabel];
}



#pragma mark UITableViewDelegate
//返回组个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _titileArr.count;
}
//单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"cellID";
    UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
        cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _titileArr[indexPath.row];
    return cell;
    
}


//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//组头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 25)];
    return label;
}

//组视图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

//点击单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {
            //模卡介绍
            McAboutViewController *detailWewbVC = [[McAboutViewController alloc] init];
            detailWewbVC.title = @"MOKA介绍";            detailWewbVC.webUrlString = @"http://www.mokacool.com/aboutapp";
            [self.navigationController pushViewController:detailWewbVC animated:YES];
            break;
        }
        case 1:
        {   //评分
            [self goToAppStore];
            break;
        }
        case 2:
        {
            //举报和投诉
            McAboutViewController *detailWewbVC = [[McAboutViewController alloc] init];
            detailWewbVC.webUrlString = @"http://www.moka.vc/agreement/complain";
            detailWewbVC.title = @"举报和投诉";
            [self.navigationController pushViewController:detailWewbVC animated:YES];
            break;

            break;
        }
        case 3:
        {
            //用户协议
            McAboutViewController *detailWewbVC = [[McAboutViewController alloc] init];
            detailWewbVC.webUrlString = @"http://www.moka.vc/user/protocol";
            detailWewbVC.title = @"用户协议";
            [self.navigationController pushViewController:detailWewbVC animated:YES];
            break;
        }

        default:
            break;
    }
}

//进入Appsgtore中
-(void)goToAppStore
{
    //int appID = 954184093;
    NSString *str = [NSString stringWithFormat:
                     @"http://itunes.apple.com/us/app/id954184093"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

@end
