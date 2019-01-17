//
//  MyAcutionListController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface MyAcutionListController : McBaseViewController
@property (weak, nonatomic) IBOutlet UIView *topView;

//顶部的两个按钮
@property (weak, nonatomic) IBOutlet UIButton *chooseJoinButton;
@property (weak, nonatomic) IBOutlet UIButton *choosePublishButton;
@property (weak, nonatomic) IBOutlet UILabel *centerLineLabel;

//选择下划线
@property (weak, nonatomic) IBOutlet UILabel *btnBottomLabel;

@end
