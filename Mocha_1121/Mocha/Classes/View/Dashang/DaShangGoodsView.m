//
//  DaShangGoodsView.m
//  Mocha
//
//  Created by TanJian on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "DaShangGoodsView.h"
#import "DaShangViewController.h"
#import "CommonUtils.h"
#import "JSONKit.h"
#import "jinBiViewController.h"

#define KgoodsCount 8;
#define kScale kDeviceWidth/375

@interface DaShangGoodsView ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIView *buttonView;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *stackView;
@property (nonatomic,strong) UIButton *chosenBtn;
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) UIButton *closeButton;
@property (nonatomic,strong) UILabel *plusLable;
@property (nonatomic,strong) UIScrollView *vGoodsScroll;
@property (nonatomic,strong) UILabel *priceLable;
@property (nonatomic,strong) UIButton *goodsButton;
@property (nonatomic,strong) UIView *shangView;

//大图片数组
@property (nonatomic,strong) NSMutableArray *bigImgArr;
//图片URL
@property (nonatomic,strong) NSMutableArray *imgData;

//金币数量
@property (nonatomic,copy) NSString *coinCount;
//虚拟物品信息
@property (nonatomic,strong) NSMutableArray *vGoodsArr;

@end

@implementation DaShangGoodsView

#pragma mark - 视图生命周期及控件加载
-(NSMutableArray *)vGoodsArr{
    if (!_vGoodsArr) {
        _vGoodsArr = [[NSMutableArray alloc]init];
        
    }
    return _vGoodsArr;
}

-(NSMutableArray *)bigImgArr{
    
    if (!_bigImgArr) {
        _bigImgArr = [[NSMutableArray alloc]init];
      
    }
    return _bigImgArr;
}

-(NSMutableArray *)imgData{
    if (!_imgData) {
        _imgData = [[NSMutableArray alloc]init];
    }
    return _imgData;
}


- (void)setUpviews{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    if (!uid) {
        
    }else{
        
        [self getServiceData];

        [self getUserGoldCount];
        
    }

}

-(void)setUI{
    
    UIView *shangView = [[UIView alloc] init];
    self.shangView = shangView;
    shangView.frame = self.frame;
    shangView.backgroundColor = [UIColor clearColor];
    
    UIView *backView = [[UIView alloc] initWithFrame:shangView.frame];
    self.backView = backView;
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha = 0.6;
    
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.frame = shangView.frame;
    [dismissButton addTarget:self action:@selector(closeShangView_ds) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:dismissButton];
    [shangView addSubview:backView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth/2-100, 50*kScale, 200, 30)];
    self.titleLable = titleLabel;
    titleLabel.text = @"选择打赏物品";
    titleLabel.font = [UIFont systemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [shangView addSubview:titleLabel];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeButton = closeButton;
    [closeButton setTitle:@"" forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageNamed:@"photoBrowseCancel"] forState:UIControlStateNormal];
    [closeButton setFrame:CGRectMake(kScreenWidth-60, 40*kScale, 50, 50)];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:18];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeShangView_ds) forControlEvents:UIControlEventTouchUpInside];
    [shangView addSubview:closeButton];
    

    [self setupScrollView];
    [shangView addSubview:self.stackView];
    
    [self addSubview:self.shangView];
    self.backgroundColor = [UIColor clearColor];
    
}

-(void)setupScrollView{

    // scrollView的size
    float buttonViewWidth = kScreenWidth-30;
    float buttonSpace = 30;
    float buttonWidth = (buttonViewWidth-buttonSpace*3-60)/4;
    float buttonHeight = buttonWidth;

    //添加最底层容器view
    self.stackView = [[UIView alloc]initWithFrame:CGRectMake((kDeviceWidth-buttonViewWidth)*0.5, kScreenHeight/2-190, buttonViewWidth, buttonViewWidth*300/345)];
    self.stackView.layer.cornerRadius = 10;
    self.stackView.clipsToBounds = YES;
    self.stackView.backgroundColor = [UIColor whiteColor];
    
    //添加scrollView,放置buttonview
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, buttonViewWidth, (buttonHeight*2+130)*kScale)];
    CGSize scrollViewSize = _scrollView.frame.size;
    self.scrollView.bounces = NO;
    self.scrollView.backgroundColor = [UIColor blueColor];
    
    [self.stackView addSubview:self.scrollView];
    
    NSInteger kImageCount = self.vGoodsArr.count%8 + 1;

    
