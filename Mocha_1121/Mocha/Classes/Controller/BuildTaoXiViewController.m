//
//  BuildTaoXiViewController.m
//  Mocha
//
//  Created by XIANPP on 16/2/22.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BuildTaoXiViewController.h"
#import "BuildTaoXiHeaderView.h"
#import "TaoXiPictureModel.h"
//顶部三个介绍
#import "TaoXiDescriptionCell.h"
//套系总描述
#import "TaoXiThemeDescCell.h"

#import "UploadPhotoCell.h"
#import "TaoXiTypeController.h"
#import "TaoXiInformationController.h"
#import "LocalPhotoViewController.h"
#import "PhotoAndDescriptionTableViewCell.h"
#import "SQCStringUtils.h"
#import "NewMyPageViewController.h"
#import "DeleteTableViewCell.h"
#import "ReadPlistFile.h"


@interface BuildTaoXiViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate, SelectPhotoDelegate,photoDelegateProtocol,UIActionSheetDelegate,UIAlertViewDelegate>
{
    
    //当前正在处于编辑状态的输入框
    UITextField *_textField;
    UITextView *_textView;
    
    BOOL _userAction;
    NSMutableArray *deleteArr;
    dispatch_semaphore_t sem;
    
    
    //专题相关信息
    NSString *_name;
    NSString *_type;
    NSString *_price;
    
    //专题描述
    NSString *_briefIntroduction;
    
    
    NSString *_cover;
    NSString *_description;
    //存放图片描述的字典
    NSMutableDictionary *_descriptionMutDic;
    //创建套系时保存顶部信息，包括套系的封面
    NSMutableDictionary *_informationMutDic;
    
    NSString *albumId;
    NSInteger _deleteIndex;
    BOOL delegateBool;
    NSString *_typeNum;
    UIAlertView *_backAlert;
    
    //NSString *_setintroduce;
    //UIView *_cellView;
    //NSString *_setPlace;
    //NSString *_allPhotos;
    //NSString *_goodPhotos;
    //NSString *_setTime;
    //NSString *_setExcription;
    //NSString *_setEquipment;
    
    
    
    
}

@property (nonatomic , strong)BuildTaoXiHeaderView *buildTXH;
//正在编辑
@property (nonatomic,assign)BOOL isInputting;

@property (nonatomic , strong)NSMutableArray *selectPhotos;//网络

@property (nonatomic , strong)NSMutableArray *alSelectPhotos;//选图

@property (nonatomic , strong)NSMutableArray *descriptionArr;

@property (nonatomic , strong)NSMutableArray *locationMutArr;//本地

@property (nonatomic , strong)NSMutableArray *locationHeight;//高度

@property (nonatomic , strong)UIButton *deleteBtn;

//图片squence最大值
@property(nonatomic,assign)NSInteger maxSequence;
@property(nonatomic,assign)CGRect rect;

//导航栏上按钮
@property(nonatomic,strong)UIButton *setBtn;
@property(nonatomic,strong)UIButton *rightBtn;

//是否触发了修改
@property(nonatomic,assign)BOOL haveModifyed;

@property(nonatomic,strong)NSDictionary *taoxiInfoDict;

//关于地址的设置的相关属性
//省份和相应的城市
@property (nonatomic , strong)NSMutableArray *areaArray;
@property (nonatomic , strong)NSMutableArray *cityArray;

//当前第一列的选中行：用于刷新数据
@property (nonatomic , assign)NSInteger selectedRow;

//@property(nonatomic,strong)NSMutableArray *netPhotos;

@property(nonatomic,strong)TaoXiThemeDescCell *descrCell;
@end

@implementation BuildTaoXiViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self loadTableHeaderView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"上传专题";
    //表视图
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.rect = CGRectMake(0, 0, 0, 0);
    //封面图的高度
    CGFloat imgH = kDeviceWidth * TaoXiScale;
    //表头视图
    self.buildTXH.supCon = self;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, imgH)];
    [view addSubview:_buildTXH];
    //self.tableView.tableHeaderView = view;
    self.tableView.tableHeaderView = _buildTXH;
    
    //表尾视图
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    footView.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    self.tableView.tableFooterView = footView;

    //注册单元格
    [self.tableView registerNib:[UINib nibWithNibName:@"TaoXiDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaoXiDescriptionCell"];
    
    //初始化信息
    if (!_informationMutDic) {
        _informationMutDic = [NSMutableDictionary dictionary];
    }
    
    deleteArr = [NSMutableArray array];
    _descriptionMutDic = [NSMutableDictionary dictionary];
    if (_briefIntroduction.length == 0) {
        _briefIntroduction = @"";
    }
    if(_descriptionArr == nil){
        //如果是编辑，肯定不是nil,当前为新建
        _descriptionArr = [NSMutableArray array];
        //为数组设置较大的长度，防止输入框存储文字的时候
        for (int i = 0; i< 1000; i++) {
            [_descriptionArr addObject:@""];
        }
    }
    
    //布局导航栏
    [self setNavigationInformation];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taoxiTypeChose:) name:@"taoxiTypeChose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taoxiInformation:) name:@"taoxiInformation" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taoxiCoverurl:) name:@"taoxiCoverurl" object:nil];
    //键盘
    [self addKeyBoardNotification];
    

    if (!(_maxSequence >0)) {
        _maxSequence = 0;
    }
}



-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateNO" object:nil];
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateYES" object:nil];
}

