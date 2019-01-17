//
//  authenticationTableCell.h
//  Mocha
//
//  Created by zhoushuai on 16/5/25.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthenticationTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

@property (weak, nonatomic) IBOutlet UIImageView *renzhengImgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sexLabel;

@property (weak, nonatomic) IBOutlet UILabel *sexTxtLabel;


@property (weak, nonatomic) IBOutlet UILabel *checkStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkDescLabel;

+ (AuthenticationTableCell *)getAuthenticationTableCell;

@end
