//
//  NewFeedbackCellThreeTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McNewFeedBackViewController.h"

@interface NewFeedbackCellThreeTableViewCell : UITableViewCell<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;

@property (weak, nonatomic) McNewFeedBackViewController *controller;

+ (NewFeedbackCellThreeTableViewCell *)getNewFeedbackCellThreeTableViewCell;



@end