//修改套系已有数据设置表头视图
- (void)initWithDictionary:(NSDictionary *)dictionary{
    if (_descriptionArr == nil) {
        _descriptionArr = [NSMutableArray array];
    }
    self.taoxiInfoDict = dictionary;
    _informationMutDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    //表头视图
    [self.buildTXH initWithDictionary:dictionary];
    NSDictionary *content = dictionary[@"content"];
    albumId = getSafeString(dictionary[@"albumId"]);
    if (!((NSNull *)content == [NSNull null])){
        
        _name = getSafeString(dictionary[@"content"][@"setname"]);
        _type = getSafeString(dictionary[@"content"][@"settype"]);
        _price = getSafeString(dictionary[@"content"][@"setprice"]);
        
        _briefIntroduction = getSafeString(dictionary[@"content"][@"setintroduce"]);
        _coverUrl = getSafeString(dictionary[@"content"][@"coverurl"]);
        _typeNum = getSafeString(dictionary[@"content"][@"camera_set"]);
    }
    
    NSMutableArray *mutArr = dictionary[@"photos"];
    
    
    _maxSequence = 0;
    for (NSDictionary *dic in mutArr) {
        //已经被选中的图片的信息字典
        [self.selectPhotos addObject:dic];
        
        //获取当前图片的最大位置
        if([[dic objectForKey:@"sequence"] integerValue] > _maxSequence){
            _maxSequence = [[dic objectForKey:@"sequence"] integerValue];
        }
        //已经被选中图片的描述
        [_descriptionArr addObject:dic[@"title"]];
        
        //将数据封装为modle数组
        // TaoXiPictureModel *model = [[TaoXiPictureModel alloc] initWithData:dic];
        //[self.selectPhotos addObject:model];
    }
    
    //为数组设置较大的长度，防止输入框存储文字的时候
    for (int i = 0; i< 1000; i++) {
        [_descriptionArr addObject:@""];
    }

    [self.tableView reloadData];
}



- (void)setNavigationInformation {
    //左边按钮
    _setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [_setBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_setBtn addTarget:self action:@selector(delayToPop) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:_setBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右边按钮
    if (_isEdit) {
        //编辑完成
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(editInformation) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }else{
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
        [_rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(uploadInformation) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除键盘通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidChangeFrameNotification object:nil];
}




#pragma mark - tableViewDelegateDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isEdit) {
        //编辑状态
        if (self.selectPhotos.count || self.locationMutArr.count) {
            return 6;
        }
        //编辑状态下，显示删除按钮
            return 5;
    }else{
        //新建状态
        if (self.selectPhotos.count || self.locationMutArr.count) {
            return 5;
        }else{
            return 4;
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            //主要信息
            return 3;
            break;
        }
        case 1:
            //完善信息
            return 1;
            break;
        case 2:{
            //主题描述
            return 1;
            break;
        }
        case 3:{
            if (self.selectPhotos.count || self.locationMutArr.count) {
                //服务端存在和本地已经存在图片个数
                return self.selectPhotos.count + self.locationMutArr.count;
            }else{
                //返回添加按钮
                return 1;
            }
            break;
        }
        case 4:{
            //添加按钮或者删除按钮
            //如果有图就是添加按钮，如果无图就是删除按钮
            return 1;
            break;
        }
            
        case 5:{
            //返回的是删除按钮
            return 1;
            break;
        }
        default:
            return 1;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return 0;
    }else{
        return 20;
    }
}



//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    return [[UIView alloc] init];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}

