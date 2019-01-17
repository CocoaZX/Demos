//
//  McPersonalDataViewController.m
//  Mocha
//
//  Created by renningning on 14-11-22.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McPersonalDataViewController.h"


#import "McEditNickNameViewController.h" //输入
#import "McEditPersonalViewController.h"//选择列表（单选）
#import "McEditBirthViewController.h"  //滚轮选择
#import "McEditWorkTagsViewController.h"  //多选
#import "McBwhViewController.h"  //三围
#import "McEditAreaViewController.h"  //地区
#import "McProvinceViewController.h"

#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "JSONKit.h"
#import "ReadPlistFile.h"
//更新头像和昵称
#import "ChatUserInfo.h"
#import "CoreDataManager.h"


@interface McPersonalDataViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSArray *dataArray;
    UIImageView *headImageView;
    UIImageView *nextImageView;
    
    NSDictionary *sexDict;
    NSDictionary *jobDict;
    NSArray *areaArray;
    NSDictionary *hairDict;
    NSDictionary *majorDict;
    NSDictionary *workTagDict;
    NSDictionary *figureTagDict;
    NSDictionary *feetDict;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) BOOL isModel;

@property (nonatomic , strong) UIPickerView *pickerView;

@property (nonatomic , strong) UIView *informationView;

@property (nonatomic , strong) NSArray *highArr;

@property (nonatomic , strong) NSArray *weighArr;

@property (nonatomic , strong) NSArray *xiongArr;

@property (nonatomic , strong) NSArray *yaoArr;

@property (nonatomic , strong) NSArray *tunArr;

@property (nonatomic , strong) UIButton *clickButton;

@property (nonatomic , strong) UIButton *cancelButton;

@property (nonatomic , assign) int typeNumber;//0身高1体重2三围

@property (nonatomic , strong) UILabel *informationLabel;

@property (nonatomic , strong) UILabel *bustLabel;

@property (nonatomic , strong) UILabel *waistLabel;

@property (nonatomic , strong) UILabel *hipsLabel;

//临时变量：新的昵称和头像
@property (nonatomic,copy)NSString *tempNickName;
@property (nonatomic,copy)NSString *tempHeadUrl;

@end
//ust = bust;
//_personalData.waist = waist;
//_personalData.hips

@implementation McPersonalDataViewController
#pragma mark lazyLoad
-(UILabel *)bustLabel{
    if (!_bustLabel) {
        _bustLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/6, kDeviceHeight/20, 30, 30)];
        _bustLabel.text = @"胸";
        _bustLabel.font = [UIFont systemFontOfSize:15];
    }
    return _bustLabel;
}

-(UILabel *)waistLabel{
    if (!_waistLabel) {
        _waistLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/2.05, kDeviceHeight/20, 30, 30)];
        _waistLabel.text = @"腰";
        _waistLabel.font = [UIFont systemFontOfSize:15];
    }
    return _waistLabel;
}

-(UILabel *)hipsLabel{
    if (!_hipsLabel) {
        _hipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/5*4 , kDeviceHeight/20, 30, 30)];
        _hipsLabel.text = @"臀";
        _hipsLabel.font = [UIFont systemFontOfSize:15];
    }
    return _hipsLabel;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _typeNumber = 0;
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"个人资料";
    
    NSString *type = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"type"];
    _tempNickName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"nickname"];
    _tempNickName = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];

    if ([type isEqualToString:@"1"]) {
        self.isModel = YES;

    }else
    {
        self.isModel = NO;

    }
    
    NSArray *sectionOneArr = @[@"修改头像",@"昵称",@"地区"];
    NSArray *sectionTwoArr = @[@"身高",@"体重",@"三围"];
    if (!self.isModel) {
        sectionTwoArr = @[@"工作室"];
    }
    NSArray *sectionThreeArr = @[@"个人介绍",@"工作经验"];

    dataArray = [NSArray arrayWithObjects:sectionOneArr,sectionTwoArr,sectionThreeArr, nil];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    headerView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    self.tableView.tableHeaderView = headerView;
    [self.view addSubview:_tableView];
    
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [headImageView setImage:[UIImage imageNamed:@"head60"]];
    [headImageView.layer setMasksToBounds:YES];
    [headImageView.layer setCornerRadius:headImageCornerRadius];

    nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    [nextImageView setImage:[UIImage imageNamed:@"oicon031"]];
    
    //    [self loadArrayWithFile];
