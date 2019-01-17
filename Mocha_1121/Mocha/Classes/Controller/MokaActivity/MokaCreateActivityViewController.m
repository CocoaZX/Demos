//
//  MokaCreateActivityViewController.m
//  Mocha
//
//  Created by zhoushuai on 16/1/29.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MokaCreateActivityViewController.h"

#import "McProvinceViewController.h"
#import "McEditBirthViewController.h"
#import "McWebViewController.h"
#import "ReadPlistFile.h"

#import "JSONKit.h"
#import "NSDate+Category.h"


@interface MokaCreateActivityViewController ()<UITextFieldDelegate,
    UITextViewDelegate,
    UIScrollViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    UIPickerViewDataSource,
    UIPickerViewDelegate>

//==========视图组件============
//点击更多详情
@property (nonatomic,strong)UIControl *moreDetailControlView;
//输入标题
@property (strong,nonatomic)UIView *titleView ;
//输入费用
@property (strong,nonatomic)UIView *feeView;
//选择地区
@property (strong,nonatomic)UIControl *addressCtrl;
//选择时间
@property (strong,nonatomic)UIButton *startTimeBtn ;
@property (strong,nonatomic)UIButton *stopTimeBtn ;
//输入活动详情
@property (nonatomic,strong)UIView *detailView;
@property (nonatomic,strong)UITextView *detailTxtView;
//添加图片,底部大视图
@property (strong, nonatomic) UIView *addImageView;
//发布活动显示进度
@property (strong, nonatomic) MBProgressHUD *hud;
//导航栏上按钮
@property (strong,nonatomic)UIButton *rightButton ;



//===========地址选择器相关属性========
@property (strong,nonatomic)UIWindow *pickerWindow;
//选择器
@property (strong,nonatomic)UIPickerView *pickerView;
//关于地址的设置的相关属性
//省份和相应的城市
@property (nonatomic , strong)NSMutableArray *areaArray;
@property (nonatomic , strong)NSMutableArray *cityArray;

//当前第一列的选中行：用于刷新数据
@property (nonatomic , assign)NSInteger selectedRow;
//上一次完成选择时，省份和城市的索引
@property (nonatomic, assign)NSInteger provinceArrayIndex;
@property (nonatomic, assign)NSInteger cityArrayIndex;


//=========添加图片时相关属性==========
//添加图片的视图，视图的宽度
@property (assign,nonatomic)CGFloat imageWidth;
//每行的图片的个数
@property (assign,nonatomic)NSInteger rowItemCount;
//至少上传图片的个数
@property(assign,nonatomic)NSInteger upLoadLimit_min;
//最多上传图片的个数
@property(assign,nonatomic)NSInteger upLoadLimit_max;

//已将添加的图片构成的数组
@property (strong, nonatomic) NSMutableArray *imageArray;
//图片的链接
@property(strong,nonatomic)NSMutableDictionary *imgLinkDic;
//图片的宽高
@property(strong,nonatomic)NSMutableDictionary *imgPropertyDic;
//图片链接
@property (strong,nonatomic)NSMutableArray *imgUrlArray;
//当前正在操作的图片
@property(assign,nonatomic)NSInteger imgageCurrentIndex;


//=======整体布局相关属性
//字体大小
@property (assign,nonatomic)CGFloat fontSize;
//视图距离两边的距离
@property (assign,nonatomic)CGFloat leftPadding;
//每个视图组价行间距
@property (assign ,nonatomic)CGFloat lineSpace;

//高度
@property (nonatomic,assign)CGFloat pickerTopViewHeight;
@property (nonatomic,assign)CGFloat pickerViewHeight;




//===========中间变量=================
//顶部点击查看详情使用的ULR链接
@property (nonatomic,strong)NSString *enterDetailWebUrl;
//关于服务器端对活动标题的限制
@property (nonatomic , strong) NSMutableDictionary *eventTitleLimDic;
//服务器对于图片上传个数的限制
@property (nonatomic,strong)NSMutableDictionary *imgCountLimitDic;
//@property (nonatomic,strong)


//textFeild数组
@property (strong, nonatomic) NSMutableArray *textFieldArray;
//默认详情提示文字
@property (copy,nonatomic)NSString *defaultDetailTxt;
//当前是处于编辑状态
@property (assign,nonatomic)BOOL isEditting;


@end


@implementation MokaCreateActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    //标题
    if(_TypeNum == 1){
        self.title = @"招募通告";
    }else if(_TypeNum == 2){
        self.title = @"众筹活动";
    }else if(_TypeNum == 3){
        self.title = @"活动海报";
    }

    //字体大小
    _fontSize = 15;
    //左边间距
    _leftPadding = 20;
    //行间距
    _lineSpace = 15;
    //地址选择器
    _pickerTopViewHeight =50;
    _pickerViewHeight = kDeviceHeight/3 -50;
    
    //图片数组
    self.imageArray = @[].mutableCopy;
    //存放图片链接的数组
    self.imgUrlArray = @[].mutableCopy;
    //存放图片链接的字典
    self.imgLinkDic = [NSMutableDictionary dictionary];
    self.imgPropertyDic = [NSMutableDictionary dictionary];
    
    //取出字体限制
    [self getRule_fontlimit];
    //获取地址
    [self getLoctionInformation];
    //输入框数组
    self.textFieldArray = @[].mutableCopy;
    //创建视图
    [self _initViews];
    //注册键盘的通知
    [self addKeyBoardNotification];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //跳转到其他界面的时候
    [self dismissKeyboard:nil];
}

