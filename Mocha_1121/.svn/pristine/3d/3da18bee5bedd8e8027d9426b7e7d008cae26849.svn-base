//
//  JuBaoPartThreeTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JuBaoPartThreeTableViewCell.h"

@implementation JuBaoPartThreeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.backView.layer.cornerRadius = 10.0f;
    self.contentTextfield.delegate = self;
    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self.controller resetFrame];

    NSString *titleString = @"";
    titleString =  @"填写内容详情......";
    
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
    titleString =  @"填写内容详情......";
    
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if ([@"\n" isEqualToString:text] == YES) {
        if (kScreenWidth==320) {
            //            self.view.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight);
            
        }
        [self.controller resetBackFrame];

        [self.contentTextfield resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.controller resetBackFrame];

    [textField resignFirstResponder];
    return YES;
}

- (NSString *)getContentString
{
    return getSafeString(self.contentTextfield.text);
}

+ (JuBaoPartThreeTableViewCell *)getJuBaoPartThreeTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"JuBaoPartThreeTableViewCell" owner:self options:nil];
    JuBaoPartThreeTableViewCell *cell = array[0];
    
    return cell;
}


@end
