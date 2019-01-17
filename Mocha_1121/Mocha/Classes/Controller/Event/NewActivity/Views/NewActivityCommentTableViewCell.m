 //
//  NewActivityCommentTableViewCell.m
//  Mocha
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewActivityCommentTableViewCell.h"

@implementation NewActivityCommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    //self.contentLabel.adjustsFontSizeToFitWidth = NO;
    
}


#pragma mark 设置数据源的方法
-(void)setDataDiction:(NSDictionary *)dataDiction{
    if (_dataDiction != dataDiction) {
        _dataDiction = dataDiction;
        [self setNeedsLayout];
    }
}



#pragma mark 视图布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    _leftPadding = 20;
    
    //头像
    self.headerImageView.frame = CGRectMake(_leftPadding, 10, 40, 40);
    _headerImageView.layer.cornerRadius = 20;
    _headerImageView.layer.masksToBounds = YES;
    NSString *urlString = [NSString stringWithFormat:@"%@%@",getSafeString(_dataDiction[@"head_pic"]),[CommonUtils imageStringWithWidth:kDeviceWidth/3 height:kDeviceWidth/3]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
    
    
    //昵称
    NSString *nameString = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"nickname"])];;
    float nameWidth = [SQCStringUtils getTxtLength:nameString font:15 limit:200];
    self.nameLabel.frame = CGRectMake(_headerImageView.right +10, 10, nameWidth, 20);
    self.nameLabel.text = nameString;
    
    //用户身份
    self.userTypeLabel.hidden = YES;
    //    NSString *user_type = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"user_type"])];
    //    float userWidth = [SQCStringUtils getTxtLength:user_type font:14 limit:200];
    //    self.userTypeLabel.frame = CGRectMake(self.nameLabel.right+10, 17, userWidth+10, 21);
    //    self.userTypeLabel.layer.cornerRadius = 3;
    //    self.userTypeLabel.layer.masksToBounds = YES;
    //    self.userTypeLabel.text = user_type;
    
    //时间
    self.timeLabel.frame = CGRectMake(_headerImageView.right + 10, _nameLabel.bottom, 100, 20);
    NSString *createline = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"createline"])];
    self.timeLabel.text = createline;
    
    //内容
    NSString *content = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"content"])];
    self.contentLabel.text = content;
    float contentWidth = kScreenWidth-(_headerImageView.right +10)  - _leftPadding;
    float contentHeight = [SQCStringUtils getStringHeight:self.contentLabel.text width:contentWidth font:15];
    self.contentLabel.frame = CGRectMake(_headerImageView.right +10, _headerImageView.bottom +8, contentWidth, contentHeight);
    
    
    self.replayButton.hidden =YES;
    /*
     //回复按钮
     self.replayButton.frame = CGRectMake(kScreenWidth-_leftPadding -50,self.contentLabel.frame.origin.y+self.contentLabel.frame.size.height-5, 50, 30);
     [self.replayButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
     */
    
    //vip标识
    NSString *vip = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"vip"])];
    if ([vip isEqualToString:@"1"]) {
        self.outsideVipImg.hidden = NO;
        self.outsideVipImg.center = CGPointMake(_headerImageView.right -5, _headerImageView.bottom -5);
    }else
    {
        self.outsideVipImg.hidden = YES;

    }
    
    //设置会员昵称颜色
    NSString *isMember = [NSString stringWithFormat:@"%@",getSafeString(_dataDiction[@"member"])];
    if ([isMember isEqualToString:@"1"]) {
        self.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeMemberNameColor];
    }else{
        self.nameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    }
    
    
    
    self.replayView.hidden = YES;
    /*
     //回复部分===============
     NSArray *replay = self.dataDiction[@"replies"];
     self.replayView.hidden = NO;
     self.replayButton.hidden = YES;
     if (replay.count>0) {
     CGFloat padding = 8;
     //取出第一条回复
     NSDictionary *replayDic = replay[0];
     self.replayView.hidden = NO;
     //回复人头像
     self.replay_headerImageView.frame = CGRectMake(padding, padding, 40, 40);
     self.replay_headerImageView.layer.cornerRadius = 20;
     self.replay_headerImageView.layer.masksToBounds = YES;
     NSString *urlString = [NSString stringWithFormat:@"%@%@",getSafeString(self.replayHeaderURL),[CommonUtils imageStringWithWidth:kDeviceWidth/3 height:kDeviceWidth/3]];
     [self.replay_headerImageView sd_setImageWithURL:[NSURL URLWithString:urlString]];
     
     //回复人昵称
     NSString *replaynameString = self.replayName;
     float replaynameWidth = [SQCStringUtils getTxtLength:replaynameString font:15 limit:200];
     self.replay_nameLabel.font = [UIFont systemFontOfSize:15];
     self.replay_nameLabel.frame = CGRectMake(self.replay_headerImageView.right +10, 12, replaynameWidth, 31);
     self.replay_nameLabel.text = self.replayName;
     
     //回复人身份
     NSString *replayuserString = self.replayUserType;
     float replayuserWidth = [SQCStringUtils getTxtLength:replayuserString font:14 limit:200];
     self.replay_userTypeLabel.frame = CGRectMake(self.replay_nameLabel.right+10, 17, replayuserWidth+10, 21);
     self.replay_userTypeLabel.layer.cornerRadius = 3;
     self.replay_userTypeLabel.text = replayuserString;
     
     //回复内容部分
     NSString *replaycontent = getSafeString(replayDic[@"content"]);
     NSString *vipIn = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"vip"])];
     float replayContentWidth = kScreenWidth-(_headerImageView.right +10)-(_replay_headerImageView.right +10) -_leftPadding - padding;
     float replayContentHeight = [SQCStringUtils getStringHeight:replaycontent width:replayContentWidth font:15];
     self.replay_content.frame = CGRectMake(_replay_headerImageView.right +10, 46, replayContentWidth, replayContentHeight);
     
     //replayView
     self.replayView.frame = CGRectMake(_headerImageView.right +10,self.contentLabel.bottom -5 +30, kScreenWidth-(_headerImageView.right +10) -_leftPadding, replayContentHeight+60);
     self.replay_content.text = replaycontent;
     
     //VIP标识
     if ([vipIn isEqualToString:@"1"]) {
     self.insideVipImg.hidden = NO;
     self.insideVipImg .center = CGPointMake(_replay_headerImageView.right -5, _replay_headerImageView.bottom -5);
     }else
     {
     self.insideVipImg.hidden = YES;
     }
     
     }else
     {
     self.replayView.hidden = YES;
     }
     
     NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
     if ([self.currentUid isEqualToString:uid]) {
     self.replayButton.hidden = NO;
     }else
     {
     self.replayButton.hidden = YES;
     }
     
     */
    
    
    //添加底部分割线
    if(_bottomLineView == nil){
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
        [self.contentView addSubview:_bottomLineView];
    }
    _bottomLineView.frame = CGRectMake(20, self.contentView.bottom-0.5, kDeviceWidth -20*2, 0.5);
    
}



