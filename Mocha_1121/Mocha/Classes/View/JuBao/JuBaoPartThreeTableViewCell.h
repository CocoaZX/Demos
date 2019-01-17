//
//  JuBaoPartThreeTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCJuBaoViewController.h"
@interface JuBaoPartThreeTableViewCell : UITableViewCell<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextfield;



@property (weak, nonatomic) MCJuBaoViewController *controller;

- (NSString *)getContentString;

+ (JuBaoPartThreeTableViewCell *)getJuBaoPartThreeTableViewCell;



@end