//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if (_isEdit) {
//        if (section == 3) {
//            return 0;
//        }
//    }else{
//        if (section == 1) {
//            return 0;
//        }
//        if (self.selectPhotos.count || self.locationMutArr.count) {
//            if (section == 1){
//                return 20;
//            }
//            if (section == 2){
//                return 0;
//            }
//        }
//    }
//    return 20;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        //name,type,price
        case 0:{
            return 50;
            break;
        }
        case 1:
            return 50;
            break;
        //主题描述
        case 2:{
            return 100;
//            if (_briefIntroduction.length == 0) {
//                return 50;
//            }else{
//                CGFloat themeDescHeight = [SQCStringUtils getCustomHeightWithText:_briefIntroduction viewWidth:kDeviceWidth - 5*2 textSize:16]+8;
//                return 100 +5;
//                return themeDescHeight +5;
//            }
            break;
        }
        //图片和介绍
        case 3:
        {
            if (self.selectPhotos.count || self.locationMutArr.count){
                if (indexPath.row < self.selectPhotos.count) {
                    NSDictionary *dic = self.selectPhotos[indexPath.row];
                    CGFloat imgHeight = [dic[@"height"] floatValue] * kDeviceWidth / [dic[@"width"] floatValue];
                    
                    CGFloat txtHeight = [SQCStringUtils getCustomHeightWithText:dic[@"title"] viewWidth:kDeviceWidth - 5*2 textSize:16] + 8;
                    txtHeight = 100;
                    return imgHeight + txtHeight +15;
                    
                }else{
                    UIImage *image = self.locationMutArr[indexPath.row - self.selectPhotos.count];
                    CGFloat height = image.size.height * kDeviceWidth / image.size.width;
                    return height +100 +15;
                }
            }else{
                return 50;
            }
            break;
        }
        //
        case 4:{
            //
            return 50;
            break;
        }
        //
         case 5:
        {
            return 50;
            break;
        }
     }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //section == 0
    if (indexPath.section == 0) {
        TaoXiDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiDescriptionCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [TaoXiDescriptionCell getTaoXiDescriptionCell];
            cell.descriptionTextField.returnKeyType = UIReturnKeyDone;
        }
         switch (indexPath.row) {
            case 0:
                cell.descriptionTextField.placeholder = @"输入专题名称";
                cell.descriptionTextField.text = _name;
                break;
            case 1:
                cell.descriptionTextField.text = _type;
                cell.descriptionTextField.placeholder = @"选择专题分类";
                cell.descriptionTextField.userInteractionEnabled = NO;
                cell.forward.hidden = NO;
                break;
            case 2:
                cell.descriptionTextField.placeholder = @"输入价格，最低0.1元";
                cell.descriptionTextField.text = _price;
                break;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.descriptionTextField.tag = 100 + indexPath.row;
        cell.descriptionTextField.textColor = [CommonUtils colorFromHexString:kLikeGrayTextColor];
        cell.descriptionTextField.delegate = self;
        return cell;
    
    //section == 1显示套系总描述
        
    }//完善专题信息cell
    else if(indexPath.section == 1){
         TaoXiDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiDescriptionCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [TaoXiDescriptionCell getTaoXiDescriptionCell];
            cell.descriptionTextField.returnKeyType = UIReturnKeyDone;
        }
        cell.descriptionTextField.text = _type;
        cell.descriptionTextField.text = @"完善专题信息";
        cell.descriptionTextField.textColor = [UIColor colorForHex:kLikeGrayTextColor];
        cell.descriptionTextField.userInteractionEnabled = NO;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.forward.hidden = NO;

        return cell;
    }
    else if(indexPath.section == 2){
        NSString *cellID = @"TaoXiThemeDescCell";
        TaoXiThemeDescCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        if (cell == nil) {
            cell = [[TaoXiThemeDescCell
                    alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.descTxtView.delegate = self;
        cell.descTxt = _briefIntroduction;
        cell.descTxtView.tag = 200;
        if(_briefIntroduction.length == 0){
            cell.descTxtView.text = @"请输入专题的描述";
        }
        self.descrCell = cell;
        cell.descTxtView.delegate = self;
         return cell;
    //section == 2 显示专题描述和图片
    }else if (indexPath.section == 3){
        //如果是图片和描述
        if (self.selectPhotos.count || self.locationMutArr.count) {
            //显示图片
            NSString *cellId = [NSString stringWithFormat: @"PhotoAndDescriptionTableViewCellID"];
            PhotoAndDescriptionTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!photoCell) {
                photoCell = [PhotoAndDescriptionTableViewCell getPhotoAndDescriptionTableViewCell];
                photoCell.selectionStyle = UITableViewCellSelectionStyleNone;
                [photoCell.photoImage setContentMode:UIViewContentModeScaleAspectFit];
            }
            //处于编辑状态的单元格
            //显示删除按钮
            photoCell.deleteBtn.hidden = NO;
            photoCell.delegate = self;
            photoCell.deleteBtn.tag = 1000 +indexPath.row;
            photoCell.descriptionTxtView.delegate = self;
            photoCell.descriptionTxtView.tag = 201 +indexPath.row;
            //显示网络图片
            if(indexPath.row <self.selectPhotos.count){
                photoCell.cellType = @"netCellForEditting";
                photoCell.dataDic =self.selectPhotos[indexPath.row];
            }
            else{
                //显示本地图片
                photoCell.cellType = @"localCell";
                photoCell.pictureImg = self.locationMutArr[indexPath.row - self.selectPhotos.count];
             }
            if (_descriptionArr.count > indexPath.row) {
                NSString *descriptionStr = _descriptionArr[indexPath.row];
                photoCell.pictureDesc = descriptionStr;
                //NSLog(@"---------%@",_descriptionArr);
             }
            return photoCell;

        }else{
        //没有图片，这一组显示的是图片上传按钮
            UploadPhotoCell *upCell = [tableView dequeueReusableCellWithIdentifier:@"UploadPhotoCell"];
            if (!upCell) {
                upCell = [UploadPhotoCell getUploadPhotoCell];
            }
            upCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return upCell;
        }
    }//section == 3
     else if(indexPath.section == 4){
         //如果上一组显示了图片，这一组显示的是上传cell
        if (self.selectPhotos.count || self.locationMutArr.count) {
            UploadPhotoCell *upCell = [tableView dequeueReusableCellWithIdentifier:@"UploadPhotoCell"];
            if (!upCell) {
                upCell = [UploadPhotoCell getUploadPhotoCell];
            }
            upCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return upCell;
        }else{
            //如果上一组没有图片，显示的是上传按钮，这一组显示删除按钮
            DeleteTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteTableViewCell"];
            if (!deleteCell) {
                deleteCell = [DeleteTableViewCell getDeleteCell];
            }
            deleteCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return deleteCell;
        }
    }
    //最后一层是显示的删除按钮
    else if(indexPath.section == 5){
        DeleteTableViewCell *deleteCell = [tableView dequeueReusableCellWithIdentifier:@"DeleteTableViewCell"];
        if (!deleteCell) {
            deleteCell = [DeleteTableViewCell getDeleteCell];
        }
        deleteCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return deleteCell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
        CGPoint offset = self.tableView.contentOffset;
        offset.y -= 100;
        [self.tableView setContentOffset:offset animated:YES];
    }
    switch (indexPath.section) {
        case 0:
        {   //0-1，选择套系类型
            if (indexPath.row == 1) {
                _haveModifyed = YES;
                TaoXiTypeController *typeCon = [[TaoXiTypeController alloc] init];
                typeCon.view.frame = self.view.bounds;
                [self.navigationController pushViewController:typeCon animated:YES];
            }
            break;
        }
        case 1:
        {
            //完善专题
            TaoXiInformationController *taoxiInfo = [[TaoXiInformationController alloc]init];
            
            if (_taoxiInfoDict) {
//                NSLog(@"%@",_taoxiInfoDict);
                [taoxiInfo initWithDictionary:_taoxiInfoDict];
                
            }
            
            
            [self.navigationController pushViewController:taoxiInfo animated:YES];
            break;
        }
        case 2:{
            //专题的描述
            break;
        }
        case 3:{
            //图片和描述
            if (self.selectPhotos.count || self.locationMutArr.count) {
                return;
            }else{
                _haveModifyed = YES;
                //添加图片的按钮
                LocalPhotoViewController *loadPhotoC = [[LocalPhotoViewController alloc] init];
                loadPhotoC.existCount = self.locationMutArr.count;
                loadPhotoC.selectPhotoDelegate = self;
                //loadPhotoC.selectPhotos = self.alSelectPhotos.mutableCopy;
                [self.navigationController pushViewController:loadPhotoC animated:YES];
            }
            break;
        }
        case 4:{
            if (self.selectPhotos.count || self.locationMutArr.count) {
                _haveModifyed = YES;
                //上传图片
                LocalPhotoViewController *loadPhotoC = [[LocalPhotoViewController alloc] init];
                loadPhotoC.existCount = self.locationMutArr.count;

                loadPhotoC.selectPhotoDelegate = self;
                //loadPhotoC.selectPhotos = self.alSelectPhotos.mutableCopy;
                [self.navigationController pushViewController:loadPhotoC animated:YES];
            }else{
                
                [self deleteAction:nil];
            }
        }
            break;
        case 5:{
            [self deleteAction:nil];
        }
            break;
        default:
            break;
    }
}




#pragma mark - 事件处理



-(void)deleteAction:(UIButton *)sender{
 
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除专题" otherButtonTitles: nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (albumId) {
            NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":albumId}];
            [AFNetwork getDeleteAlbum:params success:^(id data) {
                if ([data[@"status"] integerValue] == kRight) {
                    [LeafNotification showInController:self withText:@"删除成功"];
                    [self performSelector:@selector(popToPersonPage) withObject:nil afterDelay:0];
                }else{
                    [LeafNotification showInController:self withText:data[@"msg"]];
                }
                
            } failed:^(NSError *error) {
                [LeafNotification showInController:self withText:@"当前网络不顺畅哟"];
            }];
        }
    }
}