#pragma mark - 视图布局
- (void)_initViews{
    //设置导航栏
    [self _initNavigationBarItem];
    
    //准备显示的信息
    NSString *alertTxt = @"";
    NSString *titleTxt = @"";
    NSString *feeTxt = @"";
    NSString *feeDetailTxt = @"";
    NSString *addressTxt = @"所在地区";
    NSString *startTimeTxt = @"开始时间";
    NSString *stopTimeTxt = @"结束时间";
    NSString *detailTxt = @"";
    
    
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    //点击查看详情需要使用的链接地址
    NSDictionary *webUrlsDic = [USER_DEFAULT objectForKey:@"webUrlsDic"];
    
    switch (_TypeNum) {
        case  1:
        {
            //通告
            alertTxt = @"招募通告火热上线,快看看支持哪些通告类型";
            NSString *tempStr = [descriptionDic objectForKey:@"event_recruit"];
            if(tempStr.length != 0){
                alertTxt = tempStr;
            }
            //进入通告详情
            _enterDetailWebUrl = [webUrlsDic objectForKey:@"announce"];
            titleTxt = @"通告标题";
            feeTxt = @"填写费用";
            feeDetailTxt = @"不填代表面议(元)";
            detailTxt = @"通告详情";
            break;
        }
        case  2:
        {   //众筹
            alertTxt = @"众筹活动火热上线，快看看支持哪些通告类型";
            NSString *tempStr = [descriptionDic objectForKey:@"event_crowdfund"];
            if(tempStr.length != 0){
                alertTxt = tempStr;
            }
            //进入通告详情
            _enterDetailWebUrl = [webUrlsDic objectForKey:@"crowdfund"];
            titleTxt = @"众筹标题";
            feeTxt = @"众筹金额";
            feeDetailTxt = @"每人至少支持的金额(元)";
            detailTxt = @"众筹详情";
            break;
        }
        case  3:
        {   //海报
            alertTxt = @"活动海报火热上线，来看看怎么玩";
            NSString *tempStr = [descriptionDic objectForKey:@"event_poster"];
            if(tempStr.length != 0){
                alertTxt = tempStr;
            }
            //进入通告详情
            _enterDetailWebUrl = [webUrlsDic objectForKey:@"poster"];
            titleTxt = @"海报标题";
            feeTxt = @"填写费用";
            feeDetailTxt = @"不填代表面议(元)";
            detailTxt = @"海报详情";
            break;
        }
        default:
            break;
    }
    
    //最多和至少能够添加的图片个数
    _upLoadLimit_min = [_imgCountLimitDic[@"min"] integerValue];
    _upLoadLimit_max = [_imgCountLimitDic[@"max"] integerValue];

    _defaultDetailTxt = detailTxt;
    
    //显示图片的视图的宽度
    /*
    //可以根据pad和iphone的不同使用情况，调整添加图片一行显示多少个图片
    if (kScreenWidth==320) {
        //每行行显示3个
        _rowItemCount = 3;
        _imageWidth = (kDeviceWidth -(_leftPadding*2) -4*10)/3;
    }else{
        _rowItemCount = 4;
        _imageWidth = (kDeviceWidth -(_leftPadding*2) -5*10)/4;
    }
    */
    _rowItemCount = 3;
    _imageWidth = (kDeviceWidth -(_leftPadding*2) -4*10)/3;

    
    //滑动视图
    _mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _mainScrollView.backgroundColor = [CommonUtils colorFromHexString:@"#F8F6F3"];
    _mainScrollView.showsHorizontalScrollIndicator =NO;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.delegate =self;
    [self.view addSubview:_mainScrollView];
    
    //1.提示信息：存在跳转链接的时候才会显示
    [self _initMoreDetailControlView:alertTxt];
    //2.标题：通告、众筹
    [self _initTitleView:titleTxt];
    //3.填写费用
    [self _initFeeView:feeTxt withDetailTxt:feeDetailTxt];
    //4.所在地区
    [self _initAddressCtrl:addressTxt];
    
    //5.开始时间和结束时间
    [self _initTimeButton:startTimeTxt withStopTimeTxt:stopTimeTxt];
    //6.通告详情
    [self _initDetailView:detailTxt];

    //7.显示添加的图片
    [self _initAddImageView];
    
    //初始情况下滑动的视图的内容尺寸设置
    [self resetMainScrollViewContentSize];
}



- (void)_initNavigationBarItem{
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    //[leftButton setTitle:@"返回" forState:UIControlStateNormal];
    //leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    //[leftButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    leftButton.tag = 900;
    [leftButton addTarget:self action:@selector(navigationBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 30)];
    NSString *titleStr = NSLocalizedString(@"release", nil);
    if ([titleStr isEqualToString:@"发布"]) {
        _rightButton.frame = CGRectMake(0, 0, 30, 30);
    }
    
    [_rightButton setTitle:titleStr forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    _rightButton.tag = 901;
    [_rightButton addTarget:self action:@selector(navigationBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}


- (void)_initMoreDetailControlView:(NSString *)alertTxt{
    
    
    if (_enterDetailWebUrl.length ==0) {
        //不显示进入详情的按钮
        return;
    }
    //显示进入详情的按钮
    _moreDetailControlView = [[UIControl alloc] initWithFrame:CGRectMake(0, _lineSpace, kDeviceWidth, 20)];
    [_mainScrollView addSubview:_moreDetailControlView];
    
    CGFloat alertTxtWidth = [SQCStringUtils getCustomWidthWithText:alertTxt viewHeight:20 textSize:_fontSize];
    
    UILabel *alertTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, 0, alertTxtWidth, 20)];
    alertTxtLabel.text = alertTxt;
    alertTxtLabel.font = [UIFont systemFontOfSize:_fontSize];
    [_moreDetailControlView addSubview:alertTxtLabel];
    
    UIImageView *enterDetailImgView = [[UIImageView alloc] initWithFrame:CGRectMake(alertTxtLabel.right +5, 0, 20, 20)];
    enterDetailImgView.image = [UIImage imageNamed:@"oicon031"];
    [_moreDetailControlView addSubview:enterDetailImgView];
    [_moreDetailControlView addTarget:self action:@selector(moreDetailCtrlClick:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)_initTitleView:(NSString *)titleTxt{
    
    CGFloat topView_topY = 0;
    if (_enterDetailWebUrl.length ==0) {
        //不显示进入详情的按钮
        topView_topY = _lineSpace;
    }else{
        topView_topY = _moreDetailControlView.bottom +_lineSpace;
    }

    //通告视图
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, topView_topY, kDeviceWidth - _leftPadding*2, 50)];
    _titleView.backgroundColor = [UIColor whiteColor];
    _titleView.layer.cornerRadius = 5;
    _titleView.layer.masksToBounds = YES;
    [_mainScrollView addSubview:_titleView];
    //通告标题Label
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 40)];
    titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.text = titleTxt;
    [_titleView addSubview:titleLabel];
    //通告输入框
    CGRect titleTxtFieldFrame = CGRectMake(titleLabel.right + 10, 5, _titleView.width -titleLabel.right -10 -10, 40);
    NSString *str = [NSString stringWithFormat:@"%@字以上%@字内 ",_eventTitleLimDic[@"min"],_eventTitleLimDic[@"max"]];
    UITextField *titleTxtField = [self getTextfieldWithHolder:str withTag:200 withFrame:titleTxtFieldFrame];
    //添加输入完成的监听
    [titleTxtField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    titleTxtField.textAlignment = NSTextAlignmentRight;
    [_titleView addSubview:titleTxtField];
}


- (void)_initFeeView:(NSString *)feeTxt withDetailTxt:(NSString *)feeDetailTxt{
    //费用视图
    _feeView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, _titleView.bottom +_lineSpace, kDeviceWidth - _leftPadding*2, 50)];
    _feeView.backgroundColor = [UIColor whiteColor];
    _feeView.layer.cornerRadius = 5;
    _feeView.layer.masksToBounds = YES;
    [_mainScrollView addSubview:_feeView];
    //填写费用Lable
    UILabel *feeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 40)];
    feeLabel.font = [UIFont systemFontOfSize:_fontSize];
    feeLabel.textAlignment = NSTextAlignmentLeft;
    feeLabel.text = feeTxt;
    [_feeView addSubview:feeLabel];
    //费用输入框
    CGRect feeTxtFieldFrame = CGRectMake(feeLabel.right + 10, 5, _feeView.width -feeLabel.right -10 -10, 40);
    UITextField *feeTxtField = [self getTextfieldWithHolder:feeDetailTxt withTag:300 withFrame:feeTxtFieldFrame];
    feeTxtField.textAlignment = NSTextAlignmentRight;
    feeTxtField.keyboardType = UIKeyboardTypeNumberPad;
    [_feeView addSubview:feeTxtField];
    
