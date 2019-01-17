//
//  ChatDeleteTableViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/1/4.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDeleteMemberController.h"
@interface ChatDeleteTableViewCell : UITableViewCell

//选择按钮
@property (nonatomic,strong)UIImageView *checkImgView;

//头像
@property (nonatomic,strong)UIImageView *imgView;
//用户名
@property (nonatomic,strong)UILabel *titleLab;


//资源信息
@property (nonatomic,strong)NSDictionary *dataDic;
//用户的id
@property (nonatomic,copy)NSString *userID;

//所在的视图控制器
@property (nonatomic,strong)ChatDeleteMemberController *sourceVC;
@end
