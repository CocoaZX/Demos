//
//  BuildTaoXiViewController.h
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildTaoXiViewController : McBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//封面
@property (nonatomic , copy) NSString *coverId;

@property (nonatomic , copy) NSString *coverUrl;


//从哪个界面跳转而来
@property(nonatomic,copy)NSString *fromVCName;



//是否为修改，对应的状态是新建
@property (nonatomic , assign)BOOL isEdit;

-(void)initWithDictionary:(NSDictionary *)dictionary;

@end