//    //提示输入金额的文字
//    UILabel *feeDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(_feeView.width -200, 5, 180, 40)];
//    feeDetailLabel.tag = 301;
//    feeDetailLabel.textColor =  [CommonUtils colorFromHexString:kLikeGrayTextColor];
//    feeDetailLabel.textAlignment = NSTextAlignmentRight;
//    feeDetailLabel.text = feeDetailTxt;
//    [_feeView addSubview:feeDetailLabel];
}

- (void)_initAddressCtrl:(NSString *)addressTxt{
    _addressCtrl = [[UIControl alloc] initWithFrame:CGRectMake(_leftPadding, _feeView.bottom +_lineSpace, kDeviceWidth - _leftPadding*2, 50)];
    _addressCtrl.backgroundColor = [UIColor whiteColor];
    _addressCtrl.layer.cornerRadius = 5;
    _addressCtrl.layer.masksToBounds = YES;
    [_addressCtrl addTarget:self action:@selector(addressCtrlClick:) forControlEvents:UIControlEventTouchUpInside];
    [_mainScrollView addSubview:_addressCtrl];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 60, 40)];
    addressLabel.font = [UIFont systemFontOfSize:_fontSize];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    addressLabel.text = addressTxt;
    [_addressCtrl addSubview:addressLabel];
    
    UILabel *addressTxtLabel = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.right +10, 5, _addressCtrl.width - addressLabel.right -10 -20, 40)];
    addressTxtLabel.tag = 401;
    addressTxtLabel.font = [UIFont systemFontOfSize:_fontSize];
    addressTxtLabel.textAlignment = NSTextAlignmentRight;
    addressTxtLabel.text = @"";
    [_addressCtrl addSubview:addressTxtLabel];
    
    UIImageView *arrowImgView = [[UIImageView alloc] initWithFrame:CGRectMake(_addressCtrl.width -20, 15, 20, 20)];
    arrowImgView.image = [UIImage imageNamed:@"oicon031"];
    [_addressCtrl addSubview: arrowImgView];
}


- (void)_initTimeButton:(NSString *)startTimeTxt withStopTimeTxt:(NSString *)stopTimeTxt{
    CGFloat btnWidth = (kDeviceWidth -_leftPadding *2 - 10)/2;
    _startTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftPadding,_addressCtrl.bottom +_lineSpace, btnWidth, 50)];
    _startTimeBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    _startTimeBtn.backgroundColor = [UIColor whiteColor];
    _startTimeBtn.tag = 500;
    [_startTimeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _startTimeBtn.layer.cornerRadius = 5;
    _startTimeBtn.layer.masksToBounds = YES;
    [_startTimeBtn setTitle:startTimeTxt forState:UIControlStateNormal];
    [_startTimeBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
    [_mainScrollView addSubview:_startTimeBtn];
    
    //结束时间
    _stopTimeBtn = [[UIButton alloc] initWithFrame:CGRectMake(_startTimeBtn.right +10, _addressCtrl.bottom +_lineSpace, btnWidth, 50)];
    _stopTimeBtn.titleLabel.font = [UIFont systemFontOfSize:_fontSize];
    _stopTimeBtn.backgroundColor = [UIColor whiteColor];
    _stopTimeBtn.tag = 501;
    [_stopTimeBtn addTarget:self action:@selector(timeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _stopTimeBtn.layer.cornerRadius = 5;
    _stopTimeBtn.layer.masksToBounds = YES;
    [_stopTimeBtn setTitle:stopTimeTxt forState:UIControlStateNormal];
    [_stopTimeBtn setTitleColor:[CommonUtils colorFromHexString:kLikeBlackColor] forState:UIControlStateNormal];
    [_mainScrollView addSubview:_stopTimeBtn];
}

- (void)_initDetailView:(NSString *)detailTxt{
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, _stopTimeBtn.bottom +_lineSpace, kDeviceWidth -_leftPadding*2, 100)];
    _detailView.backgroundColor = [UIColor whiteColor];
    _detailView.layer.cornerRadius = 5;
    _detailView.layer.masksToBounds = YES;
    [_mainScrollView addSubview:_detailView];

    _detailTxtView = [[UITextView alloc] initWithFrame:CGRectMake(5, 2, _detailView.width -5*2, 96)];
    _detailTxtView.tag = 600;
    //_detailTxtView.backgroundColor = [UIColor orangeColor];
    [_detailView addSubview:_detailTxtView];
    _detailTxtView.delegate = self;
    _detailTxtView.font = [UIFont systemFontOfSize:_fontSize];
    
    //_detailTxtView.returnKeyType = UIReturnKeyDone;
    //提示文字
    //_detailTxtView.text = detailTxt;
    //_detailTxtView.textColor = [CommonUtils colorFromHexString:@"#D2CBA1"];
    //文字提示
    UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(2 ,7 , _detailTxtView.width -2*2, 15)];
    detailLabel.text = detailTxt;
    detailLabel.tag = 601;
    detailLabel.font = [UIFont systemFontOfSize:_fontSize];
    detailLabel.textColor =  [CommonUtils colorFromHexString:kLikeGrayTextColor];
    [_detailTxtView addSubview:detailLabel];
}

- (void)_initAddImageView{
    _addImageView = [[UIView alloc] initWithFrame:CGRectMake(20, _detailView.bottom +_lineSpace, kScreenWidth-20*2, _imageWidth +10*2)];
    _addImageView.layer.cornerRadius = 5;
    _addImageView.layer.masksToBounds = YES;
    [_mainScrollView addSubview:_addImageView];
    [self resetAddViewItems];
}


//创建一个输入框
- (UITextField *)getTextfieldWithHolder:(NSString *)holderString withTag:(NSInteger)tag withFrame:(CGRect)frame{
    UITextField *activityTitle = [[UITextField alloc] initWithFrame:frame];
    activityTitle.font = [UIFont systemFontOfSize:_fontSize];
    activityTitle.placeholder = holderString;
    activityTitle.tag = tag;
    activityTitle.returnKeyType = UIReturnKeyDone;
    activityTitle.delegate = self;
    [self.textFieldArray addObject:activityTitle];
    return activityTitle;
}

//重新设置滑动视图的内容尺寸大小
- (void)resetMainScrollViewContentSize{
    if (_addImageView.bottom +64<self.view.height) {
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth,_mainScrollView.height +10);
    }else{
        _mainScrollView.contentSize = CGSizeMake(kDeviceWidth, _addImageView.bottom +64 +10);
    }
 }


