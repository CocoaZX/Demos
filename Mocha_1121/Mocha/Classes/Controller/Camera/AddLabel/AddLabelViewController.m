//
//  AddLabelViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "AddLabelViewController.h"
#import "AddLabelBottomView.h"
#import "AddLabelListViewController.h"
#import "UploadVideoManager.h"


@interface AddLabelViewController ()<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>

{
    BOOL isTuiJian;
    float _max;
    float _min;
}
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topBackImage;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@property (weak, nonatomic) IBOutlet UIButton *playVideoButton;

//@property (strong, nonatomic) UIButton *playVideoButton;
@property (strong, nonatomic) AddLabelBottomView *bottomView;

@property (strong, nonatomic) NSMutableArray *hotLabelArray;

@property (strong, nonatomic) NSMutableArray *labelArray;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UILabel *pleaceHolderLabel;

@property (weak, nonatomic) IBOutlet UITextView *titleTextView;

//@property (weak, nonatomic) IBOutlet UIButton *selectedBut;
- (IBAction)selectedButAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *seletectImageView;

@property (weak, nonatomic) IBOutlet UILabel *tuijianLabel;

- (IBAction)tapAction:(id)sender;

//@property (weak, nonatomic) IBOutlet UIView *grayView;

@property (weak, nonatomic) IBOutlet UIView *editView;

//约束
//编辑视图距离底部的
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *editView_bottomDistance;

@end

@implementation AddLabelViewController
#pragma mark - 视图生命周期及控件加载

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotLabelArray = @[].mutableCopy;
    //图片
    self.contentImageView.image = self.currentImage;
    //输入框视图
    [self.editView addSubview:self.pleaceHolderLabel];
    self.editView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.editView.layer.shadowOpacity = 1;
    //设置阴影路径
    //最后两位参数是阴影大小
    self.editView.layer.shadowPath  = [UIBezierPath bezierPathWithRect:CGRectMake(0,120,kDeviceWidth-20 , 3)].CGPath;
    
    
    
    //视频播放按钮
    self.playVideoButton.userInteractionEnabled = NO;
    if (self.videoURL.description) {
        /*
        if (!self.playVideoButton) {
            self.playVideoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
        }
        //[self.playVideoButton addTarget:self action:@selector(playVideoMethod:) forControlEvents:UIControlEventTouchUpInside];
        [self.playVideoButton setImage:[UIImage imageNamed:@"playButton-samll"] forState:UIControlStateNormal];
        [self.view addSubview:self.playVideoButton];
         */
        [self.view bringSubviewToFront:self.playVideoButton];
        
        self.playVideoButton.hidden = NO;
    }else{
        self.playVideoButton.hidden = YES;
    }
 
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.masksToBounds = YES;

 
    
    //顶部视图的设置
    [self.releaseButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.backButton setTitleColor:[CommonUtils colorFromHexString:kLikeWhiteColor] forState:UIControlStateNormal];
    self.titleTextView.delegate = self;
    //self.grayView.backgroundColor = [CommonUtils colorFromHexString:kLikeGrayReleaseColor];
    
//TODO:推荐到热门
//    self.seletectImageView.hidden = YES;
//    self.tuijianLabel.hidden = YES;
//    self.selectedBut.hidden = YES;

    [self getRule_fontlimitDic];

    
//    [self.view addSubview:view];
    
//    AddLabelBottomView *view = [AddLabelBottomView getBottomView];
//    view.frame = CGRectMake(0, kScreenHeight-view.frame.size.height, kScreenWidth, view.frame.size.height);
//    view.contentTextfield.delegate = self;
//    self.bottomView = view;
//    
//    NSDictionary *dic = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
//    NSString *headerURL = dic[@"head_pic"];
//    NSInteger wid = CGRectGetWidth(self.bottomView.avatorImageView.frame) * 2;
//    NSInteger hei = CGRectGetHeight(self.bottomView.avatorImageView.frame) * 2;
//    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
//    NSString *url = [NSString stringWithFormat:@"%@%@",headerURL,jpg];
//    [self.bottomView.avatorImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@""]];
//    
//    
//    [self addData];
    [self.view bringSubviewToFront:self.editView];

    //设置通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLabelList:) name:@"AddNewLabel" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissToRootController:) name:@"dismissToRootController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBottomLabel:) name:@"updateBottomLabel" object:nil];
    [self addKeyBoardNotification];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /*
    //顶部视图
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 70);
    self.topBackImage.frame =CGRectMake(0, 0, kScreenWidth, 70);
    self.backButton.frame = CGRectMake(-5, 28, 67, 40);
    self.titleLabel.center = CGPointMake(kScreenWidth/2, 47);
    self.releaseButton.frame = CGRectMake(kScreenWidth-90, 29, 106, 40);
    
    
    
    //发布title部分
    //显示图片的高度
    CGFloat contentImageH = 300;
    self.contentImageView.frame = CGRectMake(5, self.topView.bottom + 5, kDeviceWidth-10,contentImageH);
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.masksToBounds = YES;
    self.titleTextView.frame = CGRectMake(5, self.contentImageView.bottom + 5, kDeviceWidth - 10, 100);
    self.grayView.frame = CGRectMake(0, self.titleTextView.bottom , kDeviceWidth, kDeviceHeight - self.titleTextView.bottom);
    
    self.pleaceHolderLabel.frame = CGRectMake(8, self.titleTextView.top - 10, kDeviceWidth/2, 50);
    
    self.bottomView.backGroundImageView.frame = CGRectMake(0, 0, kScreenWidth, self.bottomView.frame.size.height);
    if (kScreenWidth==320) {
        self.bottomView.contentTextfield.frame = CGRectMake(70,13, kScreenWidth-90, 30);
        
    }else
    {
        self.bottomView.contentTextfield.frame = CGRectMake(85,13, kScreenWidth-90, 30);
        
    }
    [self.playVideoButton setFrame:self.contentImageView.frame];
    
    */
    
    
}


