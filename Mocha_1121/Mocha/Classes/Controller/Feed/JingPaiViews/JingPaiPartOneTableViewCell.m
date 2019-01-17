//
//  JingPaiPartOneTableViewCell.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JingPaiPartOneTableViewCell.h"

@implementation JingPaiPartOneTableViewCell

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
    self.contentTextView.layer.cornerRadius = 10.0;
    self.contentTextView.delegate = self;
}




- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *titleString = @"";
    titleString =  @"竞拍详情描述......";

    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
    }
    if (kScreenWidth==320) {
        //        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight);
        
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length>500) {
        
        [LeafNotification showInController:self.releaseController withText:@"最多输入500个字"];
        
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSString *titleString = @"";
    titleString =  @"竞拍详情描述......";

    if (textView.text.length>500) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        [LeafNotification showInController:self.releaseController withText:@"最多输入500个字"];

        return NO;
    }
    
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if ([@"\n" isEqualToString:text] == YES) {
        if (kScreenWidth==320) {
            //            self.view.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight);
            
        }
        [self.contentTextView resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}




+ (JingPaiPartOneTableViewCell *)getJingPaiPartOneTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JingPaiPartOneTableViewCell" owner:self options:nil];
    JingPaiPartOneTableViewCell *cell = array[0];

    return cell;
    
}

















@end
