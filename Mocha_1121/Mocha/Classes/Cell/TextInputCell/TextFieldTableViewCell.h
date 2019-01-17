//
//  TextFieldTableViewCell.h
//  QuickPay
//
//  Created by renningning on 14-10-15.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldTableViewCell : UITableViewCell <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *detailLabel;

- (void)setTitleText:(NSString *)titleText;

- (void)setDetailText:(NSString *)detail;

- (void)setTitleLabelHidden:(BOOL)isHidden;

- (void)setDetailLabelHidden:(BOOL)isHidden;

- (void)setValueWithPlaceholder:(NSString *)placeholder;

- (void)setSecureTextEntry:(BOOL)entry;

- (void)setLabelEdgeInsets:(UIEdgeInsets)edgeInsets;

- (void)appendTitleWidth:(float)width;

- (void)appendDetailWidth:(float)width;

- (void)setDetailLabelKeyboardType:(UIKeyboardType)keyboardType;

@end
