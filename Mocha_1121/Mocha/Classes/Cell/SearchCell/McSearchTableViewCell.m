//
//  McSearchTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-12-13.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McSearchTableViewCell.h"

@interface McSearchTableViewCell()
{
    
    UIImageView *leftImageView;
    UILabel *leftUserLabel;
    UILabel *leftDescLabel;
    UIButton *leftBtn;
    
    UIImageView *rightImageView;
    UILabel *rightUserLabel;
    UILabel *rightDescLabel;
    UIButton *rightBtn;
}

@property (nonatomic,retain) NSDictionary *leftDict;
@property (nonatomic,retain) NSDictionary *rightDict;

@end

#define edgeX  10
#define edgeY  10

@implementation McSearchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        [self setBackgroundColor:[UIColor clearColor]];
        [self loadSubViews];
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadSubViews
{
    NSLog(@"%f,%f",kDeviceWidth,self.contentView.frame.size.width);
    float bgWid = (kDeviceWidth - edgeX * 3)/2;
    float bghei = bgWid;
    
    UIView *leftBgView = [[UIView alloc] initWithFrame:CGRectMake(edgeX, edgeY, bgWid, bghei)];
    [leftBgView setBackgroundColor:[UIColor whiteColor]];
    [leftBgView.layer setCornerRadius:10];
    [leftBgView.layer setMasksToBounds:YES];
    [self.contentView addSubview:leftBgView];
    
    leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgWid, bghei-60)];
    [leftBgView addSubview:leftImageView];
    
    leftUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftImageView.frame) + 5, bgWid, 20)];
    [leftUserLabel setFont:kFont16];
    [leftBgView addSubview:leftUserLabel];
    
    UIImageView *leftLineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftUserLabel.frame) + 5, bgWid, 0.5)];
    [leftBgView addSubview:leftLineImageV];
    
    leftDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftLineImageV.frame) + 5, bgWid, 20)];
    [leftBgView addSubview:leftDescLabel];
    
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setFrame:CGRectMake(CGRectGetMaxX(leftBgView.frame) - 50, leftUserLabel.frame.origin.y, 50, 20)];
    [leftBtn.titleLabel setFont:kFont12];
    [leftBtn setTitle:@"关注" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [leftBtn setBackgroundColor:[UIColor clearColor]];
    
    [leftBtn setTitle:@"已关注" forState:UIControlStateDisabled];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [leftBtn addTarget:self action:@selector(doFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
    [leftBgView addSubview:leftBtn];
    
    //右边
    UIView *rightBgView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(leftBgView.frame) + edgeX/2, edgeY, bgWid, bghei)];
    [rightBgView setBackgroundColor:[UIColor whiteColor]];
    [rightBgView.layer setCornerRadius:10];
    [rightBgView.layer setMasksToBounds:YES];
    [self.contentView addSubview:rightBgView];
    
    rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgWid, bghei-60)];
    [rightBgView addSubview:rightImageView];
    
    rightUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rightImageView.frame) + 5, bgWid, 20)];
    [rightUserLabel setFont:kFont16];
    [rightBgView addSubview:rightUserLabel];
    
    UIImageView *rightLineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rightUserLabel.frame) + 5, bgWid, 0.5)];
    [rightBgView addSubview:rightLineImageV];
    
    rightDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(rightLineImageV.frame) + 5, bgWid, 20)];
    [rightBgView addSubview:rightDescLabel];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(CGRectGetMaxX(rightBgView.frame) - 50, rightUserLabel.frame.origin.y, 50, 20)];
    [rightBtn.titleLabel setFont:kFont12];
    [rightBtn setTitle:@"关注" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [rightBtn setBackgroundColor:[UIColor clearColor]];
    
    [rightBtn setTitle:@"已关注" forState:UIControlStateDisabled];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [rightBtn addTarget:self action:@selector(doFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
    [rightBgView addSubview:rightBtn];
    
//    [self.contentView setFrame:CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)]
    
}

- (void)doFollowFriend:(id)sender
{
    
    
}

- (void)setItemValueWithDict:(NSDictionary *)itemDict rightDict:(NSDictionary *)rightDict;
{
    [leftImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head60"]];
    [leftUserLabel setText:@"左边"];
    
    
    [rightImageView sd_setImageWithURL:nil placeholderImage:[UIImage imageNamed:@"head60"]];
    [rightUserLabel setText:@"左边"];
    
}

@end
