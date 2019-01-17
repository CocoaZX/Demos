//
//  HeaderView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)setViewWithViewModel:(PersonPageViewModel *)pViewModel
{
    self.pViewModel = pViewModel;
    
    self.followNumberLabel.text = pViewModel.followNumber;
    self.fansNumberLabel.text = pViewModel.fansNumber;
    self.numberLabelLabel.text = pViewModel.timeLineNumber;
    
    NSString *url = [pViewModel getCutHeaderURLWithView:self.headerImageView];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url?url:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
    self.nameLabel.text = pViewModel.headerName;
    self.tagsLabel.text = pViewModel.headerIntroduce;
    self.mokaNumber.text = pViewModel.mokaNumber;
    [self setFollow:pViewModel.isFollowed];
    
    if ([pViewModel.authentication integerValue] == 1) {
        _renzhengImageV.hidden = NO;
    }
    else{
        _renzhengImageV.hidden = YES;
    }
    
}

- (void)reSetFrame
{
    float headerHeight = 70;
    float itemWidthButton = kScreenWidth/4-3;
    
    
    self.headerImageView.frame = CGRectMake(14, 15, headerHeight, headerHeight);
    if (kScreenWidth==320) {
        self.headerBackImage.frame = CGRectMake(0, 0, kScreenWidth, 120);

    }else
    {
        self.headerBackImage.frame = CGRectMake(0, 0, kScreenWidth, 120);
        
        self.mokaBackButton.frame = CGRectMake(1, 91, itemWidthButton, 28);
        self.dongtaiButton.frame = CGRectMake(itemWidthButton+4, 91, itemWidthButton, 28);
        self.guanzhuButton.frame = CGRectMake(itemWidthButton*2+7, 91, itemWidthButton, 28);
        self.fansButton.frame = CGRectMake(itemWidthButton*3+10, 91, itemWidthButton, 28);
    }
    self.headerImageView.layer.cornerRadius = 5;
    float itemWidth = kScreenWidth/4;
    
    self.pictureNumberLabel.frame = CGRectMake(itemWidth/2-40, 95, 30, 21);
    self.pictureNameLabel.frame = CGRectMake(itemWidth/2-5, 95, 42, 21);
    self.numberLabelLabel.frame = CGRectMake(itemWidth/2-40+itemWidth, 95, 30, 21);
    self.labelNameLabel.frame = CGRectMake(itemWidth/2-5+itemWidth, 95, 42, 21);
    self.followNumberLabel.frame = CGRectMake(itemWidth/2-40+itemWidth*2, 95, 30, 21);
    self.followNameLabel.frame = CGRectMake(itemWidth/2-5+itemWidth*2, 95, 42, 21);
    self.fansNumberLabel.frame = CGRectMake(itemWidth/2-40+itemWidth*3, 95, 30, 21);
    self.fansNameLabel.frame = CGRectMake(itemWidth/2-5+itemWidth*3, 95, 42, 21);
    self.changPictureButton.frame = CGRectMake(0, 86, itemWidth, 30);
    self.changeLabelButton.frame = CGRectMake(itemWidth, 86, itemWidth, 30);
    self.changeFollowerButton.frame = CGRectMake(itemWidth*2, 86, itemWidth, 30);
    self.changeFansButton.frame = CGRectMake(itemWidth*3, 86, itemWidth, 30);
    
    
}

- (void)appearPersonalPageView
{
    self.tuijianButton.hidden = NO;
    self.followButton.hidden = YES;
    self.chatButton.hidden = YES;
}

- (void)appearFriendPageView
{
    self.followButton.hidden = NO;
    self.chatButton.hidden = NO;
    self.tuijianButton.hidden = YES;
}

- (void)setFollow:(BOOL)isFollowed
{
    if (isFollowed) {
        [self.followButton.layer setContentsScale:10];
        [self.followButton.layer setMasksToBounds:YES];
        [self.followButton setImage:nil forState:UIControlStateNormal];
        [self.followButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.followButton.titleLabel setFont:kFont14];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followButton setImage:[UIImage imageNamed:@"watchedButton"] forState:UIControlStateNormal];
        
        [self.followButton setEnabled:NO];
        
        
    }
    else {
        
        [self.followButton setBackgroundColor:[UIColor clearColor]];
        [self.followButton setImage:[UIImage imageNamed:@"watchButton"] forState:UIControlStateNormal];
        [self.followButton setEnabled:YES];
    }
}

/*  tag 说明
 1.关注
 2.推荐
 3.私聊
 4.照片
 5.标签
 6.关注
 7.粉丝
 */
- (IBAction)buttonClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(headerViewClick:)]) {
        [self.delegate headerViewClick:sender];
    }
    
}

- (void)hidenAllBackView
{
    self.mokaBackButton.hidden = YES;
    self.dongtaiButton.hidden = YES;
    self.guanzhuButton.hidden = YES;
    self.fansButton.hidden = YES;
    
}



+ (HeaderView *)getPersonalHeaderView
{
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    HeaderView *header = nibs[0];
    return header;
}


@end
