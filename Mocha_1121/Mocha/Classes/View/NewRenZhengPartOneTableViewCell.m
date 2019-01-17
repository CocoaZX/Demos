//
//  NewRenZhengPartOneTableViewCell.m
//  Mocha
//
//  Created by zhoushuai on 16/5/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "NewRenZhengPartOneTableViewCell.h"

@implementation NewRenZhengPartOneTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _alertLabel.adjustsFontSizeToFitWidth = YES;
    _organizationTextField.returnKeyType = UIReturnKeyDone;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - 获取视图
+ (NewRenZhengPartOneTableViewCell *)getNewRenZhengPartOneTableViewCell{
    NewRenZhengPartOneTableViewCell *cell;
    
    @try {
        //加载nib
         cell = [[[NSBundle mainBundle] loadNibNamed:@"NewRenZhengPartOneTableViewCell" owner:nil options:nil] lastObject];
    }
    @catch (NSException *exception) {
        NSLog(@"错误：%@",exception);
    }
    @finally {
        
    }

    return cell;

}


@end
