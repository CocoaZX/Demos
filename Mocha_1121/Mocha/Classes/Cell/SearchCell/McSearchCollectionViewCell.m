//
//  McSearchCollectionViewCell.m
//  Mocha
//
//  Created by renningning on 14-12-18.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McSearchCollectionViewCell.h"
#import "ReadPlistFile.h"

#define edgeX  0
#define edgeY  0

@interface McSearchCollectionViewCell()
{
    
    UIImageView *leftImageView;
    UILabel *leftUserLabel;
    UILabel *leftDescLabel;
    UILabel *infoLabel;
    UIButton *leftBtn;
    UIView *leftBgView;
    UIImageView *leftLineImageV;
    UIImageView *lineImageV;
}

@end

@implementation McSearchCollectionViewCell

- (void)_init
{
    float bgWid = self.contentView.frame.size.width;
    float bghei = self.contentView.frame.size.height;
    
    if (!leftBgView) {
        leftBgView = [[UIView alloc] initWithFrame:CGRectMake(edgeX, edgeY, bgWid, bghei)];

    }
    [leftBgView setBackgroundColor:[UIColor whiteColor]];
    [leftBgView.layer setCornerRadius:8];
    [leftBgView.layer setMasksToBounds:YES];
    [self.contentView addSubview:leftBgView];
    
    if (!leftImageView) {
        leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, bgWid, bghei-60)];

    }
    [leftBgView addSubview:leftImageView];
    
    if (!leftUserLabel) {
        leftUserLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(leftImageView.frame) + 8, bgWid-50, 20)];
        
    }
    [leftUserLabel setFont:kFont14];
    [leftUserLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    [leftBgView addSubview:leftUserLabel];
    
    if (!leftLineImageV) {
        leftLineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(leftUserLabel.frame) + 8, bgWid, 0.5)];
        
    }
    [leftLineImageV setBackgroundColor:[UIColor colorForHex:kLikeLightGrayColor]];
    [leftBgView addSubview:leftLineImageV];
    
    if (!leftDescLabel) {
        leftDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, CGRectGetMaxY(leftLineImageV.frame) + 3, bgWid/2-10, 20)];
        
    }
    [leftDescLabel setFont:kFont10];
    [leftDescLabel setTextAlignment:kTextAlignmentLeft_SC];
    [leftDescLabel setTextColor:[UIColor colorForHex:kLikeGrayTextColor]];
    [leftBgView addSubview:leftDescLabel];
    
    if (!lineImageV) {
        lineImageV = [[UIImageView alloc] initWithFrame:CGRectMake(bgWid/2, CGRectGetMaxY(leftLineImageV.frame), 0.5, bghei - CGRectGetMaxY(leftLineImageV.frame))];
        
    }
    [lineImageV setBackgroundColor:[UIColor colorForHex:kLikeLightGrayColor]];
    [leftBgView addSubview:lineImageV];
    
    if (!infoLabel) {
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgWid/2 + 8, CGRectGetMaxY(leftLineImageV.frame) + 3, bgWid/2-10, 20)];
        
    }
    [infoLabel setFont:kFont10];
    [infoLabel setTextAlignment:kTextAlignmentLeft_SC];
    [infoLabel setTextColor:[UIColor colorForHex:kLikeGrayTextColor]];
    [leftBgView addSubview:infoLabel];
    
    
//    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [leftBtn setFrame:CGRectMake(CGRectGetMaxX(leftBgView.frame) - 55, leftUserLabel.frame.origin.y, 50, 20)];
//    [leftBtn.titleLabel setFont:kFont12];
//    [leftBtn setTitle:@"关注" forState:UIControlStateNormal];
//    [leftBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
//    [leftBtn setBackgroundColor:[UIColor clearColor]];
//    [leftBtn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
//    [leftBtn.layer setBorderWidth:1.0];
//    [leftBtn.layer setCornerRadius:10];
//    
//    [leftBtn setTitle:@"已关注" forState:UIControlStateDisabled];
//    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
//    [leftBtn addTarget:self action:@selector(doFollowFriend:) forControlEvents:UIControlEventTouchUpInside];
//    [leftBgView addSubview:leftBtn];

}

- (void)doFollowFriend:(id)sender
{
    if (![GlogalState isLogin]) {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewController];
        return;
    }
    
    //添加关注
}

- (void)setCollectionViewCellWithValue:(NSDictionary *)dict
{
    NSLog(@"dict:%@",dict);//createline
    [self _init];
    leftUserLabel.text = dict[@"nickname"];
    NSInteger wid = CGRectGetWidth(leftImageView.frame) * 2;
    NSInteger hei = CGRectGetHeight(leftImageView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
    NSString *url = [NSString stringWithFormat:@"%@%@",dict[@"head_pic"],jpg];
    [leftImageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    NSString *provinceId = dict[@"province"];
    NSString *cityId = dict[@"city"];
    NSString *province = @"";
    NSString *city = @"";
    NSArray *areaArray = [ReadPlistFile readAreaArray];
    for (NSDictionary *dicts in areaArray) {
        if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
            province = dicts[@"name"];
            NSArray *citys = dicts[@"citys"];
            for (NSDictionary *cityDict in citys) {
                if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                    city = cityDict[@"name"];
                }
            }
        }
    }
    
    leftDescLabel.text = [NSString stringWithFormat:@"%@%@",province,city];
    
    infoLabel.text = [[ReadPlistFile readProfession] valueForKey:dict[@"job"]];
}

@end
