//
//  TaoXiInformationController.m
//  Mocha
//
//  Created by XIANPP on 16/2/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "TaoXiInformationController.h"
#import "UploadPhotoCell.h"
#import "TaoXiDescriptionCell.h"
#import "ReadPlistFile.h"
#import "TaoXiInfoCell.h"



@interface TaoXiInformationController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    BOOL isLocation;
    BOOL isedit;
    NSMutableArray *_cityArray;
    NSMutableArray *_areaArray;
    UITextField *_textField;
    BOOL _userAction;
    NSString *_clothing;
    NSString *_makeUp;
    NSString *_plate;
    NSString *_location;
    NSString *_photos;
    NSString *_time;
    NSString *_jingxiu;
    NSString *_experience;
    NSString *_equipment;
    NSMutableDictionary *_parameterMutDic;
}
@property (nonatomic , strong)NSMutableArray *dataSource;
@property (nonatomic , strong)NSMutableArray *placeholderArr;

@property (nonatomic , assign)NSInteger selectedRow;

@property (nonatomic , strong)UIPickerView *locationPickerView;

@property (nonatomic , strong)UIView *informationView;

@property (nonatomic , strong)UIButton *cancelButton;

@property (nonatomic , strong)UIButton *clickButton;

@property (nonatomic , copy)  NSString *province;

@property (nonatomic , copy)  NSString *city;

@property (nonatomic , copy)  NSString *provinceID;
@property (nonatomic , copy)  NSString *cityID;

@property (nonatomic , strong) NSMutableDictionary *currentDict;

@end

@implementation TaoXiInformationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    [self navigationSetting];
    [self keyboardNotifiation];
//    if (!_isCheck) {
    self.placeholderArr = [NSMutableArray arrayWithArray:@[@"拍摄地点",@"拍摄照片数",@"精修照片数",@"拍摄时长(小时)",@"提供拍摄服装",@"提供化妆",@"提供底片",@"拍摄经验",@"拍摄器材"]];
//    }
    [self.tableView registerNib:[UINib nibWithNibName:@"TaoXiDescriptionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"TaoXiDescriptionCell"];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(uploadTXInformation)];
    rightItem.tintColor = [CommonUtils colorFromHexString:kLikeRedColor];
    self.navigationItem.rightBarButtonItem = rightItem;

    [self getLoctionInformation];
    _clothing = @"0";
    _makeUp = @"0";
    _plate = @"0";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateNO" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeIsNeedToPopStateYES" object:nil];
}

-(void)initWithDictionary:(NSDictionary *)dict{
    NSLog(@"%@",dict);
    
    _currentDict = [NSMutableDictionary dictionaryWithDictionary:dict];
    _provinceID = [NSString stringWithFormat:@"%@", getSafeString(dict[@"provinceID"])];
    _cityID = [NSString stringWithFormat:@"%@", getSafeString(dict[@"cityID"])];
    
    _location = [NSString stringWithFormat:@"%@", getSafeString(dict[@"content"][@"setplace"])];
    _photos = [NSString stringWithFormat:@"%@",getSafeString(dict[@"content"][@"settotalcont"])];
    _experience = [NSString stringWithFormat:@"%@",getSafeString(dict[@"content"][@"setexperience"])];
    _equipment = [NSString stringWithFormat:@"%@",getSafeString(dict[@"content"][@"setequipment"])];
    _jingxiu = [NSString stringWithFormat:@"%@", getSafeString(dict[@"content"][@"settruingcount"])];
    _time = [NSString stringWithFormat:@"%@",getSafeString(dict[@"content"][@"settime"])];
    if (_location) {
        _isCheck = YES;
    }
    
    
    _clothing = getSafeString(dict[@"content"][@"setisclothing"]);
    if ([_clothing isEqualToString:@"1"]) {
        _clothing = @"提供服装";
    }else{
        _clothing = @"不提供服装";
    }
    _makeUp = getSafeString(dict[@"content"][@"setisdressing"]);
    if ([_makeUp isEqualToString:@"1"]) {
        _makeUp = @"提供化妆";
    }else{
        _makeUp = @"不提供化妆";
    }
    _plate = getSafeString(dict[@"content"][@"setisnegative"]);
    if ([_plate isEqualToString:@"1"]) {
        _plate = @"提供底片";
    }else{
        _plate = @"不提供底片";
    }
    if (_experience.length == 0) {
        _experience = @"拍摄经验";
    }
    
    if (_equipment.length == 0) {
        _equipment = @"拍摄器材";
    }
    
//    self.dataSource = [NSMutableArray arrayWithArray:@[_location,_photos,_jingxiu,_time,@"提供拍摄服装",@"提供化妆",@"提供底片",_experience,_equipment]];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[_location?_location:@"拍摄地点",_photos?_photos:@"拍摄照片数",_jingxiu?_jingxiu:@"精修照片数",_time?_time:@"拍摄时长(小时)",@"提供拍摄服装",@"提供化妆",@"提供底片",_experience?_experience:@"拍摄经验",_equipment?_equipment:@"拍摄器材"]];
//    [self.tableView reloadData];
}

