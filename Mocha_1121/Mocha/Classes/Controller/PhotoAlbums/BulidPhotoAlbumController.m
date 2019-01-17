//
//  BulidPhotoAlbumController.m
//  Mocha
//
//  Created by zhoushuai on 16/4/14.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BulidPhotoAlbumController.h"
#import "BuildAlbumCtrlView.h"
#import "PrivacySettingViewController.h"
#import "UploadAlbumPhotosController.h"

@interface BulidPhotoAlbumController ()<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>

//视图==============
//设置相册名称
@property(nonatomic,strong)UIView *albumNameView;
@property(nonatomic,strong)UITextField *albumField;
//设置相册的隐私
@property(nonatomic,strong)UIView *albumPrivacyView;
//设置风格视图
@property(nonatomic,strong)UIView *chooseStyleView;
//删除相册按钮
@property(nonatomic,strong)UIButton *deleteBtn;


//参数==================
//距离顶部的距离
@property(nonatomic,assign)CGFloat topPadding;
//距离左边的距离
@property(nonatomic,assign)CGFloat leftPadding;
//每个视图的宽度
@property(nonatomic,assign)CGFloat viewWidth;
//每个视图的高度
@property(nonatomic,assign)CGFloat cellHeight;
//标题的高度
@property(nonatomic,assign)CGFloat titleLableHeight;
//字体的大小
@property(nonatomic,assign)CGFloat fontSize;
@property(nonatomic,assign)CGFloat contentFontSize;
//圆角程度
@property(nonatomic,assign)CGFloat cornerRadius;

//相册名称大小
@property(nonatomic,assign)NSInteger albumTitleMax;
@property(nonatomic,assign)NSInteger albumTitleMin;



//视图tittle信息================
//相册私密性
@property(nonatomic,strong)NSArray *privacyTypes;
//相册风格名称
@property(nonatomic,strong)NSMutableArray *styleTitles;
//相册风格ids
@property(nonatomic,strong)NSMutableArray *styleTitleIds;

//中间变量====================
//选中私密性索引
@property(nonatomic,assign)NSInteger privacySelectedIndex;
//选中风格索引
@property(nonatomic,assign)NSInteger styleSelectedIndex;
//相册名称
@property(nonatomic,copy)NSString *albumName;

@end

@implementation BulidPhotoAlbumController
#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.title = @"新建相册";
    [self setNavigationBar];
    [self.view addSubview:self.mainScrollView];
    
    //创建视图
    [self _initViews];
    
    //如果是编辑相册，初始化视图的一些相册的已有信息
    if (self.isEdit) {
        self.title = @"编辑相册";
        if(self.albumDic){
            [self resetAblumDataWithAlbumDic:self.albumDic];
        }
     }
    [self getAlubmInfoforEdit];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //UINavigationController *nvc = self.navigationController;
    self.navigationController.navigationBar.hidden = NO;
    //每次进入界面，重置视图状态：
    //1.从选择金币的界面进入
    //2.从其他界面进入，为了编辑相册
    [self resetViewStates];
 }


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [_albumField resignFirstResponder];
}

#pragma mark - 视图创建
- (void)_initViews{
    _topPadding = 20;
    _leftPadding = 20;
    _viewWidth = kDeviceWidth - _leftPadding *2;
    _cellHeight = 50;
    _titleLableHeight = 30;
    _fontSize = 15;
    _contentFontSize = 16;
    _cornerRadius = 10;
    //视图初始创建，设置金币个数为88
    _goldCountStr = @"88";
    //私密性分组
    _privacyTypes = @[@"公开相册",@"私密相册"];
    
    //从配置中获取有关文案
    NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
    NSArray *styleConigArr = [descriptionDic objectForKey:@"album_genre"];
    //取出字段
    for (int i = 0; i<styleConigArr.count; i++) {
        NSDictionary *dic = styleConigArr[i];
        [self.styleTitles addObject:dic[@"album_genre_name"]];
        [self.styleTitleIds addObject:dic[@"album_genre"]];
    }
    
    [self addAlbumNameField];
    [self addAlbumPrivacyView];
    [self AddChooseStyleView];
    
    if(self.isEdit){
        //处于编辑相册的状态
        [self addDeleteBtn];
        self.mainScrollView.contentSize = CGSizeMake(kDeviceWidth, _deleteBtn.bottom +_topPadding);
    }else{
        self.mainScrollView.contentSize = CGSizeMake(kDeviceWidth, _chooseStyleView.bottom +_topPadding);
    }
    
    NSLog(@"%@",NSStringFromCGRect(self.mainScrollView.frame));
    NSLog(@"%@",NSStringFromCGSize(self.mainScrollView.contentSize));

}