-(void)popToPersonPage{
    if ([self.fromVCName isEqualToString:@"CustomTabVC"]) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    for (id obj in self.navigationController.childViewControllers) {
        if ([obj isKindOfClass:[NewMyPageViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
        }
    }
}

- (void)delayToPop{
    if (_haveModifyed) {
        _backAlert = [[UIAlertView alloc]initWithTitle:@"放弃保存?" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [_backAlert show];
    }else{
        //没有修改,直接返回
        [self dismissKeyBoard];
        [self popToPersonPage];
    }
    
 
}

-(void)closeNavigationButton{
    _setBtn.userInteractionEnabled = NO;
    _rightBtn.userInteractionEnabled = NO;
    
}



#pragma mark - 完成编辑
- (void)editInformation{
    [self dismissKeyBoard];
    //点击了完成
    //此时如果存在处于编辑状态的输入框就保存内容到对应的数组中
    if (_textView) {
        [self saveTextViewContent:_textView];
    }
    
    //专题名称不能包括表情
    if ([SQCStringUtils stringContainsEmoji:_name]) {
        [LeafNotification showInController:self withText:@"专题名称不能是包含表情"];
        return;
    }
    
    
    if (![SQCStringUtils isPureFloat:_price] &&![SQCStringUtils isPureInt:_price]) {
        [LeafNotification showInController:self withText:@"专题价格请输入数字"];
        return;

    }
    
    float mon = [_price floatValue];
    if (mon>0.0999999&&mon<10000) {
        
    }else
    {
        [LeafNotification showInController:self withText:@"输入价格应在0.1和9999之间。"];
        return;
    }

    
    //编辑网络图片的描述
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
         for (id obj in _descriptionMutDic.allKeys) {
            if ([obj isKindOfClass:[NSString class]]) {
                if ([obj intValue] < self.selectPhotos.count) {
                    NSInteger objInt = [obj integerValue];
                    NSString *titleStr = getSafeString([_descriptionMutDic objectForKey:obj]);
                    //转码unicode
                    //titleStr = [SQCStringUtils utf8ToUnicode:titleStr];
                    //NSString *titleStr = getSafeString(_description);
                    NSDictionary *dic = self.selectPhotos[objInt];
                    NSString *photoId = getSafeString([dic objectForKey:@"photoId"]);
                    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"id":photoId,@"title":titleStr}];
                    [AFNetwork editPhoto:params success:^(id data) {
                        if ([data[@"status"] integerValue] == kRight) {
                            //NSLog(@"%@修改图片描述：",titleStr);
                         }else{
                            [LeafNotification showInController:self withText:data[@"msg"]];
                        }
                    } failed:^(NSError *error) {
                        NSLog(@"%@",error);
                    }];
                }
            }
        }
    });
    
    
    
    //如果有删除
    if (deleteArr.count) {
        NSMutableArray *photoIdArr = [NSMutableArray array];
        for (NSDictionary *dic in deleteArr) {
            [photoIdArr addObject:dic[@"photoId"]];
        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *photoJson = [self JSONStringWithDic:photoIdArr];
        NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"albumid":albumId,@"photoids":photoJson}];
        [AFNetwork getMokaDelete:params success:^(id data) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([data[@"status"] integerValue] == kRight) {
                //[LeafNotification showInController:self withText:data[@"msg"]];
            }
            else {
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
            
        }failed:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            
        }];
    }
    
    
    
    //新添加
    if (self.locationMutArr.count) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int i = (int)self.selectPhotos.count + 1;
            
            for (id image in self.locationMutArr) {
                if ([image isKindOfClass:[image class]]) {
                    [self uploadPhotoMethod:image with:i ];
                    i ++;
                }
            }
            
        });
    }
    
    //更新套系的基本信息
    UITextField *nametextField = [self.view viewWithTag:100];
    UITextField *typetextField = [self.view viewWithTag:101];
    UITextField *pricetextField = [self.view viewWithTag:102];
    _name = nametextField.text;
    _type = typetextField.text;
    _price = pricetextField.text;
    //转码unicode
    //_briefIntroduction = [SQCStringUtils utf8ToUnicode:_briefIntroduction];
    
    NSString *camera_set = getSafeString(_typeNum);
    NSString *coverurl = getSafeString(self.coverUrl);
    
