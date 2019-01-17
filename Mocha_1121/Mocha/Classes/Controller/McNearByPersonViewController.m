//
//  McNearByPersonViewController.m
//  Mocha
//
//  Created by zhoushuai on 15/12/9.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "McNearByPersonViewController.h"

#import "MDCSwipeToChooseViewOptions.h"
#import "MDCPanState.h"
#import "UIView+MDCSwipeToChoose.h"
#import "NewLoginViewController.h"
#import "DaShangGoodsView.h"

#import "UIView+NextViewController.h"
#define Padding 8.0

#import "PhotoBrowseViewController.h"

@interface McNearByPersonViewController ()<UIAlertViewDelegate>
//预定的附近界面的图片高度
@property (nonatomic,assign)CGFloat imgViewHeight;
//存在用户划过的图片的uid和photo
@property (nonatomic,strong)NSDictionary *userDic;
//计时
@property (nonatomic,assign)int timeCount;

@property (nonatomic,assign)BOOL isRequestData;
//一个临时存放的变量，记录需要存入哪个方向已经给过滑动提示
@property (nonatomic,copy)NSString *needSaveSwipLog;

//打赏视图
@property (nonatomic,strong) DaShangGoodsView *dashangView;
@property (nonatomic,strong) UILabel *plusLable;
@property (nonatomic,strong) UIImageView *goodsImage;
@property (nonatomic,strong) NSArray *bigImgArr;

@end

@implementation McNearByPersonViewController
#pragma mark - Object Lifecycle

-(NSArray *)bigImgArr{
    if (!_bigImgArr) {
        
        _bigImgArr = MCAPI_Data_Object1(VGOODSIMG_BIG);
    }
    return _bigImgArr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
      }
    return self;
}

#pragma mark - UIViewController Overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //初始化参数
    _pageSize = @"20";
    _peoples = [NSMutableArray array];
    CGFloat width  = CGRectGetWidth(self.view.frame) - (10 * 2);
    if([CommonUtils getRuntimeClassIsIphone]){
        _imgViewHeight = width;
    }else{
        _imgViewHeight =width/10*7-10;
    }

    //请求数据
    [self LoadNearbyPersonsDataWithIndex:_lastIndex];
    [self addButtons];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animationWithText:) name:@"MainNearGoodsAnimation" object:nil];
}


//每次界面出现都重新请求数据
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}



//请求数据
- (void)LoadNearbyPersonsDataWithIndex:(NSString *)lastIndex{
    //如果没有请求数据
    if (_isRequestData) {
        //正在请求数据
        return;
    }else{
        //没有在请求数据，执行此次请求
        
    }
    //标记当前正在请求数据
    _isRequestData = YES;
    
    //开启加载定时器,
    if (_loadTimer == nil) {
        _loadTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(loadTimerAction) userInfo:nil repeats:YES];
    }
    [_loadTimer fire];
    //显示加载视图
    [self showLoadingView:YES];
    //关闭按钮的可点击
    [self closeButtons];
    //请求数据

    
    //uid
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        [dict setValue:uid forKey:@"uid"];
    }
    
    //坐标
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //定位功能可用，开始定位
         }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        NSString *title = @"您还没有打开定位服务，使用定位才能准确找到更多附近的人哦";
        _alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        _alertView .tag = 4000;
        [_alertView show];
    }
    
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lng = Longitude;
    [dict setValue:[NSNumber numberWithDouble:lat] forKey:@"lat"];
    [dict setValue:[NSNumber numberWithDouble:lng]  forKey:@"lon"];
    //每次请求的个数
    [dict setValue:_pageSize forKey:@"pagesize"];
    //设置rd
    NSDictionary *personDic = [USER_DEFAULT objectForKey:@"nearbyPersonDic"];
    if (personDic ==nil) {
        [USER_DEFAULT setObject:@{} forKey:@"nearbyPersonDic"];
        [USER_DEFAULT synchronize];
    }
    NSDictionary *tempDic = [USER_DEFAULT objectForKey:@"nearbyPersonDic"];
    if (tempDic.count>0) {
        NSString *jsonData = [self JSONStringWithDic:tempDic];
        [dict setValue:jsonData forKey:@"rd"];
        
    }else{
        
    }
    
     NSDictionary *params = [AFParamFormat formatGetNearByPersonsParams:dict];
    //mainUserIndex  getNearByPersonsData
    [AFNetwork getNearByPersonsData:params success:^(id data) {
        //清空存储内容
        [USER_DEFAULT setObject:@{} forKey:@"nearbyPersonDic"];
        [USER_DEFAULT synchronize];
        
        //数据
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *tempData = data[@"data"];
            _peoples = [NSMutableArray arrayWithArray:tempData];
            if(tempData.count>0){
                [self refreshView];
                //显示底部按钮并且打开可点击
                [self hiddenButtons:NO];
                [self openButtons];
                
                //布局动画背后视图
//                [self viewForAnimation];
                
                //是否显示打赏按钮
                BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
                if (isAppearShang) {
                    //显示打赏
                    _daShangBtn.hidden =NO;
                }else{
                    //隐藏打赏
                    _daShangBtn.hidden =YES;
                }
                //显示加载载视图
                [self showLoadingView:YES];

            }
        }else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }else
        {
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"%@",data[@"msg"]]];
        }
        
        _isRequestData = NO;
    } failed:^(NSError *error) {
         if(!_frontCardView){
            [LeafNotification showInController:self withText:@"搜索附近的人失败"];
            [self hiddenButtons:YES];
             AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
             BOOL netIsAviliable = [delegate isNetWorkReachable];
             if (netIsAviliable) {
             //网络可用,此时请求失败，非网络问题
             [_loadTimer invalidate];
             _loadTimer  = nil;
             }else{
             //网络问题引起的失败，则开启网络监听，有网时候请求数据
             [self startNetMonitoring];
             }
        }
        
        _isRequestData = NO;
     }];
}


