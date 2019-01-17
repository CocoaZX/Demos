//
//  McRenZhengViewController.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McRenZhengViewController.h"

//#import "RenZhengPartOneTableViewCell.h"
#import "NewRenZhengPartOneTableViewCell.h"
#import "RenZhengPartTwoTableViewCell.h"
#import "RenZhengPartThreeTableViewCell.h"
#import "PersonPageViewModel.h"
@interface McRenZhengViewController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,
UIActionSheetDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *dataArray;

//新样式的cellOne
@property(nonatomic,strong)NewRenZhengPartOneTableViewCell *partOneCell;
@property (strong, nonatomic) RenZhengPartTwoTableViewCell *partTwoCell;
@property (strong, nonatomic) RenZhengPartThreeTableViewCell *partThreeCell;


@property(nonatomic,copy)NSString *organizationName;
@property(nonatomic,copy)NSString *realName;
@property(nonatomic,copy)NSString *idCardNum;

@property(nonatomic,strong)UIImage *chooseImage;
@property(nonatomic,copy)NSString *chooseImageID;

@property(nonatomic,strong)UITextField *currentTxtField;

//初始进入界面的状态
//@property(nonatomic,assign)NSInteger viewStatus;

//@property(nonatomic,strong)PersonPageViewModel *pViewModel;
//底部状态按钮，表视图的表尾视图
@property(nonatomic,strong)UIView *bottomView;

@end

@implementation McRenZhengViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"资质认证";
    
    //self.viewStatus = 0;
    
    self.dataArray = @[@"partOneCell",@"partTwoCell",@"partThreeCell"].mutableCopy;
    
    self.mainTableView.backgroundColor = NewbackgroundColor;
    
    self.mainTableView.tableFooterView = self.bottomView;
    
    //self.mainTableView.hidden = YES;
    
    //请求个人信息
    //NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //[self requestGetUserInfoWithUid_renzheng:uid];
    
    //选择照片
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(chooseRenzhengImage) name:@"chooseRenzhengImage" object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chooseRenzhengImage" object:nil];
}

- (void)resetFrame
{
    self.mainTableView.frame = CGRectMake(0, -100, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);
    
}

- (void)resetBackFrame
{
    self.mainTableView.frame = CGRectMake(0, 0, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);
    
}

- (UIView *)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        
        UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
        [submit setFrame:CGRectMake(40, 20, kScreenWidth-80, 50)];
        submit.tag = 300;
        [submit setTitle:@"确认提交" forState:UIControlStateNormal];
        [submit setClipsToBounds:YES];
        submit.layer.cornerRadius = 10.0f;
        [submit setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
        [submit addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView addSubview:submit];
    }
    return _bottomView;
}


//- (RenZhengPartOneTableViewCell *)partOneCell
//{
//    if (!_partOneCell) {
//        _partOneCell = [RenZhengPartOneTableViewCell getRenZhengPartOneTableViewCell];
//        _partOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
//        _partOneCell.backgroundColor = [UIColor clearColor];
//    }
//    return _partOneCell;
//}


- (NewRenZhengPartOneTableViewCell *)partOneCell{
    if (!_partOneCell) {
        _partOneCell  = [NewRenZhengPartOneTableViewCell getNewRenZhengPartOneTableViewCell];
        _partOneCell.organizationTextField.delegate = self;
        _partOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partOneCell.backgroundColor = [UIColor clearColor];
    }
    return _partOneCell;
}



- (RenZhengPartTwoTableViewCell *)partTwoCell
{
    if (!_partTwoCell) {
        _partTwoCell = [RenZhengPartTwoTableViewCell getRenZhengPartTwoTableViewCell];
        _partTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partTwoCell.backgroundColor = [UIColor clearColor];
        //设置输入框代理
        _partTwoCell.realnameTextfield.delegate  =self;
        _partTwoCell.idcardTextfield.delegate = self;
        
    }
    return _partTwoCell;
}

- (RenZhengPartThreeTableViewCell *)partThreeCell
{
    if (!_partThreeCell) {
        _partThreeCell = [RenZhengPartThreeTableViewCell getRenZhengPartThreeTableViewCell];
        _partThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partThreeCell.backgroundColor = [UIColor clearColor];

    }
    if (self.chooseImage) {
        _partThreeCell.renZhengImage = self.chooseImage;

    }
    return _partThreeCell;
}


