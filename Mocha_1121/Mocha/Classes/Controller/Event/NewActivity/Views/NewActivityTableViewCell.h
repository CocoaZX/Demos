//
//  NewActivityTableViewCell.h
//  Mocha
//
//  Created by sun on 15/8/19.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewActivityTableViewCell : UITableViewCell
{
    NSDictionary *roleTypeDict;
    NSArray *allAreaInfoArray;

}
@property (weak, nonatomic) IBOutlet UIView *baomingView;

@property (weak, nonatomic) IBOutlet UILabel *shenfenLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UIImageView *renzheng;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *activityDesc;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *peopleNumber;

@property (weak, nonatomic) IBOutlet UILabel *moneyPerDay;

@property (weak, nonatomic) IBOutlet UILabel *limitPeople;

@property (weak, nonatomic) IBOutlet UILabel *zhiyeLabel;

@property (weak, nonatomic) IBOutlet UILabel *mianshiLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexLabel;




- (void)setCelldataWithDiction:(NSDictionary *)diction;


+ (NewActivityTableViewCell *)getNewActivityCell;


@end