//创建三个视图，同时也是在每次数据加载之后刷新视图的方法
- (void)refreshView{
    //上
    if (!self.frontCardView) {
        self.frontCardView = [self popPersonViewWithFrame:[self frontCardViewFrame]];
        self.frontCardView.userInteractionEnabled = YES;
        [self.view addSubview:self.frontCardView];
    }
    //中
    if (!self.centerCardView) {
        self.centerCardView = [self popPersonViewWithFrame:[self centerCardViewFrame]];
        //插入到上层视图下面
        [self.view insertSubview:self.centerCardView belowSubview:self.frontCardView];
    }
    //下:
    if(!self.backCardView){
        self.backCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        //插入到中间视图的下面
        [self.view insertSubview:self.backCardView belowSubview:self.centerCardView];
     }
    
    //底：
    //最底部视图,在倒数第二层上，拖动的时候没有动画，只有移除视图时才有动画
    if (!self.bottomCardView) {
        self.bottomCardView = [self popPersonViewWithFrame:[self backCardViewFrame]];
        //插入到中间视图的下面
        [self.view insertSubview:self.bottomCardView belowSubview:self.backCardView];
    }
}



//- (NSUInteger)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

#pragma mark - MDCSwipeToChooseDelegate Protocol Methods
#pragma mark 动画的代理方法
//滑动距离不够调用
- (void)viewDidCancelSwipe:(UIView *)view {
    
    if ([_currentPersonData objectForKey:@"nickname"] != [NSNull null]) {
        
    }
    
    //如果没有登陆，要提示登录
    NSString *uid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    if (!uid) {
        [self goToLoginVC];
        return;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        _cancelBtn.transform = CGAffineTransformIdentity;
        _dianzanBtn.transform = CGAffineTransformIdentity;
    }];
 }


