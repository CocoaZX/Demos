//
//  NewRenZhengPartOneTableViewCell.h
//  Mocha
//
//  Created by zhoushuai on 16/5/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewRenZhengPartOneTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

//所在组织机构的名称
@property (weak, nonatomic) IBOutlet UITextField *organizationTextField;


+ (NewRenZhengPartOneTableViewCell *)getNewRenZhengPartOneTableViewCell;


@end
