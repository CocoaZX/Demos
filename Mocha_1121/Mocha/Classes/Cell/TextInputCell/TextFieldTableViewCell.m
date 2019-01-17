//
//  TextFieldTableViewCell.m
//  QuickPay
//
//  Created by renningning on 14-10-15.
//  Copyright (c) 2014年 lvjianxiong. All rights reserved.
//

#import "TextFieldTableViewCell.h"

@interface TextFieldTableViewCell()
{
    UIEdgeInsets labelEdgeInsets;
    
    float titleWidth;
    float detailWidth;
}

@end


@implementation TextFieldTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        labelEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 20);
        titleWidth = 100;
        detailWidth = 60;
        float width = kDeviceWidth;
        
        CGRect titleFrame = CGRectMake(labelEdgeInsets.left, labelEdgeInsets.top, titleWidth, self.contentView.frame.size.height - labelEdgeInsets.top - labelEdgeInsets.bottom);
        _titleLabel = [[UILabel alloc] initWithFrame:titleFrame];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = kFont16;
        _titleLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        [self.contentView addSubview:_titleLabel];
        
        CGRect detailFrame = CGRectMake(width - labelEdgeInsets.right - detailWidth, labelEdgeInsets.top, detailWidth, self.contentView.frame.size.height - labelEdgeInsets.top - labelEdgeInsets.bottom);
        _detailLabel = [[UILabel alloc] initWithFrame:detailFrame];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = kFont16;
        _detailLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_detailLabel];
        
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(labelEdgeInsets.left + titleWidth, 0, width - (labelEdgeInsets.left + titleWidth +labelEdgeInsets.right), self.contentView.frame.size.height)];
        
        [_textField setBackgroundColor:[UIColor clearColor]];
        [_textField setFont:kFont16];
        [_textField setTextColor:[UIColor colorForHex:kLikeBlackColor]];
        [self.contentView addSubview:_textField];
        
        [self.contentView setBackgroundColor:[UIColor clearColor]];
        [self setBackgroundColor:[UIColor whiteColor]];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)setTitleText:(NSString *)titleText
{
    _titleLabel.text = titleText;
}

- (void)setValueWithPlaceholder:(NSString *)placeholder{
    _textField.placeholder = placeholder;
    
}

- (void)setSecureTextEntry:(BOOL)entry;
{
    [_textField setSecureTextEntry:entry];
}

- (void)setDetailText:(NSString *)detail
{
    _detailLabel.text = detail;
}

- (void)setTitleLabelHidden:(BOOL)isHidden
{
    [_titleLabel setHidden:isHidden];
    
    CGRect titleFrame = CGRectMake(labelEdgeInsets.left, labelEdgeInsets.top, isHidden?0:titleWidth, self.contentView.frame.size.height - labelEdgeInsets.top - labelEdgeInsets.bottom);
    [_titleLabel setFrame:titleFrame];
    
    float plshX = _titleLabel.frame.size.width + _titleLabel.frame.origin.x;
    
    [_textField setFrame:CGRectMake(plshX, 0, kDeviceWidth - plshX - labelEdgeInsets.right - _detailLabel.frame.size.width, self.contentView.frame.size.height)];
}

- (void)setDetailLabelHidden:(BOOL)isHidden
{
    [_detailLabel setHidden:isHidden];
    CGRect detailFrame = CGRectMake(isHidden?kDeviceWidth:kDeviceWidth - labelEdgeInsets.right - detailWidth, labelEdgeInsets.top, isHidden?0:detailWidth, self.contentView.frame.size.height - labelEdgeInsets.top - labelEdgeInsets.bottom);
    CGRect fieldFrame = _textField.frame;
    [_detailLabel setFrame:detailFrame];
    float width = kDeviceWidth - (_titleLabel.frame.size.width + labelEdgeInsets.left + _detailLabel.frame.size.width + labelEdgeInsets.right);
    fieldFrame.size.width = width;
    _textField.frame = fieldFrame;
}

- (void)setLabelEdgeInsets:(UIEdgeInsets)edgeInsets
{
    labelEdgeInsets.left = edgeInsets.left;
    labelEdgeInsets.right = edgeInsets.right;
    labelEdgeInsets.top = edgeInsets.top;
    labelEdgeInsets.bottom = edgeInsets.bottom;
    
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.origin.x = labelEdgeInsets.left;
    _titleLabel.frame = titleFrame;
    
    CGRect detailFrame = _detailLabel.frame;
    detailFrame.origin.x = kDeviceWidth - labelEdgeInsets.right - detailWidth;
    _detailLabel.frame = detailFrame;
}

- (void)appendTitleWidth:(float)width
{
    titleWidth += width;
    
    CGRect titleFrame = _titleLabel.frame;
    titleFrame.size.width = titleWidth;
    _titleLabel.frame = titleFrame;
}

- (void)appendDetailWidth:(float)width
{
    detailWidth += width;
    
    CGRect detailFrame = _detailLabel.frame;
    detailFrame.size.width = detailWidth;
    _detailLabel.frame = detailFrame;
}

- (void)setDetailLabelKeyboardType:(UIKeyboardType)keyboardType
{
    _textField.keyboardType = UIKeyboardTypeNumberPad;
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

@end
