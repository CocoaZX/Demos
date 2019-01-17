//
//  NewFeedbackCellTwoTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "NewFeedbackCellTwoTableViewCell.h"

@implementation NewFeedbackCellTwoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.backView.layer.cornerRadius = 10.0;
    
    self.textView.delegate = self;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *titleString = @"";
    titleString =  @"说说看哪些功能反人类，小卡要去鞭打产品经理";
    
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
    }
    if (kScreenWidth==320) {
        //        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight);
        
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSString *titleString = @"";
    titleString =  @"说说看哪些功能反人类，小卡要去鞭打产品经理";
    
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if ([@"\n" isEqualToString:text] == YES) {
        if (kScreenWidth==320) {
            //            self.view.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight);
            
        }
        [self.textView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



+ (NewFeedbackCellTwoTableViewCell *)getNewFeedbackCellTwoTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewFeedbackCellTwoTableViewCell" owner:self options:nil];
    NewFeedbackCellTwoTableViewCell *cell = array[0];
    
    return cell;
    
}





@end
