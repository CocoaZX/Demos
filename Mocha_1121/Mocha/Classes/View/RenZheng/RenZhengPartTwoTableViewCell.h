//
//  RenZhengPartTwoTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenZhengPartTwoTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *realNameBackView;

@property (weak, nonatomic) IBOutlet UITextField *realnameTextfield;

@property (weak, nonatomic) IBOutlet UIView *idcardBackView;

@property (weak, nonatomic) IBOutlet UITextField *idcardTextfield;



+ (RenZhengPartTwoTableViewCell *)getRenZhengPartTwoTableViewCell;




@end
