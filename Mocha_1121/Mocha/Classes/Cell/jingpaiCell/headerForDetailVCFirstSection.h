//
//  headerForDetailVCFirstSection.h
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJingpaiDetailModel.h"

@interface headerForDetailVCFirstSection : UIView
@property (weak, nonatomic) IBOutlet UILabel *jingpaiCount;
@property (weak, nonatomic) IBOutlet UILabel *jingpaiPrice;
@property (weak, nonatomic) IBOutlet UIButton *checkAllButton;

@property (nonatomic,strong)UIViewController *superVC;
@property (nonatomic,strong)MCJingpaiDetailModel *model;


-(void)setupUI:(MCJingpaiDetailModel *)model;

@end