#pragma mark - 事件处理
- (void)popViewControllerDelay
{
    [self.navigationController popViewControllerAnimated:YES];
}



- (BOOL)checkValue{
    if (_organizationName.length == 0) {
        [LeafNotification showInController:self withText:@"请输入公司或者学校名称"];
        return NO;
    }
    
    
    if (_realName.length == 0) {
        [LeafNotification showInController:self withText:@"请输入真实姓名"];
        return NO;
    }
    //名字长度
    NSDictionary *realNameLimitDic = [USER_DEFAULT objectForKey:@"rule_fontlimit" ][@"real_name"];
    NSInteger min = [realNameLimitDic[@"min"] integerValue];
    NSInteger max = [realNameLimitDic[@"max"] integerValue];
    if (_realName.length<min ||_realName.length >max) {
        NSString *info = [NSString stringWithFormat:@"姓名长度在%@和%@之间",realNameLimitDic[@"min"],realNameLimitDic[@"max"]];
        [LeafNotification showInController:self withText:info];
        return NO;
    }

    
    //检查身份证号
    if (_idCardNum.length == 0) {
        [LeafNotification showInController:self withText:@"请输入身份证号"];
        return NO;
    }
    
    if (![SQCStringUtils validateIdentityCard:_idCardNum]) {
        [LeafNotification showInController:self withText:@"请输入正确的身份证号"];
        return NO;
    }
    
    
    if (self.chooseImageID.length == 0) {
        [LeafNotification showInController:self withText:@"请选择照片"];
        return NO;
    }
    
    return YES;
}



- (void)chooseRenzhengImage{
    [self dismissKeyBoard];
    UIActionSheet *choosePhotoActionSheet;
    choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片" delegate:self
                                                cancelButtonTitle:@"取消"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"拍照", @"相册", nil];
    
    [choosePhotoActionSheet showInView:self.view];
}

//UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUInteger sourceType = 0;
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
        switch (buttonIndex) {
            case 0:
                if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                else{
                    [LeafNotification showInController:self withText:@"您的设备不支持照相功能"];
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
    [self presentViewController:imagePickerController animated:NO completion:nil];
}


/*
- (void)updateBottomView{
    UIButton *subBtn = [self.bottomView viewWithTag:300];
    NSInteger status = [self.pViewModel.authentication integerValue];
    switch (status) {
        case -1://未认证
        {
            [subBtn setTitle:@"确认提交" forState:UIControlStateNormal];
            break;
        }
        case -2://认证失败
        {
            [subBtn setTitle:@"确认提交" forState:UIControlStateNormal];
            break;
        }
        case 0://审核中
        {
            [subBtn setTitle:@"审核中" forState:UIControlStateNormal];
            break;
        }
        default:{
            [subBtn setTitle:@"审核成功" forState:UIControlStateNormal];
            break;
        }
    }
}
*/



#pragma mark - 代理方法：UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.chooseImage = image;
    [self uploadSelectedImage:image];
    //更新表视图选中图片的显示
    [self.mainTableView reloadData];
 }

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





#pragma mark - 有关网络部分的操作
/*
 认证：-2=认证失败，-1=未认证
 0=审核中，非0认证级别
 */


/*
- (void)requestGetUserInfoWithUid_renzheng:(NSString *)uid
{
    NSDictionary *params = [AFParamFormat formatGetUserInfoParams:uid];
    [AFNetwork getUserInfo:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            self.mainTableView.hidden = NO;
            NSDictionary *dict = [CommonUtils cleanNullClassFromDictionary:data[@"data"]];
            
            [self processData:dict];
            
            //表尾视图
            [self updateBottomView];
            self.mainTableView.tableFooterView = self.bottomView;
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
        
    }failed:^(NSError *error){
        
    }];
}


- (void)processData:(NSDictionary *)dict
{
    @try {
        //[USER_DEFAULT setValue:dict forKey:MOKA_USER_VALUE];
       // [USER_DEFAULT synchronize];
        
    }
    @catch (NSException *exception) {
        NSLog(@"错误：%@",exception);
    }
    @finally {
        
    }
    
   self.pViewModel = [[PersonPageViewModel alloc] initWithDiction:dict];
//    NSString *url = [self.pViewModel getCutHeaderURLWithView:self.headerImageView];
//    self.titleLabel.text = self.pViewModel.headerName;
//    self.descLabel.text = self.pViewModel.headerIntroduce;
//    self.headerImageView.clipsToBounds = YES;
//    self.headerImageView.layer.cornerRadius = 5;
//    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
    //self.pViewModel.authentication = @"1";
    
 
    if([self.pViewModel.authentication isEqualToString:@"-1"])//未认证
    {
        [self notRenzheng];
        [self isHadImage:0];//
        
    }else if ([self.pViewModel.authentication isEqualToString:@"-2"])//认证失败
    {
        [self failedRenzheng];
        [self isHadImage:0];
        
    }else if ([self.pViewModel.authentication isEqualToString:@"0"])//审核中
    {
        [self doingRenzheng];
        [self isHadImage:2];
        
    }else  //审核成功
    {
        [self successRenzheng];
        [self isHadImage:1];
    }
 
}
*/