//设置导航栏
- (void)setNavigationBar{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    if (self.isEdit) {
        [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    }else{
        [rightButton setTitle:@"新建" forState:UIControlStateNormal];
    }
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(buildBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

//填写相册名称的视图
- (void)addAlbumNameField{
    //相册名称的限制
    [self getRule_fontlimitDic];
    UILabel *albumNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, _topPadding, _viewWidth, _titleLableHeight)];
    albumNameLabel.text = @"相册名称:";
    albumNameLabel.font = [UIFont systemFontOfSize:_fontSize];
    [self.mainScrollView addSubview:albumNameLabel];
    
    _albumNameView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, albumNameLabel.bottom, _viewWidth, _cellHeight)];
    _albumNameView.backgroundColor = [UIColor whiteColor];
    _albumNameView.layer.cornerRadius = _cornerRadius;
    _albumNameView.layer.masksToBounds = YES;
    
    _albumField = [[UITextField alloc] initWithFrame:CGRectMake(_leftPadding/2,0, _viewWidth -_leftPadding/2, _cellHeight)];
    _albumField.delegate = self;
    _albumField.returnKeyType = UIReturnKeyDone;

    _albumField.font = [UIFont systemFontOfSize:_fontSize];
    _albumField.placeholder = [NSString stringWithFormat: @"相册名称,%ld到%ld个字",(long)_albumTitleMin, (long)_albumTitleMax];
    [_albumNameView addSubview:_albumField];
    [self.mainScrollView addSubview:_albumNameView];
}


//设置相册的私密性
- (void)addAlbumPrivacyView{
    UILabel *albumPrivacyLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, _albumNameView.bottom + _topPadding, _viewWidth, _titleLableHeight)];
    albumPrivacyLabel.text = @"相册隐私:";
    albumPrivacyLabel.font = [UIFont systemFontOfSize:_fontSize];
    [self.mainScrollView addSubview:albumPrivacyLabel];

    //相册隐私
     _albumPrivacyView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, albumPrivacyLabel.bottom, _viewWidth, _cellHeight *2)];
    if (self.isEdit) {
        _albumPrivacyView.frame = CGRectMake(_leftPadding, albumPrivacyLabel.bottom, _viewWidth, _cellHeight);
    }
    _albumPrivacyView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:_albumPrivacyView];

    for (int i = 0; i <2; i++) {
        BuildAlbumCtrlView *ctrlView = [BuildAlbumCtrlView getBuildAlbumCtrlView];
        //ctrlView.backgroundColor = [UIColor purpleColor];
        ctrlView.frame = CGRectMake(0, _cellHeight *i,_viewWidth, _cellHeight);
        ctrlView.tag = 100 +i;
        if (i == _privacySelectedIndex) {
            ctrlView.circleView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        }
        if (i == 1) {
            ctrlView.bottomLineLabel.hidden = YES;
            ctrlView.arrowImgView.hidden = NO;
            ctrlView.detailLabel.hidden = NO;
        }
        ctrlView.titleLabel.text = _privacyTypes[i];
        [ctrlView addTarget:self action:@selector(ctrlViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_albumPrivacyView addSubview:ctrlView];
    }
    
    //编辑相册
    //公开相册和私密相册类型不可以互转
    if(self.isEdit){
        BuildAlbumCtrlView *openCtrlView = [_albumPrivacyView viewWithTag:100];
        BuildAlbumCtrlView *privacyCtrlView = [_albumPrivacyView viewWithTag:101];
        if([self isPrivacyForEdit]){
            //创建时候是私密相册
            openCtrlView.hidden =YES;
            privacyCtrlView.top = 0;
        }else{
            privacyCtrlView.hidden =YES;
            openCtrlView.bottomLineLabel.hidden =YES;
        }

        //_albumPrivacyView.frame = CGRectMake(_leftPadding, albumPrivacyLabel.bottom, _viewWidth, _cellHeight*1);
        //openCtrlView.height = 50;
        //privacyCtrlView.height = 50;

     }
     _albumPrivacyView.layer.cornerRadius = _cornerRadius;
    _albumPrivacyView.layer.masksToBounds = YES;
    [self.mainScrollView addSubview:_albumPrivacyView];
    
}


