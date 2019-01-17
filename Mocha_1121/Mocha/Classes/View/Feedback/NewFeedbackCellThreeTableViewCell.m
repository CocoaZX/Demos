//
//  NewFeedbackCellThreeTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "NewFeedbackCellThreeTableViewCell.h"

@implementation NewFeedbackCellThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.layer.cornerRadius = 10.0;
    
    self.inputTextfield.delegate = self;
    
}




+ (NewFeedbackCellThreeTableViewCell *)getNewFeedbackCellThreeTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewFeedbackCellThreeTableViewCell" owner:self options:nil];
    NewFeedbackCellThreeTableViewCell *cell = array[0];
    
    return cell;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.controller resetFrame];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self.controller resetBackFrame];

    return YES;
}

@end
