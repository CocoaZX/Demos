//
//  PersonCardViewController.m
//  Mocha
//
//  Created by XIANPP on 15/12/11.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "PersonCardViewController.h"
#import "UIImageView+WebCache.h"
#import "BuildCropViewController.h"

@interface PersonCardViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UITextViewDelegate,changeMokaPictureDelegate>

{
    UILabel *backLabel;
}
@property (nonatomic , strong)UIActionSheet *sharSheet;

@property (nonatomic , strong)UIView *cardView;//名片view

@property (nonatomic , strong)UIImageView *photoImageView;//照片imageView

@property (nonatomic , strong)UITextField *remarkTextfield;//短

@property (nonatomic , strong)UILabel *introduceLabel;//长

@property (nonatomic , strong)NSString *phoneModel;

@property (nonatomic , strong)UIImageView *downloadImageView;

@property (nonatomic , strong)UIImageView *logoImageView;

@property (nonatomic , strong)UILabel *mokaLabel;

@property (nonatomic , strong)UIImageView *mokaImageView;

@property (nonatomic , assign)BOOL isNeedUploding;

@property (nonatomic , copy)NSString* photoIdStr;

@property (nonatomic , strong)NSString *imageUrl;

@property (nonatomic , assign)NSInteger photoId;

@property (nonatomic , strong)UILabel *numberLabel;

@property (nonatomic , assign)CGPoint scrollPoint;

@property (nonatomic , strong)UITextView *introduceTextView;

@property (nonatomic , strong)UIView *inputView;

@property (nonatomic , strong)UITextField *remarkTFC;

@property (nonatomic , assign)int isRemark;

@property (nonatomic , strong)UILabel *mokaNumLabel;

@property (nonatomic , strong)NSDictionary *remark_limit;

@property (nonatomic , strong)NSDictionary *introduce_limit;
@end

@implementation PersonCardViewController