- (void)setDataWithDiction:(NSDictionary *)diction{
    
}

/*
 //调整数据显示
 - (void)setDataWithDiction:(NSDictionary *)diction
 {
 //回复部分
 NSArray *replay = diction[@"replies"];
 if (replay.count>0) {
 NSDictionary *replayDic = replay[0];
 //        NSString *replayurlString = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"head_pic"])];
 //        NSString *replaynickname = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"nickname"])];
 //        NSString *replayuser_type = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"user_type"])];
 
 //回复人头像
 //[self.replay_headerImageView sd_setImageWithURL:[NSURL URLWithString:self.replayHeaderURL] placeholderImage:[UIImage imageNamed:@"unloadHead"]];
 //[self.headerImageView sd_setImageWithURL:[NSURL URLWithString:self.replayHeaderURL]];
 
 //回复人昵称
 self.replay_nameLabel.text = self.replayName;
 //回复人身份
 self.replay_userTypeLabel.text = self.replayUserType;
 //回复内容
 NSString *replaycontent = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"content"])];
 NSString *vipIn = [NSString stringWithFormat:@"%@",getSafeString(replayDic[@"vip"])];
 if ([vipIn isEqualToString:@"1"]) {
 self.insideVipImg.hidden = NO;
 }else
 {
 self.insideVipImg.hidden = YES;
 }
 self.replay_content.text = replaycontent;
 }
 }
 */




#pragma mark 事件处理方法
- (IBAction)replayMethod:(id)sender {
    NSString *commentid = [NSString stringWithFormat:@"%@",self.dataDiction[@"id"]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appearCommentView" object:nil userInfo:@{@"replay":@"1",@"commentid":commentid}];
    
}

//进入首次回复的
- (IBAction)gotoOnePage:(id)sender {
    NSString *userName = self.dataDiction[@"nickname"];
    NSString *uid = self.dataDiction[@"uid"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
}


- (IBAction)gotoTwoPage:(id)sender {
    NSString *userName = @"";
    NSString *uid = self.dataDiction[@"replies"][0][@"uid"];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;
    
    [self.supCon.navigationController pushViewController:newMyPage animated:YES];
    
}

#pragma mark 获取cell和cell高度
+ (NewActivityCommentTableViewCell *)getNewActivityCommentCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"NewActivityCommentTableViewCell" owner:nil options:nil];
    NewActivityCommentTableViewCell *cell = array[0];
    
    return cell;
    
}


+ (float)getHeightWithDiction:(NSDictionary *)diction
{
    float cellHeight = 0;
    CGFloat leftPadding = 20;
    //
    NSString *content = [NSString stringWithFormat:@"%@",diction[@"content"]];
    float contentWidth = kScreenWidth-(leftPadding +40 +10)  - leftPadding;
    float contentHeight = [SQCStringUtils getStringHeight:content width:contentWidth font:15];
    
    if(contentHeight<20)
    {
        cellHeight = 10 +40 +8 +20 +15;
    }else
    {
        cellHeight = 10 +40 +8 + contentHeight + 15;
    }
    
    /*
     //评论部分
     NSArray *replay = diction[@"replies"];
     if (replay.count>0) {
     NSArray *replay = diction[@"replies"];
     NSDictionary *replayDic = replay[0];
     NSString *replaycontent = [NSString stringWithFormat:@"%@",replayDic[@"content"]];
     float replayContentWidth = kScreenWidth-70-70;
     float replayContentHeight = [SQCStringUtils getStringHeight:replaycontent width:replayContentWidth font:15];
     float replayHeight = replayContentHeight+60;
     cellHeight = cellHeight+replayHeight+10;
     }
     */
    return cellHeight;
}

@end