//未使用
/*
- (void)addData
{
    self.bottomView.avatorImageView.image = [UIImage imageNamed:@""];
    self.bottomView.avatorImageView.layer.cornerRadius = 20;
//    [self.hotLabelArray addObjectsFromArray:@[@"小清新",@"甜蜜",@"好啊",@"狂野"]];
    NSDictionary *params = [AFParamFormat formatGetLabelListParams:@""];
    [AFNetwork getTheLabelList:params success:^(id data) {
        NSArray *array = data[@"data"];
        self.labelArray = array.mutableCopy;
        for (int i=0; i<array.count; i++) {
            NSDictionary *diction = array[i];
            NSArray *arraytags = diction[@"tags"];
            for (int k=0; k<arraytags.count; k++) {
                NSDictionary *dictiontags = arraytags[k];
                NSString *name = [NSString stringWithFormat:@"%@",dictiontags[@"name"]];
                NSString *type = [NSString stringWithFormat:@"%@",dictiontags[@"type"]];
                if ([type isEqualToString:@"2"]) {
                    [self.hotLabelArray addObject:name];
                }
            }
        }
        [self.bottomView addLabelArray:self.hotLabelArray.copy];
    } failed:^(NSError *error) {
        
    }];
}
 */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom method
- (void)updateBottomLabel:(id)sender
{
    [self.bottomView addLabelArray:self.hotLabelArray.copy];
    [self reSetState];
}

- (void)reSetState
{
    NSArray *selectState = [self getSelectState];
    for (int i=0; i<selectState.count; i++) {
        NSString *state = selectState[i];
        if ([state isEqualToString:@"1"]) {
            UIButton *button = self.bottomView.buttonArray[i];
            [button setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
        }
    }
    
}

- (void)dismissToRootController:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)gotoLabelList:(id)sender
{

    AddLabelListViewController *listView = [[AddLabelListViewController alloc] initWithNibName:@"AddLabelListViewController" bundle:[NSBundle mainBundle]];
    listView.labelArray = self.labelArray;
    listView.hotLabelArray = self.hotLabelArray;
    listView.selectLabelArray = self.bottomView.selectLabelArray;
    listView.currentImage = self.currentImage;
    listView.selectStateArray = [self getSelectState];
    listView.titleString = self.bottomView.contentTextfield.text?self.bottomView.contentTextfield.text:@"";
    [self presentViewController:listView animated:YES completion:nil];
}

- (NSMutableArray *)getSelectState
{
    NSMutableArray *states = @[].mutableCopy;
    for (int i=0; i<self.hotLabelArray.count; i++) {
        [states addObject:@"0"];
    }
    for (int i=0; i<self.bottomView.selectLabelArray.count; i++) {
        NSString *name = self.bottomView.selectLabelArray[i];
        NSInteger index = [self.hotLabelArray indexOfObject:name];
        [states replaceObjectAtIndex:index withObject:@"1"];
    }
    
    return states;
}

- (void)upTextfiled
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.frame = CGRectMake(0, self.bottomView.frame.origin.y-180, self.bottomView.frame.size.width, self.bottomView.frame.size.height);

    } completion:^(BOOL finished) {
        
    }];
    
}

/*
 [UIView animateWithDuration:0.5 animations:^{
 
 } completion:^(BOOL finished) {
 
 }];
 */
