//
//  YuePaiPingLunTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/1/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YuePaiPingLunTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (assign, nonatomic) BOOL isJieShou;


- (void)setDataWithDic:(NSDictionary *)diction;

+ (YuePaiPingLunTableViewCell *)getYuePaiPingLunTableViewCell;







@end
