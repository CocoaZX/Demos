/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */


#import "ChatListCell.h"
#import "UIImageView+EMWebCache.h"

@interface ChatListCell (){
    UILabel *_timeLabel;
    UILabel *_unreadLabel;
    UILabel *_detailLabel;
    UIView *_lineView;
}

@end

@implementation ChatListCell

#pragma mark - 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //时间
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth-90, 7, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor =  [UIColor lightGrayColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
        
        //未读
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, 20, 20)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 10;
        _unreadLabel.clipsToBounds = YES;
        [self.contentView addSubview:_unreadLabel];
        
        //昵称
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        //详情
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 32, kScreenWidth-75, 25)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:15];
        _detailLabel.textColor = [UIColor lightGrayColor];
        //_detailLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_detailLabel];
        
        //底部分割线
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
        _lineView.backgroundColor = COLOR(207, 210, 213);
        [self.contentView addSubview:_lineView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}


#pragma mark - set方法
-(void)setName:(NSString *)name{
    if(_name != name){
        _name = name;
    }
    [self setNeedsLayout];
   // self.textLabel.text = name;
}

- (void)setDetailMsg:(NSString *)detailMsg{
    if(_detailMsg != detailMsg){
        _detailMsg = detailMsg;
    }
    [self setNeedsLayout];
}


- (void)setImgUrlString:(NSString *)imgUrlString{
    self.imageView.image = nil;
    if (_imgUrlString != imgUrlString) {
        _imgUrlString = imgUrlString;
    }
    [self layoutSubviews];
}



#pragma mark - 布局

-(void)layoutSubviews{
    [super layoutSubviews];

    //头像
    self.imageView.frame = CGRectMake(10, 7, 55, 55);
    if(_isQunLiao){
        self.imageView.image = [UIImage imageNamed:@"groupPublicHeader"];
    }else{
        NSString *completeImgURLString = [NSString stringWithFormat:@"%@%@",_imgUrlString,[CommonUtils imageStringWithWidth:kDeviceWidth/2 height:kDeviceWidth/2]];
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:completeImgURLString] placeholderImage:_placeholderImage];
    }
    CGRect frame = self.imageView.frame;


    //name
    self.textLabel.frame = CGRectMake(75, 7, kScreenWidth-75, 25);
    self.textLabel.text = _name;
    self.textLabel.adjustsFontSizeToFitWidth = YES;

    //时间
    _timeLabel.frame = CGRectMake(kScreenWidth-90, 7, 80, 16);
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    
    //未读
    if (_unreadCount > 0) {
        //设置未读数
        _unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)_unreadCount];
        
        if (_unreadCount < 9) {
            _unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            _unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            _unreadLabel.font = [UIFont systemFontOfSize:10];
            _unreadLabel.text = @"99+";
        }
        [_unreadLabel setHidden:NO];
        [self.contentView bringSubviewToFront:_unreadLabel];
    }else{
        [_unreadLabel setHidden:YES];
    }
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height -1;
    _lineView.frame = frame;
}



#pragma mark - 返回单元格高度
+(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