//    NSDictionary *contentDict = @{@"setname":_name?_name:@"",@"setprice":_price?_price:@"",@"settype":_type?_type:@"",@"setintroduce":_briefIntroduction?_briefIntroduction:@"",@"camera_set":camera_set,@"coverurl":coverurl};
//    
//    [_informationMutDic setObject:contentDict forKey:@"content"];
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithDictionary: _informationMutDic[@"content"]];
    
    [tempDict setObject:_name?_name:@"" forKey:@"setname"];
    [tempDict setObject:_price?_price:@"" forKey:@"setprice"];
    [tempDict setObject:_type?_type:@"" forKey:@"settype"];
    [tempDict setObject:_briefIntroduction?_briefIntroduction:@"" forKey:@"setintroduce"];
    [tempDict setObject:camera_set forKey:@"camera_set"];
    [tempDict setObject:coverurl forKey:@"coverurl"];
    
    [_informationMutDic setObject:tempDict forKey:@"content"];
    //修改相册封面
    NSString *album_type = @"3"; // 1模特卡、2相册、3专题
    NSString *title = getSafeString(_name);
    NSString *style = @"0"; //样式:0无（用于相册）
    NSString *albumIdParams = getSafeString(albumId);
    //将_infomationMuDic转化为json
    NSLog(@"%@",_informationMutDic[@"content"]);
    NSString *contentStr = @"";
    if (_informationMutDic[@"content"]) {
        contentStr = [SQCStringUtils JSONStringWithDic:_informationMutDic[@"content"]];
    }
    NSString *provinceID = getSafeString(_informationMutDic[@"province"]);
    NSString *cityID = getSafeString(_informationMutDic[@"city"]);
    
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:@{@"id":albumIdParams,@"album_type":album_type,@"style":style,@"title":title,@"description":_briefIntroduction,@"content":contentStr,@"province":provinceID,@"city":cityID}];
    NSLog(@"%@",params);
    
    [AFNetwork editAlbum:params success:^(id data) {
        if ([data[@"status"] integerValue] == kRight) {
            //此时已经执行了完成操作，防止导航栏上的按钮再次点击
            [self closeNavigationButton];
            [LeafNotification showInController:self withText:[self getSuccessInfo] withTime:[self getNotificatioTime]];
            //提示消失之后再返回
            [self performSelector:@selector(successNotifion) withObject:nil afterDelay:[self getNotificatioTime]];
            
         }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
    } failed:^(NSError *error) {
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哦"];
    }];
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


