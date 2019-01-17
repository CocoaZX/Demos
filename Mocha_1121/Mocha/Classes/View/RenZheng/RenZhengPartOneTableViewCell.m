//
//  RenZhengPartOneTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "RenZhengPartOneTableViewCell.h"

@implementation RenZhengPartOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.modelBackView.layer.cornerRadius = 10.0;
    self.companyBackView.layer.cornerRadius = 10.0;
    self.inputbackView.layer.cornerRadius = 10.0;
    self.inputTextfield.delegate = self;
    NSString *typeName = getSafeString([[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"typeName"]);
//    NSLog(@"%@",[USER_DEFAULT objectForKey:MOKA_USER_VALUE]);

    self.isCanTouchType = YES;

    if (typeName.length>0) {
        if ([typeName isEqualToString:@"(null)"]) {
        }else
        {
            self.modelLabel.text = typeName;
            self.isCanTouchType = NO;
        }
    }else
    {
    }

}


- (IBAction)modelChoseMethod:(id)sender {
    LOG_METHOD;
    if (self.isCanTouchType) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"模特",@"摄影师",@"化妆师",@"经纪人",@"其他", nil];
        [sheet showInView:self];
    }else
    {
        return;
    }
    

}


- (IBAction)companyChoseMethod:(id)sender {
    LOG_METHOD;
    return;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex<self.typeArray.count) {
        NSString *typeString = self.typeArray[buttonIndex];
        self.modelLabel.text = typeString;

    }
    
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

+ (RenZhengPartOneTableViewCell *)getRenZhengPartOneTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"RenZhengPartOneTableViewCell" owner:self options:nil];
    RenZhengPartOneTableViewCell *cell = array[0];
    cell.typeArray = @[@"模特",@"摄影师",@"化妆师",@"经纪人",@"其他"];
    return cell;

}



@end
