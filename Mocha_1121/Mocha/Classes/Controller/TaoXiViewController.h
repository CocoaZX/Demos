//
//  TaoXiViewController.h
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "McBaseViewController.h"

@interface TaoXiViewController :McBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic , strong)NSMutableArray *dataSourceArr;

@property (nonatomic , copy)NSString *currentUid;

@property (weak, nonatomic) IBOutlet UIButton *bookBtn;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *liantianImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *connectWid;
@property (nonatomic,assign) BOOL isHotFeedsTaoxi;
@property(nonatomic,assign)BOOL isHomePage;


//数据源
@property (nonatomic , strong)NSDictionary *dic;

-(void)initWithDictionary:(NSDictionary *)dictionary;

-(void)initWithHotFeedsDictionary:(NSDictionary *)dictionary;

@end