- (void)viewWillAppear:(BOOL)animated{
    self.phoneModel = [self deviceModel];
    [super viewWillAppear:animated];
    UIButton *backBut = [UIButton buttonWithType:UIButtonTypeCustom];
    backBut.frame = CGRectMake(0, 0, 30, 30);
    [backBut setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBut addTarget:self action:@selector(backViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarBut = [[UIBarButtonItem alloc]initWithCustomView:backBut];
    self.navigationItem.leftBarButtonItem = backBarBut;
    
    UIButton *sharBut = [UIButton buttonWithType:UIButtonTypeCustom];
    sharBut.frame = CGRectMake(0, 7, 45, 30);
    
    [sharBut setTitle:@"推荐" forState:UIControlStateNormal];
    sharBut.titleLabel.font = [UIFont systemFontOfSize:14];
    [sharBut setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [sharBut setImage:[UIImage imageNamed:@"mokafenxiang"] forState:UIControlStateNormal];
    [sharBut setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    
//    [sharBut setImage:[UIImage imageNamed:@"sharePerson"] forState:UIControlStateNormal];
    [sharBut addTarget:self action:@selector(showActionSheetAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareBarBut = [[UIBarButtonItem alloc]initWithCustomView:sharBut];
    
    UIButton *downloadBut = [UIButton buttonWithType:UIButtonTypeCustom];
    downloadBut.frame = CGRectMake(0, 0, 30, 30);
    [downloadBut setImage:[UIImage imageNamed:@"downRed"] forState:UIControlStateNormal];
    [downloadBut addTarget:self action:@selector(saveImageToAlbum:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *downloadBarBut = [[UIBarButtonItem alloc]initWithCustomView:downloadBut];
    self.navigationItem.rightBarButtonItems = @[shareBarBut,downloadBarBut];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth / 3, 30)];
    titleLabel.tintColor = [UIColor blackColor];
    titleLabel.textColor = RGB(80, 80, 80);
    titleLabel.text = @"moka名片";
    titleLabel.textColor = [CommonUtils colorFromHexString:kLikeRedColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    self.introduceLabel.numberOfLines = 2;
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UILabel *photoLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(-2, -2, self.photoImageView.width + 4, 2)];
    UILabel *photoLabelLeft = [[UILabel alloc] initWithFrame:CGRectMake(-2, -2, 2, self.photoImageView.height + 4)];
    UILabel *photoLabelRight = [[UILabel alloc] initWithFrame:CGRectMake(self.photoImageView.width , -2, 2,self.photoImageView.height + 4)];
    UILabel *photoLabelBottom = [[UILabel alloc] initWithFrame:CGRectMake(-2, self.photoImageView.height , self.photoImageView.width + 4,2)];
    UILabel *remarkLabel = [[UILabel alloc] initWithFrame:self.remarkTextfield.bounds];
    UILabel *introduceLabel = [[UILabel alloc]initWithFrame:self.introduceLabel.bounds];
    remarkLabel.backgroundColor = RGB(253, 211, 223);
    introduceLabel.backgroundColor = RGB(253, 211, 223);
    photoLabelTop.backgroundColor = RGB(244, 84, 96);
    photoLabelBottom.backgroundColor = RGB(244, 84, 96);
    photoLabelLeft.backgroundColor = RGB(244, 84, 96);
    photoLabelRight.backgroundColor = [UIColor redColor];
    [self.remarkTextfield addSubview:remarkLabel];
    [self.introduceLabel addSubview:introduceLabel];
    [self.photoImageView addSubview:photoLabelTop];
    [self.photoImageView addSubview:photoLabelBottom];
    [self.photoImageView addSubview:photoLabelLeft];
    [self.photoImageView addSubview:photoLabelRight];
    remarkLabel.alpha = 0.7;
    introduceLabel.alpha = 0.7;
    photoLabelTop.alpha = 0.7;
    photoLabelRight.alpha = 0.7;
    photoLabelLeft.alpha = 0.7;
    photoLabelBottom.alpha = 0.7;
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.9];
    [UIView setAnimationRepeatCount:2];
    remarkLabel.alpha = 0.0;
    introduceLabel.alpha = 0.0;
    photoLabelTop.alpha = 0.0;
    photoLabelRight.alpha = 0.0;
    photoLabelLeft.alpha = 0.0;
    photoLabelBottom.alpha = 0.0;
    [UIView commitAnimations];
}

#pragma mark Device model
- (void)loadCardView{
    self.view.backgroundColor = RGB(230, 230, 230);
    self.cardView.backgroundColor = [UIColor whiteColor];
    self.cardView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.cardView.layer.borderWidth = 0.5;
    [self.view addSubview:_cardView];
    [self.cardView addSubview:self.photoImageView];
    self.downloadImageView.image = [UIImage imageNamed:@"downloaErWeiMa"];
    [self.cardView addSubview:_downloadImageView];
    self.logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.cardView addSubview:self.logoImageView];
    
    self.mokaLabel.textAlignment = NSTextAlignmentLeft;
    self.mokaLabel.font = [UIFont systemFontOfSize:11];
    self.mokaLabel.numberOfLines = 0;
    [self.mokaLabel sizeToFit];
    [self.cardView addSubview:self.mokaLabel];
    self.mokaImageView.image = [UIImage imageNamed:@"mokaCardTitle"];

    [self.cardView addSubview:self.mokaImageView];
    [self.cardView addSubview:self.introduceLabel];
    [self.cardView addSubview:self.remarkTextfield];
    self.remarkTextfield.font = [UIFont systemFontOfSize:12];
   
    self.introduceLabel.font = [UIFont systemFontOfSize:9];
    self.mokaNumLabel.text = [NSString stringWithFormat:@"我的%@",self.mokaNum];
    self.mokaNumLabel.font = [UIFont systemFontOfSize:10];
    if (kDeviceWidth > 400) {
        self.introduceLabel.font = [UIFont systemFontOfSize:12];
        self.mokaNumLabel.font = [UIFont systemFontOfSize:12];
        self.remarkTextfield.font = [UIFont systemFontOfSize:14];
    }
    [self.cardView addSubview:self.mokaNumLabel];
    self.photoImageView.image = [UIImage imageNamed:@"AddPersonCard"];
    self.remarkTFC.delegate = self;
    backLabel = [[UILabel alloc] init];
    backLabel.backgroundColor = [UIColor grayColor];
    backLabel.alpha = 0.3f;
    [self.cardView addSubview:self.introduceTextView];
    self.introduceTextView.delegate = self;
    
    [self getLangDescription];
}

#pragma mark - getLangDescription
-(void)getLangDescription{
    self.remarkTextfield.text = [NSString stringWithFormat:@"我是%@ 我爱我的工作",self.nickName];
    if (self.remarkTextfield.text.length > 15) {
        self.remarkTextfield.text = [NSString stringWithFormat:@"我是%@",self.nickName];
    }

    self.introduceLabel.text = [NSString stringWithFormat:@"展现自我 美丽有价\n展现自我 美丽有价"];
    self.mokaLabel.text = @"越拍越美 越美越拍\n约模特 约摄影师 全球约拍";
    NSDictionary *lang_description = [USER_DEFAULT objectForKey:@"lang_description"];
    if (lang_description) {
        if (lang_description[@"card_moka_note"]) {
            NSString *descriptionStr = [NSString stringWithFormat:@"%@",[lang_description objectForKey:@"card_moka_note"]];
            descriptionStr = [descriptionStr stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
            self.mokaLabel.text = descriptionStr;
        }
        if (lang_description[@"card_introduce"]) {
            NSString *descriptionStr = [NSString stringWithFormat:@"%@",[lang_description objectForKey:@"card_introduce"]];
            descriptionStr = [descriptionStr stringByReplacingOccurrencesOfString:@"{%nickname%}" withString:self.nickName];
            if (descriptionStr.length > 15) {
                NSRange range = [descriptionStr rangeOfString:self.nickName];
                descriptionStr = [descriptionStr substringToIndex:range.length + range.location];
            }
            self.remarkTextfield.text = descriptionStr;
        }
        if (lang_description[@"tab_card"]) {
            self.navigationItem.title = lang_description[@"tab_card"];
        }
    }
}



- (NSString *)deviceModel{
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
        self.photoImageView.frame = CGRectMake(10, 10, kDeviceWidth - 40, kDeviceWidth * 6 / 5 - 40);
    }else{
        self.photoImageView.frame = CGRectMake(10, 10, kDeviceWidth - 40, kDeviceWidth - 40);
        //ipad
    }
    self.downloadImageView.frame = CGRectMake(10, self.cardView.bottom - 10 - 10 - (kDeviceWidth - 40)/3.5,(kDeviceWidth - 40)/3.5 , (kDeviceWidth - 40)/3.5);
    self.logoImageView.frame = CGRectMake(self.cardView.right - 10 - 10 - (kDeviceWidth - 40)/8, self.cardView.bottom - 10 - 10 - (kDeviceWidth - 40)/8, (kDeviceWidth - 40)/8, (kDeviceWidth - 40)/8);
    self.mokaLabel.frame = CGRectMake(self.downloadImageView.right + 10, self.cardView.bottom - 10 - 10 - (kDeviceWidth - 40)/10, self.logoImageView.left - self.downloadImageView.right - 20, (kDeviceWidth - 40)/10);
    self.mokaNumLabel.frame = CGRectMake(self.downloadImageView.right + 10, self.mokaLabel.top - (kDeviceWidth - 40)/15 , self.logoImageView.right - self.downloadImageView.right - 10, (kDeviceWidth - 40)/15);
    self.mokaImageView.frame = CGRectMake(10, self.downloadImageView.top - self.downloadImageView.width/19 * 7, self.downloadImageView.width,self.downloadImageView.width/26 * 6);
    
    self.remarkTextfield.frame = CGRectMake(self.downloadImageView.right + 10 ,self.downloadImageView.top - kDeviceWidth/10 + 5, self.mokaLabel.width + (kDeviceWidth - 40)/8 + 10 , kDeviceWidth/16);
    
    self.introduceLabel.frame = CGRectMake(self.downloadImageView.right + 10, self.remarkTextfield.bottom + 3, self.mokaLabel.width + (kDeviceWidth - 40)/8 + 10 , kDeviceWidth/10);
    
    
    NSArray *changeButtonframe = @[self.photoImageView,self.remarkTextfield,self.introduceLabel];
    for (int i = 0; i < 3; i ++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = [changeButtonframe[i] frame];
        button.tag = 10 + i;
        [button addTarget:self action:@selector(changePersonInformation:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        [self.cardView addSubview:button];
    }
    float width =  self.mokaLabel.width + (kDeviceWidth - 40)/8 + 10;
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.frame = CGRectMake(0, 0, (kDeviceWidth - width)/5 * 3, kDeviceWidth/10);
    self.numberLabel.backgroundColor = [UIColor whiteColor];
    [self.inputView addSubview:self.numberLabel];
    self.inputView.frame = CGRectMake(0, kDeviceHeight - kDeviceWidth/10 - 64, kDeviceWidth, kDeviceWidth/10);
    UIImageView *choseImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kDeviceWidth - (kDeviceWidth - width)/5 * 2, 0, (kDeviceWidth - width)/5 * 2, kDeviceWidth/10)];
    choseImageView.image = [UIImage imageNamed:@"inputImage"];
    [self.inputView addSubview:choseImageView];
    self.inputView.hidden = YES;
    self.inputView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.inputView];
    return [[UIDevice currentDevice] model];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getRule_fontlimit];
    [self loadCardView];
    [self loadCardInformation];
    [self registNotification];
    self.isNeedUploding = NO;
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(loseFirstResponder)];
    [self.view addGestureRecognizer:tapGR];
}



-(void)loseFirstResponder{
//    self.inputView.frame = CGRectMake(0, kDeviceHeight - 64 - 40, kDeviceWidth, kDeviceWidth/10);
    if ([self.remarkTextfield isFirstResponder]) {
        [self.remarkTextfield resignFirstResponder];
    }else if ([self.introduceTextView isFirstResponder]){
        [self.introduceTextView resignFirstResponder];
    }else if ([self.remarkTFC isFirstResponder]){
        [self.remarkTFC resignFirstResponder];
    }
}

#pragma mark - rule_fontlimitDic
-(void)getRule_fontlimit{
    NSDictionary *rule_fontlimit = [USER_DEFAULT objectForKey:@"rule_fontlimit"];
    _introduce_limit = [NSDictionary dictionary];
    _remark_limit  = [NSDictionary dictionary];
    if (rule_fontlimit) {
        if (rule_fontlimit[@"card_remark"]) {
            _remark_limit  = rule_fontlimit[@"card_remark"];
        }
        if (rule_fontlimit[@"card_introduce"]) {
            _introduce_limit = rule_fontlimit[@"card_introduce"];
        }
    }
    if (_remark_limit[@"max"] == nil) {
        [_remark_limit setValue:[NSNumber numberWithInt:15] forKey:@"max"];
        [_remark_limit setValue:[NSNumber numberWithInt:1] forKey:@"min"];
        [_introduce_limit setValue:[NSNumber numberWithInt:40] forKey:@"max"];
        [_introduce_limit setValue:[NSNumber numberWithInt:1] forKey:@"min"];
    }
}

#pragma mark - registNotification
-(void)registNotification{
    //注册键盘出现的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    //键盘变化
    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillChange:)
                                             name:UIKeyboardWillChangeFrameNotification object:nil];
    //键盘退出
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    //注册分享成功的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertSuccess) name:@"SharedSuccess" object:nil];
    //textView变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark notificationCenterSelector
