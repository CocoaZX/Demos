//
//  TaoXiThemeDescCell.h
//  Mocha
//
//  Created by zhoushuai on 16/4/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaoXiThemeDescCell : UITableViewCell

//默认文字提示
@property(nonatomic,strong)UILabel *defaultTxtLabel;

//输入框
@property (nonatomic, strong) UITextView *descTxtView;
//专题描述
@property (nonatomic,copy)NSString *descTxt;


//底部输入提示线条
@property(nonatomic,strong)UILabel *bottomLineLabel;

@end