#pragma mark 后期如果有多页礼物打开下列代码
    //添加pageController
    // 设置有多少页
//    UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame)-10, buttonViewWidth, 30)];
//    pageControl.numberOfPages = kImageCount;
//    pageControl.currentPage = 0;
//    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];//默认颜色
//    pageControl.currentPageIndicatorTintColor = [CommonUtils colorFromHexString:kLikeRedColor];//当前颜色

//    pageControl.userInteractionEnabled = NO;
//    [self.stackView addSubview:pageControl];
    
    //后续布局
    for (int i = 0; i < kImageCount; i++) {
        // 计算x的坐标
        CGFloat imageViewX = i * scrollViewSize.width;
        
        self.buttonView = [[UIView alloc] initWithFrame:CGRectMake(imageViewX, 0, scrollViewSize.width, scrollViewSize.height)];
        self.buttonView.backgroundColor = [UIColor whiteColor];
        
        int count = KgoodsCount;
        for (int i=0; i<count; i++) {
            
            UIImageView *goodsImg = [[UIImageView alloc]init];
            
            float y = 0;
            if (i>3) {
                y = buttonHeight+buttonSpace+30;
            }
            
            [goodsImg setFrame:CGRectMake(30+(buttonSpace+buttonWidth)*(i%4), (y+22)*kScale, buttonWidth*kScale , buttonHeight*kScale)];
            
            goodsImg.layer.cornerRadius = 5;
            goodsImg.clipsToBounds = YES;
            
            //礼物名称
            float nlableX = CGRectGetMinX(goodsImg.frame);
            float nlableY = CGRectGetMaxY(goodsImg.frame) ;
            float nlableW = CGRectGetWidth(goodsImg.frame);
            float nlableH = 22;
            UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(nlableX-10, nlableY, nlableW+20, nlableH*kScale)];
            
            nameLable.textAlignment = NSTextAlignmentCenter;
            nameLable.textColor = [UIColor lightGrayColor];
            nameLable.font = [UIFont systemFontOfSize:12*kScale];

            //礼物的金币价格
            float jblableX = CGRectGetMinX(nameLable.frame);
            float jblableY = CGRectGetMaxY(nameLable.frame) ;
            float jblableW = CGRectGetWidth(nameLable.frame);
            float jblableH = 20;
            self.priceLable = [[UILabel alloc]initWithFrame:CGRectMake(jblableX-10, jblableY, jblableW+20, jblableH*kScale)];
            _priceLable.textAlignment = NSTextAlignmentCenter;
            _priceLable.textColor = [UIColor lightGrayColor];
            _priceLable.font = [UIFont systemFontOfSize:12*kScale];
            
            
            UIButton *bigBtn = [[UIButton alloc]init];
            bigBtn.alpha = 0.4;
            bigBtn.tag = i;
            bigBtn.layer.cornerRadius = 5;
            bigBtn.clipsToBounds = YES;
            bigBtn.frame = CGRectMake(CGRectGetMidX(goodsImg.frame)-(buttonViewWidth-60)/4*0.5, (y+20)*kScale, (buttonViewWidth-60)/4, (buttonHeight+42)*kScale);
            
            [bigBtn addTarget:self action:@selector(choseGoods:) forControlEvents:UIControlEventTouchUpInside];
            
            //根据服务器礼物列表决定有多少礼物显示
            if (i<self.vGoodsArr.count) {
                
                float width = buttonHeight*kScale;
                NSString *jpg = [CommonUtils PngImageStringWithWidth:width * 4 height:width * 4];
                NSString *url = [NSString stringWithFormat:@"%@%@",self.vGoodsArr[i][@"vgoods_img"],jpg];

                [goodsImg sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    
                    [self.bigImgArr addObject:image];
                    //把礼物图片缓存到本地
                    [self cacheImageToSandbox:image withIndex:i];
                    
                }];
                
                [self.buttonView addSubview:goodsImg];

                nameLable.text = [NSString stringWithFormat:@"%@",self.vGoodsArr[i][@"vgoods_name"]];
                [self.buttonView addSubview:nameLable];
                
                self.priceLable.text = [NSString stringWithFormat:@"%@金币",self.vGoodsArr[i][@"free_coin"]];
                [self.buttonView addSubview:_priceLable];
                
                [self.buttonView addSubview:bigBtn];
                
            }
        }
        
        [_scrollView addSubview:self.buttonView];
        
    }
    
    
    //我的金币以及充值
    UILabel *myGold = [[UILabel alloc]initWithFrame:CGRectMake(20*kScale,(CGRectGetHeight(self.stackView.frame)-buttonSpace-20),70*kScale,25*kScale)] ;
    myGold.text = @"我的金币：";
    myGold.textAlignment = NSTextAlignmentLeft;
    myGold.font = [UIFont systemFontOfSize:14*kScale];
    
    myGold.numberOfLines = 0;
    myGold.textColor = [UIColor lightGrayColor];
    [self.stackView addSubview:myGold];
    
    
    self.goodsButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(myGold.frame),CGRectGetMinY(myGold.frame),60*kScale,25*kScale)] ;
    _goodsButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    _goodsButton.titleLabel.font = [UIFont systemFontOfSize:14*kScale];
    [_goodsButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_goodsButton addTarget:self action:@selector(showGoodsCountDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addSubview:_goodsButton];
    
    
    UIButton *rechargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rechargeBtn.frame = CGRectMake(CGRectGetMaxX(_goodsButton.frame), CGRectGetMinY(myGold.frame), 40*kScale, 25*kScale);
    [rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
    rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:15*kScale];
    
    [rechargeBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rechargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [rechargeBtn addTarget:self action:@selector(didRecharge) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addSubview:rechargeBtn];
    
    UIButton *confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //判断iphone或者是pad重新布局确认键大小
    if([CommonUtils getRuntimeClassIsIphone]){
        
        confirmBtn.frame = CGRectMake(CGRectGetWidth(self.buttonView.frame)-(buttonSpace+85)*kScale, CGRectGetMinY(myGold.frame)-7.5*kScale, 85*kScale, 40*kScale);
        confirmBtn.layer.cornerRadius = 7;
    }else{
        confirmBtn.frame = CGRectMake(CGRectGetWidth(self.buttonView.frame)-buttonSpace-85, CGRectGetMinY(myGold.frame)-7.5, 85, 40);
        confirmBtn.layer.cornerRadius = 6;
    }
    
    confirmBtn.layer.cornerRadius = 7;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [confirmBtn setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    
    [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [confirmBtn addTarget:self action:@selector(didConfirm) forControlEvents:UIControlEventTouchUpInside];
    [self.stackView addSubview:confirmBtn];
    
    // scrollView的 contentSize
    _scrollView.contentSize = CGSizeMake(kImageCount * scrollViewSize.width, 0);
    
    // 隐藏水平方向上的 指示器
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    // pageEnabled 分页效果
    _scrollView.pagingEnabled = YES;
}


#pragma mark 缓存礼物图片
-(void)cacheImageToSandbox:(UIImage *)image withIndex:(int)i{
    NSString *sandPath = NSHomeDirectory();
    NSString *imagePath = [sandPath stringByAppendingString:[NSString stringWithFormat:@"/Documents/%d.png",i]];
    [self.imgData addObject:imagePath];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
}

#pragma mark -
//点击金币数量按钮显示详情
-(void)showGoodsCountDetail{
    
    UILabel *goodsCountDetail = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.goodsButton.frame), CGRectGetMinY(self.goodsButton.frame), 90, 22)];
    goodsCountDetail.text = [NSString stringWithFormat:@"  %@个",self.coinCount? self.coinCount:@"0"];
    goodsCountDetail.font = [UIFont systemFontOfSize:14];
    goodsCountDetail.textColor = [UIColor whiteColor];
    goodsCountDetail.backgroundColor = [UIColor lightGrayColor];
    
    goodsCountDetail.layer.cornerRadius = 4;
    goodsCountDetail.clipsToBounds = YES;
//    goodsCountDetail.alpha = 0;
    
    [self.stackView addSubview:goodsCountDetail];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1 animations:^{
            goodsCountDetail.alpha = 0;
        }];
    });
}

