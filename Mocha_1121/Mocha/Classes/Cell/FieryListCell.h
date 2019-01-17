//
//  FieryListCell.h
//  Mocha
//
//  Created by TanJian on 16/5/26.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UIImageView *huoImg;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shenjiaWordsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *prizeImg;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIView *seprateline;


-(void)setupUIWithDict:(NSDictionary *)dict withTypeStr:(NSString *)type;

@end
