//
//  PingJiaViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/1/5.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "PingJiaViewController.h"

@interface PingJiaViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UIView *headPointView;

@property (weak, nonatomic) IBOutlet UIButton *starOne;
@property (weak, nonatomic) IBOutlet UIButton *starTwo;
@property (weak, nonatomic) IBOutlet UIButton *starThree;
@property (weak, nonatomic) IBOutlet UIButton *starFour;
@property (weak, nonatomic) IBOutlet UIButton *starFive;

@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextview;
@property (weak, nonatomic) IBOutlet UIView *pingjiaView;

@property (copy, nonatomic) NSString *currentUid;
@property (copy, nonatomic) NSString *currentTitle;
@property (copy, nonatomic) NSString *currentHeaderURL;

@property (copy, nonatomic) NSString *currentCid;
@property (copy, nonatomic) NSString *currentStar;


@end

@implementation PingJiaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价详情";

    NSString *headURL = getSafeString(self.diction[@"to_head_pic"]);
    NSString *nickName = getSafeString(self.diction[@"to_nickname"]);
    NSString *sex = getSafeString(self.diction[@"to_user_sex"]);
    NSString *typeName = getSafeString(self.diction[@"to_type"]);
    NSString *uid = getSafeString(self.diction[@"to_uid"]);
    NSString *cid = getSafeString(self.diction[@"covenant_id"]);

    if (self.isJieShou) {
        headURL = getSafeString(self.diction[@"head_pic"]);
        nickName = getSafeString(self.diction[@"nickname"]);
        sex = getSafeString(self.diction[@"user_sex"]);
        typeName = getSafeString(self.diction[@"user_type"]);
        uid = getSafeString(self.diction[@"uid"]);
    }
    
    self.currentUid = uid;
    self.currentTitle = nickName;
    self.currentHeaderURL = headURL;
    self.currentCid = cid;
    
    self.nameLabel.text = nickName;
    self.sexLabel.text = [NSString stringWithFormat:@"%@",sex];
    self.typeLabel.text = typeName;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:headURL] placeholderImage:nil];
    
    self.headerImage.layer.cornerRadius = 25;
    self.headerImage.clipsToBounds = YES;

    self.commentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commentView.layer.borderWidth = 0.5;
    
    self.currentStar = @"5";
    
    if (self.isDingdan) {
        self.commentTextview.text = @"谈谈你对这个订单的看法";
            
    }else{
        self.commentTextview.text =@"说点和对方约拍的感受吧";
        
    }
    
    //监听键盘弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
}

//计算键盘的高度
-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
}

-(void)keyboardWillAppear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    float keyboardH = [self keyboardEndingFrameHeight:notification.userInfo];
    float pingjiaBottom = self.pingjiaView.bottom;

    self.view.frame=CGRectMake(currentFrame.origin.x, kDeviceHeight-pingjiaBottom-keyboardH, currentFrame.size.width, currentFrame.size.height);
}

-(void)keyboardWillDisappear:(NSNotification *)notification
{
    CGRect currentFrame = self.view.frame;
    
    self.view.frame=CGRectMake(currentFrame.origin.x, 64, currentFrame.size.width, currentFrame.size.height);
}



- (IBAction)chatMethod:(id)sender {
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:[ChatManager sharedInstance].hxName password:@"123456"
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
             //获取群组列表
             [[EaseMob sharedInstance].chatManager asyncFetchMyGroupsList];
             
             //设置是否自动登录
             [[EaseMob sharedInstance].chatManager setIsAutoLoginEnabled:YES];
             
             //将2.1.0版本旧版的coredata数据导入新的数据库
             EMError *error = [[EaseMob sharedInstance].chatManager importDataToNewDatabase];
             if (!error) {
                 error = [[EaseMob sharedInstance].chatManager loadDataFromDatabase];
             }
             
             //发送自动登陆状态通知
             [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@YES];
         }
         else
         {
         }
     } onQueue:nil];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fromHeaderURL = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"head_pic"];
        ChatViewController *chatController = [[ChatViewController alloc] initWithChatter:self.currentUid conversationType:eConversationTypeChat];
        chatController.title = getSafeString(self.currentTitle);
        
        chatController.fromHeaderURL = getSafeString(fromHeaderURL);
        chatController.toHeaderURL = getSafeString(self.currentHeaderURL);
        [self.navigationController pushViewController:chatController animated:YES];
        
    });

}

- (IBAction)submitButton:(id)sender {
    NSString *covenant_id = self.currentCid;
    NSString *star = self.currentStar;
    NSString *content = getSafeString(self.commentTextview.text);
    if (self.isDingdan) {
        if ([content isEqualToString:@"谈谈你对这个订单的看法"]) {
            content = @"";
        }
    }else{
        if ([content isEqualToString:@"说点和对方约拍的感受吧"]) {
            content = @"";
        }
    }
    
    if (content.length == 0) {
        [LeafNotification showInController:self withText:@"请输入评价内容"];
        return;
    }
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{@"covenant_id":covenant_id,@"star":star,@"content":content}];
    
    [SVProgressHUD show];
    
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiPingLun success:^(id data){
        [SVProgressHUD dismiss];
        
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self withText:data[@"msg"]];

            [self performSelector:@selector(delayToPop) withObject:nil afterDelay:1.0];
            
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [LeafNotification showInController:self withText:data[@"msg"]];
        }else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [SVProgressHUD dismiss];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];        
    }];
    

}



- (IBAction)firstMethod:(id)sender {
    [self.starOne setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starTwo setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starThree setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starFour setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starFive setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    self.currentStar = @"1";
    
}

- (IBAction)secondMethod:(id)sender {
    [self.starOne setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starTwo setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starThree setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starFour setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starFive setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    self.currentStar = @"2";

    
}

- (IBAction)thirdMethod:(id)sender {
    [self.starOne setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starTwo setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starThree setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starFour setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    [self.starFive setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    self.currentStar = @"3";

    
}

- (IBAction)fourMethod:(id)sender {
    [self.starOne setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starTwo setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starThree setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starFour setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starFive setImage:[UIImage imageNamed:@"xingxing-1"] forState:UIControlStateNormal];
    self.currentStar = @"4";

    
}

- (IBAction)fiveMethod:(id)sender {
    [self.starOne setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starTwo setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starThree setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starFour setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    [self.starFive setImage:[UIImage imageNamed:@"xingxing"] forState:UIControlStateNormal];
    self.currentStar = @"5";

    
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSString *titleString = @"";
    if (self.isDingdan) {
        titleString = @"谈谈你对这个订单的看法";

    }else{
        titleString =  @"说点和对方约拍的感受吧";

    }
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
        
    }
    if (kScreenWidth==320) {
//        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight);
        
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSString *titleString = @"";
    if (self.isDingdan) {
        titleString = @"谈谈你对这个订单的看法";
        
    }else{
        titleString =  @"说点和对方约拍的感受吧";
        
    }
    if ([textView.text isEqualToString:titleString]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    if ([@"\n" isEqualToString:text] == YES) {
        if (kScreenWidth==320) {
//            self.view.frame = CGRectMake(0, 30, kScreenWidth, kScreenHeight);
            
        }
        [self.commentTextview resignFirstResponder];
        
        return NO;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
