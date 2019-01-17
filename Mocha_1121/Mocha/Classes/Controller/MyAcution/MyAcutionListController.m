//
//  MyAcutionListController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MyAcutionListController.h"
#import "AcutionListController.h"
@interface MyAcutionListController ()

@property(nonatomic,assign)NSInteger selectedIndex;
//我参加的竞拍
@property(nonatomic,strong)AcutionListController *myJoinAcutionListVC;
//我发起的竞拍
@property(nonatomic,strong)AcutionListController *myPublishAcutionListVC;

@end


@implementation MyAcutionListController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MyAuction", nil);;
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    
    [self setViews];
    [self showViewControllerAtBtnTag:100];
    
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //[self.customTabBarController hidesTabBar:NO animated:NO];
}




#pragma mark - 事件点击
- (void)btnClick:(UIButton *)btn{
    CGFloat buttonWidth = 100;
    if (btn.tag == 100) {
        //执行消失动画
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //选择加入
            _btnBottomLabel.frame = CGRectMake(_chooseJoinButton.center.x -buttonWidth/2, _chooseJoinButton.bottom+2, buttonWidth, 2);
            [_chooseJoinButton setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
            [_choosePublishButton setTitleColor:[CommonUtils colorFromHexString:kLikeGrayTextColor] forState:UIControlStateNormal];

         } completion:^(BOOL finished) {
             
         }];
        [self showViewControllerAtBtnTag:btn.tag];

    }else if(btn.tag == 200){
        //执行消失动画
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            //选择发布
            _btnBottomLabel.frame = CGRectMake(_choosePublishButton.center.x -buttonWidth/2, _chooseJoinButton.bottom+2, buttonWidth, 2);
            [_chooseJoinButton setTitleColor:[CommonUtils colorFromHexString:kLikeGrayTextColor] forState:UIControlStateNormal];
            [_choosePublishButton setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
        }];
        [self showViewControllerAtBtnTag:btn.tag];
    }
}



//显示视图
- (void)showViewControllerAtBtnTag:(NSInteger)tag
{
     if (tag == 100) {
        //显示我参加的活动
        self.myJoinAcutionListVC.view.frame =CGRectMake(0, 60, kDeviceWidth, kDeviceHeight -kNavHeight - 60);
        [self.view addSubview:self.myJoinAcutionListVC.view];
        self.myJoinAcutionListVC.tableView.scrollEnabled = YES;
        self.myPublishAcutionListVC.tableView.scrollEnabled = NO;
        
    }else if(tag == 200){
        //显示我发布的活动
        self.myPublishAcutionListVC.view.frame =CGRectMake(0, 60, kDeviceWidth, kDeviceHeight -kNavHeight - 60);

        [self.view addSubview:self.myPublishAcutionListVC.view];
        self.myPublishAcutionListVC.tableView.scrollEnabled = YES;
        self.myJoinAcutionListVC.tableView.scrollEnabled = NO;
    }
}



#pragma mark - 辅助方法
- (void)setViews{
    //设置顶部选择按钮
    CGFloat buttonWidth = 100;
    CGFloat buttonPadding = 20;
    
    _topView.frame = CGRectMake(0, 0, kDeviceWidth, 50);
    //左侧按钮
    _chooseJoinButton.frame = CGRectMake((kDeviceWidth - buttonWidth *2- buttonPadding)/2, 10, buttonWidth, 25);
    [_chooseJoinButton setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
    [_chooseJoinButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    _chooseJoinButton.tag = 100;
    
    //中间分割线
    _centerLineLabel.frame = CGRectMake((kDeviceWidth -1)/2, 10, 1, 25);
    
    //右侧按钮
    _choosePublishButton.frame = CGRectMake(_chooseJoinButton.right +buttonPadding, 10, buttonWidth, 25);
    _choosePublishButton.tag = 200;
    [_choosePublishButton setTitleColor:[CommonUtils colorFromHexString:kLikeGrayTextColor] forState:UIControlStateNormal];
    [_choosePublishButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //按钮下面的线条
    _btnBottomLabel.frame = CGRectMake(_chooseJoinButton.center.x -buttonWidth/2, _chooseJoinButton.bottom +2, buttonWidth, 2);
    _btnBottomLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    //底部滑动线条不显示(需求改)
    _btnBottomLabel.hidden = YES;
}



#pragma mark - get/set
//我发布和我加入的的视图控制器
- (AcutionListController *)myJoinAcutionListVC{
    if (_myJoinAcutionListVC == nil) {
        _myJoinAcutionListVC = [[AcutionListController alloc] init];
        _myJoinAcutionListVC.acutionType = @"join";
        _myJoinAcutionListVC.superVC = self;
    }
    return _myJoinAcutionListVC;
}


- (AcutionListController *)myPublishAcutionListVC{
    if (_myPublishAcutionListVC == nil) {
        _myPublishAcutionListVC = [[AcutionListController alloc] init];
        _myPublishAcutionListVC.acutionType = @"publish";
        _myPublishAcutionListVC.superVC = self;
    }
    return _myPublishAcutionListVC;
}


@end
