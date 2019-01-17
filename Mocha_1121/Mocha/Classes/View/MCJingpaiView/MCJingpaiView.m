//
//  MCJingpaiView.m
//  Mocha
//
//  Created by TanJian on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJingpaiView.h"
#import "DaShangViewController.h"
#import "NewLoginViewController.h"
#import "JinBiViewController.h"
#import "MCShareJingpaiView.h"

@interface MCJingpaiView ()<UIAlertViewDelegate>


@property(nonatomic,copy) NSString *currentCoin;
@property(nonatomic,copy) NSString *myCoinCount;
@property(nonatomic,strong)MCShareJingpaiView *shareView;


@end


@implementation MCJingpaiView

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
        case superElse:
            
            break;
        default:
            break;
    }
    
    self.backgroundColor = [UIColor clearColor];
    UIView *backView = [[UIView alloc]initWithFrame:self.frame];
    backView.alpha = 0.6;
    backView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView)];
    [backView addGestureRecognizer:recognizer];
    [self addSubview:backView];
    
    MCJingpaiContentView *contentView = [[MCJingpaiContentView alloc]init];
    contentView.frame = CGRectMake(0, kDeviceHeight-189, kDeviceWidth, 125);
    NSString *lastPrice = [self.lastPrice stringByReplacingOccurrencesOfString:@".00" withString:@""];
    NSString *upPrice = [self.up_range stringByReplacingOccurrencesOfString:@".00" withString:@""];
    contentView.priceTextField.placeholder = [NSString stringWithFormat:@"当前%@金币,最低加价%@金币", lastPrice,upPrice];
    self.contentView = contentView;
    [self addSubview:contentView];
    
    [self.contentView.cancelButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView.confirmButton addTarget:self action:@selector(confirmToPay) forControlEvents:UIControlEventTouchUpInside];
    
    //键盘监听
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardDidHideNotification object:nil];
    
    
    
    [self getUserGoldCount];
}


//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    float keyboardH = [self keyboardEndingFrameHeight:notification.userInfo];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(0, kDeviceHeight-189-keyboardH, kDeviceWidth, 189);
    }];
    
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    
    [self closeView];
    
}

//取消按钮方法
-(void)closeView{
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self removeFromSuperview];
}

//确认按钮方法
-(void)confirmToPay{

    BOOL isRightPrice = NO;
    BOOL isRightComment = NO;
    
    //判断价格输入是否符合标准
    NSString *coin = self.contentView.priceTextField.text;
    NSString *regex = @"^[0-9]*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isValid = [predicate evaluateWithObject:coin];
    
    float currentPrice = getSafeString(_lastPrice).floatValue;
    
    if (isValid) {
        if (coin.floatValue > currentPrice && coin.floatValue <= 50000) {
            NSLog(@"开始竞价");
            
            float upRange = getSafeString(_up_range).floatValue;
            
            if (coin.floatValue < currentPrice+upRange) {

                [self showTips:@"差价必须大于出价幅度" OnSuperType:_superVCType];
                return;
            }
            
            self.currentCoin = coin;
            isRightPrice = YES;
            
        }else if(coin.floatValue <= currentPrice){

            [self showTips:@"出价不能少于当前竞拍价" OnSuperType:_superVCType];
            return;
            
        }else if(coin.floatValue > 50000){

            [self showTips:@"出价不能大于50000" OnSuperType:_superVCType];
            return;
            
        }
    }else{
        

        [self showTips:@"请输入数字价格" OnSuperType:_superVCType];
        
        return;
        
    }
    
    //判断评论是否符合标准
    
    NSString *commentStr = self.contentView.commentTextField.text;
    
    //isRightComment是前期需求必须有评论才能竞价
    commentStr = @"不需评论";
    
    NSInteger n = commentStr.length;
    int l = 0;
    int a = 0;
    int b = 0;
    unichar c;
    
    for(int i = 0; i < n;i++){
        c = [commentStr characterAtIndex:i];
        if(isblank(c)){
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
    }
    float strLen = l+(int)ceilf((float)(a+b)/2.0);
    if (strLen<1) {
        //后期需求改变，不需要输入评论
//        [LeafNotification showInController:self.superVC withText:@"请输入评论"];
        return;
    }else if(strLen>140){
        
        [LeafNotification showInController:self.superVC withText:@"字数超过最大字数限制"];
        return;
    }else{
        NSLog(@"评论内容正确");
        isRightComment = YES;
    }
    
    if (isRightPrice) {
        
        [self payWithMyCoin];
        [self.contentView.priceTextField endEditing:YES];
        [self.contentView.commentTextField endEditing:YES];
        
    }
}


//竞价成功，弹出分享view
-(void)appearShareView{
    
    MCShareJingpaiView *shareView = [[MCShareJingpaiView alloc]init];
    shareView.frame = CGRectMake(0, 0, kDeviceWidth, kDeviceHeight);
    self.shareView = shareView;
    shareView.superVC = self.superVC;
    shareView.auctionID = _auctionID;
    shareView.firstImg = self.shareImg;
    shareView.shareDes = _auction_des;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:shareView];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareView animationForView];
    });
    
}