-(void)setWithDic:(NSDictionary *)dic{
    NSLog(@"setDic");
    _location = getSafeString(dic[@"setplace"]);
    _photos = getSafeString(dic[@"settotalcont"]);
    _jingxiu = getSafeString(dic[@"settruingcount"]);
    _time = getSafeString(dic[@"settime"]);
    _experience = getSafeString(dic[@"setexperience"]);
    _equipment = getSafeString(dic[@"setequipment"]);
    _clothing = getSafeString(dic[@"setisclothing"]);
    _makeUp = getSafeString(dic[@"setisdressing"]);
    _plate = getSafeString(dic[@"setisnegative"]);
    self.dataSource = [NSMutableArray arrayWithArray:@[_location,_photos,_jingxiu,_time,_clothing,_makeUp,_plate,_experience,_equipment]];
    [self.tableView reloadData];
}

-(void)navigationSetting{
    self.navigationItem.title = @"专题信息";
    UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [setBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [setBtn addTarget:self action:@selector(doBackAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:setBtn];
    self.navigationItem.leftBarButtonItem = rightItem;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
}

- (void)keyboardNotifiation{
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //键盘变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillChange:)
                                                 name:UIKeyboardWillChangeFrameNotification object:nil];
    //键盘退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification{
    
}

- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGPoint offset = self.tableView.contentOffset;
    if (yOffset < 0) {
        offset.y -= yOffset;
        if (offset.y < 0) {
            offset.y = 0;
        }
    }
    [self.tableView setContentOffset:offset animated:YES];
}

- (void)keyboardWillBeHidden:(NSNotification *)notification{
    
}