- (NSString*)JSONStringWithDic:(NSArray *)diction
{
    NSError* error = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:diction
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (error != nil) {
        //NSLog(@"NSDictionary JSONString error: %@", [error localizedDescription]);
        return nil;
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
- (void)uploadInformation {
    [self dismissKeyBoard];
    UITextField *nametextField = [self.view viewWithTag:100];
    UITextField *typetextField = [self.view viewWithTag:101];
    UITextField *pricetextField = [self.view viewWithTag:102];
    _name = nametextField.text;
    _type = typetextField.text;
    _price = pricetextField.text;
    NSString *camera_set = getSafeString(_typeNum);
    
    //转码
    //_briefIntroduction = [SQCStringUtils utf8ToUnicode:_briefIntroduction];

    
    //上传
//    [_informationMutDic[@"content"] setObject:_name?_name:@"" forKey:@"setname"];
//    [_informationMutDic[@"content"] setObject:_price?_price:@"" forKey:@"setprice"];
//    [_informationMutDic[@"content"] setObject:_type?_type:@"" forKey:@"settype"];
//    [_informationMutDic[@"content"] setObject:_briefIntroduction?_briefIntroduction:@"" forKey:@"setintroduce"];
//    [_informationMutDic[@"content"] setObject:camera_set forKey:@"camera_set"];
    NSString *coverurl = getSafeString(self.coverUrl);
    
    NSDictionary *contentDict = @{@"setname":_name?_name:@"",@"setprice":_price?_price:@"",@"settype":_type?_type:@"",@"setintroduce":_briefIntroduction?_briefIntroduction:@"",@"camera_set":camera_set,@"coverurl":coverurl,@"setplace":@"",@"settotalcont":@"",@"settime":@"",@"settruingcount":@""};
    
    [_informationMutDic setObject:contentDict forKey:@"content"];
    if (!coverurl.length) {
        [LeafNotification showInController:self withText:@"请上传封面照片"];
        return;
    }
//    [_informationMutDic[@"content"] setObject:coverurl forKey:@"coverurl"];
    //    NSString *locationStr = [_informationMutDic objectForKey:@"setplace"];
    //    if (locationStr.length < 2) {
    //        [LeafNotification showInController:self withText:@"请填写地区信息"];
    //        return;
    //    }
    
    
    //专名名称不能包括表情
    if ([SQCStringUtils stringContainsEmoji:_name]) {
        [LeafNotification showInController:self withText:@"专题名称不能是包含表情"];
        return;
    }

    if (![SQCStringUtils isPureFloat:_price] &&![SQCStringUtils isPureInt:_price]) {
        [LeafNotification showInController:self withText:@"专题价格请输入数字"];
        return;
        
    }

    float mon = [_price floatValue];
    if (mon>0.0999999&&mon<10000) {
        
    }else
    {
        [LeafNotification showInController:self withText:@"输入价格应在0.1和9999之间。"];
        return;
    }
    [self creatAlbum];
}

- (void)creatAlbum{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
    }
    
    NSString *album_type = @"3"; // 1模特卡、2相册、3专题
    NSString *title = getSafeString(_name);

    NSString *style = @"0"; //样式:0无（用于相册）
    NSString *description = _description;
    NSLog(@"%@",_informationMutDic);
    NSString *contentStr = @"";
    if (_informationMutDic[@"content"]) {
        contentStr = [SQCStringUtils JSONStringWithDic:_informationMutDic[@"content"]];
    }
    NSString *provinceID = getSafeString(_informationMutDic[@"province"]);
    NSString *cityID = getSafeString(_informationMutDic[@"city"]);
    
    NSDictionary *params = [AFParamFormat formatCreateMokaParams:@{@"album_type":album_type,@"style":style,@"title":title,@"description":_briefIntroduction,@"content":contentStr,@"province":provinceID,@"city":cityID}];
    [AFNetwork createAlbum:params success:^(id data) {
         if ([data[@"status"] integerValue] == kRight) {
            //此时已经执行了完成操作，防止导航栏上的按钮再次点击
            [self closeNavigationButton];
            [LeafNotification showInController:self withText:[self getSuccessInfo] withTime:[self getNotificatioTime]];
            //提示消失消失之后再返回
            //[self performSelector:@selector(successNotifion) withObject:nil afterDelay:[self getNotificatioTime]];
             [self performSelector:@selector(popToPersonPage) withObject:nil afterDelay:[self getNotificatioTime]];

            //获取到套系的id之后才可以继续正确的上传图片
            albumId = getSafeString(data[@"data"][@"albumId"]);
            //上传图片到套系中
             dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                for (int i = 0; i < self.locationMutArr.count; i ++) {
                    [self uploadPhotoMethod:self.locationMutArr[i] with:i+1];
                }
            });
            
        }else if([data[@"status"] integerValue] == kReLogin){
            
            
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }else{
            [LeafNotification showInController:self withText:getSafeString(data[@"msg"])];
        }
        
    } failed:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哦~"];
    }];
}

-(void)uploadPhotoMethod:(UIImage *)image with:(int)i{
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        BOOL isBangDing = [USER_DEFAULT boolForKey:IsBangDingPhone];
        if (!isBangDing) {
            //显示绑定
            [(AppDelegate *)[UIApplication sharedApplication].delegate showBangDingViewController];
            return;
        }
    }else{
        //显示登陆
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        return;
    }
    NSInteger type = 6;
    NSString *tags = @"";
    NSString *title = @"";
    
    NSString *sequence = [NSString stringWithFormat:@"%ld",_maxSequence + i - 1];
    
    @try {
        if ([_descriptionMutDic objectForKey:[NSString stringWithFormat:@"%d",i - 1]]) {
            title = [_descriptionMutDic objectForKey:[NSString stringWithFormat:@"%d",i - 1]];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    title = _descriptionArr[i -1];
    //转码unicode
    //title = [SQCStringUtils utf8ToUnicode:title];
    
    
    
   // NSDictionary *dict = [AFParamFormat formatPostMokaUploadTaoXiParams:uid tags:tags title:title type:type albumid:albumId file:@"file"];
    NSDictionary *dict = [AFParamFormat formatPostMokaUploadParams:uid tags:tags title:title type:type sequence:sequence albumid:albumId file:@"file"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    //NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    //    //2M以下不压缩
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(image, 0.3);
    }
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
        image = [UIImage imageWithData:imageData];
    }
    
//    NSLog(@"--------:%@",dict);
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data) {
        //        dispatch_semaphore_signal(sem);
        if ([data[@"status"] integerValue] == kRight) {
            
        }else{
            [LeafNotification showInController:self withText:getSafeString(data[@"msg"])];
        }
        
    } failed:^(NSError *error) {
        //        dispatch_semaphore_signal(sem);
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哦~"];    }];
}