#pragma mark 网络请求
-(void)payWithMyCoin{
    
    int myCoin = self.myCoinCount.intValue;
    int currentCoin = self.currentCoin.intValue;

    if (currentCoin < myCoin) {
        
        NSDictionary *payDict = @{@"1":@"0",@"2":@"0",@"3":self.currentCoin};
        NSString *pay_info = [SQCStringUtils JSONStringWithDic:payDict];
        
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"auctionId":_auctionID,@"comment":@"",@"pay_info":pay_info}];
        
        [AFNetwork ParticipateInAuction:params path:PathPostAuctionJoin success:^(id data) {
            
            if ([data[@"status"] integerValue] == kRight) {
                
                [self appearShareView];
                
            }else {
                
                [self showTips:data[@"msg"] OnSuperType:_superVCType];
                
            }
            
        } failed:^(NSError *error) {
            [self showTips:@"当前网络不太顺畅" OnSuperType:_superVCType];

        }];
        //发送请求，完成竞价

    }else{
        
        if (self.superVCType == superElse) {
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"金币不足" message:@"您账户的金币不足，请先充值" delegate:self.superVC cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            [alert show];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"金币不足" message:@"您账户的金币不足，请先充值" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
            [alert show];
            
        }
    }
}


//请求网络显示用户金币数量
- (void)getUserGoldCount{
    
    NSString *theUid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:theUid];
    
    NSString *pathAll = [NSString stringWithFormat:@"%@%@%@",DEFAULTURL,PathGetUserInfo,[AFNetwork getCompleteURLWithParams:params]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        NSMutableURLRequest *request=[NSMutableURLRequest  requestWithURL:[NSURL URLWithString:pathAll]];
        
        [request setHTTPMethod:@"POST"];
        NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSDictionary *diction = nil;
        @try {
            diction=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        }
        @catch (NSException *exception) {
            return ;
        }
        @finally {
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *coinCount = [NSString stringWithFormat:@"%@",diction[@"data"][@"goldCoin"]];
            
            self.myCoinCount = coinCount;
                });
    });
    [self.contentView.priceTextField becomeFirstResponder];
    
}

#pragma mark alertDelegate
//-(void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self closeView];
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
            //跳到充值界面
            [self jumpToRechargeVC];
            break;

        default:
            break;
    }
}


#pragma mark 私有方法

-(void)jumpToRechargeVC{

    switch (self.superVCType) {
            
        case superHot:

        case superList:
            
        case superNear:
            [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToAuctionRecharge" object:nil];
            break;
            
        case superElse:
            //此类的alert代理为superVC
            break;
        default:
        
            break;
    }
}

-(void)pushToRecharge{
    JinBiViewController *rechargeVC = [[JinBiViewController alloc]init];
    [self.superVC.navigationController pushViewController:rechargeVC animated:YES];
}

-(void)showTips:(NSString *)msg OnSuperType:(MCsuperType) type{
    
    switch (type) {
            
        case superHot:
            [LeafNotification showInController:self.superHotVC withText:msg];
            break;
        case superList:
            [LeafNotification showInController:self.superListVC withText:msg];
            
            break;
        case superNear:
            [LeafNotification showInController:self.superNearVC withText:msg];
            break;
        case superElse :
            [LeafNotification showInController:self.superVC withText:msg];
            
        default:
            break;
            
    }
}

@end