//选择相册的风格
- (void)AddChooseStyleView{
    UILabel *albumStyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_leftPadding, _albumPrivacyView.bottom + _topPadding, _viewWidth, _titleLableHeight)];
    albumStyleLabel.text = @"风格:";
    albumStyleLabel.font = [UIFont systemFontOfSize:_fontSize];
    [self.mainScrollView addSubview:albumStyleLabel];
    
    //相册隐私
    _chooseStyleView = [[UIView alloc] initWithFrame:CGRectMake(_leftPadding, albumStyleLabel.bottom, _viewWidth, _cellHeight *4)];
    _chooseStyleView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i <4; i++) {
        BuildAlbumCtrlView *ctrlView = [BuildAlbumCtrlView getBuildAlbumCtrlView];
        ctrlView.frame = CGRectMake(0, _cellHeight *i,_viewWidth, _cellHeight);
        ctrlView.tag = 200 + i;
        //设置选中颜色
        if (i == _privacySelectedIndex) {
            ctrlView.circleView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        }
        
        if (i == 3) {
            ctrlView.bottomLineLabel.hidden = YES;
        }
        ctrlView.titleLabel.text = _styleTitles[i];
        [ctrlView addTarget:self action:@selector(ctrlViewClick:) forControlEvents:UIControlEventTouchUpInside];
        [_chooseStyleView addSubview:ctrlView];
    }
    
    _chooseStyleView.layer.cornerRadius = _cornerRadius;
    _chooseStyleView.layer.masksToBounds = YES;
    [self.mainScrollView addSubview:_chooseStyleView];
}


- (void)addDeleteBtn{
    _deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(_leftPadding, _chooseStyleView.bottom +_topPadding, _viewWidth, _cellHeight)];
    _deleteBtn.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    _deleteBtn.layer.cornerRadius = _cornerRadius;
    _deleteBtn.layer.masksToBounds = YES;
    [_deleteBtn setTitle:@"删除相册" forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(deleteAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:_deleteBtn];
}


-(void)getRule_fontlimitDic{
    NSDictionary *rule_fontDic = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    _albumTitleMin = 1;
    _albumTitleMax = 6;
    if (rule_fontDic) {
        NSDictionary *album_titleDic = [rule_fontDic objectForKey:@"album_title"];
        _albumTitleMax = [album_titleDic[@"max"] integerValue];
        _albumTitleMin = [album_titleDic[@"min"] integerValue];
    }
}








#pragma mark - 代理-textField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //
    }else{
        //删除相册
        [self requestForDeleteAlbum];
    }
}



