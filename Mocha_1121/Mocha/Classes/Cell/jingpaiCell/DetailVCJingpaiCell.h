//
//  DetailVCJingpaiCell.h
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiDetailModel.h"

@interface DetailVCJingpaiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *profitLabel;
@property (weak, nonatomic) IBOutlet UIImageView *winImageView;
@property (nonatomic ,strong)MCJingpaiDetailModel *model;

@property (nonatomic,strong) UIViewController *superVC;
@property (nonatomic,copy) NSString *auctorID;

-(void)setupUI:(NSDictionary *)dict;

@end
