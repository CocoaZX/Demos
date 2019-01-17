//
//  AcutionListController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"

@interface AcutionListController : McBaseViewController

@property(nonatomic,strong)UITableView *tableView;

//竞拍类型
@property(nonatomic,copy)NSString *acutionType;

//所在视图控制器
@property(nonatomic,strong)UIViewController *superVC;



 
@end
