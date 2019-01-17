//
//  AcutionPublishSuccessController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "AcutionPublishSuccessController.h"

@interface AcutionPublishSuccessController ()<UIActionSheetDelegate>

@end

@implementation AcutionPublishSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"竞拍详情";
    self.acutionInfoView.dataDic  = self.acutionDic;
    
    //竞拍成功的说明
    NSString *last_price = getSafeString(self.acutionDic[@"last_price"]);
    NSString *successInfo = [NSString stringWithFormat:@"此竞拍获得金额%@元，已经存入钱包",last_price];
    _successInfoDescLabel.text = successInfo;
    
    NSString *shareInfo = [NSString stringWithFormat:@"这单赚了%@元，快去分享给朋友们~",last_price];

    [self.shareBtn setTitle:shareInfo forState:UIControlStateNormal];
    CGFloat shareInfoWidth = [SQCStringUtils getCustomWidthWithText:shareInfo viewHeight:20 textSize:15] +10;
    self.bottomLine_width.constant = shareInfoWidth;
    
 }



- (IBAction)shareBtnClick:(id)sender {
    
    [self showShareAction];
}



-(void)showShareAction{
    NSLog(@"shareInformationMethod");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"推荐到微信朋友圈",@"推荐到微信好友",@"推荐给QQ好友",nil];
    [actionSheet showInView:self.view];
}


#pragma mark alert代理
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"竞拍分享");
    UIImage *coverImg = self.acutionInfoView.imgView.image;
    NSString *auctionID = self.acutionDic[@"auction_id"];

    NSString *description =self.acutionDic[@"auction_description"];
    if (!coverImg) {
        coverImg = [UIImage imageNamed:@"AppIcon"];
    }
    switch (buttonIndex) {
        case 0://推荐微信朋友圈
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:coverImg shareTitle:@"我在MOKA发现一个竞拍，快来抢拍" shareDes:description];
        }
            break;

            
            
        case 1://推荐微信好友
        {
            [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
            
             [(AppDelegate *)[UIApplication sharedApplication].delegate sendLinkContentToWXFriendsAuctionId:auctionID header:coverImg shareTitle:@"我在MOKA发现一个竞拍，快来抢拍" shareDes:description];
        }
            break;
            
            
        case 2://QQ好友
        {
            NSArray *img_urls = self.acutionDic[@"img_urls"];
            NSString *url = img_urls[0][@"url"];
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
            
            if (!imageData) {
                imageData = [NSData dataWithContentsOfFile:@"AppIcon.png"];
            }
            
            [(AppDelegate *)[UIApplication sharedApplication].delegate sendAuctionLinkToQQdecription:description title:@"我在MOKA发现一个竞拍,快来抢拍" imageData:imageData auctionID:auctionID isQZone:NO];
        }
            break;

        default:
            
            break;
    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