//发送之前的选择。返回“0”,视图不会切换
//返回1，此次的选择是成功的，视图将会切换
- (BOOL)view:(UIView *)view shouldBeChosenWithDirection:(MDCSwipeDirection)direction{
    //如果没有登陆，要提示登录
    NSString *uid = [[USER_DEFAULT objectForKey:MOKA_USER_VALUE] objectForKey:@"id"];
    if (!uid) {
        _frontCardView.nopeView.alpha = 0;
        _frontCardView.likedView.alpha = 0;
        _cancelBtn.transform = CGAffineTransformIdentity;
        _dianzanBtn.transform = CGAffineTransformIdentity;
         return 0;
    }
    
    //检查是不是第一次使用附近功能,给出提示
    //一个bool值判断是不是第一使用左滑和右滑的功能
    BOOL noFirstSwip= false;
    NSString *alertTitle = @"";
    NSString *alertInfo = @"";
    if(direction ==  MDCSwipeDirectionLeft){
        noFirstSwip  = [[NSUserDefaults standardUserDefaults] boolForKey:@"noFirstUseNearbyLeft"];
        //左滑
        alertTitle = @"不感兴趣";
        alertInfo = @"滑到左侧代表你对这张照片不感兴趣";
        _needSaveSwipLog = @"noFirstUseNearbyLeft";
 
    }else{
        noFirstSwip  = [[NSUserDefaults standardUserDefaults] boolForKey:@"noFirstUseNearbyRight"];
        //右滑
        alertTitle = @"照片点赞";
        alertInfo = @"滑到右侧代表你赞了这张照片，对方可以收到你的点赞";
        _needSaveSwipLog = @"noFirstUseNearbyRight";

    }
    //为真值，说明是第一次使用滑动
    if(!noFirstSwip){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle message:alertInfo delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        alertView.tag = 3000;
        [alertView show];
    }
    
    //切换了视图，此时就变化视图
    [self finishChooseView:direction];
    [self closeButtons];
    
    //按钮的变化
    if(direction ==UISwipeGestureRecognizerDirectionRight){
        //执行动画
        [UIView animateWithDuration:0.2 animations:^{
            _cancelBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                _cancelBtn.transform = CGAffineTransformIdentity;
            }];
        }];
     }else if(direction == UISwipeGestureRecognizerDirectionLeft){
         //执行动画
         [UIView animateWithDuration:0.2 animations:^{
             _dianzanBtn.transform = CGAffineTransformMakeScale(1.5, 1.5);
         } completion:^(BOOL finished) {
             [UIView animateWithDuration:0.2 animations:^{
                 _dianzanBtn.transform = CGAffineTransformIdentity;
             }];
         }];
    }
    return 1;
}




//确定已经完成了选择,视图开始移动
- (void)finishChooseView:(MDCSwipeDirection)direction{
    //点赞
    if (direction == MDCSwipeDirectionLeft) {
        
    } else {
        if ([_currentPersonData objectForKey:@"nickname"] != [NSNull null]) {
            
        }
        //右方向滑动点赞
        [self addLike];
        
    }

    
    //确定要滑动了之后，记录下次请求数据需要的参数
    //photoid uid
    @try {
        //取出字典
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT objectForKey:@"nearbyPersonDic"]];
        //取出
        NSMutableArray *mPhotosArr;
        if ([tempDic objectForKey:@"photos"]) {
            mPhotosArr = [NSMutableArray arrayWithArray:[tempDic objectForKey:@"photos"]];
        }else{
            mPhotosArr = [NSMutableArray array];
        }
        NSMutableArray *mPeopleArr;
        if ([tempDic objectForKey:@"people"]) {
            mPeopleArr = [NSMutableArray arrayWithArray:[tempDic objectForKey:@"people"]];
        }else{
            mPhotosArr = [NSMutableArray array];
        }
        //存
        [mPhotosArr addObject:[_currentPersonData objectForKey:@"photoid"]];
        [mPeopleArr addObject:[_currentPersonData objectForKey:@"uid"]];
        //去重
        NSMutableSet *mSet = [NSMutableSet set];
        //对photos去重
        [mSet addObjectsFromArray:mPhotosArr];
        mPhotosArr = [NSMutableArray arrayWithArray:[mSet allObjects]];
        //对people去重
        [mSet removeAllObjects];
        [mSet addObjectsFromArray:mPeopleArr];
        mPeopleArr = [NSMutableArray arrayWithArray:[mSet allObjects]];
        [tempDic setValue:mPhotosArr forKey:@"photos"];
        [tempDic setValue:mPeopleArr forKey:@"people"];
        
        [USER_DEFAULT setObject:tempDic forKey:@"nearbyPersonDic"];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }

    //打开下层视图的手势
    self.centerCardView.userInteractionEnabled =YES;
    //切换视图
    [self changeViews];
}


//切换视图
- (void)changeViews{
    NearByPersonView *tempView1 = self.frontCardView;
    self.frontCardView = self.centerCardView;
    tempView1 = nil;
    self.centerCardView = self.backCardView;
    self.backCardView = self.bottomCardView;
    //创建最低层的视图
    if ((self.bottomCardView = [self popPersonViewWithFrame:[self backCardViewFrame]])) {
        //Fade the back card into view.
        self.bottomCardView.alpha = 0.f;
        [self.view insertSubview:self.bottomCardView belowSubview:self.backCardView];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.bottomCardView.alpha = 1.f;
                         } completion:nil];
    }

}