- (void)successNotifion{
    for (id obj in self.navigationController.childViewControllers) {
        if ([obj isKindOfClass:[NewMyPageViewController class]]) {
            [self.navigationController popToViewController:obj animated:YES];
            return;
        }
    }
}



#pragma mark - 代理textFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //标记已经修改
    _haveModifyed = YES;
    _textField = textField;
    [self saveFieldContent:textField];
     return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self saveFieldContent:textField];
    _textField = textField;
    return YES;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    //指针指向textfield，指针取消第一响应
    NSInteger fieldTag = textField.tag;
    if (fieldTag == 100){
        //专题名称
        _name = getSafeString(textField.text);
    }else if (fieldTag == 101){
        //专题类型
        _type = getSafeString(textField.text);
    }else if(fieldTag == 102){
        //专题价格
        _price = getSafeString(textField.text);
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
    _textField = textField;
}



- (void)saveFieldContent:(UITextField *)textField{
    //指针指向textfield，指针取消第一响应
    NSInteger fieldTag = textField.tag;
    if (fieldTag == 100){
        //专题名称
        _name = getSafeString(textField.text);
    }else if (fieldTag == 101){
        //专题类型
        _type = getSafeString(textField.text);
    }else if(fieldTag == 102){
        //专题价格
        _price = getSafeString(textField.text);
        textField.keyboardType = UIKeyboardTypeDecimalPad;
    }
}




#pragma mark - 代理TextView
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _haveModifyed = YES;
    _textView = textView;
    [self saveTextViewContent:textView];
    //隐藏提示文字
    UILabel *label = [textView viewWithTag:50];
    if (label != nil) {
        label.hidden = YES;
    }
    return YES;
}



- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    [self saveTextViewContent:textView];
    /*
     CGSize  size = textView.contentSize;
     textView.frame = CGRectMake(textView.left ,textView.top, size.width,size.height );
     NSInteger viewTag = textView.tag;
     if (viewTag >200) {
     //图片单元格上的txtView
     NSIndexPath *indexPath=[NSIndexPath indexPathForRow:viewTag -201 inSection:2];
     //更新tableView高度
     [self tableView:self.tableView heightForRowAtIndexPath:indexPath];
     }
     */
    
//    CGSize  size = textView.contentSize;
//    textView.frame = CGRectMake(textView.left ,textView.top, size.width,size.height );

    if ([text isEqualToString:@"\n"]) {
        [textView endEditing:YES];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}



- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    //结束编辑
    _isInputting = NO;
    //如果没有内容显示提示文字
    UILabel *label = [textView viewWithTag:50];
    if (label != nil) {
        if(textView.text.length == 0)
            label.hidden = NO;
    }
    [textView resignFirstResponder];
    [textView setContentOffset:CGPointMake(0, 0)];
    //保存内容
    [self saveTextViewContent:textView];
    return YES;
}


- (void)saveTextViewContent:(UITextView *)textView{
    NSInteger viewTag= textView.tag;
    NSString *description = textView.text;
    if (viewTag == 200) {
        //保存专题的描述
        _briefIntroduction = description;
        if (textView.text.length == 0) {
            
        }
        
    }else if(viewTag >200){
        //保存对于图片的描述
        NSString *str = [NSString stringWithFormat:@"%d",(int)(viewTag -201)];
        [_descriptionMutDic setObject:description forKey:str];
        @try {
            [self.descriptionArr setObject:description atIndexedSubscript:viewTag -201];

        }
        @catch (NSException *exception) {
            NSLog(@"错误：%@",exception);
        }
        @finally {
            
        }

    }
}

#pragma mark - 代理UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //如果是外层tableView,
    if ([scrollView isKindOfClass:[UITableView class]]) {
        //滑动外层的tableView，目的是消失键盘
        if (_isInputting) {
            [_textField resignFirstResponder];
            [_textView resignFirstResponder];
            _isInputting = NO;
        }else{
            
        }
    }
    
    //如果是textField
    if ([scrollView isKindOfClass:[UITextField  class]]) {
        
     }
    //如果是textView
    if ([scrollView isKindOfClass:[UITextField  class]]) {
        
    }
}


- (void)dismissKeyBoard{
    
    [_textField resignFirstResponder];
    [_textView resignFirstResponder];
    
    [_textView endEditing:YES];
    [_textField endEditing:YES];
}



#pragma mark - SelectPhotoDelegate
-(void)getSelectedPhoto:(NSMutableArray *)photos{
    NSLog(@"seleted");
    //[self.locationMutArr removeAllObjects];
    for (id obj in photos) {
        if ([obj isKindOfClass:[ALAsset class]]) {
            CGImageRef posterImageRef= [[obj defaultRepresentation] fullScreenImage];
            UIImage *image = [UIImage imageWithCGImage:posterImageRef];
            [self.locationMutArr addObject:image];
        }
    }
    
    [self.alSelectPhotos addObjectsFromArray: photos];
    [self.tableView reloadData];
}

-(void)delegatePhoto:(id)sender{
    NSLog(@"delegate");
    _deleteBtn = sender;
    _deleteBtn.hidden = YES;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定删除？" message:@"删除照片同时会删除照片的内容描述" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
    UIButton *btn = (UIButton *)sender;
    //记录将删除的图片的所以
    _deleteIndex = btn.tag - 1000;
    
}



#pragma mark - 通知处理
- (void)taoxiTypeChose:(NSNotification *)notification{
    NSDictionary *dic = notification.object;
    _type = getSafeString(dic[@"value"]);
    _typeNum = getSafeString(dic[@"type"]);
    [self.tableView reloadData];
}

