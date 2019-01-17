//
//  recommendCell.h
//  Mocha
//
//  Created by TanJian on 16/5/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCMainFieryViewController.h"



@interface recommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIView *seprateLine;
@property (weak, nonatomic) IBOutlet UILabel *personGoodLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *yueButton;
@property (weak, nonatomic) IBOutlet UIButton *dashangButton;

@property (weak, nonatomic) IBOutlet UIImageView *oneGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *twoGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *threeGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *fourGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *fiveGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *sixGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *sevenGoodsImg;
@property (weak, nonatomic) IBOutlet UIImageView *eightGoodsImg;

@property (weak, nonatomic) IBOutlet UILabel *oneGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fiveGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightGoodsLabel;


@property (nonatomic,strong) MCMainFieryViewController *superVC;

+(float)getHeight;
-(void)setupUIWithDict:(NSDictionary *)dict;

@end