//确认后执行购物车动画效果
-(void)didConfirm{
    
    NSInteger goldCount = self.coinCount.integerValue;

    NSInteger tag = (NSInteger)self.chosenBtn.tag;
    
    NSString *priceSTtr = self.vGoodsArr[tag][@"free_coin"];
    NSInteger price = priceSTtr.integerValue;
    
    if (self.chosenBtn) {
        //判断用户金币是否足够
        if (goldCount<price) {
            [self showAlert];
            
        }else{
            //打赏成功，发请求
            NSString *object_type = @"";
            NSString *photoid = self.currentPhotoId;

            NSString *vgoods_id = [NSString stringWithFormat:@"%@",self.vGoodsArr[tag][@"vgoods_id"]];
            
            NSString *jinbi = self.vGoodsArr[tag][@"free_coin"];
            
            object_type = self.dashangType;
            NSString *goodsName = self.vGoodsArr[tag][@"vgoods_name"];
            [self postDashangRequestPhotoId:photoid objectType:object_type vGoodsId:vgoods_id jinbi:jinbi vGoodsName:goodsName];
        }
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"您还没有选择礼物" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    
 
}


-(void)viewWillAppear:(BOOL)animated{
    
    
}


//动画效果
-(void)startAnimation{
    
    //照片View有购物车动画效果
    if ([self.animationType isEqualToString:@"dashangWithAnimation"]) {
        
        [self.shangView removeFromSuperview];
        //购物车动画

        //1.取到选择礼物显示到view上
        UIImageView *bigGoodsImage = [[UIImageView alloc]initWithImage:self.bigImgArr[self.chosenBtn.tag]];
        
        
        [bigGoodsImage setSize:CGSizeMake(100,100)];
        bigGoodsImage.center = self.center;
        
        [self addSubview:bigGoodsImage];
        
        //2.抛物线动画
        CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
        
        CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        CGMutablePathRef thePath = CGPathCreateMutable();
        
        CGPoint startP = self.center;
        CGPoint endP = CGPointMake(kDeviceWidth-kDeviceWidth/6, kDeviceHeight-30);
        
        CGPathMoveToPoint(thePath, NULL, startP.x, startP.y);
        CGPathAddQuadCurveToPoint(thePath, NULL, 200, 200, endP.x, endP.y);
        
        goodsAnimation.path = thePath;
        
        //图片缩放动画
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.3];
        scaleAnimation.autoreverses = NO;
        
        group.animations = @[scaleAnimation,goodsAnimation];
        group.duration = 1;
        group.fillMode = kCAFillModeForwards;
        group.removedOnCompletion = NO;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [bigGoodsImage.layer addAnimation:group forKey:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //礼物加1动画效果
                _plusLable = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth-kDeviceWidth/6-5, kDeviceHeight-55, 40, 25)];
                _plusLable.text = @"+1";
                _plusLable.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
                _plusLable.font = [UIFont systemFontOfSize:16];
                _plusLable.alpha = 1;
                [self addSubview:_plusLable];
                
                [UIView animateWithDuration:1 animations:^{
                    _plusLable.alpha = 0;
                    bigGoodsImage.alpha = 0;
                    _plusLable.frame = CGRectMake(kDeviceWidth-kDeviceWidth/6-5, kDeviceHeight-85, 40, 25);
                }];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    //打赏成功发送通知刷新界面
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshDaShangView" object:nil];
   
                    [self.plusLable removeFromSuperview];
                    [bigGoodsImage removeFromSuperview];
                    
                    [self addSubview:self.shangView];
                    [self closeShangView_ds];
                    
                });
                
            });
            
        });
        //秀等cell中的打赏特殊结束点动画效果
    }else if([self.animationType isEqualToString:@"dashangWithNoAnimation"]){
        
        [self closeShangView_ds];
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObject:[NSString stringWithFormat:@"%ld",(long)self.chosenBtn.tag] forKey:@"btnTag"];
        [dict setObject:self.imgData[self.chosenBtn.tag] forKey:@"imgData"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"McFeedTableViewCellPlus" object:nil userInfo:dict];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MainNearGoodsAnimation" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"photoDetailViewAnimation" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"fullScreenVideoAnim" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"mainFieryGoodsAnimation" object:nil userInfo:dict];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //为防止cell中发通知会有复用问题，在这里发通知刷新tableview
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateTableView" object:nil userInfo:@{@"photoId":self.currentPhotoId}];
            
        });
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            

            [self getUserGoldCount];

            self.backView.alpha = 0.6;
    
        });
    }
}


