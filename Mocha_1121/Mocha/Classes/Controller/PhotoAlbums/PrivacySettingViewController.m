//
//  PrivacySettingViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/14.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "PrivacySettingViewController.h"

@interface PrivacySettingViewController ()

//视图=================
@property(nonatomic,strong)UILabel *descLabel;
@property(nonatomic,strong)UIImageView *chekcImgView;


//参数==================
//距离顶部的距离
@property(nonatomic,assign)CGFloat topPadding;
//距离左边的距离
@property(nonatomic,assign)CGFloat leftPadding;
//按钮宽度
@property(nonatomic,assign)CGFloat buttonWidth;
//按钮的高度
@property(nonatomic,assign)CGFloat buttonHeight;
//按钮之间的间距
@property(nonatomic,assign)CGFloat buttonPadding;


//button的显示内容数组
@property(nonatomic,strong)NSMutableArray *goldSettingArr;

@end

@implementation PrivacySettingViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"私密相册";
    _leftPadding = 30;
    _topPadding = 50;
    _buttonPadding = 50;
    _buttonWidth = (kDeviceWidth - _leftPadding*2 -_buttonPadding)/2;
    _buttonHeight = 50;
    //读取本地金额设置数
    [self getSettingData];
    
    //设置到导航栏
    [self setNavigationBar];
    [self _initViews];
 }

//设置导航栏
- (void)setNavigationBar{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

- (void)_initViews{
    //设置说明
    NSString *descTxt = @"对方需要支付一定数量的金币后才能够查看大图,下载原图。请设置需要支付金币的数量";
    CGFloat labelHeight = [SQCStringUtils getCustomHeightWithText:descTxt viewWidth:kDeviceWidth - _leftPadding *2 textSize:16];
    _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, _topPadding, kDeviceWidth - _leftPadding *2, labelHeight)];
    _descLabel.text = descTxt;
    _descLabel.numberOfLines = 0;
    _descLabel.font = [UIFont systemFontOfSize:16];
    _descLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
    [self.view addSubview:_descLabel];
    
    //按钮选项
    //行与列
    NSInteger row = 0;
    NSInteger cols = 0;
    for (int i = 0; i<_goldSettingArr.count; i++) {
        //当前行
        if ((i%2) ==0) {
            row ++;
        }
        //当前列
        cols = i%2;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(_leftPadding +cols *(_buttonWidth +_buttonPadding), _descLabel.bottom + (_topPadding -20) +(row -1) *(_buttonHeight +_buttonPadding/3), _buttonWidth, _buttonHeight)];
        btn.tag = 100+i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [btn setTitle:[NSString stringWithFormat:@"%@金币",_goldSettingArr[i]] forState:UIControlStateNormal];
        btn.layer.cornerRadius = 8;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
     }
    
    UIButton *btn = [self.view viewWithTag:100+_goldSelectedIndex];
    //选中的图片
    _chekcImgView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.right -13.5,btn.center.y-9 , 27, 18)];
    _chekcImgView.image = [UIImage imageNamed:@"onRed"];
    [self.view addSubview:_chekcImgView];

}


#pragma mark - 获取数据
- (void)getSettingData{
    NSArray *arr = @[@"50",@"88",@"188",@"388",@"520",@"1314"];
    NSArray *configArr = [USER_DEFAULT objectForKey:@"album_private_coin"];
    if (configArr) {
        arr = configArr;
    }
    
    [self.goldSettingArr removeAllObjects];
    [self.goldSettingArr addObjectsFromArray:arr];
    for (int i = 0; i<self.goldSettingArr.count; i++) {
        if([_goldCountStr isEqualToString:_goldSettingArr[i]]){
            _goldSelectedIndex = i;
            break;
        }
    }
}


#pragma mark - 事件点击
- (void)btnClick:(UIButton *)btn{
    _goldSelectedIndex = btn.tag - 100;
    [UIView animateWithDuration:0.3
                     animations:^{
                         _chekcImgView.frame = CGRectMake(btn.right -13.5,btn.center.y-9 , 27, 18);
                       }];

}

//确定图片选择
- (void)sureBtnClick:(UIButton *)btn{
    self.superVC.goldCountStr = _goldSettingArr[_goldSelectedIndex];
     [self.navigationController popViewControllerAnimated:YES];
}





#pragma mark - get/set
- (NSMutableArray *)goldSettingArr{
    if (_goldSettingArr == nil) {
        _goldSettingArr = [NSMutableArray array];
    }
    return  _goldSettingArr;
}
@end
