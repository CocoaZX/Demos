//
//  DetailVCJingpaiCell.m
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DetailVCJingpaiCell.h"
#import "NewMyPageViewController.h"

@implementation DetailVCJingpaiCell

-(void)awakeFromNib{
    
    self.headerImageView.layer.cornerRadius = self.headerImageView.width*0.5;
    self.headerImageView.clipsToBounds = YES;
    self.priceLabel.textColor = [UIColor colorForHex:kLikeRedColor];
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    
    [self.headerButton addTarget:self action:@selector(jumpToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)init{
    
    return [[NSBundle mainBundle]loadNibNamed:@"DetailVCJingpaiCell" owner:self options:nil].lastObject;
}

-(void)setupUI:(NSDictionary *)dict{

    self.auctorID = dict[@"uid"];
    [self.headerImageView setImageWithURL:[NSURL URLWithString:dict[@"head_pic"]?dict[@"head_pic"]:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nicknameLabel.text = dict[@"nickname"];
    NSString *lastPrice = [getSafeString(dict[@"auction_price"]) stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.priceLabel.text = [NSString stringWithFormat:@"%@金币",lastPrice];
    self.profitLabel.text = [NSString stringWithFormat:@"获利 %@金币",dict[@"earn"]];
    
}

-(void)jumpToPersonalPage{
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    //    newMyPage.currentTitle = userName;
    
    newMyPage.currentUid = self.auctorID;
    [self.superVC.navigationController pushViewController:newMyPage animated:YES];
}


@end
