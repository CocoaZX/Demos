//
//  McSiXinSettingViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/3/10.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McSiXinSettingViewController.h"

@interface McSiXinSettingViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
}


@property (weak, nonatomic) IBOutlet UIButton *closeDaShangSettingBtn;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

//关于布局
@property (nonatomic,assign)CGFloat leftPadding;

//打赏设置选择器
@property(nonatomic,strong)UIWindow *pickerWindow;
@property(nonatomic,strong)UIPickerView *pickerView;
//高度
@property (nonatomic,assign)CGFloat pickerTopViewHeight;
@property (nonatomic,assign)CGFloat pickerViewHeight;

//上次选中的索引
@property(nonatomic,assign)NSInteger lastIndex;


//资源
@property(nonatomic,strong)NSDictionary *userInfoDic;
//金币选择器的数据源
@property(nonatomic,strong)NSArray *pickerSource;


//desc的高度约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constrainForDescLabel_Height;

@end

@implementation McSiXinSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置私信打赏";
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    _userInfoDic = [NSDictionary dictionary];
    //地址选择器
    _pickerTopViewHeight =50;
    _pickerViewHeight = kDeviceHeight/3 -50;
    _leftPadding = 20;
    //初始化设置
    [self _initViews];
    _pickerSource = @[@"1",@"2",@"3"];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUserInfo];
}




- (void)_initViews{
    [self _initNavigationBarItem];
    _descLabel.frame = CGRectMake(20, 90, kDeviceWidth -20*2, 0);
}


//重新布局视图
- (void)resetViews{
    NSString *reward = @"";
    //1.设置按钮显示
    NSString *message_reward_on = _userInfoDic[@"setting"][@"message"][@"message_reward_is_on"];
    if ([message_reward_on isEqualToString:@"0"]) {
        [_closeDaShangSettingBtn setTitle:@"关闭" forState:UIControlStateNormal];
     }else{
        NSString *message_reward = _userInfoDic[@"setting"][@"message"][@"message_reward"];
        [_closeDaShangSettingBtn setTitle:[NSString stringWithFormat:@"%@个金币", message_reward] forState:UIControlStateNormal];
        reward = message_reward;
    }
    
    //2.设置文案显示
    NSString *descTxt = _userInfoDic[@"message_setting_desc"][@"desc"];
    //_descLabel.backgroundColor = [UIColor redColor];
    CGFloat descTxtHight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth -_leftPadding *2 textSize:15];
    _descLabel.text = descTxt;
    _constrainForDescLabel_Height.constant = descTxtHight+10;
 
    //3.picker选择器的数据源
    NSArray *message_rank_rewardArr = [_userInfoDic objectForKey:@"message_rank_reward"];
    NSInteger currLevelNum = [[_userInfoDic objectForKey:@"currLevel"] integerValue];
    NSMutableSet *set = [NSMutableSet set];
    NSInteger loopCount  = currLevelNum >message_rank_rewardArr.count ? message_rank_rewardArr.count :currLevelNum;
    for (int i = 0; i<loopCount; i++) {
        NSDictionary *dic = message_rank_rewardArr[i];
        [set addObject:dic[@"min"]];
        [set addObject:dic[@"max"]];
    }
    //排序装入数组中
    NSArray *numArr = [set allObjects];
    NSArray *sortedArray = [numArr sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        if ([obj1 intValue] < [obj2 intValue]) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    NSLog(@"%@",sortedArray);
    _pickerSource = sortedArray;
    
    //获取默认的_lastIndex;
    if (reward.length != 0) {
        for (int i= 0; i< _pickerSource.count; i++) {
            NSString *str = [NSString stringWithFormat:@"%@",_pickerSource[i]];
            if ([reward isEqualToString:str]) {
                _lastIndex = i;
                break;
            }
        }
    }else{
        _lastIndex = 0;
    }
   
    
}



//初始化视图
- (void)_initNavigationBarItem{
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    rightBtn.tag = 901;
    [rightBtn addTarget:self action:@selector(navigationBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}






- (void)navigationBarItemClick:(UIButton *)btn{
    //当前用户的等级
    NSInteger currLevelNum = [[_userInfoDic objectForKey:@"currLevel"] integerValue];
    if (currLevelNum <2) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        //可改变用户的是否选择了不同的金额设置
        NSString *message_reward = _userInfoDic[@"setting"][@"message"][@"message_reward"];
        if ([message_reward integerValue] == [_pickerSource[_lastIndex] integerValue]) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //需要请求网络设置新的打赏限制
            [self requestForDashanglimite];
        }
    }
}



//打赏设置
- (IBAction)closeDashangSettingBtnClick:(id)sender {
    if (_userInfoDic ) {
        //
        
    }
    [self showPickerView];
    
}







