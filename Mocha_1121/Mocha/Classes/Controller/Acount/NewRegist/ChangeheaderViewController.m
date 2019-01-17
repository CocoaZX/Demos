//
//  ChangeheaderViewController.m
//  Mocha
//
//  Created by sun on 15/6/16.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ChangeheaderViewController.h"
#import "BangDingPhoneViewController.h"
#import "ReadPlistFile.h"

@interface ChangeheaderViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate , UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameTextfield;
@property (weak, nonatomic) IBOutlet UIButton *takephotoButton;
@property (weak, nonatomic) IBOutlet UIButton *sexButton;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
@property (assign, nonatomic) BOOL isGirl;
@property (strong, nonatomic) UIImage *headerImage;

@property (strong, nonatomic) UIImageView *headerImageView;

@property (strong, nonatomic) UILabel *yelloLabel;
@property (strong, nonatomic) UIView *alertView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navView;

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (nonatomic , strong)NSDictionary * nickNameLimDic;

@property (weak, nonatomic) IBOutlet UIButton *locationButton;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic , strong)NSArray * areaArray;
@property (nonatomic , strong)UIPickerView *locationPickerView;
@property (nonatomic , strong)NSMutableArray *cityArray;
@property (nonatomic , assign)NSInteger selectedRow;
@property (nonatomic , strong)UIView *informationView;
@property (nonatomic , strong)UIButton *cancelButton;
@property (nonatomic , strong)UIButton *clickButton;
@property (nonatomic , copy)  NSString *province;
@property (nonatomic , copy)  NSString *city;
@end

@implementation ChangeheaderViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRule_fontLimit];
    // Do any additional setup after loading the view from its nib.
    self.isGirl = YES;
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(96, 100, 130, 130)];
    self.headerImageView.center = CGPointMake(kScreenWidth/2, 165);
    self.headerImageView.layer.cornerRadius = 65;
    self.headerImageView.clipsToBounds = YES;
    self.nameTextfield.returnKeyType = UIReturnKeyDone;
    self.nameTextfield.delegate = self;
    if([ThirdLoginManager shareThirdLoginManager].isThirdLogin)
    {
        [self.takephotoButton setImage:nil forState:UIControlStateNormal];
        self.nameTextfield.text = [ThirdLoginManager shareThirdLoginManager].thirdUserName;
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL]];
    }
    [self.view addSubview:self.headerImageView];
    [self.view insertSubview:self.headerImageView belowSubview:self.takephotoButton];
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 34)];
    self.alertView.backgroundColor = [UIColor clearColor];
    
    self.yelloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
    self.yelloLabel.backgroundColor = RGB(255,255, 123);
    self.yelloLabel.textColor = RGB(230,62, 70);
    self.yelloLabel.text = @"";
    self.yelloLabel.hidden = NO;
    self.yelloLabel.font = [UIFont systemFontOfSize:15];
    self.yelloLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.alertView addSubview:self.yelloLabel];
    [self.view insertSubview:self.alertView belowSubview:self.navView];
    [self loadArrayWithFile];
}

-(void)loadArrayWithFile{
    //读取地区信息
    _areaArray = [ReadPlistFile readAreaArray];
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
    _selectedRow = 0;
    NSDictionary *locDic = [USER_DEFAULT valueForKey:USER_LOCATION];
    NSString *provinceStr = @"";
    NSString *cityStr = @"地区";
    if (locDic) {
        cityStr = [locDic valueForKey:@"city"];
        for (int i = 0; i < _cityArray.count; i++) {
            for (NSDictionary *dic in _cityArray[i]) {
                if ([cityStr isEqualToString:[NSString stringWithFormat:@"%@",dic[@"name"]]]) {
                    provinceStr = getSafeString(_areaArray[i][@"name"]);
                    _locationLabel.text = [NSString stringWithFormat:@"%@  %@",provinceStr,cityStr];
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

#pragma mark - getrule_fontlimit
-(void)getRule_fontLimit{
    _nickNameLimDic = [NSDictionary dictionary];
    NSDictionary *rule_fontDic = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    if (rule_fontDic) {
        if (rule_fontDic[@"nickname"]) {
            _nickNameLimDic = rule_fontDic[@"nickname"];
        }
    }
    if (_nickNameLimDic[@"max"] == nil) {
        [_nickNameLimDic setValue:[NSNumber numberWithInt:6] forKey:@"max"];
        [_nickNameLimDic setValue:[NSNumber numberWithInt:1] forKey:@"min"];
    }
}

- (void)showAlertWithString:(NSString *)string
{
    self.yelloLabel.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 64, kScreenWidth, 34);
    }];
    
    [self performSelector:@selector(hideAlerView) withObject:nil afterDelay:2.0];
}

- (void)hideAlerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 24, kScreenWidth, 34);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
}