- (void)showAlertSuccess
{
    [LeafNotification showInController:self withText:@"分享成功"];
}
//开始键盘弹出
-(void)keyboardWasShown:(NSNotification *)object{
    dispatch_after(0.15, dispatch_get_main_queue(), ^{
        self.inputView.hidden = NO;
    });
    _isNeedUploding = YES;
}
//变化
- (void)keyboardWillChange:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    CGRect inputRect = self.inputView.frame;
    inputRect.origin.y += yOffset ;
    self.inputView.frame = inputRect;
        //remark
        CGRect Change = self.remarkTextfield.frame;
        if (_isRemark) {
            Change = self.remarkTextfield.frame;
            Change.origin.x = self.numberLabel.right + 2;
            Change.origin.y = 2;
            Change.size.height = kDeviceWidth/10 - 4;
            Change.size.width = self.mokaLabel.width + (kDeviceWidth - 40)/8 + 10 - 2;
            self.remarkTFC.layer.borderColor = [[UIColor blackColor] CGColor];
            self.remarkTFC.layer.borderWidth = 0.5;
            self.remarkTFC.frame = Change;
        }
        //introduce
        else  {
            Change = self.introduceTextView.frame;
            Change.origin.x = self.numberLabel.right + 1;
            Change.origin.y = 2;
            Change.size.height = kDeviceWidth/10 - 4;
            Change.size.width = self.mokaLabel.width + (kDeviceWidth - 40)/8 + 10 - 2;
        }
    self.introduceTextView.font = [UIFont systemFontOfSize:14];
    self.introduceTextView.frame = Change;
    self.introduceTextView.layer.borderColor = [[UIColor blackColor] CGColor];
    self.introduceTextView.layer.borderWidth = 0.0;
    self.introduceTextView.backgroundColor = [CommonUtils colorFromHexString:kLikeLightGrayColor];
    [self.inputView addSubview:self.introduceTextView];
}
//结束编辑
-(void)keyboardWillBeHidden:(NSNotification *)object{
    self.inputView.hidden = YES;
    self.remarkTextfield.layer.borderWidth = 0.0f;
    self.inputView.frame = CGRectMake(0, kDeviceHeight - kDeviceWidth/10 - 64, kDeviceWidth, kDeviceWidth/10);
}
#pragma mark textView
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (_isRemark == 1) {
        textView.text = self.remarkTextfield.text;
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)textView.text.length,_remark_limit[@"max"]];
    }else if(_isRemark == 2){
    textView.text = self.introduceLabel.text;
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)textView.text.length,_introduce_limit[@"max"]];
    }
}
-(void)textViewChanged:(NSNotification *)sender{
    if (_isRemark == 1) {
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.introduceTextView.text.length,_remark_limit[@"max"]];
        if (self.introduceTextView.text.length > [_remark_limit[@"max"] intValue] + 5) {
            [self.introduceTextView resignFirstResponder];
            [LeafNotification showInController:self withText:[NSString stringWithFormat:@"不能超过%@个字",_remark_limit[@"max"]]];
        }
    }else if(_isRemark == 2){
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.introduceTextView.text.length,_introduce_limit[@"max"]];
    if (self.introduceTextView.text.length > [_introduce_limit[@"max"] intValue] + 5) {
        [self.introduceTextView resignFirstResponder];
        [LeafNotification showInController:self withText:[NSString stringWithFormat:@"不能超过%@个字",_introduce_limit[@"max"]]];
        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    if (_isRemark == 1) {
      self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)self.introduceTextView.text.length,_remark_limit[@"max"]];
        NSString *str = textView.text;
        if (str.length > [_remark_limit[@"max"] intValue]) {
            str = [str substringToIndex:[_remark_limit[@"max"] intValue]];
        }
        self.remarkTextfield.text = str;
    }else if (_isRemark == 2){
        self.numberLabel.text = [NSString stringWithFormat:@"%lu/%@",(unsigned long)textView.text.length,_introduce_limit[@"max"]];
        NSString *str = textView.text;
        if (str.length > [_introduce_limit[@"max"] intValue]) {
        str = [str substringToIndex:[_introduce_limit[@"max"] intValue]];
            }
        self.introduceLabel.text = str;
        self.introduceLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        self.introduceLabel.font = [UIFont systemFontOfSize:10];
        if (kDeviceWidth > 400) {
        self.introduceLabel.font = [UIFont systemFontOfSize:12];
        }
    }
    self.introduceTextView.frame = CGRectZero;
}
#pragma mark loadData
-(void)loadCardInformation{
    if (self.curruid) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDictionary *params = [AFParamFormat formatGetUserMokaListParams:self.curruid];
        [AFNetwork getPersonCardInformation:params success:^(id data) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (data) {
                if ([data[@"status"] integerValue] == kRight){
                    self.photoIdStr = [NSString stringWithFormat:@"%@",data[@"data"][@"photoId"]];
                    self.remarkTextfield.text = data[@"data"][@"remark"];
                    self.introduceLabel.text = data[@"data"][@"introduce"];
                    NSString *url = data[@"data"][@"photoUrl"];
                    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
                    if (image) {
                        self.photoImageView.image = image;
                    }
                    else
                    {
                        float width = self.photoImageView.width * 2;
                        float height = self.photoImageView.height * 2;
                        url = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:width height:height]];
                    [self.photoImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"AddPersonCard"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    }
                }else if ([data[@"status"] integerValue] == 1){
                    NSLog(@"%@",data[@"msg"]);
                    
                }
            }
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [LeafNotification showInController:self withText:@"暂时网络错误"];
        }];
    }
}
#pragma mark CardView
-(void)changePersonInformation:(UIButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
    switch (sender.tag) {
        case 10:{
            if ([self.remarkTextfield isFirstResponder] || [self.introduceTextView isFirstResponder] || [self.remarkTFC isFirstResponder]) {
                [self loseFirstResponder];
                return;
            }
            UIActionSheet *choosePhotoActionSheet;
            choosePhotoActionSheet = [[UIActionSheet alloc] initWithTitle:@"选择名片照片"
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照", @"相册", nil];

            [choosePhotoActionSheet showInView:self.view];
        }
            break;
        case 11:
            _isRemark = 1;
            self.introduceTextView.frame = self.remarkTextfield.frame;
            [self.introduceTextView becomeFirstResponder];
            
            break;
        case 12:
            _isRemark = 2;
            self.introduceTextView.frame = self.introduceLabel.frame;
            [self.introduceTextView becomeFirstResponder];
            ;
            break;
        default:
            break;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark navigationItems
-(void)backViewController:(UIButton *)sender{
    if (_isNeedUploding) {
    NSString *remarkStr = [self protrctStr:self.remarkTextfield.text];
    NSString *introduceStr = [self protrctStr:self.introduceLabel.text];
        if (remarkStr.length == 0 || introduceStr.length == 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"请填写名片信息哦" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    NSDictionary *params = [AFParamFormat formatPostPersonCardParamsPhotoid:self.photoIdStr Remark:remarkStr introduce:introduceStr];
    [AFNetwork postPersonCardInformationToServer:params success:^(id data) {
            NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];
        if ([dic objectForKey:@"status"] == [NSNumber numberWithInt:kRight]) {
            
        }else{
            if (self.supViewController) {
                @try {
                    [LeafNotification showInController:self.supViewController withText:dic[@"msg"]];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception.name);
                }
                @finally {
                    
                }
            }
        }
    }
            failed:^(NSError *error) {
                NSLog(@"%@",error);
            }
         ];
    }
       [self.navigationController popViewControllerAnimated:YES];
}
-(void)showActionSheetAction:(UIButton *)sender{
    [self.sharSheet showInView:self.view];
}
-(void)saveImageToAlbum:(UIButton *)sender{
    UIImage *image = [self snapshot:self.cardView];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.cardView.frame];
    imageView.image = image;
    image = [self snapshot:imageView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
- (void)image:(UIImage *) image
    didFinishSavingWithError: (NSError *) error
                 contextInfo: (void *) contextInfo{
    if (error == nil) {
        [LeafNotification showInController:self withText:@"保存成功"];
    }else{
        [LeafNotification showInController:self withText:@"保存失败\n请检查是否允许使用相册"];
    }
}
#pragma mark actionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImage *image = [self snapshot:self.cardView];
    if (actionSheet == _sharSheet) {
        
        switch (buttonIndex) {
            case 0://QQ
            {
                NSData *imageData = UIImagePNGRepresentation(image);
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToQQWithImageDataReallyData:imageData previewImage:image title:@"分享" description:nil];
            }
                break;
            case 1://微信
                [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneSession];
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:nil];
                break;
            case 2://微博
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendMessageToSinaWithPic:image];
                break;
            case 3://朋友圈
                [(AppDelegate *)[UIApplication sharedApplication].delegate changeScene:WXSceneTimeline];
                [(AppDelegate *)[UIApplication sharedApplication].delegate sendImageContentWithImage:image title:@"模卡"];
                break;
            default:
                break;
        }
    }else{
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] || [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            
            switch (buttonIndex) {
                case 0:
                    
                {
                    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                    {
                        //检查相机模式是否可用
                        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                            NSLog(@"sorry, no camera or camera is unavailable.");
                            return;
                        }
                        //创建图像选取器
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                        //设置代理
                    imagePickerController.delegate = self;
                        //允许编辑
                    imagePickerController.allowsEditing = NO;
                        //设置选取器的来源模式
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                        //设置选取器的类型
                    imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeImage, nil];
                        
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    }
                    else{
                        return;
                    }
                }
                    break;
                case 1:
                {
                    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
                        NSLog(@"sorry, no camera or camera is unavailable.");
                        return;
                    }
                    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                    imagePickerController.delegate = self;
                    imagePickerController.allowsEditing = NO;
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//                    imagePickerController.view.frame = self.photoImageView.bounds;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                    break;
                }
            }
        }
    }
}
#pragma mark imagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [self fixOrientation:image];
//    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
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

    BuildCropViewController *cropVC = [[BuildCropViewController alloc]initWithImageData:imageData];
    cropVC.originImage = image;
    cropVC.cardType = 15;
    cropVC.delegate = self;
     [self.navigationController pushViewController:cropVC animated:YES];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark buildCropDelegate
