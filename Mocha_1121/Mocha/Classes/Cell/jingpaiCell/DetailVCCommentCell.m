//
//  DetailVCCommentCell.m
//  Mocha
//
//  Created by TanJian on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DetailVCCommentCell.h"
#import "NewMyPageViewController.h"

@interface DetailVCCommentCell ()

@property (nonatomic,strong)NSDictionary *dataDict;

@end

@implementation DetailVCCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    self.headerImageView.layer.cornerRadius = self.headerImageView.width*0.5;
    self.headerImageView.clipsToBounds = YES;
    [self.headerButton addTarget:self action:@selector(jumpToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"DetailVCCommentCell" owner:self options:nil].lastObject;
}


-(void)setupUI:(NSDictionary *)dict{
    
    self.dataDict = dict;
    self.commentLabel.text = dict[@"content"];
    self.nicknameLabel.text = dict[@"nickname"];
    //设置会员昵称颜色
    NSString *isMember = getSafeString(self.dataDict[@"member"]);
    if ([isMember isEqualToString:@"1"]) {
        self.nicknameLabel.textColor = [CommonUtils colorFromHexString:kLikeMemberNameColor];
    }else{
        self.nicknameLabel.textColor = [CommonUtils colorFromHexString:kLikeBlackColor];
    }

    
    
    self.timeLabel.text = [CommonUtils dateTimeIntervalString:dict[@"createline"]];
    [self.headerImageView  setImageWithURL:[NSURL URLWithString:dict[@"head_pic"]?dict[@"head_pic"]:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

}

+(float)getHeightWithDict:(NSDictionary *)dict{
    
    float headerH = 60;
    float commentH = [SQCStringUtils getCustomHeightWithText:dict[@"content"] viewWidth:kDeviceWidth-90 textSize:14];
    
    return headerH+commentH;
}

-(void)jumpToPersonalPage{
    NSLog(@"跳转个人页面");
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    
    newMyPage.currentUid = self.dataDict[@"uid"];
    [self.superVC.navigationController pushViewController:newMyPage animated:YES];
}

@end