#pragma mark - Internal Methods（重置视图的操作）
- (void)setFrontCardView:(NearByPersonView *)frontCardView {
    // Keep track of the person currently being chosen.
    // Quick and dirty, just for the purposes of this sample app.
    _frontCardView = frontCardView;
    
    //_frontCardView.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.1 animations:^{
        _frontCardView.frame = [self frontCardViewFrame];
    } completion:^(BOOL finished) {
        //
        [self openButtons];

    }];
    self.currentPersonData = frontCardView.personData;
}

- (void)setCenterCardView:(NearByPersonView *)centerCardView{
    _centerCardView = centerCardView;
    [UIView animateWithDuration:0.3 animations:^{
        _centerCardView.frame = [self centerCardViewFrame];
    }];
}

- (void)setBackCardView:(NearByPersonView *)backCardView{
    _backCardView = backCardView;
    [UIView animateWithDuration:0.3 animations:^{
        _backCardView.frame = [self backCardViewFrame];
    }];

}


//创建选择视图
- (NearByPersonView *)popPersonViewWithFrame:(CGRect)frame {
    if ([self.peoples count] == 0) {
        //[self LoadNearbyPersonsDataWithIndex:_lastIndex];
        if (_frontCardView ==nil) {
            //请求数据，开始请求数据
            [self LoadNearbyPersonsDataWithIndex:_lastIndex];
            [self hiddenButtons:YES];
            [self openButtons];
            [self showLoadingView:YES];
        }
        return nil;
    }
    // UIView+MDCSwipeToChoose and MDCSwipeToChooseView are heavily customizable.
    // Each take an "options" argument. Here, we specify the view controller as
    // a delegate, and provide a custom callback that moves the back card view
    // based on how far the user has panned the front card view.
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.threshold = 30;
    //当视图被拖动平移的时候执行时候调用
    options.onPan = ^(MDCPanState *state){
        //中间的视图
        //scale 显示了拖动的幅度
        //最大拖动距离下，centerCardView的frame与frontCardView相同
        //此时可以连续滑动
        CGRect frame = [self centerCardViewFrame];
        CGFloat scale = state.thresholdRatio;
          self.centerCardView.frame =
                    CGRectMake(frame.origin.x-Padding*scale,
                                frame.origin.y-Padding *3*scale,
                               CGRectGetWidth(frame)+scale *Padding*2,
                               CGRectGetHeight(frame)+scale*Padding*2);
        
        //back的视图
        CGRect backframe = [self backCardViewFrame];
         self.backCardView.frame =
            CGRectMake(backframe.origin.x-Padding*scale,
                       backframe.origin.y - scale*Padding*3,
                        CGRectGetWidth(backframe)+scale*Padding*2,
                       CGRectGetHeight(backframe) +scale*Padding *2);
        
        //按钮的变化
        if(state.direction ==UISwipeGestureRecognizerDirectionRight){
            _cancelBtn.transform = CGAffineTransformMakeScale(1+scale*0.5, 1+scale*0.5);

        }else if(state.direction == UISwipeGestureRecognizerDirectionLeft){
            _dianzanBtn.transform = CGAffineTransformMakeScale(1+scale*0.5, 1+scale*0.5);
        }
     };
    
    // Create a personView with the top person in the people array, then pop
    // that person off the stack.
   NearByPersonView *personView = [[NearByPersonView alloc]
                                   initWithFrame:frame
                                        person:self.peoples[0]
                                       options:options];
   
    personView.superNVC = self.superNVC;
    
   [self.peoples removeObjectAtIndex:0];
    //NSLog(@"count:;%ld",[_peoples count]);
    
     return personView;
}

#pragma mark View Contruction（创建视图）
//上视图
- (CGRect)frontCardViewFrame {
    //水平间距
    CGFloat horizontalPadding = 10.f;
    //据顶部高度
    CGFloat topPadding = 10.f;
    //CGFloat bottomPadding = 250.f;
    return CGRectMake(horizontalPadding,
                      topPadding,
                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
                       _imgViewHeight+70);
//    return CGRectMake(horizontalPadding,
//                      topPadding,
//                      CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
//                      CGRectGetHeight(self.view.frame) - bottomPadding);
}