-(void)finishCropImage:(UIImage *)image{
    self.photoImageView.image = image;
    [self uploadPersonCardImage];
    self.isNeedUploding = YES;
}
-(NSString *)protrctStr:(NSString *)str{
    if (str && str.length > 0) {
        
    }else{
        str = @"";
    }
    return [str copy];
}
-(void)hideHUDForSelfView{
    if (self.remarkTextfield.text) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
//截图视图
- (UIImage *)snapshot:(UIView *)view
{
    //创建画布
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, YES, 0);
    //绘制图片
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    //从当前画布得到图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭画布,很占内存
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark uploadImage
-(void)uploadPersonCardImage{
//    UIImage *image = [self scaleToSize:self.photoImageView.image size:self.photoImageView.size];
    UIImage *image = self.photoImageView.image;
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

    NSDictionary *param = [AFParamFormat formatPostPersonCardImage:@"cardImage"];
    [self performSelector:@selector(hideHUDForSelfView) withObject:nil afterDelay:1.0];
    NSLog(@"%@",param);
    [AFNetwork postPersonCardImageWithParams:param fileData:imageData success:^(id data) {
        if (data) {
        [self hideHUDForSelfView];
        NSDictionary *diction = [NSDictionary dictionaryWithDictionary:data];
        if ([diction[@"status"] integerValue]== kRight) {
            self.photoIdStr = [NSString stringWithFormat:@"%@",diction[@"data"][@"id"]];
            NSLog(@"%@",diction[@"msg"]);
        }else {
            NSLog(@"%@",diction[@"msg"]);
        }
        }
    } failed:^(NSError *error) {
        [self hideHUDForSelfView];
        NSLog(@"%@",error);
    }];
}


#pragma mark lazyLoding
-(UIActionSheet *)sharSheet{
    if (!_sharSheet) {
        _sharSheet = [[UIActionSheet alloc]initWithTitle:@"分享我的moka名片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"QQ",@"微信",@"微博",@"朋友圈", nil];
        [_sharSheet setCancelButtonIndex:4];
    }
    return _sharSheet;
}

-(UIImageView *)downloadImageView{
    if (!_downloadImageView) {
    _downloadImageView= [[UIImageView alloc]initWithFrame:CGRectMake(10, 10 + kDeviceWidth - 40 + (kDeviceWidth - 40)/4 / 20 * 7 + 2, (kDeviceWidth - 40)/4, (kDeviceWidth - 40)/4)];
    }
    return _downloadImageView;
}

-(UIView *)cardView{
    if (!_cardView) {
        //ipad
        _cardView = [[UIView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth - 20, kDeviceHeight - 84)];
    }
    return _cardView;
}

-(UIImageView *)photoImageView{
    if (!_photoImageView) {
        //ipad
        _photoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, kDeviceWidth - 40, kDeviceWidth - 40)];
    }
    return _photoImageView;
}