#pragma mark - 显示地址选择器
- (void)showPickerView{
    //顶部区域的高度
    if(_pickerWindow == nil){
        //window
        _pickerWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight + _pickerViewHeight +_pickerTopViewHeight)];
        _pickerWindow.alpha = 0;
        _pickerWindow.hidden = YES;
        _pickerWindow.backgroundColor = [UIColor clearColor];
        //window的遮罩颜色
        UIView *backView = [[UIView alloc] initWithFrame:_pickerWindow.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.alpha = 0.3;
        [_pickerWindow addSubview:backView];
        
        //设置手势属性
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenPickerWindow)];
        [_pickerWindow addGestureRecognizer: singleTap];
        
        //window上的地址视图
        UIView *locationView = [[UIView alloc] initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, _pickerTopViewHeight +_pickerViewHeight)];
        locationView.tag = 3000;
        locationView.backgroundColor = [UIColor cyanColor];
        [_pickerWindow addSubview:locationView];
        
        //顶部按钮区域
        UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, _pickerTopViewHeight)];
        topView.backgroundColor = [CommonUtils colorFromHexString:@"DEDFE1"];
        [locationView addSubview:topView];
        
        //顶部按钮的宽度
        CGFloat topButtonWidth = 60;
        //取消按钮
        UIButton *cancleBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftPadding , 0,topButtonWidth, _pickerTopViewHeight)];
        cancleBtn.tag = 3001;
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [cancleBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
        [cancleBtn addTarget: self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:cancleBtn];
        //完成按钮
        UIButton *completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth -_leftPadding -topButtonWidth , 0, topButtonWidth, _pickerTopViewHeight)];
        completeBtn.tag = 3002;
        [completeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
        [completeBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
        [completeBtn addTarget: self action:@selector(pickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [topView addSubview:completeBtn];
        
        //地址选择器picker
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, topView.bottom, kDeviceWidth , _pickerViewHeight)];
        _pickerView.backgroundColor = [CommonUtils colorFromHexString:@"D8D8D8"];
        [_pickerWindow addSubview:_pickerView];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [locationView addSubview:_pickerView];
        
    }
    //显示地址视图
    _pickerWindow.hidden =NO;
    [_pickerView selectRow:_lastIndex inComponent:0 animated:YES];
    UIView *locationView = [_pickerWindow viewWithTag:3000];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _pickerWindow.alpha = 1;
        locationView.frame = CGRectMake(0, kDeviceHeight-_pickerTopViewHeight -_pickerViewHeight, kDeviceWidth, _pickerTopViewHeight +_pickerViewHeight);
    } completion:^(BOOL finished) {
        //_pickerWindow.hidden = NO;
    }];
    
}


- (void)pickerViewBtnClick:(UIButton *)btn{
    if(btn.tag == 3000) {
        //隐藏地址选择器，不保存数据
        [self hiddenPickerWindow];
    }else{
        //保存数据,并隐藏
        _lastIndex = [_pickerView selectedRowInComponent:0];
        [self updateSetting];
        [self hiddenPickerWindow];
    }
}


- (void)updateSetting{
    //当前选中的索引
    NSInteger selectedIndex = _lastIndex;
    //选中的个数（NSnumber类型）
    NSNumber *selectedNum = [_pickerSource objectAtIndex:selectedIndex];
    NSInteger selectedMoney = [selectedNum integerValue];

    if (selectedMoney == 0) {
        [_closeDaShangSettingBtn setTitle:@"关闭" forState:UIControlStateNormal];
    }else{
        //有选中的金币个数
        [_closeDaShangSettingBtn setTitle:[NSString stringWithFormat:@"%@个金币",selectedNum] forState:UIControlStateNormal];
    }
}


//隐藏地址选择器，并且获取地址编号
- (void)hiddenPickerWindow{
    //隐藏视图
    CGFloat topViewHeight = 50;
    UIView *locationView = [_pickerWindow viewWithTag:3000];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _pickerWindow.alpha = 0;
        locationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight/3+topViewHeight);
    } completion:^(BOOL finished) {
        _pickerWindow = nil;
    }];
}



#pragma mark - pickerView
#pragma mark - 代理方法：pickerView
//返回组
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//返回组中项目数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return _pickerSource.count;
}


//返回的指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSNumber *num = _pickerSource[row];
    if([num integerValue] == 0){
        return [NSString stringWithFormat:@"关闭"];
    }else{
        return [NSString stringWithFormat:@"%@个金币",_pickerSource[row]];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
   // NSString *title = [NSString stringWithFormat:@"%@个金币",_pickerSource[row]];
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}


//选中
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

//返回宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kDeviceWidth;
}

//返回高度
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}





#pragma mark - 获取用户信息
- (void)getUserInfo{
    NSString *uid = [NSString stringWithFormat:@"%@",getCurrentUid()];
    if (!uid) {
        return;
    }
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data) {
        NSLog(@"测试：%@",data);
        _userInfoDic = data[@"data"];
        [self resetViews];
     } failed:^(NSError *error) {
         [LeafNotification showInController:self withText:@"网络请求失败"];
    }];
}


- (void)requestForDashanglimite{
    NSMutableDictionary *mDic= [NSMutableDictionary dictionary];
    if ([_pickerSource[_lastIndex] integerValue] == 0) {
        [mDic setObject:@"0" forKey:@"message_reward_is_on"];
    }else{
        [mDic setObject:@"1" forKey:@"message_reward_is_on"];
    }
    NSString *tempStr = [NSString stringWithFormat:@"%@",_pickerSource[_lastIndex]];
    [mDic setObject:tempStr forKey:@"message_reward"];
    [mDic setObject:getCurrentUid() forKey:@"id"];
    //格式化参数
    NSDictionary *params = [AFParamFormat formatSetForDaShangLimitParams:mDic];
    
    [AFNetwork SetForDaShangLimit:params success:^(id data) {
        NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
        if ([state isEqualToString:@"0"]) {
            [LeafNotification showInController:self withText:@"设置打赏金币成功"];
            [self.navigationController popViewControllerAnimated:YES];
         }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    } failed:^(NSError *error) {
        [LeafNotification showInController:self withText:@"操作失败"];
    }];

 }




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
