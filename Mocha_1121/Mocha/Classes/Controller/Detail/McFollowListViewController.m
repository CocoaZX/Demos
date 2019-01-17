//
//  McFollowListViewController.m
//  Mocha
//
//  Created by renningning on 14-11-24.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McFollowListViewController.h"

@interface McFollowListViewController ()

@end

@implementation McFollowListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

#pragma mark Request
- (void)requestGetCommitList
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    [dict setValue:uid forKey:@"uid"];
    NSDictionary *param = [AFParamFormat formatGetCommentListParams:dict];
    [AFNetwork getLikeList:param success:^(id data){
        
    }failed:^(NSError *error){
        
    }];
}

@end