- (void)sendDaShangGoldCoinMessage:(NSDictionary *)chatDiction extDic:(NSDictionary *)extDiction{
    
    NSMutableDictionary *chatMutDic = [NSMutableDictionary dictionaryWithDictionary:chatDiction];
    NSString *fromUid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    [chatMutDic setObject:fromUid forKey:@"from"];
    [chatMutDic setObject:_targetUid forKey:@"target"];
    
    //扩展字典
    NSMutableDictionary *extdic = [NSMutableDictionary dictionaryWithDictionary:extDiction];
    //打赏对象:ID
    [extdic setObject:self.currentPhotoId forKey:@"objectId"];
    //打赏对象:视频1 图片2 人3
    //[extdic setObject:@"3" forKey:@"rewardType"];
    //自定义消息类型：
    [extdic setObject:@(3) forKey:@"objectType"];
    
    //打赏金币个数
    //[extdic setObject:goldCoin forKey:@"money"];
    //[extdic setObject:_name forKey:@"username"];
    [chatMutDic setObject:extdic forKey:@"ext"];
    
    EMMessage *message = [ChatManager sendDaShangSuccessMessage:chatMutDic];
    
    //发出通知刷新聊天界面的单元格
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshChatVCForDaShang" object:message];
    
}


//账户金币不足，alert提醒充值
-(void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"礼物打赏" message:@"您的账户金币不足，快去充值吧~" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"充值", nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    }else{
        [self didRecharge];
    }
    
}