//    
//    [self requestGetUserInfo];
//    [self loadPersonalData];
    [self loadInformationView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark LoadInformationView

-(void)loadInformationView{
    self.informationView = [[UIView alloc]initWithFrame:CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight/3)];
    self.informationView.backgroundColor = [UIColor whiteColor];
    
    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(5, kDeviceHeight/3 - kDeviceHeight/4 - 5, kDeviceWidth - 10 , kDeviceHeight/3);
//    self.pickerView.backgroundColor = [UIColor grayColor];
    [self.informationView addSubview:self.pickerView];
    
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
    
    self.informationLabel = [[UILabel alloc]initWithFrame:CGRectMake(kDeviceWidth/3, 0, kDeviceWidth/3, 25)];
    self.informationLabel.textAlignment = NSTextAlignmentCenter;
    self.informationLabel.font = [UIFont systemFontOfSize:18];
    [self.informationView addSubview:self.informationLabel];
    
    [self.view addSubview:self.informationView];
}
#pragma mark LoadData
- (void)loadArrayWithFile
{
    sexDict = [ReadPlistFile readSex];

    areaArray = [ReadPlistFile readAreaArray];
    
//    workTagDict = [ReadPlistFile readWorkTags];
//    
//    figureTagDict = [ReadPlistFile readWorkStyles];
//    
//    hairDict = [ReadPlistFile readHairs];
//    
//    jobDict = [ReadPlistFile readProfession];
//    
//    majorDict = [ReadPlistFile readMajor];
//    
//    feetDict = [ReadPlistFile readFeets];

}

//未用到
- (void)loadPersonalData
{
    NSDictionary *dataDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    if (!_personalData) {
        _personalData = [[McPersonalData alloc] init];
    }
    _personalData.nickName = dataDict[@"nickname"];
    _personalData.headUrl = dataDict[@"head_pic"];
    NSString *sexStr = dataDict[@"sex"];
    
    if ([sexStr intValue] == 1) {
        _personalData.sex = @"男";
    }
    else if([sexStr intValue] == 2){
        _personalData.sex = @"女";
    }
    else{
        _personalData.sex = @"";
    }
    
    _personalData.job = [jobDict valueForKey:dataDict[@"job"]];
    _personalData.major = [majorDict valueForKey:dataDict[@"major"]];
    _personalData.height = dataDict[@"height"];
    _personalData.weight = dataDict[@"weight"];
    
    _personalData.age = [dataDict[@"birth"] isEqualToString:@"0000-00-00"]?@"":dataDict[@"birth"];
    
    NSString *provinceId = dataDict[@"province"];
    NSString *cityId = dataDict[@"city"];
    NSString *province = @"";
    NSString *city = @"";
    for (NSDictionary *dicts in areaArray) {
        if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
            province = dicts[@"name"];
            NSArray *citys = dicts[@"citys"];
            for (NSDictionary *cityDict in citys) {
                if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                    city = cityDict[@"name"];
                }
            }
        }
    }
    _personalData.area = [NSString stringWithFormat:@"%@%@",getSafeString(dataDict[@"provinceName"]) ,getSafeString(dataDict[@"cityName"])];
    _personalData.measurements = [NSString stringWithFormat:@"%@-%@-%@",dataDict[@"bust"],dataDict[@"waist"],dataDict[@"hipline"]];
    _personalData.bust = dataDict[@"bust"];
    _personalData.waist = dataDict[@"waist"];
    _personalData.hips = dataDict[@"hipline"];
    _personalData.hair = [hairDict valueForKey:dataDict[@"hair"]];//需要修改
    _personalData.feetCode = [hairDict valueForKey:dataDict[@"foot"]];
    _personalData.signName = dataDict[@"mark"];
    _personalData.leg = dataDict[@"leg"];
    
    NSArray *workArr = [dataDict[@"worktags"] componentsSeparatedByString:@","];
    NSMutableString *workStr = [NSMutableString stringWithString:@""];
    for (NSString *key in workArr) {
        [workStr appendString:[NSString stringWithFormat:@"%@ ",workTagDict[key]]];
    }
    
    NSArray *figureArr = [dataDict[@"workstyle"] componentsSeparatedByString:@","];
    NSMutableString *figureStr = [NSMutableString stringWithString:@""];
    for (NSString *key in figureArr) {
        [figureStr appendString:[NSString stringWithFormat:@"%@ ",figureTagDict[key]]];
    }
    if ([figureStr isEqualToString:@"[NULL]"]) {
        figureStr = [NSMutableString stringWithString:@""];
    }
    if ([workStr isEqualToString:@"[NULL]"]) {
        workStr = [NSMutableString stringWithString:@""];
    }
    
    _personalData.figureLabel = figureStr;
    _personalData.workExperience = dataDict[@"workhistory"];
    _personalData.introduction = dataDict[@"introduction"];
    _personalData.workLabel = workStr;
    _personalData.desiredSalary = dataDict[@"payment"];
}


