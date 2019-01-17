//
//  TaoXiThemeDescCell.m
//  Mocha
//
//  Created by zhoushuai on 16/4/1.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiThemeDescCell.h"

@implementation TaoXiThemeDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}


- (void)_initViews{
    //输入框
    _descTxtView = [[UITextView alloc] initWithFrame:CGRectMake(5, 0, kDeviceWidth - 5*2, self.height)];
    _descTxtView.font = [UIFont systemFontOfSize:16];
    [self.contentView addSubview:_descTxtView];
    
    //默认的提示
    _defaultTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 200, 30)];
    _defaultTxtLabel.text = @"请输入专题的描述";
    _defaultTxtLabel.font = [UIFont systemFontOfSize:15];
    _defaultTxtLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    _defaultTxtLabel.tag = 50;
    
    _descTxtView.returnKeyType = UIReturnKeyDone;
    [_descTxtView addSubview:_defaultTxtLabel];
    
    //底部线条

//    _bottomLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _descTxtView.bottom +1, kDeviceWidth -5*2, 1)];
//     _bottomLineLabel.backgroundColor =  [CommonUtils colorFromHexString:kLikeLightGrayColor];;
//    [self.contentView addSubview:_bottomLineLabel];

    
}


- (void)setDescTxt:(NSString *)descTxt{
    if (_descTxt != descTxt) {
        _descTxt = descTxt;
    }
    [self setNeedsLayout];
}



- (void)layoutSubviews{
    [super layoutSubviews];
    //设置文字
//    NSString *utf_8_desc  = @"";
//    @try {
//       utf_8_desc = [SQCStringUtils replaceUnicode:_descTxt];
//
//    }
//    @catch (NSException *exception) {
//        NSLog(@"错误：%@",exception);
//    }
//    @finally {
//        
//    }

    _descTxtView.text = _descTxt;
    
    //是否显示默认提示
    if (_descTxt.length == 0) {
        _defaultTxtLabel.hidden = NO;
    }else{
        _defaultTxtLabel.hidden = YES;
    }
    //高度
    //CGFloat themeDescHeight = [SQCStringUtils getCustomHeightWithText:_descTxt viewWidth:kDeviceWidth - 5*2 textSize:16]+8;
    
    //_descTxtView.frame = CGRectMake(5, 0, kDeviceWidth - 5*2, themeDescHeight +8);

    // _bottomLineLabel.frame = CGRectMake(5,self.contentView.bottom, kDeviceWidth - 5*2, 2);
    
    //输入文字
    _descTxtView.frame = CGRectMake(5, 0, kDeviceWidth - 5*2, 100);
    //_descTxtView.backgroundColor = [UIColor redColor];
    //_bottomLineLabel.frame = CGRectMake(5,_descTxtView.bottom +1, kDeviceWidth - 5*2, 1);
}




@end
