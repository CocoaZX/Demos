//
//  MCNewDongtaiCell.h
//  Mocha
//
//  Created by TanJian on 16/5/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McMyFeedListViewController.h"

@interface MCNewDongtaiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *hiddenLine;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIView *redLine;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UIView *longLine;
@property (weak, nonatomic) IBOutlet UIView *pointView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLabel;
@property (weak, nonatomic) IBOutlet UIImageView *commentImg;
@property (weak, nonatomic) IBOutlet UILabel *zanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *zanImg;
@property (weak, nonatomic) IBOutlet UIImageView *dynamicImgView;
@property (weak, nonatomic) IBOutlet UIImageView *tagImgView;
@property (weak, nonatomic) IBOutlet UIImageView *playImg;


//是否隐藏顶部的短线条
@property (nonatomic,assign) BOOL isHiddenLine;
@property (nonatomic,assign) NSInteger index;
@property (nonatomic,strong) UIViewController *superVC;

+(float)getNewDongtaiCellHeight:(NSDictionary *)dict;

-(void)setupNewDongtaiCellView:(NSDictionary *)dict;


@end