//中视图
- (CGRect)centerCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x+Padding,
                      frontFrame.origin.y + Padding *3,
                      CGRectGetWidth(frontFrame) -Padding *2,
                      CGRectGetHeight(frontFrame)-Padding *2);
}


//底部视图
- (CGRect)backCardViewFrame {
    CGRect centerFrame = [self centerCardViewFrame];
    return CGRectMake(centerFrame.origin.x+Padding,
                      centerFrame.origin.y + Padding *3,
                      CGRectGetWidth(centerFrame) -Padding*2,
                      CGRectGetHeight(centerFrame)-Padding *2);
}


//
- (void)addButtons{
    //CGFloat bottomPadding = 100.f;
    //取消按钮
    CGFloat padding = (kDeviceHeight - 64 -10 -_imgViewHeight - 70 -Padding *2-kTabBarHeight -70)/2;
    CGFloat height = 10 +_imgViewHeight + 70 + Padding *2 +padding;
    
    _cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, height, 70, 70)];
    _cancelBtn.tag = 101;
    [_cancelBtn setImage:[UIImage imageNamed:@"quxiao"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self
               action:@selector(changeViewButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.exclusiveTouch = YES;
    [self.view addSubview:_cancelBtn];
    
    
    //添加打赏的button
    _daShangBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth -70)/2,height, 70, 70)];
    NSLog(@"%@",_daShangBtn);
    [_daShangBtn setImage:[UIImage imageNamed:@"dashang2"] forState:UIControlStateNormal];
    [_daShangBtn addTarget:self action:@selector(showDashangView) forControlEvents:UIControlEventTouchUpInside];

    
    _daShangBtn.exclusiveTouch = YES;
    [self.view addSubview:_daShangBtn];
    

    //右侧按钮
    _dianzanBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth -70- 30, height, 70, 70)];
    _dianzanBtn.tag = 102;
     [_dianzanBtn setImage:[UIImage imageNamed:@"dianzan"] forState:UIControlStateNormal];
    [_dianzanBtn addTarget:self
               action:@selector(changeViewButtonClick:)
     forControlEvents:UIControlEventTouchUpInside];
    _dianzanBtn.exclusiveTouch = YES;
    [self.view addSubview:_dianzanBtn];
    
    //默认隐藏按钮
    [self hiddenButtons:YES];
}


//是否隐藏按钮
- (void)hiddenButtons:(BOOL)show{
    _cancelBtn.hidden = show;
    _daShangBtn.hidden = show;
    _dianzanBtn.hidden = show;
}

//关闭所有按钮的可点击
-(void)closeButtons{
    _cancelBtn.userInteractionEnabled = NO;
    _daShangBtn.userInteractionEnabled = NO;
    _dianzanBtn.userInteractionEnabled = NO;
}

//打开按钮可以点击
- (void)openButtons{
    _cancelBtn.userInteractionEnabled = YES;
    _daShangBtn.userInteractionEnabled = YES;
    _dianzanBtn.userInteractionEnabled = YES;
}


#pragma mark Control Events（触发事件的操作）
// Programmatically "nopes" the front card view.
//切图按钮点击触发
//点击之后设置所有按钮都是不可点击
- (void)changeViewButtonClick:(UIButton *)button{
//切换图片的时候不能再点击
    [self closeButtons];
    if (button.tag == 101) {
        //nope
        [self nopeFrontCardView:button];
     }else{
         //like
        [self likeFrontCardView:button];
     }
}


//切换视图
- (void)nopeFrontCardView:(UIButton *)btn{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionLeft];
 }

- (void)likeFrontCardView:(UIButton *)btn{
    [self.frontCardView mdc_swipe:MDCSwipeDirectionRight];
}


//给图片点赞
- (void)addLike{
    {
        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        //如果没有登录，进入登录界面
         if (!uid) {
            [self goToLoginVC];
            return;
        }
        
        NSString *photoId = _currentPersonData[@"photoid"];
        NSDictionary *dict = [AFParamFormat formatLikeActionParams:photoId userId:uid];
        [AFNetwork likeAdd:dict success:^(id data){
            NSLog(@"点赞data:%@",data);
            if ([data[@"status"] integerValue] == kRight) {
                NSLog(@"点赞-%@,成功",photoId);
                //[LeafNotification showInController:self withText:@"点赞成功"];
            }else{
                //[LeafNotification showInController:self withText:data[@"msg"]];
            }
        }failed:^(NSError *error){
            //[LeafNotification showInController:self withText:@"%操作失败"];
         }];
    }
}

