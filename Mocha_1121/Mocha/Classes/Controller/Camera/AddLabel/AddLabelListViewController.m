//
//  AddLabelListViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "AddLabelListViewController.h"

@interface AddLabelListViewController ()


@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topBackImage;
@property (weak, nonatomic) IBOutlet UIButton *releaseButton;

@property (strong, nonatomic) MBProgressHUD *hud;

@property (weak, nonatomic) IBOutlet UIView *midleView;
@property (weak, nonatomic) IBOutlet UIImageView *midleViewBackImage;
@property (weak, nonatomic) IBOutlet UITextField *customAddKeyword;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIScrollView *labelsScrollView;

@property (strong, nonatomic) NSMutableArray *hotButtonArray;



@end

@implementation AddLabelListViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 70);
    self.topBackImage.frame =CGRectMake(0, 0, kScreenWidth, 70);
    self.backButton.frame = CGRectMake(-5, 28, 67, 40);
    self.titleLabel.center = CGPointMake(kScreenWidth/2, 47);
    self.releaseButton.frame = CGRectMake(kScreenWidth-90, 29, 106, 40);
    self.midleView.frame = CGRectMake(0, 170, kScreenWidth, 50);
    self.addButton.frame = CGRectMake(kScreenWidth-90, 0, 90, 48);
    self.midleViewBackImage.frame = CGRectMake(0, 0, kScreenWidth, 50);

    if (kScreenWidth==320) {
        self.customAddKeyword.frame = CGRectMake(26,10, kScreenWidth-110, 30);
        
    }else
    {
        self.customAddKeyword.frame = CGRectMake(40,10, kScreenWidth-110, 30);
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hotButtonArray = @[].mutableCopy;
    self.labelsScrollView.frame = CGRectMake(0, 220, kScreenWidth, kScreenHeight-220);
    [self initViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom method

- (void)initViews
{
    [self initSelectLabel];
    
    float startY = 10;
    for (int i=0; i<self.labelArray.count; i++) {
        NSDictionary *labels = self.labelArray[i];
        NSArray *array = labels[@"tags"];
        float height = (array.count/3)*30+30;
        
        float theY = startY;
        startY = theY+height+20;
        UIView *labelsView = [[UIView alloc] initWithFrame:CGRectMake(0, theY, 320, height+20)];

        float titleW = [SQCStringUtils getTxtLength:labels[@"name"] font:15 limit:1000];
        titleW = titleW+13;
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 5,titleW, 30)];
        title.text = labels[@"name"];
        title.textColor = [UIColor grayColor];
        title.textAlignment = NSTextAlignmentRight;
        title.font = [UIFont boldSystemFontOfSize:13];
        [labelsView addSubview:title];
        
        
        float line1 =  10;
        float line2 = 40;
        float line3 = 70;
        int currentX = titleW+10;
        int space = 5;
//        BOOL isOffWidth = NO;
        for (int i=0; i<array.count; i++) {
            float theX = 0;
            float theY = line1;
            float theW = 70;
            float theH = 22;
            theX = currentX + (theW+space)*i;
            if (kScreenWidth==320) {
                if (i>2&&i<=6) {
                    theY = line2;
                    theX = 20+(theW+space)*(i-3);
                }else if (i>6)
                {
                    theY = line3;
                    theX = 20+(theW+space)*(i-7);
                    
                }
            }else
            {
                if (i>3&&i<=7) {
                    theY = line2;
                    theX = 20+(theW+space)*(i-4);
                }else if (i>7)
                {
                    theY = line3;
                    theX = 20+(theW+space)*(i-8);
                    
                }
            }
            NSString *contentName = array[i][@"name"];
            NSLog(@"***********  %@",contentName);
//            if (isOffWidth) {
//                
//            }else
//            {
//                int contentWidth = [SQCStringUtils getTxtLength:contentName font:12 limit:200];
//                if (contentWidth>33) {
//                    isOffWidth = YES;
//                }
//                theW = 60+contentWidth-25;
//            }
            
            CGRect frame = CGRectMake(theX, theY, theW, theH);
            UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [labelButton addTarget:self action:@selector(selectLabel:) forControlEvents:UIControlEventTouchUpInside];
            if ([self isInTheArrayWithName:contentName]) {
                [labelButton setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
                [labelButton setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];

            }else
            {
                [labelButton setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
                [labelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
            
            [labelButton setTitle:contentName forState:UIControlStateNormal];
            labelButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [labelButton setFrame:frame];
            [labelButton setTag:i];
            int maxcount = 11;
            if (kScreenWidth==320) {
                maxcount = 11;
            }else
            {
                maxcount = 14;
            }
            if (i<maxcount) {
                [labelsView addSubview:labelButton];
            }
            
        }
        
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, height+17, kScreenWidth, 2)];
        lineView.image = [UIImage imageNamed:@"backLine"];
        [labelsView addSubview:lineView];
        [self.labelsScrollView addSubview:labelsView];
    }
    [self.labelsScrollView setContentSize:CGSizeMake(320, 500)];
    
    
}

- (BOOL)isInTheArrayWithName:(NSString *)name
{
    BOOL isInArray = NO;
    for (int i=0; i<self.selectLabelArray.count; i++) {
        NSString *nameStr = self.selectLabelArray[i];
        if ([name isEqualToString:nameStr]) {
            isInArray = YES;
        }
    }
    return isInArray;
}

- (void)initSelectLabel
{
    
    float line1 = 80;
    float line2 = 110;
    float line3 = 140;
    int currentX = 105;
    for (int i=0; i<self.hotLabelArray.count; i++) {
        
        float theX = 0;
        float theY = line1;
        float theW = 60;
        float theH = 22;
        theX = currentX + (theW+10)*i;
        if (kScreenWidth==320) {
            if (i>2&&i<=6) {
                theY = line2;
                theX = 20+(theW+10)*(i-3);
            }else if (i>6)
            {
                theY = line3;
                theX = 20+(theW+10)*(i-7);
                
            }
        }else
        {
            if (i>3&&i<=8) {
                theY = line2;
                theX = 18+(theW+10)*(i-4);
            }else if (i>8)
            {
                theY = line3;
                theX = 18+(theW+10)*(i-9);
                
            }
        }
        CGRect frame = CGRectMake(theX, theY, theW, theH);
        
        UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [labelButton addTarget:self action:@selector(choseLabel:) forControlEvents:UIControlEventTouchUpInside];
        NSString *state = self.selectStateArray[i];
        if ([state isEqualToString:@"0"]) {
            [labelButton setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
            [labelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

        }else
        {
            [labelButton setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
            [labelButton setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];

        }
        [labelButton setTitle:self.hotLabelArray[i] forState:UIControlStateNormal];
        labelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [labelButton setFrame:frame];
        [labelButton setTag:i];
        
        int maxcount = 11;
        if (kScreenWidth==320) {
            maxcount = 11;
        }else
        {
            maxcount = 14;
        }
        if (i<maxcount) {
            BOOL isInTheArray = NO;
            NSString *selectTitle = self.hotLabelArray[i];
            for (int k=0; k<self.hotButtonArray.count; k++) {
                UIButton *button = self.hotButtonArray[k];
                if ([button.titleLabel.text isEqualToString:selectTitle]) {
                    isInTheArray = YES;
                }
            }
            if (!isInTheArray) {
                [self.hotButtonArray addObject:labelButton];
                [self.view addSubview:labelButton];

            }


        }
        
        
    }

}

- (void)choseLabel:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
        [button setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
        [self.selectLabelArray addObject:button.titleLabel.text];
        [self.selectStateArray replaceObjectAtIndex:button.tag withObject:@"1"];

        
    }else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.selectLabelArray removeObject:button.titleLabel.text];
        [self.selectStateArray replaceObjectAtIndex:button.tag withObject:@"0"];

        
    }
    
}

- (void)selectLabel:(id)sender
{
    UIButton *button = (UIButton *)sender;
    BOOL isSame = NO;
    NSString *name = button.titleLabel.text;
    for (int i=0; i<self.hotLabelArray.count; i++) {
        NSString *target = self.hotLabelArray[i];
        if ([name isEqualToString:target]) {
            isSame = YES;
        }
    }
    if (!isSame) {
        if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
            [button setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
            [self.hotLabelArray addObject:button.titleLabel.text];
            [self.selectStateArray addObject:@"1"];
            [self.selectLabelArray addObject:button.titleLabel.text];
            [self initSelectLabel];
            
        }else
        {
            [button setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.hotLabelArray removeObject:button.titleLabel.text];
            NSInteger index = [self.hotLabelArray indexOfObject:button.titleLabel.text];
            [self.selectStateArray removeObjectAtIndex:index];
            [self.selectLabelArray removeObject:button.titleLabel.text];
            [self initSelectLabel];
            
        }
    }else
    {
//        [button setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        [self.hotLabelArray removeObject:button.titleLabel.text];
//        NSInteger index = [self.hotLabelArray indexOfObject:button.titleLabel.text];
//        [self.selectStateArray removeObjectAtIndex:index];
//        [self.selectLabelArray removeObject:button.titleLabel.text];
//        [self initSelectLabel];
        
    }
    
    
}

#pragma mark - IBAction

- (IBAction)backMethod:(id)sender {
    [self.customAddKeyword resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBottomLabel" object:nil];
}


- (IBAction)releaseThePhoto:(id)sender {
    [self.customAddKeyword resignFirstResponder];
    
    if (self.currentImage) {
        NSString *uid = @"";
        uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        
        if (uid) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.hud.mode = MBProgressHUDModeText;
            self.hud.detailsLabelText = @"正在发照片...";
            self.hud.removeFromSuperViewOnHide = YES;
//            NSData *imageData = UIImageJPEGRepresentation(self.currentImage, 0.3);
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
            for (int i=0; i<self.selectLabelArray.count; i++) {
                [tagString appendFormat:@"%@,",self.selectLabelArray[i]];
            }
            NSString *tags = @"";
            if (tagString.length>1) {
                tags = [[tagString substringFromIndex:0] substringToIndex:tagString.length-1];
                
            }
            
            NSString *title = @"";
            if (self.titleString.length>0) {
                title = self.titleString;
            }
            int imgType = [SingleData shareSingleData].currnetImageType;

            NSDictionary *dict = [AFParamFormat formatPostUploadParams:uid tags:tags title:title type:imgType file:@"file"];
            [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
//                NSLog(@"uploadPhoto:%@ test SVN",data);
                self.hud.detailsLabelText = @"发送成功";
                [self.hud hide:YES afterDelay:1.0];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshPhotoView" object:nil];
                NSDictionary *diction = (NSDictionary *)data;
                NSString *str = [NSString stringWithFormat:@"%@",diction[@"status"]];
                if ([str isEqualToString:@"0"]) {
                    [self dismissViewControllerAnimated:NO completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissToRootController" object:nil];
                        int imgType = [SingleData shareSingleData].currnetImageType;
                        if (imgType==1) {
                            self.customTabBarController.selectedIndex = 4;
                            [SingleData shareSingleData].isFromPaiZhao = YES;
                        }
                        
                    }];
                   
                }else{
                    [LeafNotification showInController:self withText:diction[@"msg"]];
                    
                }
            }failed:^(NSError *error){
                
            }];
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

- (IBAction)addNewLabel:(id)sender {
    BOOL isSame = NO;
    NSString *name = self.customAddKeyword.text;
    if([name length] == 0){
        return;
    }
    for (int i=0; i<self.hotLabelArray.count; i++) {
        NSString *target = self.hotLabelArray[i];
        if ([name isEqualToString:target]) {
            isSame = YES;
        }
    }
    if (!isSame) {
        [self.hotLabelArray addObject:self.customAddKeyword.text];
        [self.selectStateArray addObject:@"0"];
        [self initSelectLabel];
    }
    
}

#pragma mark - UItextfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    
    return YES;
}


@end