#pragma mark - 加载文案和相关数据
-(void)getRule_fontlimit{
    _eventTitleLimDic = [NSMutableDictionary dictionary];
    _imgCountLimitDic = [NSMutableDictionary dictionary];
    NSDictionary *rule_fontlimit = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    if (rule_fontlimit) {
        //活动标题限制
       _eventTitleLimDic = rule_fontlimit[@"event_tile"];
        //活动图片限制
        switch (_TypeNum) {
            case 1:
            {
                _imgCountLimitDic = rule_fontlimit[@"event_announce"];
                break;
            }
            case 2:
            {
                _imgCountLimitDic = rule_fontlimit[@"event_crowdfund"];
                break;
            }
            case 3:
            {
                _imgCountLimitDic = rule_fontlimit[@"event_poster"];
                break;
            }
            default:
                break;
        }
        
    }else{
        //服务器返回的字段为空,设定默认值
        [_eventTitleLimDic setObject:@"2" forKey:@"min"];
        [_eventTitleLimDic setObject:@"15" forKey:@"max"];
        //
        [_imgCountLimitDic setObject:@"1" forKey:@"min"];
        [_imgCountLimitDic  setObject:@"9" forKey:@"max"];
    }
    
}



//地区信息
-(void)getLoctionInformation{
    _selectedRow = 0;
    //读取地区信息
    _areaArray = (NSMutableArray *)[ReadPlistFile readAreaArray];
    _cityArray = [NSMutableArray array];
    @try {
        for (NSDictionary *dic in _areaArray) {
            NSMutableArray *citysMutArr = [NSMutableArray array];
            //每个省份之后都加上了不限
             NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
            [mutDic setObject:@"0" forKey:@"id"];
            [mutDic setObject:@"不限" forKey:@"name"];
            [citysMutArr addObject:mutDic];

            [citysMutArr addObjectsFromArray:dic[@"citys"]];
            [_cityArray addObject:citysMutArr];
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"%@",exception.name);
    }
    @finally {
        
    }
}


#pragma mark - 代理方法：UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//    if (textField.tag == 200) {
//        //输入标题
//    }else if(textField.tag == 300){
//        //输入金额时隐藏提示文字
//        //UILabel *feeDetailLabel = [_feeView viewWithTag:301];
//        //feeDetailLabel.hidden = YES;
//    }
    return YES;
}

//输入确定后
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self dismissKeyboard:nil];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.tag == 200) {
        /*
        NSString *lastStr = textField.text;
        NSString *rangeStr = NSStringFromRange(range);
        NSString *replaceStr = string;
        NSLog(@"--lastStr is %@", lastStr);
        NSLog(@"rangeStr is %@", rangeStr);
        NSLog(@"replaceStr is %@", replaceStr);
        */
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //range.length== 1的时候，是处于删除状态的时候
        if (toBeString.length > [_eventTitleLimDic[@"max"] intValue] && range.length!=1){
            textField.text = [toBeString substringToIndex:[_eventTitleLimDic[@"max"] intValue]];
            return NO;
        }
        return YES;
 
    }else if(textField.tag == 300){

        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        //range.length== 1的时候，是处于删除状态的时候
        if (toBeString.length > 7 && range.length!=1){
            textField.text = [toBeString substringToIndex:7];
            return NO;
        }
        return YES;
    }
    return YES;
}


- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.tag == 200) {
        
        NSString *toBeString = textField.text;
        // 键盘输入模式
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) {
            // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textField markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                if (toBeString.length > [_eventTitleLimDic[@"max"] intValue]) {
                    textField.text = [toBeString substringToIndex:[_eventTitleLimDic[@"max"] intValue]];
                }
            }
            else{
                // 有高亮选择的字符串，则暂不对文字进行统计和限制
            }
        }else{
            // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
            if (toBeString.length > [_eventTitleLimDic[@"max"] intValue]) {
                textField.text = [toBeString substringToIndex:[_eventTitleLimDic[@"max"] intValue]];
            }
        }
    }else{
        
    }
}

#pragma mark - 代理方法：UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UILabel *detailLabel = [_detailTxtView viewWithTag:601];
    detailLabel.hidden = YES;
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    //已经开始编辑了

}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
//    if ([textView.text isEqualToString:_defaultDetailTxt]) {
//        textView.text = @"";
//        textView.textColor = [UIColor blackColor];
//    }
//    
//    if ([@"\n" isEqualToString:text] == YES) {
//        [_detailTxtView resignFirstResponder];
//        return NO;
//    }
//    return YES;
//}

//输入确定后
//- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
//    [self dismissKeyboard:nil];
//    return YES;
//}



#pragma mark - 代理方法 UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_detailTxtView.isFirstResponder) {
        //在MainScrollView滑动完毕，此时_detailTxtView为可编辑状态
        if (_isEditting) {
            if (scrollView.tag == 600 ) {
                //此时监听到的scollview的滑动是txtView的滑动，所以不消失键盘
            }else{
                //当进入isEdtting的状态时，MainscrollView除非为了消失键盘否则不滑动
                //此时监听到的滑动是MainScrollView的滑动，让键盘消失
                //textView滑动到顶端
                _detailTxtView.contentOffset = CGPointMake(0, 0);
                [self dismissKeyboard:nil];
            }
        }else{
            //为了让textView上移，MainscrollView正在上滑中
            //txtView已经为第一响应者，但是此时不需要消失键盘
        }
    }else{
        //textView不是第一响应者，是与其无关的滑动
        //此时执行键盘的消失试试为了让textField的输入状态消失
        [self dismissKeyboard:nil];
    }
}




- (void)dismissKeyboard:(id)sender {
    // _mainScrollView.contentOffset = CGPointMake(0, 0);
    //结束编辑状态
    _isEditting = NO;
    //输入框和输入区都失去焦点
    for (int i=0; i<self.textFieldArray.count; i++) {
        UITextField *textfield = self.textFieldArray[i];
        if (textfield.isFirstResponder) {
            [textfield resignFirstResponder];
        }
    }
    
    if (_detailTxtView.isFirstResponder) {
        [_detailTxtView resignFirstResponder];
    }
    
    //是否还显示输入金额的提示
    //    UITextField *feeTxtField = [_feeView viewWithTag:300];
    //    UILabel *feeDetailLabel = [_feeView viewWithTag:301];
    //    if (feeTxtField.text.length ==0) {
    //        //显示提示文字
    //        feeDetailLabel.hidden = NO;
    //    }else{
    //        feeDetailLabel.hidden = YES;
    //    }
    
    //是否显示活动详情的提示文字
    UILabel *detailLabel = [_detailTxtView viewWithTag:601];
    if(_detailTxtView.text.length == 0 ||[@"\n" isEqualToString:_detailTxtView.text]){
        detailLabel.hidden = NO;
    }else{
        detailLabel.hidden = YES;
    }
    //保存输入的内容
    [self saveInputContent];
}






