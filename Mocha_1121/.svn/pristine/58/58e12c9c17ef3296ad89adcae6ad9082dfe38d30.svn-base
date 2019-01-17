//
//  ChoseRoleViewController.m
//  Mocha
//
//  Created by sun on 15/6/16.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ChoseRoleViewController.h"
#import "ChangeheaderViewController.h"


@interface ChoseRoleViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *moteGou;

@property (weak, nonatomic) IBOutlet UIImageView *sheyingshiGou;

@property (weak, nonatomic) IBOutlet UIImageView *huazhuangshiGou;

@property (weak, nonatomic) IBOutlet UIImageView *jingjirenGou;

@property (weak, nonatomic) IBOutlet UIImageView *qitaGou;

@property (strong, nonatomic) NSString *currentTag;

@property (strong, nonatomic) UILabel *yelloLabel;
@property (strong, nonatomic) UIView *alertView;

@property (weak, nonatomic) IBOutlet UINavigationBar *navView;

@property (weak, nonatomic) IBOutlet UILabel *moteLabel;

@property (weak, nonatomic) IBOutlet UILabel *sheyingshiLabel;

@property (weak, nonatomic) IBOutlet UILabel *huazhuangshiLabel;

@property (weak, nonatomic) IBOutlet UILabel *jingjirenLabel;

@property (weak, nonatomic) IBOutlet UILabel *qitaLabel;


@end

@implementation ChoseRoleViewController

#pragma mark - 视图生命周期及控件加载
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.currentTag = @"0";
    
    
    
    self.alertView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 27)];
    self.alertView.backgroundColor = [UIColor clearColor];
    
    self.yelloLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 27)];
    self.yelloLabel.backgroundColor = RGB(255,255, 123);
    self.yelloLabel.textColor = RGB(230,62, 70);
    self.yelloLabel.text = @"";
    self.yelloLabel.hidden = NO;
    self.yelloLabel.font = [UIFont systemFontOfSize:15];
    self.yelloLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.alertView addSubview:self.yelloLabel];
    [self.view insertSubview:self.alertView belowSubview:self.navView];
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



- (void)showAlertWithString:(NSString *)string
{
    self.yelloLabel.text = string;
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 64, kScreenWidth, 27);
    }];
    
    [self performSelector:@selector(hideAlerView) withObject:nil afterDelay:2.0];
}

- (void)hideAlerView
{
    [UIView animateWithDuration:0.5 animations:^{
        self.alertView.frame = CGRectMake(0, 24, kScreenWidth, 27);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)moteClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSInteger tag = button.tag;
    self.currentTag = [NSString stringWithFormat:@"%ld",(long)button.tag];
    [self hidenAll];
    if (tag==1) {
        self.moteGou.hidden = NO;
        self.moteLabel.textColor = RGB(230,62, 70);

    }else if(tag==2)
    {
        self.sheyingshiGou.hidden = NO;
        self.sheyingshiLabel.textColor = RGB(230,62, 70);


    }else if(tag==3)
    {
        self.huazhuangshiGou.hidden = NO;
        self.huazhuangshiLabel.textColor = RGB(230,62, 70);


    }else if(tag==4)
    {
        self.jingjirenGou.hidden = NO;
        self.jingjirenLabel.textColor = RGB(230,62, 70);


    }else if(tag==5)
    {
        self.qitaGou.hidden = NO;
        self.qitaLabel.textColor = RGB(230,62, 70);


    }
    
}

- (void)hidenAll
{
    self.moteGou.hidden = YES;
    self.sheyingshiGou.hidden = YES;
    self.huazhuangshiGou.hidden = YES;
    self.jingjirenGou.hidden = YES;
    self.qitaGou.hidden = YES;
    self.moteLabel.textColor = [UIColor blackColor];
    self.sheyingshiLabel.textColor = [UIColor blackColor];
    self.huazhuangshiLabel.textColor = [UIColor blackColor];
    self.jingjirenLabel.textColor = [UIColor blackColor];
    self.qitaLabel.textColor = [UIColor blackColor];
}


- (IBAction)cancelLeftMethod:(id)sender {
    NSLog(@"123");
}








- (IBAction)nextStep:(id)sender {
    if ([self.currentTag isEqualToString:@"0"]) {

        [self showAlertWithString:@"请选择身份"];
        return;
    }
    
    ChangeheaderViewController *changeHeader = [[ChangeheaderViewController alloc] initWithNibName:@"ChangeheaderViewController" bundle:[NSBundle mainBundle]];
    changeHeader.currentRole = self.currentTag;
    [self.navigationController pushViewController:changeHeader animated:YES];
    return;
    
    
    /*  两步一起提交，记录当前状态，等上传完头像再提交
     
    NSDictionary *params = [AFParamFormat formatSaveInfoParams:self.currentTag];
    [AFNetwork completeUserInfo:params success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {
            
            NSLog(@"%@",data);
            ChangeheaderViewController *changeHeader = [[ChangeheaderViewController alloc] initWithNibName:@"ChangeheaderViewController" bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:changeHeader animated:YES];
        }
        [LeafNotification showInController:self withText:data[@"msg"]];
     
    }failed:^(NSError *error){
     
        [LeafNotification showInController:self withText:@"网络请求失败"];
     
    }];
     
    */

}





@end
