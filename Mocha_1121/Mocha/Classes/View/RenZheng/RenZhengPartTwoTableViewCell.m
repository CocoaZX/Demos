//
//  RenZhengPartTwoTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "RenZhengPartTwoTableViewCell.h"

@implementation RenZhengPartTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _realnameTextfield.returnKeyType = UIReturnKeyDone;
    _idcardTextfield.returnKeyType = UIReturnKeyDone;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.realNameBackView.layer.cornerRadius = 10.0f;
    self.idcardBackView.layer.cornerRadius = 10.0f;
    
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    
    return YES;
}

+ (RenZhengPartTwoTableViewCell *)getRenZhengPartTwoTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RenZhengPartTwoTableViewCell" owner:self options:nil];
    RenZhengPartTwoTableViewCell *cell = array[0];
    return cell;
    
}


@end