#pragma mark - 添加图片的相关处理
- (void)resetAddViewItems
{
    //清空所有子视图
    for (UIView *view in _addImageView.subviews) {
        [view removeFromSuperview];
    }

    //默认添加图片的父视图的frame
    _addImageView.frame = CGRectMake(20, _detailView.bottom +_lineSpace, kDeviceWidth -20 *2, _imageWidth+10*2);
    [self resetMainScrollViewContentSize];
    
    //没有图片
    if (self.imageArray.count==0) {
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, _imageWidth, _imageWidth)];
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:@"activityAddImg"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 0;
        [button setFrame:imgView.frame];
        [button addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_addImageView addSubview:imgView];
        [_addImageView addSubview:button];
        
    }else {
        NSInteger imagesCount  = self.imageArray.count;
        //如果没有达到最大数9个就要在最后显示一个增加图片的按钮
        NSInteger viewsCount =imagesCount;
        if(imagesCount<_upLoadLimit_max){
            viewsCount = viewsCount +1;
        }
        //计算行与列
        NSInteger row = 0;
        NSInteger col = 0;
        if ((viewsCount % _rowItemCount) == 0) {
            row = viewsCount/_rowItemCount;
        }else{
            row = viewsCount/_rowItemCount +1;
        }
        
        //确认添加图片的视图的大小
        _addImageView.frame = CGRectMake(20, _detailView.bottom +_lineSpace, kDeviceWidth -20*2, row*(_imageWidth +10)+10);
        //调整滑动视图的的大小
        [self resetMainScrollViewContentSize];
        
        //添加图片
        row = 0;
        col = 0;
        for (NSInteger i = 0; i<viewsCount; i++) {
            //当前的行数
            if((i%_rowItemCount) == 0){
                row ++;
            }
            //当前列
            col =i %_rowItemCount;
            
            //显示图片
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(col*(_imageWidth +10)+10, (row -1) *(_imageWidth +10)+10, _imageWidth, _imageWidth)];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            
            //最后一张添加图片
            if (i == self.imageArray.count) {
                //如果是用于添加图片的按钮
                imageView.image = [UIImage imageNamed:@"activityAddImg"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = self.imageArray.count;
                [button setFrame:imageView.frame];
                [button addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_addImageView addSubview:imageView];
                [_addImageView addSubview:button];
                return;
            }
            
            //否则显示正常的图片
            UIImage *image = self.imageArray[i];
            imageView.image = image;
            [_addImageView addSubview:imageView];
            //同时正常图片也可点击更换
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:imageView.frame];
            button.tag = i;
            [button addTarget:self action:@selector(addImageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_addImageView addSubview:imageView];
            [_addImageView addSubview:button];
        }
    }
}

- (void)addImageBtnClick:(UIButton *)btn
{
    _imgageCurrentIndex = btn.tag;
    
    [_detailTxtView resignFirstResponder];
    UIActionSheet *choosePhotoActionSheet;
    choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"拍照", @"相册", nil];
    
    [choosePhotoActionSheet showInView:self.view];
}

//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        switch (buttonIndex) {
            case 0:
            {
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                else{
                    //                    [NotificationManager notificationWithMessage:@"您的设备不支持照相功能"];
                    return;
                }
                break;
            }
            case 1:
            {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            }
            case 2:
                return;
                break;
            default:
                break;
            return;
        }
    } else {
        if (buttonIndex == 1) {
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    //imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

#pragma mark - 代理方法：UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSLog(@"UIImage:width：%f,height:%f",image.size.width,image.size.height);
    if (_imgageCurrentIndex == 0) {
        if(_imageArray.count == 0){
            //保存图片对象
            [self.imageArray addObject:image];
            //上传图片,保存图片的链接
            [self uploadSelectedImage:image withIndex:0];
        }else{
            //删除原来的图片，插入新图片
            [self.imageArray removeObjectAtIndex:0];
            [self .imageArray insertObject:image atIndex:0];
            [self uploadSelectedImage:image withIndex:0];
        }
        
    }else if(_imgageCurrentIndex == [_imageArray count]){
        //点击了最后一个添加按钮
        [self.imageArray addObject:image];
        //上传图片,保存图片的链接
        [self uploadSelectedImage:image withIndex:self.imageArray.count -1];
    }else{
        //中间的图片
        [self.imageArray removeObjectAtIndex:_imgageCurrentIndex];
        [self.imageArray insertObject:image atIndex:_imgageCurrentIndex];
        [self uploadSelectedImage:image withIndex:_imgageCurrentIndex];
    }
    
    [self resetAddViewItems];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
        topView.backgroundColor = [CommonUtils colorFromHexString:@"#DEDFE1"];
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
        _pickerView.backgroundColor = [CommonUtils colorFromHexString:@"#D8D8D8"];
        [_pickerWindow addSubview:_pickerView];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        [locationView addSubview:_pickerView];
        
    }
    //显示地址视图
    _pickerWindow.hidden =NO;
    _selectedRow = _provinceArrayIndex;
    [_pickerView selectRow:_provinceArrayIndex inComponent:0 animated:YES];
    [_pickerView reloadComponent:1];
    [_pickerView selectRow:_cityArrayIndex inComponent:1 animated:YES];
    
    UIView *locationView = [_pickerWindow viewWithTag:3000];
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _pickerWindow.alpha = 1;
        locationView.frame = CGRectMake(0, kDeviceHeight-_pickerTopViewHeight -_pickerViewHeight, kDeviceWidth, _pickerTopViewHeight +_pickerViewHeight);
    } completion:^(BOOL finished) {
        //_pickerWindow.hidden = NO;
    }];

}


- (void)pickerViewBtnClick:(UIButton *)btn{
    if(btn.tag == 3001) {
        //隐藏地址选择器，不保存数据
        [self hiddenPickerWindow];
    }else{
        //保存数据,并隐藏
        [self updatePikcerLocation];
        [self hiddenPickerWindow];
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

- (void)updatePikcerLocation {
    //当前省份
    //获取当前第一组选中的索引位置
    _provinceArrayIndex = [_pickerView selectedRowInComponent:0];
    NSDictionary *provinceDic = _areaArray[_provinceArrayIndex];

    NSString *provinceName = provinceDic[@"name"];
    NSString *provinceId = provinceDic[@"id"];
    
    NSString *cityName = @"";
    NSString *cityId = @"";
    
    //第二组的索引位置
    if (_selectedRow != _provinceArrayIndex) {
        //此时索引未更新，此时取当前省份的第一个城市
        _cityArrayIndex = 0;
    }else{
        //此时第一组已经确定，可以直接取值
        _cityArrayIndex = [_pickerView selectedRowInComponent:1];
    }
    
    NSArray *cityArr = provinceDic[@"citys"];
    cityArr = _cityArray[_provinceArrayIndex];
    cityName = cityArr[_cityArrayIndex][@"name"];
    cityId = cityArr[_cityArrayIndex][@"id"];

    
//    //第二组的索引位置
//    if (_selectedRow != _provinceArrayIndex) {
//        //此时索引未更新，此时取当前省份的第一个城市
//        _cityArrayIndex = 0;
//        NSArray *cityArr = provinceDic[@"citys"];
//        cityName = cityArr[_cityArrayIndex][@"name"];
//        cityId = cityArr[_cityArrayIndex][@"id"];
//    }else{
//        //此时第一组已经确定，可以直接取值
//        cityName = _cityArray[_selectedRow][[_pickerView selectedRowInComponent:1]][@"name"];
//        cityId = _cityArray[_selectedRow][[_pickerView selectedRowInComponent:1]][@"id"];
//    }
    
    //NSArray *tempArr = @[@"省",@"市",@"区",@"县"];
    // NSLog(@"%@",_areaArray);
    //NSLog(@"%@",_cityArray);
    
    //显示地址视图
    NSString *addressString= @"";
    if ([cityName isEqualToString:@"不限"]) {
        addressString= getSafeString([NSString stringWithFormat: @"%@",provinceName]);
    }else{
        addressString= getSafeString([NSString stringWithFormat: @"%@ %@",provinceName,cityName]);
    }
     UILabel *addTxtLabel = [_addressCtrl viewWithTag:401];
    addTxtLabel.text = addressString;
    
    [ActivityDataModel sharedInstance].province = getSafeString(provinceId);
    [ActivityDataModel sharedInstance].cityCode = getSafeString(cityId);
}



#pragma mark - 代理方法：pickerView
//返回列数
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

//对应每列数据的个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return _areaArray.count;
            break;
        case 1:{
            return [_cityArray[_selectedRow] count];
            break;
        }
        default:
            break;
    }
    return 0;
}