- (void)downTextfiled
{
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomView.frame = CGRectMake(0, self.bottomView.frame.origin.y+180, self.bottomView.frame.size.width, self.bottomView.frame.size.height);

    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma mark - IBAction

- (IBAction)backMethod:(id)sender {
    [self.bottomView.contentTextfield resignFirstResponder];
    [self downTextfiled];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"放弃发布动态？" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"放弃", nil];
    [alertView show];
}

- (void)uploadVideoDone
{
    self.hud.detailsLabelText = @"发送成功";
    [self.hud hide:YES afterDelay:0.5];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)releaseMethod:(id)sender {
    [self.bottomView.contentTextfield resignFirstResponder];
//    [self downTextfiled];
    
    if (self.currentImage) {
        NSString *uid = @"";
        uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

        if (uid) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"正在发动态...";
            self.hud.removeFromSuperViewOnHide = YES;
            NSData *imageData = UIImageJPEGRepresentation(self.currentImage, 1.0);
            NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
            //    //2M以下不压缩
            if (imageData.length/1024 > 1024 * 5) {
                 imageData = UIImageJPEGRepresentation(self.currentImage, 0.3);
            }
            while (imageData.length/1024 > 2048) {
                imageData = UIImageJPEGRepresentation(self.currentImage, 0.6);
                self.currentImage = [UIImage imageWithData:imageData];
            }

            NSMutableString *tagString = @"".mutableCopy;
            for (int i=0; i<self.bottomView.selectLabelArray.count; i++) {
                [tagString appendFormat:@"%@,",self.bottomView.selectLabelArray[i]];
            }
            NSString *tags = @"";
            if (tagString.length>1) {
                tags = [[tagString substringFromIndex:0] substringToIndex:tagString.length-1];

            }
#ifdef TencentRelease
            
            if (self.videoURL) {
                [self performSelector:@selector(uploadVideoDone) withObject:nil afterDelay:2.0];
                [[UploadVideoManager sharedInstance] uploadWithVideo:self.videoURL block:^(NSString *string) {
                     
                    if (string) {
                        UIImage *image = self.currentImage;
                        //    NSData *imageData = UIImageJPEGRepresentation(image, 0.3);
                        NSData *imageData_video = UIImageJPEGRepresentation(image, 1.0);
                        NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData_video.length/1024);
                        //    //2M以下不压缩
                        if (imageData_video.length/1024 > 1024 * 5) {
                            imageData_video = UIImageJPEGRepresentation(image, 0.3);
                        }
                        while (imageData_video.length/1024 > 2048) {
                            imageData_video = UIImageJPEGRepresentation(image, 0.6);
                        }
                        
                        NSDictionary *param = [AFParamFormat formatPostPersonVideoImage:@"videoImage"];
//                        NSLog(@"%@",param);
                        [AFNetwork postPersonCardImageWithParams:param fileData:imageData success:^(id data) {
                            if (data) {
                                NSDictionary *diction = [NSDictionary dictionaryWithDictionary:data];
                                if ([diction[@"status"] integerValue]== kRight) {
                                    NSString *photoIdStr = [NSString stringWithFormat:@"%@",diction[@"data"][@"id"]];
                                    NSString *title = self.bottomView.contentTextfield.text?self.bottomView.contentTextfield.text:@"";
                                    NSDictionary *dict = [AFParamFormat formatPostUploadVideoParams:string photoid:photoIdStr tags:tags detail:@"" title:title ishot:@"1"];
                                    [AFNetwork uploadVideo:dict fileData:imageData success:^(id data){
//                                        NSLog(@"上传视频成功:%@",data);
                                    }failed:^(NSError *error){
                                        
                                    }];
                                
                                }else {

                                }
                            }
                        } failed:^(NSError *error) {
                            
                        }];
                        
                    }else
                    {
                        [LeafNotification showInController:self withText:@"上传失败，请检查网络."];

                    }
                    
                }];
            }else
            {
                NSString *title = self.titleTextView.text?self.titleTextView.text:@"";
                int imgType = [SingleData shareSingleData].currnetImageType;
                NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid tags:tags title:title type:imgType file:@"file"];
                NSLog(@"%d",imgType);
                [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
//                    NSLog(@"uploadPhoto:%@ test SVN",data);
                    self.hud.detailsLabelText = @"发送成功";
                    [self.hud hide:YES afterDelay:1.0];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPhotoView" object:nil];
                    
                    NSDictionary *diction = (NSDictionary *)data;
                    NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
                    if ([str isEqualToString:@"0"]) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                        int imgType = [SingleData shareSingleData].currnetImageType;
                        if (imgType==1) {
                            [SingleData shareSingleData].isFromPaiZhao = YES;
                        }
                        
                    }else{
                        [LeafNotification showInController:self withText:diction[@"msg"]];
                        
                    }
                    
                }failed:^(NSError *error){
                    NSLog(@"%@",error);
                    NSLog ( @"operation: %@",error.description  );
                }];
                
            }
            
