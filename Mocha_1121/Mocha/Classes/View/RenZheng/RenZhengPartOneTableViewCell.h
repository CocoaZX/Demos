//
//  RenZhengPartOneTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RenZhengPartOneTableViewCell : UITableViewCell<UITextFieldDelegate,UIActionSheetDelegate>


@property (weak, nonatomic) IBOutlet UIView *modelBackView;
@property (weak, nonatomic) IBOutlet UIView *companyBackView;
@property (weak, nonatomic) IBOutlet UIView *inputbackView;

@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;

@property (assign, nonatomic) BOOL isCanTouchType;

@property (weak, nonatomic) IBOutlet UILabel *modelLabel;

@property (strong, nonatomic) NSArray *typeArray;

+ (RenZhengPartOneTableViewCell *)getRenZhengPartOneTableViewCell;


@end
