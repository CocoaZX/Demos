//
//  SystemMessageTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 15/2/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemMessageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


//数据源
@property(nonatomic,strong)NSDictionary *dataDic;

+ (SystemMessageTableViewCell *)getSystemMessage;

@end
