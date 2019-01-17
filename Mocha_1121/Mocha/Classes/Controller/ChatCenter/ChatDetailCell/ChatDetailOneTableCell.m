//
//  ChatDetailOneTableCell.m
//  Mocha
//
//  Created by zhoushuai on 15/11/18.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "ChatDetailOneTableCell.h"


@implementation ChatDetailOneTableCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化组件
        [self _initViews];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}


- (void)awakeFromNib {
    // Initialization code
}


//创建视图
- (void)_initViews{
    //图片
    _imgView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imgView.hidden = YES;
    [self.contentView addSubview:_imgView];
    
    //大标题
    _titleLab  = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLab.font = [UIFont boldSystemFontOfSize:18];
    [self.contentView addSubview:_titleLab];
    
    //小标题
    _detailLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:_detailLab];
    
}

//set方法:设置数据
- (void)setHeaderPic:(NSString *)headerPic{
    if (_headerPic != headerPic) {
        _headerPic = headerPic;
        [self setNeedsLayout];
    }
}


//对视图进行重新布局
- (void)layoutSubviews{
    [super layoutSubviews];
    //群组 80
    if (!_isChatGroup) {
        _imgView.hidden = NO;
        _imgView.frame = CGRectMake(10, 10, 60, 60);
        
        UIImage *placeholderImage = [UIImage imageNamed:@"chatListCellHead"];
        NSString *headerURLString = [NSString stringWithFormat:@"%@%@",_headerPic,[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        [_imgView sd_setImageWithURL:[NSURL URLWithString:headerURLString] placeholderImage:placeholderImage];
        _titleLab.frame = CGRectMake(80, 10, 200, 30);
        _detailLab.frame = CGRectMake(80, 40, 200, 30);
        
    }else{//80
        _imgView.hidden = YES;
        _titleLab.frame = CGRectMake(10, 10, kDeviceWidth-10, 30);
        _detailLab.frame = CGRectMake(10, 40, kDeviceWidth-10, 30);
    }
}

@end