- (void)doBackAction:(id)sender
{
    if (!_isCheck) {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"放弃保存？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!_isCheck) {
        return 1;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return 4;
//            break;
//        case 1:
//            return 3;
//            break;
//        case 2:
//            return 2;
//            break;
//        default:
//            return 1;
//            break;
//    }
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
    view.backgroundColor = [CommonUtils colorFromHexString:kLikeGrayReleaseColor];
    UILabel *label = [[UILabel alloc]initWithFrame:view.bounds];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor grayColor];
    [view addSubview:label];
    switch (section) {
        case 0:
            label.text = @" 让他人了解拍摄专题的细节";
            break;
        case 1:
            label.text = @" 完善拍摄细节";
            break;
        case 2:
            label.text = @" 让他人更了解你";
            break;
        default:
            break;
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 3) {
        return 20;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isCheck) {
        if (indexPath.section == 2) {
            //经验和器材
            switch (indexPath.row) {
                case 0:{
                    CGSize size = [CommonUtils sizeFromText:_experience textFont:[UIFont systemFontOfSize:16] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 30, MAXFLOAT)];
                    if (size.height < 50) {
                        size.height = 50;
                    }
                    return size.height;
                }
                    break;
                case 1:{
                    CGSize size = [CommonUtils sizeFromText:_equipment textFont:[UIFont systemFontOfSize:16] boundingRectWithSizeOrconstrainedToSize:CGSizeMake(kDeviceWidth - 30, MAXFLOAT)];
                    if (size.height < 50) {
                        size.height = 50;
                    }
                    return size.height;
                }
                    break;
                default:
                    break;
            }
        }
    }
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (indexPath == 0) {
        TaoXiInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiInfoCell"];;
    
        if (!cell) {
            cell = [[TaoXiInfoCell alloc]init];
        }
    
    cell.contentTextFild.tag = indexPath.row;
        cell.titleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
        cell.titleLabel.text = self.placeholderArr[indexPath.row];
        
        cell.contentTextFild.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    
    if (_isCheck) {
        cell.contentTextFild.placeholder = [NSString stringWithFormat:@"%@",self.dataSource[indexPath.row]];
    }
    
        cell.forwardImg.hidden = YES;
        
        if (indexPath.row == 0) {
            cell.contentTextFild.userInteractionEnabled = NO;
//            cell.contentTextFild.hidden = YES;
            cell.contentTextFild.borderStyle = UITextBorderStyleNone;
            cell.forwardImg.hidden = NO;
        }else{
            cell.contentTextFild.userInteractionEnabled = YES;
            cell.contentTextFild.hidden = NO;
            cell.forwardImg.hidden = YES;
        }
        cell.contentTextFild.keyboardType = UIKeyboardTypeNumberPad;
        cell.contentTextFild.delegate = self;
        //                if (_isCheck) {
        //                    cell.descriptionTextField.userInteractionEnabled = NO;
        //                }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
//    }

        
//    if (indexPath.section!=3) {
//        if (indexPath == 0) {
//            TaoXiInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiInfoCell" forIndexPath:indexPath];
//            if (!cell) {
//                cell = [TaoXiInfoCell getTaoXiInfoCell];
//            }
//        }else{
//            TaoXiDescriptionCell *descriptionCell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiDescriptionCell" forIndexPath:indexPath];
//            if (!descriptionCell) {
//                descriptionCell = [TaoXiDescriptionCell getTaoXiDescriptionCell];
//            }
//        }
//        
//        
//        switch (indexPath.section) {
//                
//            case 0:
//            { if (indexPath == 0) {
//                    TaoXiInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiInfoCell" forIndexPath:indexPath];
//                    if (!cell) {
//                        cell = [TaoXiInfoCell getTaoXiInfoCell];
//                    }
//                    
//                cell.titleLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
//                cell.titleLabel.text = self.placeholderArr[indexPath.row];
//                
////                if (![cell.descriptionTextField.text isEqualToString:@""]) {
////                    cell.descriptionTextField.placeholder = self.dataSource[indexPath.row];
////                }
//                
//                cell.contentTextFild.textColor = [UIColor colorForHex:kLikeGrayTextColor];
//                cell.contentTextFild.text = [NSString stringWithFormat:@"%@:%@",self.placeholderArr[indexPath.row],self.dataSource[indexPath.row]];
//                cell.forwardImg.hidden = YES;
//                
//                
//                
//                
//                if (indexPath.row == 0) {
//                    cell.contentTextFild.userInteractionEnabled = NO;
//                    cell.forwardImg.hidden = NO;
//                }
//                cell.contentTextFild.keyboardType = UIKeyboardTypeNumberPad;
//                cell.contentTextFild.delegate = self;
////                if (_isCheck) {
////                    cell.descriptionTextField.userInteractionEnabled = NO;
////                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//                break;
//                }
//            case 1:
//                
//
//                    {   TaoXiDescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiDescriptionCell" forIndexPath:indexPath];
//                        if (!cell) {
//                            cell = [TaoXiDescriptionCell getTaoXiDescriptionCell];
//                        }
//                
//                cell.detailTextView.hidden = YES;
//                cell.descriptionTextField.text = self.dataSource[4+indexPath.row];
//                cell.descriptionTextField.userInteractionEnabled = NO;
//                NSString *judgeStr = @"0";
//                for (id obj in cell.subviews) {
//                    if ([obj isKindOfClass:[UISwitch class]]) {
//                        judgeStr = @"1";
//                    }
//                }
//                if (!_isCheck && [judgeStr isEqualToString:@"0"]) {
//                    UISwitch *customSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(kDeviceWidth - 70, 10, 80, 40)];
//                    customSwitch.onTintColor = [CommonUtils colorFromHexString:kLikeRedColor];
//                    [customSwitch setContentMode:UIViewContentModeRedraw];
//                    [cell addSubview:customSwitch];
//                    customSwitch.tag = 10 + indexPath.row;
//                    [customSwitch addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
//                }                    
//            
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return cell;
//                break;
//                        }
//            case 2:
//            {
//                TaoXiDescriptionCell *tempCell = [tableView dequeueReusableCellWithIdentifier:@"TaoXiDescriptionCell" forIndexPath:indexPath];
//                if (!tempCell) {
//                    tempCell = [TaoXiDescriptionCell getTaoXiDescriptionCell];
//                }
//                tempCell.descriptionTextField.placeholder = self.dataSource[7+indexPath.row];
//                tempCell.descriptionTextField.returnKeyType = UIReturnKeyDone;
//                tempCell.forward.hidden = YES;
//                tempCell.descriptionTextField.userInteractionEnabled = YES;
//                tempCell.descriptionTextField.delegate = self;
//                if (_isCheck) {
//                    tempCell.detailTextView.hidden = NO;
//                    tempCell.detailTextView.text = self.dataSource[7+indexPath.row];
//                }
//            
//                tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
//                return tempCell;
//                break;
//            }
//            default:
//                break;
//            
//        
//        return nil;
//    }
//    UploadPhotoCell *cell = [UploadPhotoCell getUploadPhotoCell];
//    cell.btn.text = @"确定";
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
}