#pragma mark private
- (void)choosePhoto:(id)sender
{
    UIActionSheet *choosePhotoActionSheet;
    choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片"
                                                         delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"拍照", @"相册", nil];
    
    
    [choosePhotoActionSheet showInView:self.view];
}

- (void)requestGetUserInfo
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            [USER_DEFAULT setValue:dict forKey:MOKA_USER_VALUE];
            [USER_DEFAULT synchronize];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        
    }];
}


- (void)editUserHeadAction:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    //    //2M以下不压缩
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(image, 0.3);
    }
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
        image = [UIImage imageWithData:imageData];
    }

    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
    NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid type:3 file:@"file"];
    
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@  SVN",data);
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:@"修改头像成功"];
            //            [self editSaveHeadUrl:data];
        }
    }failed:^(NSError *error){
        
    }];}

- (void)modifyUserHeadAction:(UIImage *)image
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
    //    //2M以下不压缩
    if (imageData.length/1024 > 1024 * 5) {
        imageData = UIImageJPEGRepresentation(image, 0.3);
    }
    while (imageData.length/1024 > 2048) {
        imageData = UIImageJPEGRepresentation(image, 0.6);
        image = [UIImage imageWithData:imageData];
    }

    NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid type:3 file:@"file"];
    [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
        NSLog(@"uploadPhoto:%@  SVN",data);
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:@"修改头像成功"];
            //更新头像到数据库中
            _tempHeadUrl = data[@"data"][@"url"];
            [self updateChatInfoToDB];
            NSString *jpg = [CommonUtils imageStringWithWidth:100 height:100];
            _personalData.headUrl = [NSString stringWithFormat:@"%@%@",data[@"data"][@"url"],jpg];
            [_tableView reloadData];
            
