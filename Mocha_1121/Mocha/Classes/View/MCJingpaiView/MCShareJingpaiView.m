//
//  MCShareJingpaiView.m
//  Mocha
//
//  Created by TanJian on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCShareJingpaiView.h"

@implementation MCShareJingpaiView

-(instancetype)init{
    
    return [[NSBundle mainBundle] loadNibNamed:@"MCShareJingpaiView" owner:self options:nil].lastObject;
}

-(void)animationForView{
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.7;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeShareView)];
    [backView addGestureRecognizer:recognizer];
    [self addSubview:backView];
    
    float imageW = 300*kDeviceHeight/667;
    UIImageView *flowerImage = [[UIImageView alloc]initWithFrame:self.bounds];
    flowerImage.image = [UIImage imageNamed:@"auctionSuccess"];
    [self addSubview:flowerImage];
    
    
    UILabel *successLable = [[UILabel alloc]initWithFrame:CGRectMake((kDeviceWidth-imageW)*0.5, flowerImage.bottom+10, imageW, 21)];
    successLable.text = @"竞价成功";
    successLable.textAlignment = NSTextAlignmentCenter;
    successLable.textColor = [UIColor whiteColor];
//    [self addSubview:successLable];
    
    NSArray *imageArr = @[[UIImage imageNamed:@"auctionWeixin"],[UIImage imageNamed:@"auctionPengyou"],[UIImage imageNamed:@"auctionWeibo"],[UIImage imageNamed:@"auctionQQ"]];
    NSArray *titleArr = @[@"微信",@"朋友圈",@"新浪微博",@"QQ"];
    //创建分享按钮和显示标签
    CGFloat buttonWidth = 55*kDeviceWidth/375;
    CGFloat spaceWidth = (kDeviceWidth - buttonWidth*4)/5;
    for (int i = 0; i < imageArr.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(spaceWidth*(i+1)+buttonWidth *i, kDeviceHeight/3 * 1.35, buttonWidth, buttonWidth)];
        
        btn.tag = 2000 +i;
        [btn addTarget:self action:@selector(sharJingpai:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = (buttonWidth - 15)/2 ;
        btn.layer.masksToBounds = YES;
        [btn setImage:imageArr[i] forState:UIControlStateNormal];

        //若有关闭按钮打开
        if (i == 4) {
            btn.frame = CGRectMake((kDeviceWidth-buttonWidth)/2 , kDeviceHeight/3 * 2+110, buttonWidth-15 , buttonWidth-15 );
            
        }
        [self addSubview:btn];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = titleArr[i];
        
        titleLabel.tag = 3000 + i;
        [titleLabel sizeToFit];
        titleLabel.origin= CGPointMake(btn.center.x-titleLabel.width*0.5, btn.bottom+5);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = [UIColor whiteColor];
        
//        [self addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:btn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        [self addSubview:titleLabel];
    }
    
    //显示分享按钮
    for(int i = 0 ;i < imageArr.count; i++){
        UIButton *btn = (UIButton *)[self viewWithTag:2000+i];
        UILabel *titleLabel = (UILabel *)[self viewWithTag:3000 +i];
        //当前视图缩小为原来的0.5倍
        btn.transform = CGAffineTransformMakeScale(0.5, 0.5);
        btn.alpha = 0;
        btn.top = kDeviceHeight;
        
        titleLabel.transform = CGAffineTransformMakeScale(0.5, 0.5);
        titleLabel.alpha = 0;
        titleLabel.top = btn.bottom +5;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            //延迟动画的调用
            [UIView setAnimationDelay:i * 0.08];
            btn.transform = CGAffineTransformMakeScale(1.2, 1.2);
            btn.alpha = 1;
            btn.top = kDeviceHeight/1.35 - 30;
            if (i == 4) {
                btn.top = kDeviceHeight/1.35 +80;
            }
            titleLabel.transform = CGAffineTransformMakeScale(1.2, 1.2);
            titleLabel.alpha = 1;
            titleLabel.top = btn.bottom +5;
            
        } completion:^(BOOL finished) {
            //让视图从1.2--》1
            [UIView animateWithDuration:0.5
                             animations:^{
                                 btn.transform = CGAffineTransformMakeScale(1, 1);
                                 btn.alpha = 1;
                                 btn.top = kDeviceHeight/1.35;
                                 if (i == 4) {
                                     btn.top = kDeviceHeight/1.35 + 110;
                                 }
                                 titleLabel.transform = CGAffineTransformMakeScale(1, 1);
                                 titleLabel.alpha = 1;
                                 titleLabel.top = btn.bottom + 5;
                             }];
        }];
    }

}

//点击分享按钮后响应
-(void)sharJingpai:(UIButton *)sender{
    
    switch (sender.tag) {
            
        case 2003://QQ好友
        {
            
            NSData *imageData;
            if (UIImagePNGRepresentation(self.firstImg) == nil) {
                
                imageData = UIImageJPEGRepresentation(_firstImg, 1);
                
            } else {
                
                imageData = UIImagePNGRepresentation(_firstImg);
            }
            if (!imageData) {
                imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendAuctionLinkToQQdecription:self.shareDes title:@"我竞拍了一个好东西,点击查看" imageData:imageData auctionID:self.auctionID isQZone:NO];
        }
            break;
        case 2000://推荐微信好友
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            
            UIImage *headerImg = self.firstImg;
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            NSString *auctionID = self.auctionID;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:headerImg shareTitle:@"我竞拍了一个好东西,点击查看" shareDes:self.shareDes];
        }
            break;
            
        case 2001://推荐微信朋友圈
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            UIImage *headerImg = self.firstImg;
            if (!headerImg) {
                headerImg = [UIImage imageNamed:@"AppIcon"];
            }
            NSString *auctionID = self.auctionID;
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:headerImg shareTitle:@"我竞拍了一个好东西,点击查看" shareDes:self.shareDes];
        }
            break;

        case 2002:
            //新浪
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToSinaWithPic:nil];
            
            [LeafNotification showInController:self.superVC withText:@"微博分享失败"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self closeShareView];
            });
            
        }
            break;
      
    
            
            
        default:
            
            break;
    }
    
    
}

-(void)closeShareView{
    
    [self removeFromSuperview];
//    self.superVC.superNVC.navigationBarHidden = NO;
//    self.superVC.superNVC.customTabBarController.tabBar.hidden = NO;
}

@end
