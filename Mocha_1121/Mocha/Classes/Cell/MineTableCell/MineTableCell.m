//
//  MineTableCell.m
//  Mocha
//
//  Created by zhoushuai on 15/12/28.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "MineTableCell.h"

@implementation MineTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        //加载视图组件
        [self _initViews];
    }
    return self;
 }



//初始化视图组件
- (void)_initViews{
    _badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-57, 17, 20, 20)];
    [_badgeLabel setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    [_badgeLabel.layer setCornerRadius:10];
    [_badgeLabel.layer setMasksToBounds:YES];
    //设置其上文字的显示样式
    _badgeLabel.textAlignment = NSTextAlignmentCenter;
    _badgeLabel.textColor = [UIColor whiteColor];
    _badgeLabel.hidden  = YES;
    [_badgeLabel setAdjustsFontSizeToFitWidth:YES];
    [self.contentView addSubview:_badgeLabel];
    
    
    
    _redView = [[UIView alloc] initWithFrame:CGRectMake(kDeviceWidth-45, 22, 10, 10)];
    _redView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _redView.layer.cornerRadius = 5;
    _redView.clipsToBounds = YES;
    _redView.hidden = YES;
    [self.contentView addSubview:_redView];

    
}



//重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
 }


@end