- (void)taoxiInformation:(NSNotification *)notification{
    
    _informationMutDic = [NSMutableDictionary dictionaryWithDictionary:notification.object];
    
    self.taoxiInfoDict = _informationMutDic;
    
}

- (void)taoxiCoverurl:(NSNotification *)notification{
    self.coverUrl = getSafeString(notification.object);
    _haveModifyed = YES;
}



#pragma mark - alertView处理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView == _backAlert) {
        switch (buttonIndex) {
            case 1:
                [self dismissKeyBoard];
                 [self.navigationController popViewControllerAnimated:YES];
                break;
                
            default:
                break;
        }
    }else{
        switch (buttonIndex) {
                _haveModifyed = YES;
            //删除图片弹出提示
            case 1:
                //网络
                if (_deleteIndex < self.selectPhotos.count) {
                    [deleteArr addObject:[self.selectPhotos objectAtIndex:_deleteIndex]];
                    [self.selectPhotos removeObjectAtIndex:_deleteIndex];
                    //删除描述
                     [self.descriptionArr removeObjectAtIndex:_deleteIndex];

                    
                }else{
                    //删除本地图片
                    [self.alSelectPhotos removeObjectAtIndex:_deleteIndex - self.selectPhotos.count];
                    [self.locationMutArr removeObjectAtIndex:_deleteIndex - self.selectPhotos.count];
                    [self.descriptionArr removeObjectAtIndex:_deleteIndex];
                }
                //本地
                [self.tableView reloadData];
                break;
                
            default:
                _deleteBtn.hidden = NO;
                break;
        }
    }
}




#pragma mark - 键盘监听
- (void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardNotificationAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

//
//- (void)addKeyBoardNotification{
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardNotificationAction:) name:UIKeyboardDidShowNotification object:nil];
//}


//键盘响应事件
- (void)keyBoardNotificationAction:(NSNotification *)notification{
    CGFloat keyBoard_topY = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;

    
    //CGFloat keyBoard_height = [notification.userInfo objectForKey:(nonnull id)]

    //得到的坐标是是不计导航栏的
    NSLog(@"键盘的顶部高度(不计导航栏):%f",keyBoard_topY);
    //获取当前的输入框相对于屏幕的位置
    CGRect rect;
    if ([_textView isFirstResponder]) {
        rect = [_textView convertRect:_textView.bounds toView:_textView.window];
    }else if([_textField isFirstResponder]){
        rect = [_textField convertRect:_textField.bounds toView:_textField.window];
    }

    
    
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    

    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y - end.origin.y>0)){
        //keyBoardHeight = curkeyBoardHeight;
        if (rect.origin.y +rect.size.height >keyBoard_topY) {
            //tablew需要滑动一定的距离之后，才能够不遮住键盘
            CGFloat distance  = rect.origin.y +rect.size.height - keyBoard_topY +10;
            //原来tableView的偏移量
            CGPoint tableOffset = self.tableView.contentOffset;
            //执行动画
            [UIView animateWithDuration:0.3 animations:^{
                [self.tableView  setContentOffset:CGPointMake(tableOffset.x, tableOffset.y +distance) animated:NO];
            }completion:^(BOOL finished) {
                //在tableView滑动到合适的位置时
                //进入编辑状态
                _isInputting = YES;
                
            }];
        }else{
            _isInputting = YES;
        }
    }
    
    if (begin.origin.y < end.origin.y) {
        
        [self.tableView  setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}


 #pragma mark - get方法
//表头视图
-(BuildTaoXiHeaderView *)buildTXH{
    if (!_buildTXH) {
        _buildTXH = [[BuildTaoXiHeaderView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth,kDeviceWidth *TaoXiScale)];
    }
    return _buildTXH;
}
//已经上传网络的图片
-(NSMutableArray *)selectPhotos{
    if (!_selectPhotos) {
        _selectPhotos = [NSMutableArray array];
    }
    return _selectPhotos;
}


- (NSMutableArray *)descriptionArr{
    if (_descriptionArr == nil) {
        _descriptionArr = [NSMutableArray array];
    }
    return _descriptionArr;
}


//
-(NSMutableArray *)alSelectPhotos{
    if (!_alSelectPhotos) {
        _alSelectPhotos = [NSMutableArray array];
    }
    return _alSelectPhotos;
}

-(NSMutableArray *)locationMutArr{
    if (!_locationMutArr) {
        _locationMutArr = [NSMutableArray array];
    }
    return _locationMutArr;
}

-(NSMutableArray *)locationHeight{
    if (!_locationHeight) {
        _locationHeight = [NSMutableArray array];
    }
    return _locationHeight;
}

//点击完成弹出的文案
- (NSString *)getSuccessInfo{
    NSString *info = @"";
    if(_locationMutArr.count > 0){
        //此次操作有新图片上传
        NSDictionary *descriptionDic = [USER_DEFAULT objectForKey:@"lang_description" ];
        info = [descriptionDic objectForKey:@"album_upload"];
        if (info.length == 0) {
            info = @"内容上传中,请稍后再来查看";
        }

    }else{
        //此次操作无图片上传
        info = @"操作成功";
    }
    
    return info;
}

//点击完成，弹出的提示的显示时间
- (NSInteger)getNotificatioTime{
    if (_locationMutArr.count == 0) {
        //无图片上传,显示时间较短
        return 1.3;
    }else{
        //有图片上传
        return 2;
    }
}



@end
