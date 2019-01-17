//
//  authenticationTableCell.m
//  Mocha
//
//  Created by zhoushuai on 16/5/25.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AuthenticationTableCell.h"

@implementation AuthenticationTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSDictionary *userDic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *authentication = [userDic objectForKey:@"authentication"];
    
     NSString *headerURL = [NSString stringWithFormat:@"%@%@",getSafeString(userDic[@"head_pic"]),[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
    
    NSString *name = [NSString stringWithFormat:@"%@",getSafeString(userDic[@"nickname"])];
    
    NSString *sex  = userDic[@"sex"];
    
    if ([sex isEqualToString:@"1"]) {
        sex = @"    男";
    }else{
        sex = @"    女";
    }
    
    //性别标识
//    if ([sex isEqualToString:@"男"]) {
//        self.sexImageView.image = [UIImage imageNamed:@"newmale"];
//    }else
//    {
//        self.sexImageView.image = [UIImage imageNamed:@"newfemale"];
//        
//    }
   // NSString *mote = [NSString stringWithFormat:@"%@",getSafeString(userDic[@"type"])];
    
    //头像
    //[self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerURL] placeholderImage:[UIImage imageNamed:@""]];

    //-1未认证， -2认证失败，0 审核中
    NSInteger authenticationNum = [authentication integerValue];
    
    switch (authenticationNum) {
        case -1://未认证
        {
            break;
        }
        case -2://认证失败
        {
            break;
        }
        case 0://审核中
        {
            break;
        }

        default:{
            
            break;
        }
    }

}


+ (AuthenticationTableCell *)getAuthenticationTableCell{

    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AuthenticationTableCell" owner:self options:nil];
    AuthenticationTableCell *cell = array[0];
    return cell;
}




@end