-(UITextField *)remarkTextfield{
    if (!_remarkTextfield) {
        _remarkTextfield = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    return _remarkTextfield;
}

-(UILabel *)introduceLabel{
    if (!_introduceLabel) {
        _introduceLabel = [[UILabel alloc]init];
    }
    return _introduceLabel;
}

-(UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
    }
    return _logoImageView;
}

-(UILabel *)mokaLabel{
    if (!_mokaLabel) {
        _mokaLabel = [[UILabel alloc]init];
    }
    return _mokaLabel;
}

-(UIImageView *)mokaImageView{
    if (!_mokaImageView) {
        _mokaImageView = [[UIImageView alloc] init];
    }
    return _mokaImageView;
}

-(UILabel *)numberLabel{
    if (!_numberLabel) {
        _numberLabel = [[UILabel alloc] init];
    }
    return _numberLabel;
}
-(UITextView *)introduceTextView{
    if (!_introduceTextView) {
        _introduceTextView = [[UITextView alloc] init];
    }
    return _introduceTextView;
}
-(UIView *)inputView{
    if (!_inputView) {
        _inputView = [[UIView alloc]init];
    }
    return _inputView;
}
-(UITextField *)remarkTFC{
    if (!_remarkTFC) {
        _remarkTFC = [[UITextField alloc]init];
    }
    return _remarkTFC;
}
-(UILabel *)mokaNumLabel{
    if (!_mokaNumLabel) {
        _mokaNumLabel = [[UILabel alloc]init];
    }
    return _mokaNumLabel;
}
@end
