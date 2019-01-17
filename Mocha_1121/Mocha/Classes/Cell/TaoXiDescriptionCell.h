//
//  TaoXiDescriptionCell.h
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoXiDescriptionCell : UITableViewCell 
+(TaoXiDescriptionCell *)getTaoXiDescriptionCell;

@property (weak, nonatomic) IBOutlet UITextField *descriptionTextField;

@property (weak, nonatomic) IBOutlet UIImageView *forward;

@property (weak, nonatomic) IBOutlet UILabel *backLabel;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;

//底部分割线
@property(nonatomic,strong)UILabel *lineLabel;

@end