-(void)didRecharge{
    
    JinBiViewController *rechargeController = [[JinBiViewController alloc]init];

    if (self.superController) {
        [self.superController.navigationController pushViewController:rechargeController animated:YES];
    }else{
        [self.superNVC pushViewController:rechargeController animated:YES];
    }
    [self closeShangView_ds];
    
}

//选择礼物btn调用方法
- (void)choseGoods:(UIButton *)button
{
    
    [self.chosenBtn setBackgroundColor:[UIColor clearColor]];
    
    self.chosenBtn = button;
    
    [button setBackgroundColor:[UIColor lightGrayColor]];
    
}


- (void)closeShangView_ds{
    [self removeFromSuperview];
}

- (void)addToWindow
{
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            
            [window addSubview:self];
            
            break;
        }
    }
    
}

#pragma mark 网络操作
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


            self.coinCount = coinCount;
            if (coinCount.intValue > 99999999) {
                [self.goodsButton setTitle:@"有钱任性"  forState:UIControlStateNormal];
                return;
            }
            //金币超过9999改为万为单位
            if (coinCount.intValue > 9999) {
                int count = coinCount.intValue/10000;
                [self.goodsButton setTitle:[NSString stringWithFormat:@"%d万+",count]  forState:UIControlStateNormal];
            }else{
                [self.goodsButton setTitle:[NSString stringWithFormat:@"%@",coinCount? coinCount:@"0"]  forState:UIControlStateNormal];
                if ([coinCount isEqualToString:@"null"]) {
                    [self.goodsButton setTitle:@"0"  forState:UIControlStateNormal];
                }
            }
        });
    });
}