//            NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            [self.tableView reloadRowsAtIndexPaths:@[reloadIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            [self editSaveHeadUrl:data];
        }
    }failed:^(NSError *error){
        
    }];
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
        headImageView.image = image;
        //上传头像
        [self modifyUserHeadAction:image];
        //    [self editUserHeadAction:info];
        
    }
 
    
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITableViewDataSource UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"PersonalDataCell%ld",(long)indexPath.row + (long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSArray *arr = [dataArray objectAtIndex:indexPath.section];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    cell.textLabel.textColor = [CommonUtils colorFromHexString:kLikeGrayColor];
    
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping; //如何换行
    cell.detailTextLabel.numberOfLines = 0; //这个值设置为0可以让UILabel动态的显示需要的行数。
//    tableView.visibleCells

    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [headImageView sd_setImageWithURL:[NSURL URLWithString:_personalData.headUrl]];
                cell.accessoryView = headImageView;
                break;
            case 1:
                
                cell.detailTextLabel.text = _personalData.nickName;
                break;
            case 2:
                cell.detailTextLabel.text = _personalData.area;
                break;
             
                
            default:
                break;
        }
    }
    else if(indexPath.section == 1){
        if (self.isModel) {
            switch (indexPath.row) {
                case 0:
                    cell.detailTextLabel.text = [_personalData.height integerValue] > 0?[NSString stringWithFormat:@"%@厘米",_personalData.height]:@"";
                    if ([_personalData.authentication integerValue] == 1){
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case 1:
                    cell.detailTextLabel.text = [_personalData.weight integerValue] > 0?[NSString stringWithFormat:@"%@公斤",_personalData.weight]:@"";
                    if ([_personalData.authentication integerValue] == 1){
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                case 2:
                    cell.detailTextLabel.text = _personalData.measurements;
                    if ([_personalData.authentication integerValue] == 1){
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }
                    break;
                    
                default:
                    break;
            }
        }else
        {
            
        
        }
        
    }
    else if(indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
            case 1:
                cell.detailTextLabel.text = @"";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                break;
            
            default:
                break;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 10)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    return view;
    
}

//UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
//            _personalData.signName
            CGSize size = [CommonUtils sizeFromText:[_personalData.signName stringByReplacingOccurrencesOfString:@"\n" withString:@" "] textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(self.tableView.frame.size.width - 80, 100)];
            return (size.height + 20) > 50? (size.height + 20) : 50;
        }
    }
    if(indexPath.section == 2) {
        if (indexPath.row == 1) {
            CGSize size = [CommonUtils sizeFromText:_personalData.workLabel textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(self.tableView.frame.size.width - 80, 100)];
            return (size.height + 20) > 50? (size.height + 20) : 50;
        }
        

    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                [self choosePhoto:nil];
                break;
            case 1:
            {
                McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McpersonalTypeNickName];
                editDataVC.personalData = _personalData;
                
                [self.navigationController pushViewController:editDataVC animated:YES];
            }
                break;
            case 2:
            {
                McProvinceViewController *editDataVC = [[McProvinceViewController alloc] init];
                editDataVC.personalData = _personalData;
                editDataVC.editOrSearch = 1;
                [self.navigationController pushViewController:editDataVC animated:YES];
            }
                break;
            
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
        if (self.isModel) {
//            switch (indexPath.row) {
//                case 0:
//                {
////                    if ([_personalData.authentication integerValue] == 1) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请联系客服修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        return;
////                    }
//// 身高页面改为pickerview
//                    [self personDataPicker:indexPath];
////
////                    McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McPersonalTypeHeight];
////                    editDataVC.personalData = _personalData;
////                    [self.navigationController pushViewController:editDataVC animated:YES];
////                    
//                }
//                    break;
//                case 1:
//                {
////                    if ([_personalData.authentication integerValue] == 1) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请联系客服修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        return;
////                    }
//                    [self personDataPicker:indexPath];
//         
////                    McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McPersonalTypeWeight];
////                    editDataVC.personalData = _personalData;
////                    [self.navigationController pushViewController:editDataVC animated:YES];
//                }
//                    break;
//                case 2:
//                {
////                    if ([_personalData.authentication integerValue] == 1) {
////                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请联系客服修改" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
////                        [alert show];
////                        return;
////                    }
//                    
////                    McBwhViewController *editDataVC = [[McBwhViewController alloc] init];
////                    editDataVC.personalData = _personalData;
////                    [self.navigationController pushViewController:editDataVC animated:YES];
//                    [self personDataPicker:indexPath];
//        
//                }
//                    break;
//                    
//                default:
//                    break;
//            }
            [self personDataPicker:indexPath];
        }else
        {
            McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McPersonalTypeWorkWorkPlace];
            editDataVC.personalData = _personalData;
            [self.navigationController pushViewController:editDataVC animated:YES];
            
        }
        
    }
    else if (indexPath.section == 2){
        switch (indexPath.row) {
            case 0:
            {
                McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McPersonalTypeWorkIntroduction];
                editDataVC.personalData = _personalData;
                [self.navigationController pushViewController:editDataVC animated:YES];
            }
                break;
            case 1:
            {
                McEditNickNameViewController *editDataVC = [[McEditNickNameViewController alloc] initWithType:McPersonalTypeWorkExperience];
                editDataVC.personalData = _personalData;
                [self.navigationController pushViewController:editDataVC animated:YES];
                
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - 身高 体重 三围选择器
-(void)personDataPicker:(NSIndexPath *)indexPath{
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
     [self judgeInformationView];
            switch (indexPath.row) {
            case 0://身高
            {
                NSMutableArray *highMutArr = @[].mutableCopy;
                for (int i = 150; i< 200; i++) {
                    NSNumber *high = [NSNumber numberWithInt:i];
                    [highMutArr addObject:high];
                }
                self.highArr = highMutArr;
                [self.pickerView selectRow:25 inComponent:0 animated:NO];
                 self.informationLabel.text = @"身高";
                _typeNumber = 0;
                
            }
                break;
            case 1://体重
            {
                NSMutableArray *weightMutArr = @[].mutableCopy;
                for (int i = 35; i<90; i++) {
                    NSNumber *weight = [NSNumber numberWithInt:i];
                    [weightMutArr addObject:weight];
                }
                self.weighArr = weightMutArr;
                _typeNumber = 1;
                [self.pickerView selectRow:30 inComponent:0 animated:NO];
                self.informationLabel.text = @"体重";
                break;
            }
            case 2://三围
            {
                NSMutableArray *xiongArr = @[].mutableCopy;
                for (int i = 70; i<130; i++) {
                    NSString *xiong = [NSString stringWithFormat:@"%d",i];
                    [xiongArr addObject:xiong];
                }
                self.xiongArr = xiongArr;
                NSMutableArray *yaoArr = @[].mutableCopy;
                for (int i = 50; i< 110; i++) {
                    NSString *yao = [NSString stringWithFormat:@"%d",i];
                    [yaoArr addObject:yao];
                }
                self.yaoArr = yaoArr;
                NSMutableArray *tunArr = @[].mutableCopy;
                for (int i = 70; i < 130; i++) {
                    NSString *tun = [NSString stringWithFormat:@"%d",i];
                    [tunArr addObject:tun];
                }
                self.tunArr = tunArr;
                self.informationLabel.text = @"请选择三围";
                _typeNumber = 2;
                
                [self.pickerView selectRow:20 inComponent:0 animated:NO];
                [self.pickerView selectRow:20 inComponent:1 animated:NO];
                [self.pickerView selectRow:20 inComponent:2 animated:NO];
                [self.informationView addSubview:self.bustLabel];
                [self.informationView addSubview:self.waistLabel];
                [self.informationView addSubview:self.hipsLabel];
                break;
            }
        }
    [self.pickerView reloadAllComponents];
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight/2, kDeviceWidth, kDeviceHeight/3);
    }];
}