- (IBAction)dismissKeyboard:(id)sender {
    [self.nameTextfield resignFirstResponder];
    
}


- (IBAction)backMethod:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)uploadHeader:(id)sender {
    UIActionSheet *choosePhotoActionSheet;
    choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"拍照", @"相册", nil];
    
    
    [choosePhotoActionSheet showInView:self.view];
    
}

- (IBAction)nvButton:(id)sender {
    self.isGirl = YES;
    
    self.sexImageView.image = [UIImage imageNamed:@"female"];
}

- (IBAction)nanButton:(id)sender {
    self.isGirl = NO;
    
    self.sexImageView.image = [UIImage imageNamed:@"male"];
}



- (IBAction)enterMoka:(id)sender {
    self.enterButton.enabled = NO;
    [self sendUserInfo];
    
}


- (BOOL)isCheck{
    
    if (self.nameTextfield.text.length==0) {

        [self showAlertWithString:[NSString stringWithFormat:@"昵称需要在%@-%@个字符",_nickNameLimDic[@"min"],_nickNameLimDic[@"max"]]];
        return NO;
    }
    
    if (self.nameTextfield.text.length > [_nickNameLimDic[@"max"] intValue] || self.nameTextfield.text.length < [_nickNameLimDic[@"min"] intValue]) {
        
        [self showAlertWithString:[NSString stringWithFormat:@"昵称需要在%@-%@个字符",_nickNameLimDic[@"min"],_nickNameLimDic[@"max"]]];
        return NO;

    }
    
    return YES;
}

- (IBAction)choseLocation:(id)sender {
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
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight/3 * 2 - 10, kDeviceWidth, kDeviceHeight/3);
    }];
    
    
}

-(void)cancelButtonAction:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
    }];
}

-(void)clickButtonAction:(UIButton *)sender{
    _province = _areaArray[[_locationPickerView selectedRowInComponent:0]][@"name"];
    _city = _cityArray[_selectedRow][[_locationPickerView selectedRowInComponent:1]][@"name"];
    _locationLabel.text = [NSString stringWithFormat:@"%@  %@",_province,_city];
    if ([_province isEqualToString:_city]) {
        _locationLabel.text = [NSString stringWithFormat:@"%@",_province];
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
    }];
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