//打赏虚拟礼物
-(void)showDashangView{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    //如果没有登录，进入登录界面
    if (!uid) {
        [self goToLoginVC];
        return;
    }
    
    //图片主人的id号
    NSString *CurrentUid =_currentPersonData[@"uid"];
    if (!CurrentUid) {
        return;
    }
    
    self.dashangView = [[DaShangGoodsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.dashangView.superNVC = self.superNVC;
    self.dashangView.animationType = @"dashangWithNoAnimation";
    self.dashangView.dashangType = @"6";
    self.dashangView.targetUid = CurrentUid;
    self.dashangView.currentPhotoId =_currentPersonData[@"photoid"];

    [self.dashangView setUpviews];
    [self.dashangView addToWindow];
    
//    [self.view addSubview:self.dashangView];
    
}

#pragma mark 通知执行动画


//首页附近功能送礼物动画
-(void)animationWithText:(NSNotification *)text{
    
    //动画期间界面禁用
    self.superNVC.view.userInteractionEnabled = NO;
    _plusLable = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-45, 50, 40, 25)];
    _plusLable.center = CGPointMake(self.daShangBtn.center.x+10, self.daShangBtn.center.y - 40);
    _plusLable.text = @"+1";
    _plusLable.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _plusLable.alpha = 0;
    
    [self.view addSubview:_plusLable];
    
    //1.取到选择礼物显示到view上
    NSString *dataStr = text.userInfo[@"imgData"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:dataStr];
    UIImage *image = [[UIImage alloc]initWithData:data];
    _goodsImage = [[UIImageView alloc]initWithImage:image];
    
    [_goodsImage sizeToFit];
    _goodsImage.center = CGPointMake(kDeviceWidth*0.5, kDeviceHeight*0.5-100);
    
    [self.view addSubview:_goodsImage];
    //购物车动画

    self.goodsImage.hidden = NO;
    
    //2.抛物线动画
    CAAnimationGroup *group = [[CAAnimationGroup alloc]init];
    
    CAKeyframeAnimation *goodsAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPoint startP = CGPointMake(kDeviceWidth*0.5, kDeviceHeight*0.5-100);
    CGPoint endP = self.daShangBtn.center;
    
    
    CGPathMoveToPoint(thePath, NULL, startP.x, startP.y);
    CGPathAddQuadCurveToPoint(thePath, NULL, 200, 200, endP.x, endP.y);
    
    goodsAnimation.path = thePath;
    
    //图片缩放动画
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.1];
    scaleAnimation.autoreverses = NO;
    
    group.animations = @[scaleAnimation,goodsAnimation];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [_goodsImage.layer addAnimation:group forKey:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            //礼物加1动画效果
            self.plusLable.alpha = 1;
            
            
            [UIView animateWithDuration:1 animations:^{
                _plusLable.alpha = 0;
                _goodsImage.alpha = 0;
                _plusLable.center = CGPointMake(self.plusLable.center.x, self.plusLable.center.y - 25);
                
            }];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [_plusLable removeFromSuperview];
                [_goodsImage removeFromSuperview];
                
                self.superNVC.view.userInteractionEnabled = YES;
            });
            
        });
        
    });

}

//给图片打赏红包界面
- (void)daShang{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //如果没有登录，进入登录界面
    if (!uid) {
        [self goToLoginVC];
        return;
    }
    
    //图片主人的id号
     NSString *CurrentUid =_currentPersonData[@"uid"];
    if (!CurrentUid) {
        return;
    }
    //图片的编号
    NSString *photoId =_currentPersonData[@"photoid"];
    
    PhotoBrowseViewController *browseVC = [[PhotoBrowseViewController alloc] init];
    browseVC.firstShowDaShang = YES;
    browseVC.startWithIndex = 0;
    browseVC.currentUid = CurrentUid;
    
    [browseVC setDataFromPhotoId:photoId uid:CurrentUid];
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    [self.superNVC pushViewController:browseVC animated:YES];
    
    
 }