#else
            NSString *title = self.titleTextView.text?self.titleTextView.text:@"";
            int imgType = [SingleData shareSingleData].currnetImageType;
           
//            NSData *titleData = [title dataUsingEncoding:NSUTF8StringEncoding];
            NSString *isHot = @"0";
            if (isTuiJian) {
                isHot = @"1";
            }
            NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid tags:tags title:title type:imgType file:@"file" isHot:isHot];
            [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
//                NSLog(@"uploadPhoto:%@ test SVN",data);
                self.hud.detailsLabelText = @"发送成功";
                [self.hud hide:YES afterDelay:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPhotoView" object:nil];
                
                NSDictionary *diction = (NSDictionary *)data;
                NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
                if ([str isEqualToString:@"0"]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                    int imgType = [SingleData shareSingleData].currnetImageType;
                    if (imgType==1) {
                        [SingleData shareSingleData].isFromPaiZhao = YES;
                    }
                    
                }else{
                    [LeafNotification showInController:self withText:diction[@"msg"]];
                    
                }
                
            }failed:^(NSError *error){
                [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
            }];
#endif
           
        }else
        {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"请登录";
            self.hud.removeFromSuperViewOnHide = YES;
            [self.hud hide:YES afterDelay:1.0];

        }
        
    }else
    {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.hud.mode = MBProgressHUDModeText;
        self.hud.detailsLabelText = @"照片不能为空";
        self.hud.removeFromSuperViewOnHide = YES;
        [self.hud hide:YES afterDelay:1.0];
        
    }

}

- (NSString *)URLEncodedString:(NSString *)string
{
    CFStringRef stringRef = CFBridgingRetain(string);
    CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                  stringRef,
                                                                  NULL,
                                                                  CFSTR("!*'\"();:@&=+$,/?%#[]% "),
                                                                  kCFStringEncodingUTF8);
    CFRelease(stringRef);
    return CFBridgingRelease(encoded);
}

#pragma mark - UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self downTextfiled];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self upTextfiled];
}

#pragma mark - rule_fontlimitDic
-(void)getRule_fontlimitDic{
    NSDictionary *rule_fontDic = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    _max = 500;
    if (rule_fontDic) {
        NSDictionary *feed_fontDic = [rule_fontDic objectForKey:@"feed_title"];
        _max = [feed_fontDic[@"max"] floatValue];
        _min = [feed_fontDic[@"min"] floatValue];
    }
}

#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.pleaceHolderLabel.hidden = YES;
    }else{
        self.pleaceHolderLabel.hidden = NO;
    }
    if (_max) {
        if (textView.text.length > _max) {
            [LeafNotification showInController:self withText:[NSString  stringWithFormat:@"不能超过%.0f字",_max]];
            if ([self.titleTextView isFirstResponder]) {
                [self.titleTextView resignFirstResponder];
                NSString *str = self.titleTextView.text;
                if (str.length > _max) {
                    str = [str substringToIndex:_max];
                    self.titleTextView.text = str;
                }
            }
        }
    }
}

#pragma mark - alertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            return;
            break;
        case 1:
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        default:
            break;
    }
}

- (IBAction)selectedButAction:(id)sender {
    isTuiJian = !isTuiJian;
    if (isTuiJian) {
        self.seletectImageView.image = [UIImage imageNamed:@"selected"];
        
    }else{
        self.seletectImageView.image = [UIImage imageNamed:@"deSelected"];
    }
}
- (IBAction)tapAction:(id)sender {
    if ([self.titleTextView isFirstResponder]) {
        [self.titleTextView resignFirstResponder];
        [UIView animateWithDuration:0.2 animations:^{
            self.editView_bottomDistance.constant = 50;
        }];
    }
}






#pragma mark - 键盘监听
- (void)addKeyBoardNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardNotificationAction:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
}

//键盘响应事件
- (void)keyBoardNotificationAction:(NSNotification *)notification{
    CGFloat keyBoard_topY = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].origin.y;
    
    //得到的坐标是是不计导航栏的
    NSLog(@"键盘的顶部高度(不计导航栏):%f",keyBoard_topY);
    //获取当前的输入框相对于屏幕的位置
    
    CGRect begin = [[[notification userInfo] objectForKey:@"UIKeyboardFrameBeginUserInfoKey"] CGRectValue];
    CGRect end = [[[notification userInfo] objectForKey:@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    
    
    // 第三方键盘回调三次问题，监听仅执行最后一次
    if(begin.size.height>0 && (begin.origin.y - end.origin.y>0)){
        [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.editView_bottomDistance.constant = kDeviceHeight -keyBoard_topY;
        } completion:^(BOOL finished) {
            //
        } ];
      }
}

@end