-(void)judgeInformationView{
    for (UILabel *obj in [self.informationView subviews]) {
        if (obj == self.bustLabel) {
            [self.bustLabel removeFromSuperview];
            [self.waistLabel removeFromSuperview];
            [self.hipsLabel removeFromSuperview];
            return;
        }
    }
}

#pragma mark - pickViewDelegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_typeNumber == 2) {
        return 3;
    }
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component{
    switch (_typeNumber) {
        case 0:
            return self.highArr.count;
            break;
        case 1:
            return self.weighArr.count;
            break;
        case 2:{
            switch (component) {
                case 0:
                    return self.xiongArr.count;
                    break;
                case 1:
                    return self.yaoArr.count;
                    break;
                case 2:
                    return self.tunArr.count;
                    break;
            }
        }
    }
           return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row
           forComponent:(NSInteger)component{
    switch (_typeNumber) {
        case 0:
            return [NSString stringWithFormat:@"%@ cm",self.highArr[row]];
            break;
        case 1:
            return [NSString stringWithFormat:@"%@ kg",self.weighArr[row]];
            break;
        case 2:{
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self.pickerView selectRow:15 inComponent:0 animated:NO];
                [self.pickerView selectRow:20 inComponent:1 animated:NO];
                [self.pickerView selectRow:20 inComponent:2 animated:NO];
            });
                switch (component) {
                case 0:
                    return [NSString stringWithFormat:@"%@",self.xiongArr[row]];
                    break;
                case 1:
                    return [NSString stringWithFormat:@"%@",self.yaoArr[row]];
                    break;
                case 2:
                    return [NSString stringWithFormat:@"%@",self.tunArr[row]];
                    break;
            }
        }
    }
    return nil;
}