-(void)switchValueChanged:(id)sender{
    //数据处理
    UISwitch *customSwitch = (UISwitch *)sender;
    switch (customSwitch.tag) {
        case 10:
            if (customSwitch.isOn) {
                _clothing = @"1";
            }else{
                _clothing = @"0";
            }
            break;
        case 11:
            if (customSwitch.isOn) {
                _makeUp = @"1";
            }else{
                _makeUp = @"0";
            }
            break;
            
        case 12:
            if (customSwitch.isOn) {
                _plate = @"1";
            }else{
                _plate = @"0";
            }
            break;
        default:
            break;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (_isCheck) {
//        return;
//    }
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:{
                    if (!isLocation) {
                        if ([_textField isFirstResponder]) {
                            [_textField resignFirstResponder];
                        }
                    self.tableView.scrollEnabled = NO;
                    NSLog(@"choseLoaction");
                    _locationPickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(5, kDeviceHeight/3 - kDeviceHeight/4, kDeviceWidth - 10 , kDeviceHeight/3)];
                    _locationPickerView.delegate = self;
                    _locationPickerView.dataSource = self;
                    [_locationPickerView selectRow:_selectedRow inComponent:0 animated:NO];
                    self.informationView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight/3)];
                    self.informationView.backgroundColor = [UIColor whiteColor];
                    [self.informationView addSubview:self.locationPickerView];
                    
                    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    self.cancelButton.frame = CGRectMake(5, 3, 30, 30);
                    [self.cancelButton setTitle:@"取消" forState:UIControlStateNormal];
                    [self.cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.informationView addSubview:self.cancelButton];
                    
                    self.clickButton = [UIButton buttonWithType:UIButtonTypeSystem];
                    self.clickButton.frame = CGRectMake(kDeviceWidth - 35, 3, 30, 30);
                    [self.clickButton setTitle:@"完成" forState:UIControlStateNormal];
                    [self.clickButton addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                    [self.informationView addSubview:self.clickButton];
                    [self.view addSubview:self.informationView];
                    isLocation = YES;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.informationView.frame = CGRectMake(0, kDeviceHeight/2 - 10, kDeviceWidth, kDeviceHeight/2);
                    }];
                }
                }
                    break;
            }
        }
            break;
        case 1:{
            
        }
            break;
        case 3:{
            
        }
            break;
        default:
            break;
    }
    
}

-(void)cancelButtonAction:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
    }];
    self.tableView.scrollEnabled = YES;
    isLocation = NO;
}

