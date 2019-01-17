//
//  McTrendViewController.m
//  Mocha
//
//  Created by renningning on 15-4-3.
//  Copyright (c) 2015年 renningning. All rights reserved.
//  动态

#import "McTrendViewController.h"

@interface McTrendViewController ()

@end

@implementation McTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"热门动态",@"关注动态"]];
    segControl.frame = CGRectMake((kScreenWidth - 160)/2, 24.0, 160, 30.0);
    segControl.selectedSegmentIndex = 0;//设置默认选择项索引
    segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    self.navigationItem.titleView = segControl;
    
    
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

@end
