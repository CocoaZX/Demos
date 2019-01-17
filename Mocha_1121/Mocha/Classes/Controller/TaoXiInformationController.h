//
//  TaoXiInformationController.h
//  Mocha
//
//  Created by XIANPP on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoXiInformationController : UITableViewController

@property (nonatomic , assign)BOOL isCheck;

- (void)initWithDictionary:(NSDictionary *)dict;

- (void)setWithDic:(NSDictionary *)dic;

@end