-(void)clickButtonAction:(UIButton *)sender{
    
    _province = _areaArray[[_locationPickerView selectedRowInComponent:0]][@"name"];
    _city = _cityArray[_selectedRow][[_locationPickerView selectedRowInComponent:1]][@"name"];
    
    _provinceID = _areaArray[[_locationPickerView selectedRowInComponent:0]][@"id"];
    _cityID = _cityArray[_selectedRow][[_locationPickerView selectedRowInComponent:1]][@"id"];
    
    self.dataSource[0] = getSafeString([NSString stringWithFormat: @"%@  %@",_province,_city]);
    if ([_province isEqualToString:_city]) {
        self.dataSource[0] = getSafeString([NSString stringWithFormat:@"%@",_province]);
    }
    _location = getSafeString(self.dataSource[0]);
    
    NSLog(@"%@",_location);
    _isCheck = YES;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
    }];
    isLocation = NO;
    self.tableView.scrollEnabled = YES;
    
    
//    [self.tableView reloadData];
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
            if ([dic[@"name"] isEqualToString:@"北京市"]|[dic[@"name"] isEqualToString:@"天津市"]|[dic[@"name"] isEqualToString:@"重庆"]|[dic[@"name"] isEqualToString:@"上海市"]) {
                NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
                [mutDic setObject:dic[@"id"] forKey:@"id"];
                [mutDic setObject:dic[@"name"] forKey:@"name"];
                [citysMutArr addObject:mutDic];
            }
            [citysMutArr addObjectsFromArray:dic[@"citys"]];
            [_cityArray addObject:citysMutArr];
        }
        NSDictionary *locDic = [USER_DEFAULT valueForKey:USER_LOCATION];
        NSString *provinceStr = @"";
        NSString *cityStr = @"地区";
        if (locDic) {
            cityStr = [locDic valueForKey:@"city"];
            for (int i = 0; i < _cityArray.count; i++) {
                for (NSDictionary *dic in _cityArray[i]) {
                    if ([cityStr isEqualToString:[NSString stringWithFormat:@"%@",dic[@"name"]]]) {
                        provinceStr = getSafeString(_areaArray[i][@"name"]);
                        
                        return;
                    }
                }
            }
        }
    }
    
    @catch (NSException *exception) {
        NSLog(@"%@",exception.name);
    }
    @finally {
        
    }
}
#pragma mark - Done
- (void)uploadTXInformation{
    
    [_textField endEditing:YES];
    //判断条件
//    if (_location.length < 2) {
//        [LeafNotification showInController:self withText:@"请填写地区信息"];
//        return;
//    }
    _parameterMutDic = [NSMutableDictionary dictionary];
    [_parameterMutDic setObject:_clothing?_clothing:@"" forKey:@"setisclothing"];
    [_parameterMutDic setObject:_makeUp?_makeUp:@"" forKey:@"setisdressing"];
    [_parameterMutDic setObject:_plate?_plate:@"" forKey:@"setisnegative"];
    
    
    [_parameterMutDic setObject:_location?_location:@"" forKey:@"setplace"];
    [_parameterMutDic setObject:_photos?_photos:@"" forKey:@"settotalcont"];
    [_parameterMutDic setObject:_time?_time:@"" forKey:@"settime"];
    [_parameterMutDic setObject:_jingxiu?_jingxiu:@"" forKey:@"settruingcount"];
    
    BOOL isExisPhoto = [self isExisString:_photos];
//    BOOL isExislocation = [self isExisString:_location];
    BOOL isExistime = [self isExisString:_time];
    BOOL isExisjingxiu = [self isExisString:_jingxiu];
    
//    [_parameterMutDic setObject:_experience?_experience:@"" forKey:@"setexperience"];
//    [_parameterMutDic setObject:_equipment?_equipment:@"" forKey:@"setequipment"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    [dict setObject:_parameterMutDic forKey:@"content"];
    [dict setObject:_provinceID?_provinceID:@"" forKey:@"province"];
    [dict setObject:_cityID?_cityID:@"" forKey:@"city"];
    
    _currentDict = [NSMutableDictionary dictionary];
    [_currentDict setObject:_parameterMutDic forKey:@"content"];
    [_currentDict setObject:_provinceID?_provinceID:@"" forKey:@"province"];
    [_currentDict setObject:_cityID?_cityID:@"" forKey:@"city"];
    
    NSLog(@"%@",_currentDict[@"content"]);
    
    if (isExistime && isExisPhoto && isExisjingxiu && _location.length ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"taoxiInformation" object:_currentDict];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [LeafNotification showInController:self withText:@"请将信息填写完整"];
    }
    
}