#pragma mark - 事件点击
//跳过中间上传图片的视图控制器直接返回
- (void)skipUploadForback{
    NSMutableArray *removeArr = @[].mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[UploadAlbumPhotosController class]]) {
            [removeArr addObject:controller];
            
        }
     }
    
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];
    }
    [self.navigationController setViewControllers:tempArr];
    
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)ctrlViewClick:(UIControl *)ctrl{
    NSInteger tag = ctrl.tag;
     if (tag <200) {
         //私密性选择
         _privacySelectedIndex = tag -100;
         if (tag == 101) {
             //跳转进入到设置金币的界面
             PrivacySettingViewController *privacyVC = [[PrivacySettingViewController alloc] initWithNibName:@"PrivacySettingViewController" bundle:nil];
             privacyVC.superVC = self;
             privacyVC.goldCountStr = _goldCountStr;
            [self.navigationController pushViewController:privacyVC animated:YES];
         }
     }else{
         //样式选择
         _styleSelectedIndex = tag -200;
     }
    [self resetViewStates];
}



//创建相册
- (void)buildBtnClick:(UIButton *)btn{
    
    if(self.isEdit){
        //编辑相册
        [self requestForEditPrivacyAlbum];
    }else{
        //创建相册
        [self requesetForBuildPrivacyAlbum];
    }
}

- (void)deleteAlbum{

    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:@"删除相册？" message:@"删除相册将会删除相册中所有图片" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [deleteAlert show];
}


- (void)resetAblumDataWithAlbumDic:(NSDictionary *)albumDic{
    //相册名称
    self.albumField.text = self.albumDic[@"title"];
    //私密性
    NSDictionary *dic = self.albumDic[@"setting"][@"open"];
    if ([dic[@"is_private"] isEqualToString:@"1"]) {
        _privacySelectedIndex = 1;
        _goldCountStr = dic[@"visit_coin"];
    }else{
        _privacySelectedIndex = 0;
        _goldCountStr = @"88";
    }
    
    //风格
    NSString *styleStr = self.albumDic[@"album_genre"];
    self.styleSelectedIndex = 0;
    for (int i = 0;  i<self.styleTitleIds.count; i++) {
        if ((i+1) == [styleStr integerValue]) {
            //设置风格选中索引
            self.styleSelectedIndex = i;
            break;
        }
    }
    //重新设置视图被选中状态
    [self resetViewStates];
}

//重新设置红点的位置
- (void)resetViewStates{
    //私密性重置
    for (int i = 0; i<_privacyTypes.count; i++) {
        BuildAlbumCtrlView *ctrl = [_albumPrivacyView viewWithTag:100 +i];
        //设置选中状态
        ctrl.circleView.backgroundColor = [CommonUtils colorFromHexString:@"#f7f7f7"];
        if (i == _privacySelectedIndex) {
            ctrl.circleView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        }
        //设置私密相册金币个数
        if (i == 1) {
            ctrl.detailLabel.text = [NSString stringWithFormat:@"%@金币",_goldCountStr];
        }
    }
    
    
    //风格样式重置
    for (int i = 0; i<_styleTitles.count; i++) {
        BuildAlbumCtrlView *ctrl = [_chooseStyleView viewWithTag:200 +i];
        ctrl.circleView.backgroundColor = [CommonUtils colorFromHexString:@"#f7f7f7"];
        if (i == _styleSelectedIndex){
            ctrl.circleView.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
        }
    }
}


//返回相册私密性
- (BOOL)isPrivacyForEdit{
    NSDictionary *dic = self.albumDic[@"setting"][@"open"];
    if ([dic[@"is_private"] isEqualToString:@"1"]) {
        return YES;
     }else{
         return NO;
    }
}


#pragma mark - 网络处理
//获取相册的信息
- (void)getAlubmInfoforEdit{
    if (self.albumID) {
         NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
        [mdic setObject:@"2" forKey:@"album_type"];
        [mdic setObject:self.albumID forKey:@"id"];
        NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
        [AFNetwork getMokaDetail:params success:^(id data) {
//            NSLog(@"%@",data);
            //移除原来的数据
             self.albumDic = data[@"data"];
            [self resetAblumDataWithAlbumDic:self.albumDic];
         } failed:^(NSError *error) {
            
        }];
    }
}