//返回的指定列和列表项的标题文本
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (component) {
        case 0:
            return _areaArray[row][@"name"];
            break;
        case 1:
        {
            return _cityArray[_selectedRow][row][@"name"];
            break;
        }
        default:
            break;
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    NSString *title = @"";
    switch (component) {
        case 0:
            title =  _areaArray[row][@"name"];
            break;
        case 1:
        {
            title =  _cityArray[_selectedRow][row][@"name"];
            break;
        }
        default:
            break;
    }
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];

        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16]];
    }
    // Fill the label text here
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}



-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0:
            _selectedRow = row;
            [pickerView reloadComponent:1];
            break;
        case 1:
            break;
        default:
            break;
    }
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return kDeviceWidth/2;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return 35;
}


#pragma mark - 键盘的监听
- (void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardNotificationAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
}

//键盘响应事件
- (void)keyBoardNotificationAction:(NSNotification *)notification{
    CGFloat keyBoard_topY = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y -64;
    //得到的坐标是是不计导航栏的
    NSLog(@"键盘的顶部高度(不计导航栏):%f",keyBoard_topY);
    
    
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y - end.origin.y>0)){
    //在详情输入框是第一响应者的情况下才做处理
    if (_detailTxtView.isFirstResponder) {
        //输入框的地端在键盘top的下面，这样需要处理
        if ((_detailView.bottom -keyBoard_topY)>0) {
            [UIView animateWithDuration:0.3 animations:^{
                _mainScrollView.contentOffset = CGPointMake(0, _detailView.bottom -keyBoard_topY+10);
            }completion:^(BOOL finished) {
                //mainScrollView上移完成，此时的textView成为编辑状态
                _isEditting = YES;
            }];
        }else{
            _isEditting = YES;
        }
    }
    }
}



