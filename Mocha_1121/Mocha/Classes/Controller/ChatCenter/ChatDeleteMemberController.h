//
//  ChatDeleteMemberController.h
//  Mocha
//
//  Created by zhoushuai on 16/1/4.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"
@interface ChatDeleteMemberController :McBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
//数据
@property (nonatomic,strong)NSDictionary *dataDic;
//成员
@property (nonatomic,strong)NSMutableArray *members;
//要删除的id;
@property (nonatomic,strong)NSMutableArray *deleteMemberIds;
@end
