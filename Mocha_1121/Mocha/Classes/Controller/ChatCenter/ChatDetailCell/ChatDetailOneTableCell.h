//
//  ChatDetailOneTableCell.h
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatDetailOneTableCell : UITableViewCell


@property (nonatomic,strong)UIImageView *imgView;

@property (nonatomic,strong)UILabel *titleLab;

@property (nonatomic,strong)UILabel *detailLab;

//单元格类型
@property (nonatomic,assign)BOOL isChatGroup;


@property (nonatomic,strong)NSString *headerPic;

@end
