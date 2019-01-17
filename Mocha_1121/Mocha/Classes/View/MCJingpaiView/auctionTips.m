//
//  auctionTips.m
//  Mocha
//
//  Created by TanJian on 16/5/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

//第一次打开进入竞拍给的提示
#import "auctionTips.h"
#import "MCAuctionTipsController.h"
#import "MCAuctionTipsController.h"

#define kScaleX kDeviceWidth/375
#define kscaleY kDeviceHeight/667

@interface auctionTips ()


@end


@implementation auctionTips

-(void)setupUI{
    
    switch (self.superVCType) {
            
        case superHot:
            self.superHotVC = self.superHotVC;
            self.superVC = _superHotVC;
            break;
        case superList:
            self.superListVC = self.superListVC;
            self.superVC = _superListVC;
            break;
        case superNear:
            self.superNearVC = self.superNearVC;
            self.superVC = _superNearVC;
            break;
        default:
            break;
    }
    
    
    self.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:self.frame];
    backView.alpha = 0.7;
    backView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [backView addGestureRecognizer:recognizer];
    [self addSubview:backView];
    
    UIImageView *tipsView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"auctionTips"]];
    float width = kDeviceWidth*0.8;
    tipsView.frame = CGRectMake(kDeviceWidth*0.1, kDeviceHeight*0.5-kDeviceWidth*0.4-20,width, width);
    [self addSubview:tipsView];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth*0.9-15, tipsView.top-15, 30, 30)];
    [closeBtn setImage:[UIImage imageNamed:@"close2"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeBtn];
    
    UIButton *detailBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth*0.5-60*kScaleX, tipsView.bottom-65*kscaleY, 120, 50)];
    [detailBtn addTarget:self action:@selector(jumpToTipsVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:detailBtn];
    
}

-(void)jumpToTipsVC{
    
    [self removeFromSuperview];
    MCAuctionTipsController *tipsVC = [[MCAuctionTipsController alloc] initWithNibName:@"MCAuctionTipsController" bundle:nil];

    NSString *urlStr = [USER_DEFAULT valueForKey:@"webUrl"];
    tipsVC.linkUrl = [NSString stringWithFormat:@"%@/about/BiddingRule",urlStr];
    NSLog(@"%@",tipsVC.linkUrl);
    switch (self.superVCType) {
            
        case superHot:
            
        case superList:
            
        case superNear:
            
             [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpToAuctionTipVC" object:nil];
            break;
        case superElse:
            [self goToAuctionTipsVC];
            break;
            
        default:
            
            break;
    }
    
}

-(void)goToAuctionTipsVC{
    MCAuctionTipsController *tipsVC = [[MCAuctionTipsController alloc] initWithNibName:@"MCAuctionTipsController" bundle:nil];
    
    //    NSDictionary *dict = [USER_DEFAULT valueForKey:@"webUrlsDic"];
    //    tipsVC.linkUrl = dict[@"auction_rule"];
    NSString *urlStr = [USER_DEFAULT valueForKey:@"webUrl"];
    tipsVC.linkUrl = [NSString stringWithFormat:@"%@/about/BiddingRule",urlStr];
    
    [self.superVC.navigationController pushViewController:tipsVC animated:YES];
}

-(void)closeView{
    [self removeFromSuperview];
}
@end
