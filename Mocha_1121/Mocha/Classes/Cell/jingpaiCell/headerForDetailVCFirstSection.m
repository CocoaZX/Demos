//
//  headerForDetailVCFirstSection.m
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "headerForDetailVCFirstSection.h"
#import "MCJingpaiLisetController.h"

@interface headerForDetailVCFirstSection ()



@end

@implementation headerForDetailVCFirstSection

-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    self.checkAllButton.layer.cornerRadius = 6;
    self.checkAllButton.clipsToBounds = YES;
    self.checkAllButton.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    
    [self.checkAllButton addTarget:self action:@selector(jumpToJingpaiListVC) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"headerForDetailVCFirstSection" owner:self options:nil].lastObject;
}

-(void)setupUI:(MCJingpaiDetailModel *)model{
    self.model = model;
    NSString *lastPrice = [self.model.last_price stringByReplacingOccurrencesOfString:@".00" withString:@""];
    self.jingpaiPrice.text = [NSString stringWithFormat:@"%@金币", lastPrice];
    self.jingpaiCount.text = [NSString stringWithFormat:@"%ld人竞拍,最高价格为:", (unsigned long)self.model.auctors.count];
    
}

-(void)jumpToJingpaiListVC{
    //竞拍list
    MCJingpaiLisetController *listVC = [[MCJingpaiLisetController alloc]initWithNibName:@"MCJingpaiLisetController" bundle:nil];
    listVC.auctionID = self.model.auction_id;
    
    [self.superVC.navigationController pushViewController:listVC animated:YES];
}

@end


