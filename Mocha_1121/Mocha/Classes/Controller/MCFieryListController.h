//
//  MCFieryListController.h
//  Mocha
//
//  Created by TanJian on 16/5/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseListViewController.h"

@interface MCFieryListController : McBaseViewController

@property(nonatomic , strong)UITableView *tableView;
@property(nonatomic , strong)UIViewController *superVC;
@property(nonatomic , copy)NSString *listType;

@end