#pragma mark save data
-(void)cancelButtonAction:(UIButton *)sender{
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
    }];
}

-(void)clickButtonAction:(UIButton *)sender{
    NSDictionary *userDict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
    NSString *uid = [userDict valueForKey:@"id"];
    NSString *mobile = [userDict valueForKey:@"mobile"];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"uid":uid,@"mobile":mobile}];
    //上传数据
    switch (_typeNumber) {
        case 0://身高
        {
            NSInteger row = [self.pickerView selectedRowInComponent:0] +150;
            NSString *highStr = [NSString stringWithFormat:@"%ld",(long)row];
            [dict setValue:highStr forKey:@"height"];
            _personalData.height = highStr;
        }
            
            break;
        case 1://体重
        {
            NSInteger row = [self.pickerView selectedRowInComponent:0] + 35;
            NSString *weightStr = [NSString stringWithFormat:@"%ld",(long)row];
            [dict setValue:weightStr forKey:@"weight"];
            _personalData.weight = weightStr;
        }
            break;
        case 2://三围
        {
            NSInteger xiong = [self.pickerView selectedRowInComponent:0] + 70;
            NSInteger yao = [self.pickerView selectedRowInComponent:1] + 50;
            NSInteger tun = [self.pickerView selectedRowInComponent:2] + 70;
            NSString *bust = [NSString stringWithFormat:@"%ld",(long)xiong];
            NSString *waist = [NSString stringWithFormat:@"%ld",(long)yao];
            NSString *hips = [NSString stringWithFormat:@"%ld",(long)tun];
            [dict setValue:bust forKey:@"bust"];
            [dict setValue:waist forKey:@"waist"];
            [dict setValue:hips forKey:@"hipline"];
            _personalData.measurements = [NSString stringWithFormat:@"%@-%@-%@",bust,waist,hips];
        }
            break;
    }
    NSDictionary *params = [AFParamFormat formatEditUserInfoParams:dict];
    [AFNetwork editUserInfo:params success:^(id data) {
        [self editDonePersonalData:data];
    } failed:^(NSError *error) {
        NSLog(@"error :%@,%d",error,__LINE__);
    }];
    [self.tableView reloadData];
    [UIView animateWithDuration:0.5 animations:^{
        self.informationView.frame = CGRectMake(0, kDeviceHeight, kDeviceWidth, kDeviceHeight);
    }];
}
- (void)editDonePersonalData:(id)data{
    if ([data[@"status"] integerValue] == kRight) {
        NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
        [USER_DEFAULT setObject:dict forKey:MOKA_USER_VALUE];
        [USER_DEFAULT synchronize];
    }
}


#pragma mark - 更新数据到数据库中
//更新头像
- (void)updateChatInfoToDB{
    //说明这是从聊天界面进入的那么可以更新一下此人的用户信息
    ChatUserInfo *chatUser = [self getUserWithMessageUserName:getCurrentUid()];
    if (!chatUser) {
        //创建对象存在数据库中
        chatUser = (ChatUserInfo *)[[CoreDataManager shareInstance] createMO:@"ChatUserInfo"];
        chatUser.chatId = getCurrentUid();
        chatUser.nickName = _tempNickName;
        chatUser.headPic = _tempHeadUrl;
        [[CoreDataManager shareInstance] saveManagerObj:chatUser];
    }else{
        //用户存在，但是有更新，就更新数据库
        if (![chatUser.nickName isEqualToString:_tempNickName] ||![chatUser.headPic isEqualToString:_tempHeadUrl]) {
            chatUser.nickName = _tempNickName;
            chatUser.headPic = _tempHeadUrl;
            [[CoreDataManager shareInstance] updateManagerObj:chatUser];
        }
    }
    
}

//从数据库中取出昵称和头像信息
- (ChatUserInfo *)getUserWithMessageUserName:(NSString *)username{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"chatId=%@",username];
    NSArray *users = [[CoreDataManager shareInstance] query:@"ChatUserInfo" predicate:predicate];
    
    if (users.count>0) {
        return users[0];
    }
    return nil;
}


@end
