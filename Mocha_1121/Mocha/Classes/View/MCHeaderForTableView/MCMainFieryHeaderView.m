//
//  MCMainFieryHeaderView.m
//  Mocha
//
//  Created by TanJian on 16/5/20.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCMainFieryHeaderView.h"
#import "McMainModelViewController.h"
#import "MCFieryListController.h"
#import "MokaActivityDetailViewController.h"
#import "McWebViewController.h"
#import "PhotoViewDetailController.h"

#define kScaleW    kDeviceWidth/375
#define kScaleH    kDeviceHeight/667

@interface MCMainFieryHeaderView ()

@property (nonatomic,strong)NSArray *headerArr;

@end

@implementation MCMainFieryHeaderView

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"MCMainFieryHeaderView" owner:self options:nil].lastObject;
}



-(void)awakeFromNib{
    
    _seprateline.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    _modelTitleLine.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    _modelTitleLable.textColor = [UIColor colorForHex:kLikeRedColor];
    _grapherTitleLine.backgroundColor = [UIColor colorForHex:kLikeGreenLightColor];
    _grapherTitleLabel.textColor = [UIColor colorForHex:kLikeGreenLightColor];
    _bigSeprateLine.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    
    float headRadius = (kDeviceWidth-40-25)/12;
    for (UIImageView *imgView in self.headerArr) {
        imgView.layer.cornerRadius = headRadius;
        imgView.clipsToBounds = YES;
    }

    
    self.backgroundColor = [UIColor whiteColor];
}

-(void)setupUI{
    
    for (int i = 0; i<self.dataArr.count; i++) {
        
        NSString *url = getSafeString(self.dataArr[i][@"head_pic"]);
        
        UIImageView *imgView = self.headerArr[i];
        url = [NSString stringWithFormat:@"%@%@",getSafeString(url),[CommonUtils imageStringWithWidth:_imgView.width*2 height:_imgView.width*2]];
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        
    }
    
    NSDictionary *advdict = [USER_DEFAULT objectForKey:@"hot_adv"];
    NSString *urlStr = getSafeString(advdict[@"url"]);
    
    NSString *url = [NSString stringWithFormat:@"%@%@",urlStr,[CommonUtils imageStringWithWidth:kDeviceWidth height:kDeviceWidth/75*32]];

    [_imgView sd_setImageWithURL:[NSURL URLWithString:url]];
    
}


- (IBAction)jumpForFieryBanner:(id)sender {
    NSLog(@"banner跳转");
    NSDictionary *advdict = [USER_DEFAULT objectForKey:@"hot_adv"];
    
    NSInteger jumpType = [getSafeString(advdict[@"type"]) integerValue];
//    jumpType = 2;
    switch (jumpType) {
        case 1://个人
            if (jumpType == 1) {
            
                NSString *uid = getSafeString(advdict[@"jump"]);
                
                NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
                
                newMyPage.currentUid = uid;
                UserDefaultSetBool(NO, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];
                [self.superVC.superNVC pushViewController:newMyPage animated:YES];
            }
            
            break;
        case 2://活动
        {
            //活动ID
            MokaActivityDetailViewController *mokaDetailVC = [[MokaActivityDetailViewController alloc] init];
            mokaDetailVC.eventId = getSafeString(advdict[@"jump"]);
            
            [self.superVC.superNVC pushViewController:mokaDetailVC animated:YES];
        }
            
            break;
        case 3://网页
        {
            NSString *uid = @"";
            NSString *tempUid =[[USER_DEFAULT valueForKey:MOKA_USER_VALUE]valueForKey:@"id"];
            uid = tempUid ? tempUid : @"";
            NSString *webURL = getSafeString(advdict[@"jump"]);
            NSRange webRange = [webURL rangeOfString:@"?"];
            
            if (webURL.length==0) {
                return;
            }
            if (uid) {
                if (webRange.length != 0) {
                    webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"&uid/%@",uid]];
                }else{
                    
                    if (uid.length) {
                        webURL = [webURL stringByAppendingString:[NSString stringWithFormat:@"?uid/%@",uid]];
                    }
                }
            }
            //            NSLog(@"%@",webURL);
            //            webURL = @"http://www.moka.vc/about/jump/";
            //            webURL = @"http://yzh.web.mokacool.com/vote/";
            if (webURL.length) {
                McWebViewController *webVC = [[McWebViewController alloc] init];
                webVC.webUrlString = webURL;
                
                webVC.needAppear = YES;
                UserDefaultSetBool(NO, @"isHiddenTabbar");
                [USER_DEFAULT synchronize];
                //进入网页
                [self.superVC.superNVC pushViewController:webVC animated:YES];
            }
        }
            break;
        case 4://照片详情
        {
            NSString *photoId = getSafeString(advdict[@"jump"]);
            PhotoViewDetailController *detailVc = [[PhotoViewDetailController alloc] init];
            [detailVc requestWithPhotoId:photoId uid:@""];
            [self.superVC.superNVC pushViewController:detailVc animated:YES];
            
        }
            //跳视频详情
            //            - (void)requestWithVideoId:(NSString *)vid uid:(NSString *)uid
            break;
            
        case 5://调用Safari打开网页
        {
            NSString *webURL = getSafeString(advdict[@"jump"]);
            if (webURL.length != 0) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webURL]];
            }
        }
            break;
            
        default:
            break;
    }

    //跳转信息在字典中
    
   
}

-(void)setupUIWithData:(NSArray *)dataArr{
    
    
    self.dataArr = dataArr;
    
    [self setupUI];
    
}


- (IBAction)doClickHeader:(UIButton *)sender {
    
    MCFieryListController *fieryListVC = [[MCFieryListController alloc]init];
    fieryListVC.superVC = self.superVC;
    if (sender.tag < 6) {
        fieryListVC.listType = @"1";
    }else{
        fieryListVC.listType = @"2";
    }
    
    [self.superVC.superNVC  pushViewController:fieryListVC animated:YES];
    
    //早期跳转个人主页方法
/*
    NSLog(@"%ld",(long)sender.tag);
    NSInteger index = sender.tag;
    if (self.dataArr.count > index) {
        
        NSString *userName = getSafeString(_dataArr[index][@"nickname"]);
        NSString *uid = getSafeString(_dataArr[index][@"uid"]);
        
        NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
        newMyPage.currentTitle = userName;
        newMyPage.currentUid = uid;
        
        [self.superVC.superNVC  pushViewController:newMyPage animated:YES];
        
    }else{
        [LeafNotification showInController:self.superVC withText:@"数据错误,请稍后"];
    }
*/
 
}


-(NSArray *)headerArr{
    if (!_headerArr) {
        _headerArr = @[_firstImg,_secondImg,_thirdImg,_fouthImg,_fifthImg,_sixthImg,_firstGImg,_secondGImg,_thirdGImg,_fouthGImg,_fifthGimg,_sixthGImg];
    }
    return _headerArr;
}

@end
