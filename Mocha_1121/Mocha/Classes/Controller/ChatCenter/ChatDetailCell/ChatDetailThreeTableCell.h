//
//  ChatDetailThreeTableCell.h
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailGroupViewController.h"

@interface ChatDetailThreeTableCell : UITableViewCell

@property (nonatomic,strong)UILabel *infoLabel;

@property (nonatomic,strong)UIView *memberView;

//数据
@property (nonatomic,strong)NSDictionary *dataDic;

//是否是群id
@property (nonatomic,strong)NSString *groupID;
//是否是群主
@property (nonatomic,assign)BOOL isOwner;
//成员
@property (nonatomic,strong)NSArray *memberArr;


@property (nonatomic,strong)ChatDetailGroupViewController *chatDetailGroupVC;

@end