//显示加载资源的动画
- (void)showLoadingView:(BOOL)show{
    if (show) {
        if (_loadingView == nil){
            _loadingView = [[UIView alloc] initWithFrame:self.view.bounds];
            _loadingView.backgroundColor = [UIColor whiteColor];
            
            //uiimgView
            _loadingImgView = [[UIImageView alloc] initWithFrame:CGRectMake((_loadingView.width-50)/2, 150, 50, 50)];
            NSMutableArray *marr = [NSMutableArray array];
            for (int i = 1; i<9;i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d.tiff",i]];
                [marr addObject:image];
            }
            _loadingImgView.animationDuration = 1;
            _loadingImgView.animationImages = marr;
            [_loadingView addSubview:_loadingImgView];
            
            _loadingLabel  = [[UILabel alloc] initWithFrame:CGRectMake((_loadingView.width-200)/2, _loadingImgView.bottom +20, 200, 30)];

            //使用文案
            //默认设置
            _loadingLabel.text  = @"正在搜索附近的美图...";
            _loadingLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
            _loadingLabel.textAlignment = NSTextAlignmentCenter;
            [_loadingView addSubview:_loadingLabel];
            //添加加载视图
            [self.view addSubview:_loadingView];
        }
        
         //执行动画
        if ([_loadingImgView isAnimating]) {
        }else{
            [_loadingImgView startAnimating];
        }
        //将记载视图提到最上层
        
        [self.view bringSubviewToFront:_loadingView];
        
    }else{
        if (_loadingView) {
            //关闭动画
            if([_loadingImgView isAnimating]){
                [_loadingImgView stopAnimating];
            }
            //隐藏加载视图
            [UIView animateWithDuration:0.5 animations:^{
                _loadingView.alpha = 0;
            } completion:^(BOOL finished) {
                [_loadingView removeFromSuperview];
                _loadingImgView = nil;
                _loadingLabel = nil;
                _loadingView = nil;
            }];

        }else{
            return;
        }
     }
}





//在未登录的状态下点赞和打赏都要首先登陆
- (void)goToLoginVC{
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT setObject:nil forKey:MOKA_USER_VALUE];
    [USER_DEFAULT synchronize];
    NewLoginViewController *login = [[NewLoginViewController alloc] initWithNibName:@"NewLoginViewController" bundle:[NSBundle mainBundle]];
    [self.superNVC pushViewController:login animated:YES];
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //这是判断是否第一次滑动给出提示的alertview的处理
    if (alertView.tag == 3000) {
        [USER_DEFAULT setBool:YES forKey:_needSaveSwipLog];
    }
    
    //判断是否打开地图服务的alertView
    if (alertView.tag == 4000) {
        
        if (buttonIndex == 0) {
            //取消
        }else{
            //选择确定引导用户进入设置打开定位服务
            [self OpenLocationSetting];
        }
    }
    
}

//打开位置设置
-(void)OpenLocationSetting{
    NSString *str = @"prefs:root=LOCATION_SERVICES";
    NSURL *url = [NSURL URLWithString:str];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}


#pragma mark 定时器任务
- (void)loadTimerAction{
    _timeCount =  _timeCount +1;
    [self showLoadingView:YES];
    if (_timeCount >3 &&_peoples.count>0) {

        [self showLoadingView:NO];
        [_loadTimer invalidate];
        _loadTimer = nil;
        _timeCount = 0;
    }else{
        if (_loadingView) {
            [self.view bringSubviewToFront:_loadingView];
        }
    }

}


//开启网路检测,如果网路重连就开始记载新数据
- (void)startNetMonitoring{
    if (_netTimer == nil) {
        _netTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkNetStatus) userInfo:nil repeats:YES];
    }
    [_netTimer fire];

}

//检查网络状态，网络重连之后会重新请求数据
- (void)checkNetStatus{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BOOL netIsAviliable = [delegate isNetWorkReachable];
    
    if (netIsAviliable) {
        [_netTimer invalidate];
        _netTimer  = nil;
        [self LoadNearbyPersonsDataWithIndex:_lastIndex];
    }
}

//处理json数据
- (NSString*)JSONStringWithDic:(NSDictionary *)diction
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:diction
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}


- (void)dealloc{
    
}

@end
