//
//  MokaMyActivityController.m
//  Mocha
//
//  Created by zhoushuai on 16/3/4.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaMyActivityController.h"
#import "MokaMyActivityListViewController.h"

@interface MokaMyActivityController ()

//分页器
@property(nonatomic,strong)UISegmentedControl *segControl;
//选择索引
@property (nonatomic, assign) NSInteger selectedSegIndex;

//两个视图控制器==========
//我发布
@property (nonatomic,strong)MokaMyActivityListViewController *myPublishActivityListVc;
//我参加
@property (nonatomic,strong)MokaMyActivityListViewController *myJoinActivityListVc;

@end;


@implementation MokaMyActivityController
#pragma mark - 视图初始加载与生命周期控制
- (void)viewDidLoad{
    [super viewDidLoad];
    //选择类型
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //分页选择器
    _segControl = [[UISegmentedControl alloc] initWithItems:@[@"已报名",@"已发布"]];
    _segControl.frame = CGRectMake((kScreenWidth - 160)/2, 10.0, 160, 30.0);
    _segControl.selectedSegmentIndex = 0;
    self.selectedSegIndex = 0;
    _segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [_segControl addTarget:self action:@selector(doSelectSegment:) forControlEvents:UIControlEventValueChanged];
    _segControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segControl;
    
    //设置显示视图大小
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height = kScreenHeight  - kNavHeight;
    self.view.frame = viewFrame;
    
    //默认显示模特视图
    [self showViewControllerAtIndex:_segControl.selectedSegmentIndex];
    
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customTabBarController hidesTabBar:YES animated:NO];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.customTabBarController hidesTabBar:NO animated:NO];
}




#pragma mark 我发布和我加入的的视图控制器
- (MokaMyActivityListViewController *)myPublishActivityListVc{
    if (_myPublishActivityListVc == nil) {
        _myPublishActivityListVc = [[MokaMyActivityListViewController alloc] init];
        _myPublishActivityListVc.view.frame = self.view.bounds;
        _myPublishActivityListVc.activityType = @"myPublishActivityListVc";
        _myPublishActivityListVc.superNVC = self.navigationController;
    }
    return _myPublishActivityListVc;
}

- (MokaMyActivityListViewController *)myJoinActivityListVc{
    if (_myJoinActivityListVc == nil) {
        _myJoinActivityListVc = [[MokaMyActivityListViewController alloc] init];
        _myJoinActivityListVc.view.frame = self.view.bounds;
        _myJoinActivityListVc.activityType = @"myJoinActivityListVc";
        _myJoinActivityListVc.superNVC = self.navigationController;

    }
    return _myJoinActivityListVc;

}

#pragma mark 切换子视图
//选择视图
- (void)doSelectSegment:(UISegmentedControl *)segCtrl{
    
    [self showViewControllerAtIndex:segCtrl.selectedSegmentIndex];
    
}

//显示视图
- (void)showViewControllerAtIndex:(NSInteger)index
{
    self.selectedSegIndex = index;
    if (index == 0) {
        //显示我参加的活动
        [self.view addSubview:self.myJoinActivityListVc.view];
        self.myJoinActivityListVc.collectionView.scrollEnabled = YES;
        self.myPublishActivityListVc.collectionView.scrollEnabled = NO;
        
    }else if(index == 1){
        //显示我发布的活动
        [self.view addSubview:self.myPublishActivityListVc.view];
        self.myJoinActivityListVc.collectionView.scrollEnabled = NO;
        self.myPublishActivityListVc.collectionView.scrollEnabled = YES;
    }
}



@end