//获取打赏界面礼物列表信息
- (void)getServiceData{
    
    NSString *cuid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":cuid}];
    [AFNetwork postRequeatDataParams:params path:PathUserWalletVgoods success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            NSMutableArray *arr = data[@"data"];
            
            self.vGoodsArr = arr;
            
            [self setUI];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self.superController withText:data[@"msg"]];
            [self closeShangView_ds];
        }
        
    }failed:^(NSError *error){

        [LeafNotification showInController:self.superController withText:@"当前网络不太顺畅哟"];
        [self closeShangView_ds];
        
    }];
    
}

//创建打赏请求
-(void)postDashangRequestPhotoId:(NSString *)photoId objectType:(NSString *)object_type vGoodsId:(NSString *)vgood_id jinbi:(NSString *)jinbi vGoodsName:(NSString *)vGoods_name{
    
    
    NSDictionary *payArr = @{@"1":@"0",@"2":@"0",@"3":jinbi};
    
    NSString *pay_info = [SQCStringUtils JSONStringWithDic:payArr];
    
    NSDictionary *params = [AFParamFormat formatPostVgoodsRechargePhotoId:photoId pay_info:pay_info object_type:object_type vgood_id:vgood_id];

    NSString *interfacePath = PathUserReward;
    
    [AFNetwork postRequeatDataParams:params path:interfacePath success:^(id data){
        [MBProgressHUD hideHUDForView:self animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            //打赏成功执行动画
            [self startAnimation];
            [self getUserGoldCount];
            //打赏成功提示信息
            [LeafNotification showInController:self.superController withText:data[@"msg"]];
            
            //发送打赏消息
            //构建一个data字典，作为环信消息的扩展信息(虚拟礼物不需要通过环信)
            NSMutableDictionary *chatMutDic = [NSMutableDictionary dictionary];
            //扩展字典
            NSMutableDictionary *extdic = [NSMutableDictionary dictionary];
            [extdic setObject:[NSString stringWithFormat:@"送了一个%@",vGoods_name] forKey:@"rewardTxt"];
            [extdic setObject:jinbi forKey:@"money"];
            
            NSString *msgTxt = NSLocalizedString(@"message.cantShowGoldMessage", @"");
            NSInteger objedct_typeNum = [object_type integerValue];
            switch (objedct_typeNum) {
                case 6:
                {
                    [chatMutDic setObject:msgTxt forKey:@"msg"];
                    [extdic setObject:@"2" forKey:@"rewardType"];
                    break;
                }
                case 11:{
                    [chatMutDic setObject:msgTxt forKey:@"msg"];
                    [extdic setObject:@"1" forKey:@"rewardType"];
                    break;
                }
                case 17:{
                    [chatMutDic setObject:msgTxt forKey:@"msg"];
                    [extdic setObject:@"3" forKey:@"rewardType"];
                    break;
                }
                default:
                    break;
            }
  
            [self sendDaShangGoldCoinMessage:chatMutDic extDic:extdic];
            
        }else if([data[@"status"] integerValue] == kReLogin){
            //登陆过期
            [self closeShangView_ds];
            [LeafNotification showInController:self.superController withText:data[@"msg"]];
        }else
        {
            [self closeShangView_ds];
            //原有的打赏金额超过限额提示
            [LeafNotification showInController:self.superController withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        
        [self closeShangView_ds];
        [MBProgressHUD hideHUDForView:self animated:YES];
        [LeafNotification showInController:self.superController withText:@"当前网络不太顺畅哟"];
        
    }];
    
    
}



@end
