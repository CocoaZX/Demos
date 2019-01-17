//
//  XiangCeTableViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XiangCeTableViewCell : UITableViewCell

@property(nonatomic,weak)UIViewController *superVC;
@property(nonatomic,strong)NSArray *dataArray;

//是否是人
@property(nonatomic,assign)BOOL isMaster;
//当前id
@property(nonatomic,copy)NSString *currentUID;


+(CGFloat)getXiangCeTableViewCellHeight:(NSMutableArray *)array;

@end
