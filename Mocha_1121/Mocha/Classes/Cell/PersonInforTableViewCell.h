//
//  PersonInforTableViewCell.h
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonInforTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fengeLineLabel;




@property (weak, nonatomic) UIViewController *supCon;



+(PersonInforTableViewCell *)getPersonInforTableViewCell;

- (void)initWithDictionary:(NSDictionary *)dictionary;

@end