//请求认证
- (void)submitData:(id)sender
{
    
    _organizationName = [self getTextFieldContent:100];
    _realName = [self getTextFieldContent:200];
    _idCardNum = [self getTextFieldContent:201];
    
    if (![self checkValue]) {
        return;
    }
    
    NSString *uid = getCurrentUid();
    NSDictionary *dict = @{@"uid":uid,@"photoid":self.chooseImageID,@"real_name":self.realName, @"organization_ame":self.organizationName,@"user_card":self.idCardNum};
    
    NSDictionary *param = [AFParamFormat formatSystemFeedBackParams:dict];
    
    [AFNetwork postRequeatDataParams:param path:PathPersonRenZheng success:^(id data) {
        NSLog(@"请求认证：%@",data);
        NSInteger status = [data[@"status"] integerValue];
        if (status == kRight) {
            [self popViewControllerDelay];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    } failed:^(NSError *error) {
        NSLog(@"请求失败：%@",error.description);
    }];
}

//选择图片之后上传图片
- (void)uploadSelectedImage:(UIImage *)image{
    {
        //避免图片太大，对图片压缩
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
        //    //2M以下不压缩
        while (imageData.length/1024 > 2048) {
            imageData = UIImageJPEGRepresentation(image, 0.8);
            self.chooseImage= [UIImage imageWithData:imageData];
        }
        
        //上传图片的参数
        NSString *uid = getSafeString(getCurrentUid());
        NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid type:UploadPhotoType_IDENTIFIER file:@"file"];

        [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
             NSLog(@"%@",data);
             //1.上传图片成功，得到图片id
             NSDictionary *dic = data[@"data"];
             _chooseImageID= [NSString stringWithFormat:@"%@",dic[@"id"]];
          }failed:^(NSError *error){
             NSLog(@"上传图片失败");
         }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _currentTxtField = textField;
     return YES;
}

//输入确定后
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)dismissKeyBoard{
    [_currentTxtField resignFirstResponder];
}

- (NSString *)getTextFieldContent:(NSInteger)tag{
    UITextField *textField = [self.mainTableView viewWithTag:tag];
    return  getSafeString(textField.text);
}



#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return 80;
        
    }else if(indexPath.row==1)
    {
        return 130;
        
    }else if (indexPath.row==2)
    {
        return 130;
    }
    
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
    BOOL canEdit = NO;
    NSInteger status = [self.pViewModel.authentication integerValue];
    switch (status) {
        case -1://未认证
        {
            canEdit = YES;
            break;
        }
        case 0://审核中
        {
            canEdit = NO;
            break;
        }

        case -2://认证失败
        {
            canEdit = YES;
            break;
        }

        default://审核成功
        {
            canEdit = NO;
            break;
        }
    }
    */
    if (indexPath.row==0) {
        //self.partOneCell.organizationTextField.enabled = canEdit;
         return self.partOneCell;
        
    }else if(indexPath.row==1)
    {
        //self.partTwoCell.realnameTextfield.enabled= canEdit;
        //self.partTwoCell.idcardTextfield.enabled= canEdit;
        return self.partTwoCell;
        
    }else if (indexPath.row==2)
    {
        //self.partThreeCell.addPhotoButton.userInteractionEnabled= canEdit;
        return self.partThreeCell;
    }
    
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self dismissKeyBoard];
}


@end