-(BOOL)isExisString:(NSString *)str{
    
    if (![SQCStringUtils isPureFloat:str] &&![SQCStringUtils isPureInt:str]) {
        
        return NO;
    }
    
    if (str.length > 0) {
        return YES;
    }else{
        return NO;
    }
}





-(NSString *)getOnlyDataString:(NSString *)str{
    
    
    NSString *newStr;
    NSRange range= [newStr rangeOfString: @":"];
    
    if(range.location!=NSNotFound)
    {
       newStr = [str substringWithRange: NSMakeRange(range.location+1, str.length-range.length-1)];
        NSLog(@"%@",str);
    }
    
    return newStr;
}

#pragma mark - pickerViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _areaArray.count;
            break;
        case 1:
            return [_cityArray[_selectedRow] count];
            break;
        default:
            break;
    }
    return 0;
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

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    switch (component) {
        case 0:
            return _areaArray[row][@"name"];
            break;
        case 1:
            return _cityArray[_selectedRow][row][@"name"];
        default:
            break;
    }
    return nil;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    textField.text = @"";
    
    if (isLocation) {
        [UIView animateWithDuration:0.25 animations:^{
            self.informationView.frame = CGRectMake(0, kDeviceHeight * 2, kDeviceWidth, kDeviceHeight);
        }];
        isLocation = NO;
    }
    _textField = textField;
    _userAction = NO;
    if ([textField.placeholder isEqualToString:@"拍摄照片数"]||[textField.placeholder isEqualToString:@"精修照片数"] || [textField.placeholder isEqualToString:@"拍摄时长(小时)"]) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    _userAction = NO;
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
//    if ([textField.placeholder isEqualToString:@"拍摄照片数"]) {
//        _photos = getSafeString(textField.text);
//    }
//    if ([textField.placeholder isEqualToString:@"精修照片数"]) {
//        _jingxiu = getSafeString(textField.text);
//    }
//    if ([textField.placeholder isEqualToString:@"拍摄时长(小时)"]) {
//        _time = getSafeString(textField.text);
//    }
//    if ([textField.placeholder isEqualToString:@"拍摄经验"]) {
//        _experience = getSafeString(textField.text);
//    }
//    if ([textField.placeholder isEqualToString:@"拍摄器材"]) {
//        _equipment = getSafeString(textField.text);
//    }
    NSLog(@"%ld",(long)_textField.tag);
    if (_textField.tag == 1) {
        _photos = getSafeString(textField.text);
    }else if (textField.tag == 2){
        _jingxiu = getSafeString(textField.text);
    }else if(_textField.tag == 3){
        _time = getSafeString(textField.text);
    }else{
        
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([_textField isFirstResponder] && _userAction) {
        [_textField resignFirstResponder];
        if ([_textField.placeholder isEqualToString:@"拍摄照片数"]) {
            _photos = getSafeString(_textField.text);
        }
        if ([_textField.placeholder isEqualToString:@"精修照片数"]) {
            _jingxiu = getSafeString(_textField.text);
        }
        if ([_textField.placeholder isEqualToString:@"拍摄时长(小时)"]) {
            _time = getSafeString(_textField.text);
        }
        if ([_textField.placeholder isEqualToString:@"拍摄经验"]) {
            _experience = getSafeString(_textField.text);
        }
        if ([_textField.placeholder isEqualToString:@"拍摄器材"]) {
            _equipment = getSafeString(_textField.text);
        }
    }
    
    if (!_isCheck) {
        self.dataSource = [NSMutableArray arrayWithArray:@[_location?_location:@"拍摄地点",_photos?_photos:@"拍摄照片数",_jingxiu?_jingxiu:@"精修照片数",_time?_time:@"拍摄时长(小时)",@"提供拍摄服装",@"提供化妆",@"提供底片",_experience?_experience:@"拍摄经验",_equipment?_equipment:@"拍摄器材"]];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _userAction = YES;
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
