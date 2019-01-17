//
//  DetailVCPraiseCell.h
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVCPraiseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *praiseCountLabel;

@property (nonatomic,strong) UIViewController *superVC;

-(void)setupUI:(NSArray *)array;

+(float)getHeightWithArr:(NSArray *)array;

@end