#pragma mark - 事件点击处理
//进入webView详情
- (void)moreDetailCtrlClick:(UIControl *)control{
    NSLog(@"查看支持的其他类型");
    McWebViewController *webVC = [[McWebViewController alloc] init];
    webVC.webUrlString = _enterDetailWebUrl;
    webVC.needAppear = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

//设置地区
- (void)addressCtrlClick:(UIControl *)control{
    /*
     NSLog(@"选择地址");
     McProvinceViewController *editDataVC = [[McProvinceViewController alloc] init];
     editDataVC.editOrSearch = 1;
     [editDataVC setCallBack:^(NSString *string) {
     NSLog(@"%@",string);
     UILabel *addTxtLabel = [_addressCtrl viewWithTag:401];
     addTxtLabel.text = string;
     }];
     [self.navigationController pushViewController:editDataVC animated:YES];
     */
    [self dismissKeyboard:nil];
    [self showPickerView];
}

//选择时间
- (void)timeBtnClick:(UIButton *)btn{
    NSInteger tag = btn.tag;
    McEditBirthViewController *editDataVC = [[McEditBirthViewController alloc] initWithType:McPersonalTypeBirth];
    if (tag == 500) {
        editDataVC.titleString = @"开始时间";
        [editDataVC setCallBack:^(NSString *string) {
            NSLog(@"%@",string);
            [_startTimeBtn setTitle:string forState:UIControlStateNormal];
        }];
        
    }else if(tag == 501){
        editDataVC.titleString = @"结束时间";
        [editDataVC setCallBack:^(NSString *string) {
            NSLog(@"%@",string);
            [_stopTimeBtn setTitle:string forState:UIControlStateNormal];
        }];
    }
    
    [self.navigationController pushViewController:editDataVC animated:YES];
    
}


//点击导航栏按钮
- (void)navigationBarItemClick:(UIButton *)btn{
    if (btn.tag == 900) {
        //如果没有填写过任何内容不弹出提示，直接返回
        if ([self canDirectlyBack]) {
            [[ActivityDataModel sharedInstance] clearData];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            //选择是否退出发布
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"" message:@"确定放弃发布活动?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 1001;
            [alertV show];
        }
    }else{
        //发布活动
        [self submitDataToServer_new];
    }
}


- (BOOL)canDirectlyBack{
    //标题为空
    if ([ActivityDataModel sharedInstance].activityTitle.length==0) {
        //省份为空
        if ([ActivityDataModel sharedInstance].province.length == 0) {
            //城市为空
            if([ActivityDataModel sharedInstance].cityCode.length==0){
                //开始时间为空
                if ([ActivityDataModel sharedInstance].startTime.length==0) {
                    //结束时间为空
                    if ([ActivityDataModel sharedInstance].endTime.length==0) {
                        //详情为空
                        if([ActivityDataModel sharedInstance].activityDescription.length==0){
                            if(_imageArray.count == 0){
                                //没有填写任何数据，可以直接返回
                                return YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return NO;
}






//保存输入内容
- (void)saveInputContent
{
    for (int i=0; i<self.textFieldArray.count; i++) {
        UITextField *textfield = self.textFieldArray[i];
        switch (textfield.tag) {
            case 200:
            {   //获取输入的活动标题
                [ActivityDataModel sharedInstance].activityTitle = getSafeString(textfield.text);
            }
                break;
            case 300:
            {   //获取填写的费用
                [ActivityDataModel sharedInstance].money = getSafeString(textfield.text);
            }
                break;
            default:
                break;
        }
    }
    
    //保存活动详情文字
    NSMutableString *mDetailTxt = [NSMutableString stringWithFormat:@"%@",getSafeString(_detailTxtView.text)];;
    //去除收尾空格和换行
    NSString *detailContent =  [mDetailTxt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //保存详情内容
    [ActivityDataModel sharedInstance].activityDescription = detailContent;
    
}





#pragma mark - 有关网络部分的操作
//选择图片之后上传图片
- (void)uploadSelectedImage:(UIImage *)image withIndex:(NSInteger)index{
    {
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
        //    //2M以下不压缩
        while (imageData.length/1024 > 2048) {
            imageData = UIImageJPEGRepresentation(image, 0.8);
            self.imageArray[index] = [UIImage imageWithData:imageData];
        }
        
         NSDictionary *dict = [AFParamFormat formatTempleteParams:@{@"file":@"file",@"type":[NSNumber numberWithInteger:UploadPhotoType_ReleaseActivity]}];
        
        [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
            NSLog(@"uploadPhoto:%@ test SVN",data);
           //successCount++;
            NSDictionary *dic = data[@"data"];
            NSString *dictionURL = [NSString stringWithFormat:@"%@",dic[@"url"]];
            [_imgLinkDic setObject:dictionURL forKey:[NSNumber numberWithInteger:index]];
            NSDictionary *tempDic = @{@"width":dic[@"width"],@"height":dic[@"height"],@"photoId":dic[@"id"]};
            //以图片链接为key，保存宽高
            [_imgPropertyDic setObject:tempDic forKey:dictionURL];
            
          }failed:^(NSError *error){
           // successCount++;
            NSLog(@"上传图片失败");
            
        }];
        
    }
    
}


//打印数据，用于测试
- (void)printActivityInfo{
    NSLog(@"ActivityDataModel.activityTitle:%@",[ActivityDataModel sharedInstance].activityTitle);
    NSLog(@"ActivityDataModel.money:%@",[ActivityDataModel sharedInstance].money);
    NSLog(@"startTime:%@",[ActivityDataModel sharedInstance].startTime);
    NSLog(@"ActivityDataModel.endTime:%@",[ActivityDataModel sharedInstance].endTime);
    NSLog(@"ActivityDataModel.province:%@",[ActivityDataModel sharedInstance].province);
    NSLog(@"ActivityDataModel.cityCode:%@",[ActivityDataModel sharedInstance].cityCode);
    NSLog(@"ActivityDataModel.activityDescription:%@",[ActivityDataModel sharedInstance].activityDescription);
}

//判断是否符合提交条件
- (BOOL)judgeDataIsOK{
    [self saveInputContent];
    //打印测试数据
    [self printActivityInfo];
    //标题
    if ([ActivityDataModel sharedInstance].activityTitle.length==0) {
        [LeafNotification showInController:self withText:@"请填写活动标题"];
        return NO;
    }
    
    if ([ActivityDataModel sharedInstance].activityTitle.length > [_eventTitleLimDic[@"max"] intValue] || [ActivityDataModel sharedInstance].activityTitle.length < [_eventTitleLimDic[@"min"] intValue]) {
        NSString *tempStr = [NSString stringWithFormat:@"活动标题大于%@字小于%@字",_eventTitleLimDic[@"min"],_eventTitleLimDic[@"max"]];
        [LeafNotification showInController:self withText:tempStr];
        return NO;
    }
    
    //费用
    if ([ActivityDataModel sharedInstance].money.length==0) {
        [ActivityDataModel sharedInstance].money = @"0";
        //[LeafNotification showInController:self withText:@"请填写费用"];
        //return NO;
    }
    
    
    //地区
    if ([ActivityDataModel sharedInstance].province.length==0) {
        [LeafNotification showInController:self withText:@"请完善地址信息"];
        return NO;
    }
    if ([ActivityDataModel sharedInstance].cityCode.length==0) {
        [LeafNotification showInController:self withText:@"请完善地址信息"];
        return NO;
    }
    
    
    //时间
    if ([ActivityDataModel sharedInstance].startTime.length==0) {
        [LeafNotification showInController:self withText:@"请填写开始时间"];
        return NO;
    }
    if ([ActivityDataModel sharedInstance].endTime.length==0) {
        [LeafNotification showInController:self withText:@"请填写结束时间"];
        return NO;
    }
    
    int startTime = [[ActivityDataModel sharedInstance].startTime intValue];
    int endTime = [[ActivityDataModel sharedInstance].endTime intValue];
    int timenow = [[NSDate date] timeIntervalSince1970];
    
    NSDate *startDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)startTime];
    NSDate *nowDate = [NSDate date];
    
    NSString *startDateString = [[startDate.description substringFromIndex:0] substringToIndex:10];
    NSString *nowDateString = [[nowDate.description substringFromIndex:0] substringToIndex:10];
    
    if (timenow>startTime) {
        if ([startDateString isEqualToString:nowDateString]) {
        }else
        {
            [LeafNotification showInController:self withText:@"活动开始时间不能小于当前时间"];
            return NO;
        }
    }
    if (endTime<startTime) {
        [LeafNotification showInController:self withText:@"活动结束时间不能大于开始时间"];
        return NO;
    }
    
    //详情
    if ([ActivityDataModel sharedInstance].activityDescription.length==0) {
        switch (_TypeNum) {
            case 1:
            {
                [LeafNotification showInController:self withText:@"请填写招募通告的详细说明"];
                break;
            }
            case 2:
            {
                [LeafNotification showInController:self withText:@"请填写众筹活动的详细说明"];
                break;
            }
            case 3:
            {
                [LeafNotification showInController:self withText:@"请填写活动海报的详细说明"];
                break;
            }
            default:
                break;
        }
        
        return NO;
    }else if([ActivityDataModel sharedInstance].activityDescription.length >10000){
        [LeafNotification showInController:self withText:@"详细说明的字数超过上限制，请重新输入"];
        return NO;
    }
    
    
    //检查图片
    if (_imageArray.count <_upLoadLimit_min) {
        switch (_TypeNum) {
            case 1:
            {
                [LeafNotification showInController:self withText: [NSString stringWithFormat:@"创建通告活动至少上传%ld张图片",(long)_upLoadLimit_min]];
                return NO;
                 break;
            }
            case 2:
            {
                
                [LeafNotification showInController:self withText: [NSString stringWithFormat:@"创建众筹活动至少上传%ld张图片",(long)_upLoadLimit_min]];
                return NO;
//                if (_imageArray.count<_up) {
//                    [LeafNotification showInController:self withText:@"创建众筹活动至少上传一张图片"];
//                    return NO;
//                }
                
                break;
            }
            case 3:
            {
                [LeafNotification showInController:self withText: [NSString stringWithFormat:@"创建海报活动至少上传%ld图片",(long)_upLoadLimit_min]];
                return NO;
//                if (_imageArray.count<1) {
//                    [LeafNotification showInController:self withText:@"创建海报活动至少上传一张图片"];
//                    return NO;
//                }
                break;
            }
                
            default:
                break;
        }

        
    }

    
    return YES;
}





- (void)submitDataToServer_new{
    //判断当前是否符合发布条件
    if (![self judgeDataIsOK]) {
        //不符合条件，放弃请求数据
        return;
    }
    //开始执行网络请求发布活动，此时关闭发布按钮的可点击
    _rightButton.userInteractionEnabled = NO;
    //显示正在发布活动
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *paramDic = @{@"title":[ActivityDataModel sharedInstance].activityTitle,
                                      @"startdate":[ActivityDataModel sharedInstance].startTime,
                                      @"enddate":[ActivityDataModel sharedInstance].endTime,
                                      @"province":[ActivityDataModel sharedInstance].province,
                                      @"city":[ActivityDataModel sharedInstance].cityCode,
                                      @"address":[ActivityDataModel sharedInstance].addressDetail,
                                      @"last_enrol_date":[ActivityDataModel sharedInstance].baomingTime,
                                      @"user_type":[ActivityDataModel sharedInstance].activityJobType,
                                      @"number":[ActivityDataModel sharedInstance].activityPeopleCount,
                                      @"sex":[ActivityDataModel sharedInstance].sexType,
                                      @"interview_method":[ActivityDataModel sharedInstance].mianshiType,
                                      @"payment":[ActivityDataModel sharedInstance].money,
                                      @"content":[ActivityDataModel sharedInstance].activityDescription}.mutableCopy;
    //设置活动类型参数
    switch (_TypeNum) {
        case 1:
        {
            [paramDic setObject:@"4" forKey:@"type"];
            break;
        }
        case 2:{
            [paramDic setObject:@"5" forKey:@"type"];
            break;
        }
        case 3:{
            [paramDic setObject:@"6" forKey:@"type"];
            break;
        }

        default:
            break;
    }
    
    
    
    
    //设置图片参数
    if (_imgLinkDic.count >0) {
        _imgUrlArray =[NSMutableArray arrayWithArray:[_imgLinkDic allValues]] ;
    }
    //封装图片json数据
    //[{"url":"www.baidu.com","width":500,"height":"500"},{"url":"www.baidu.com","width":500,"height":"500"}]
    if (_imgUrlArray.count>0) {
        NSMutableArray *mArr = [NSMutableArray array];
        for (int i = 0; i<_imgUrlArray.count; i++) {
            NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
            //链接
            [mdic setObject:_imgUrlArray[i] forKey:@"url"];
            //宽高
            NSDictionary *propertyDic = [_imgPropertyDic objectForKey:_imgUrlArray[i]];
            [mdic setObject:[propertyDic objectForKey:@"width"] forKey:@"width"];
            [mdic setObject:[propertyDic objectForKey:@"height"] forKey:@"height"];
            [mdic setObject:[propertyDic objectForKey:@"photoId"] forKey:@"photoId"];

            [mArr addObject:mdic];
        }
        //转化为json格式
        NSString *jsonStr = [mArr JSONString];
        
        @try {
            [paramDic setObject:jsonStr forKey:@"img_url"];
        }
        @catch (NSException *exception) {
            NSLog(@"错误：%@",exception);
        }
        @finally {
            
        }

    }

    //格式化参数集
    NSDictionary *param = [AFParamFormat formatNewActivityParams:paramDic];
    //请求网络发布照片
    [AFNetwork eventPublish:param success:^(id data){
        [self.hud hide:YES];
        if([data[@"status"] integerValue] == kRight){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"您发布的活动已经成功提交，我们将在一个小时内完成审核，感谢您的支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertV.tag = 1000;
            [alertV show];
        }
        else{
            NSLog(@"请求发布失败：%@",data[@"msg"]);
            [LeafNotification showInController:self withText:data[@"msg"]];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            _rightButton.userInteractionEnabled = YES;

        }
    }failed:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        _rightButton.userInteractionEnabled = YES;

    }];
}





- (void)submitDataToServer
{
    //判断当前是否符合发布条件
    if (![self judgeDataIsOK]) {
        //不符合条件，放弃请求数据
        return;
    }
    
    //显示正在发布活动
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __block NSMutableArray *imagesURL = @[].mutableCopy;
    //首先上传图片，获取到图片链接数组
    if (self.imageArray.count>0) {
        __block int successCount = 0;
        for (int i=0; i<self.imageArray.count; i++) {
            //NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 0.3);
            NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 1.0);
            NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
            //    //2M以下不压缩
            while (imageData.length/1024 > 2048) {
                imageData = UIImageJPEGRepresentation(self.imageArray[i], 0.8);
                self.imageArray[i] = [UIImage imageWithData:imageData];
            }
            
            NSDictionary *dict = [AFParamFormat formatPostUploadParamWithFile:@"file"];
            [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
                NSLog(@"uploadPhoto:%@ test SVN",data);
                successCount++;
                NSString *dictionURL = [NSString stringWithFormat:@"%@",data[@"data"][@"url"]];
                [imagesURL addObject:getSafeString(dictionURL)];
                
            }failed:^(NSError *error){
                successCount++;
                
            }];
            
        }
        NSLog(@"************  wait upload images");
        
        while (imagesURL.count<self.imageArray.count) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"************  start upload teach info");
        
    }
    
    
//    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.hud.mode = MBProgressHUDModeIndeterminate;
//    self.hud.removeFromSuperViewOnHide = YES;
    
    
    NSMutableDictionary *paramDic = @{@"title":[ActivityDataModel sharedInstance].activityTitle,
                                      @"startdate":[ActivityDataModel sharedInstance].startTime,
                                      @"enddate":[ActivityDataModel sharedInstance].endTime,
                                      @"province":[ActivityDataModel sharedInstance].province,
                                      @"city":[ActivityDataModel sharedInstance].cityCode,
                                      @"address":[ActivityDataModel sharedInstance].addressDetail,
                                      @"last_enrol_date":[ActivityDataModel sharedInstance].baomingTime,
                                      @"user_type":[ActivityDataModel sharedInstance].activityJobType,
                                      @"number":[ActivityDataModel sharedInstance].activityPeopleCount,
                                      @"sex":[ActivityDataModel sharedInstance].sexType,
                                      @"interview_method":[ActivityDataModel sharedInstance].mianshiType,
                                      @"payment":[ActivityDataModel sharedInstance].money,
                                      @"content":[ActivityDataModel sharedInstance].activityDescription}.mutableCopy;
    //区分类型
    //区分类型
    switch (_TypeNum) {
        case 1:
        {
            [paramDic setObject:@"4" forKey:@"type"];
            break;
        }
        case 2:{
            [paramDic setObject:@"5" forKey:@"type"];
            break;
        }
        case 3:{
            [paramDic setObject:@"6" forKey:@"type"];
            break;
        }
        default:
            break;
    }
    
    //图片链接
    if (imagesURL.count>0) {
        NSString *jsonStr = [imagesURL JSONString];
        [paramDic setObject:jsonStr forKey:@"img_url"];
    }
    NSDictionary *param = [AFParamFormat formatNewActivityParams:paramDic];
    
    //请求网络发布照片
    [AFNetwork eventPublish:param success:^(id data){
        [self.hud hide:YES];
        if([data[@"status"] integerValue] == kRight){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"您发布的活动已经成功提交，我们将在一个小时内完成审核，感谢您的支持" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            alertV.tag = 1000;
            [alertV show];
        }
        else{
            NSLog(@"请求发布失败：%@",data[@"msg"]);
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];

    }];
}



//提交活动之后就会清空单例中的数据
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1000) {
        //提交成功后
        [[ActivityDataModel sharedInstance] clearData];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else if(alertView.tag == 1001){
        if (buttonIndex == 0) {
            //
        }else
        {
            [[ActivityDataModel sharedInstance] clearData];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }
}





#pragma mark - 测试部分
//处理json数据
- (NSString*)JSONStringWithArray:(NSArray *)array
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error != nil) {
        NSLog(@"array JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}



#pragma mark -dealloc
- (void)dealloc{
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}

@end
