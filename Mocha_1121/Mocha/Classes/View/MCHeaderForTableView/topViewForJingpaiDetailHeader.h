//
//  topViewForJingpaiDetailHeader.h
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiDetailModel.h"

@interface topViewForJingpaiDetailHeader : UIView
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *browseCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *remainTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiStatus;
@property (weak, nonatomic) IBOutlet UILabel *userType;
@property (weak, nonatomic) IBOutlet UIImageView *memberImage;

@property (nonatomic,strong) MCJingpaiDetailModel *model;
@property (nonatomic,strong) UIViewController *superVC;

-(void)setupUI:(MCJingpaiDetailModel *)model;

@end