//判断参数正确性，返回请求参数字典
- (NSDictionary *)prepareForRequest{
    //新建相册
    //相册名是否符合要求
    _albumName = _albumField.text;
    if (_albumName.length <_albumTitleMin) {
     [LeafNotification showInController:self withText:[NSString stringWithFormat:@"相册名称长度至少为%ld",(long)_albumTitleMin] ];
        return nil ;
    }
    if(_albumName.length >_albumTitleMax){
        [LeafNotification showInController:self withText:[NSString stringWithFormat:@"相册名称长度最多为%ld",(long)_albumTitleMax]];
        return nil;
    }
    
    //判断登陆和绑定
    if (getCurrentUid()) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return nil;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return nil;
    }
    
    //设置请求参数
    NSMutableDictionary *diction = [NSMutableDictionary dictionary];
    [diction setObject:_albumField.text forKey:@"title"];
    [diction setObject:_styleTitleIds[_styleSelectedIndex] forKey:@"album_genre"];
    [diction setObject:@"2" forKey:@"album_type"];
    //设置私密性
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    if(_privacySelectedIndex == 0) {
        [tempDic setObject:@"0" forKey:@"is_private"];
        [tempDic setObject:@"0" forKey:@"visit_coin"];
    }else if(_privacySelectedIndex == 1){
        [tempDic setObject:@"1" forKey:@"is_private"];
        [tempDic setObject:_goldCountStr forKey:@"visit_coin"];
    }
    NSMutableDictionary *openDic = [NSMutableDictionary dictionary];
    [openDic setObject:tempDic forKey:@"open"];
    NSString *openString = [SQCStringUtils JSONStringWithDic:openDic];
    [diction setObject:openString forKey:@"setting"];
    
    return diction;
}


//创建相册
- (void)requesetForBuildPrivacyAlbum{
    if ([self prepareForRequest] == nil) {
        return;
    }
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:[self prepareForRequest]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //请求网络创建相册
    [AFNetwork createAlbum:params success:^(id data){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //数据请求成功之后就进入照片界面
            NSString *albumId = getSafeString(data[@"data"][@"albumId"]);
            UploadAlbumPhotosController *uploadPhotosVC = [[UploadAlbumPhotosController alloc] initWithNibName:@"UploadAlbumPhotosController" bundle:nil];
            uploadPhotosVC.fromVCName = @"fromNewBuildVC";
            uploadPhotosVC.albumID = albumId;
            uploadPhotosVC.currentTitle = getSafeString(data[@"data"][@"title"]);
            [self.navigationController pushViewController:uploadPhotosVC animated:YES];
        }
        else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}

//编辑相册
- (void)requestForEditPrivacyAlbum{
    if ([self prepareForRequest] == nil) {
        return;
    }
    //增加相册ID参数
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:[self prepareForRequest]];
    [mdic setObject:_albumDic[@"albumId"] forKey:@"id"];
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:mdic];
    
    [AFNetwork editAlbum:params success:^(id data) {
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:@"编辑相册成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            //其他原因
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    } failed:^(NSError *error) {
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哦"];
    }];
}



- (void)requestForDeleteAlbum{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":_albumDic[@"albumId"]}];
    [AFNetwork getDeleteAlbum:params success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([data[@"status"] integerValue] == kRight) {
            //删除相册成功
            [LeafNotification showInController:self withText:@"删除相册成功"];
            //跳过中间的上传图片视图控制器，直接返回
            [self skipUploadForback];
         }
        else if([data[@"status"] integerValue] == kReLogin){
            //显示登陆
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }else if ([data[@"status"] integerValue] == 1){
            //其他情况
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
}


#pragma mark - set/get方法
- (UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, kDeviceHeight-kNavHeight)];
        _mainScrollView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
     }
    return _mainScrollView;
}


- (NSMutableArray *)styleTitles{
    if (_styleTitles == nil) {
        _styleTitles = [NSMutableArray array];
    }
    return _styleTitles;
}

- (NSMutableArray *)styleTitleIds{
    if (_styleTitleIds == nil) {
        _styleTitleIds = [NSMutableArray array];
    }
    return _styleTitleIds;
}


@end