#pragma mark- UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        
        switch (buttonIndex) {
            case 0:
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                else{
                    //                    [NotificationManager notificationWithMessage:@"您的设备不支持照相功能"];
                    return;
                }
                break;
            case 1:
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
            case 2:
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
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    //[self presentModalViewController:imagePickerController animated:YES];
    [self presentViewController:imagePickerController animated:NO completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    BOOL isAviary = UserDefaultGetBool(@"isUseAviary");
    if (isAviary) {
       
        
    }else
    {
        [self resetHeaderImage:image];

        
    }

}

- (void)resetHeaderImage:(UIImage *)image
{
    self.headerImage = image;
    [self.takephotoButton setImage:nil forState:UIControlStateNormal];
    self.headerImageView.image = image;
    self.headerImageView.layer.cornerRadius = 65;
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendUserInfo
{
    
    if (self.nameTextfield.text.length==0) {
        [self showAlertWithString:[NSString stringWithFormat:@"昵称需要在%@-%@个字符",_nickNameLimDic[@"min"],_nickNameLimDic[@"max"]]];
        [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
        return;
    }
    
//    if ([self.locationLabel.text isEqualToString:@"地区"]) {
//        [self showAlertWithString:[NSString stringWithFormat:@"请输入地区信息"]];
//        [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
//        return;
//    }
    
    if ([ThirdLoginManager shareThirdLoginManager].isThirdLogin) {
        if (self.headerImage) {
            [self uploadHeaderImage];

        }else
        {
            if ([ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL.length<2) {
                [self uploadHeaderImage];
                
            }else
            {
                [self uploadThirdHeaderImage];
            }
        }
        
    }else
    {
        [self uploadHeaderImage];
    }
   
}

//将图片缩放成指定大小（压缩方法）
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size {
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

- (void)uploadHeaderImage
{
    if (!self.headerImage) {
        [self showAlertWithString:@"头像不能为空"];
        [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
        
        return;
    }
    UIImage *headerImage = [self scaleToSize:self.headerImage size:CGSizeMake(500, 500)];
    
//    NSData *imageData = UIImageJPEGRepresentation(headerImage, 0.3);
    NSData *imageData = UIImageJPEGRepresentation(headerImage, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    
    //    //2M以下不压缩
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(headerImage, 0.3);
    }
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(headerImage, 0.6);
        headerImage = [UIImage imageWithData:imageData];
    }

    NSInteger sex = self.isGirl?2:1;
    
    [SVProgressHUD show];
    NSDictionary *dict = [AFParamFormat formatPostUploadNewLoginParams:sex
                                                                  name:self.nameTextfield.text
                                                              userType:self.currentRole
                                                                  file:@"headfile"
                                                                  province:_province
                                                                  city:_city];
    [AFNetwork uploadPhotoNewLogin:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@  SVN",data);
        if ([data[@"status"] integerValue] == kRight) {
            [self showAlertWithString:@"用户信息设置成功"];
            
            if ([ThirdLoginManager shareThirdLoginManager].isThirdLogin) {
                [self thirdLoginWithDiction:[ThirdLoginManager shareThirdLoginManager].paraDiction];

            }else
            {
                [self didLoginMethod];

            }
            
            return;
        }
        [SVProgressHUD dismiss];

        [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
        
        [self showAlertWithString:data[@"msg"]];
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
        
    }];

}

- (void)uploadThirdHeaderImage
{
    //传第三方的头像
    
    NSInteger sex = self.isGirl?2:1;
    NSDictionary *dict = [AFParamFormat formatPostUploadNewLoginThireParams:sex
                        name:self.nameTextfield.text
                   headerURL:[ThirdLoginManager shareThirdLoginManager].thirdHeaderImageURL
                    userType:self.currentRole];
    [AFNetwork uploadPhotoNewLoginThird:dict fileData:nil success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            [self showAlertWithString:@"用户信息设置成功"];
            //请绑定手机号
            BangDingPhoneViewController *bangding = [[BangDingPhoneViewController alloc] initWithNibName:@"BangDingPhoneViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:bangding animated:YES];
            return;
        }
        
        [self showAlertWithString:data[@"msg"]];
        
        
    }failed:^(NSError *error){
        
        
    }];
    [self performSelector:@selector(delayTowSecondEnable) withObject:nil afterDelay:2.0];
    
}

- (void)delayTowSecondEnable
{
    self.enterButton.enabled = YES;

}

- (void)didLoginMethod
{
    NSString *code = @"";
    NSString *password = @"";
    NSInteger _loginType = 2;
    
    password = [ThirdLoginManager shareThirdLoginManager].password;

    NSDictionary *params = [AFParamFormat formatLoginParams:[ThirdLoginManager shareThirdLoginManager].phoneNumber verify:code password:password loginType:_loginType];
    [AFNetwork newLoginWithUserName:params success:^(id data){
        [SVProgressHUD dismiss];

        if ([data[@"status"] integerValue] == kRight) {
            //将null转换“”
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
            [[ThirdLoginManager shareThirdLoginManager] clear];
            
            [ChatManager registOrLogin];

            [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];
            return;
        }
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];

        [self showAlertWithString:@"网络错误"];
        
    }];

}

- (void)thirdLoginWithDiction:(NSDictionary *)diction
{
    NSDictionary *params = [AFParamFormat formatThirdLoginParams:diction[@"openid"]
                                                    access_token:diction[@"access_token"]
                                                      expires_in:diction[@"expires_in"]
                                                       plat_type:[diction[@"plat_type"] integerValue]
                                                            idfa:diction[@"idfa"]];
    
    [AFNetwork getThirdLoginInfo:params success:^(id data){
        [SVProgressHUD dismiss];

        [[ThirdLoginManager shareThirdLoginManager] clear];
        
        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
        [USER_DEFAULT setValue:@"0" forKey:MOKA_USER_OVERDUE];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
        [[ThirdLoginManager shareThirdLoginManager] clear];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNewLoginDoneNotification object:nil];
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];

        [self showAlertWithString:@"网络请求失败"];
        
    }];
    
    
}

 

@end
