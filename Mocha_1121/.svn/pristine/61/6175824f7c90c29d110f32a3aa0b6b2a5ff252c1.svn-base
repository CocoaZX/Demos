//
//  HeaderViewController.m
//  Mocha
//
//  Created by XIANPP on 15/12/25.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "HeaderViewController.h"

@interface HeaderViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *headerView;

- (IBAction)backBut:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

@property (weak, nonatomic) IBOutlet UIButton *backBut;

@property (nonatomic , strong)UITapGestureRecognizer *tap;
@end

@implementation HeaderViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGPoint centerPoint = self.nickNameLab.center;
    centerPoint.x = kDeviceWidth/2;
    self.nickNameLab.center = centerPoint;
    
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headerView.frame = CGRectMake(10, kDeviceHeight/4, kDeviceWidth - 20, kDeviceWidth - 20);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self loadImageView];
    // Do any additional setup after loading the view from its nib.
    _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenOrShowNavitionItem)];
    [self.backBut setImage:[UIImage imageNamed:@"whiteBack"] forState:UIControlStateNormal];
    self.backBut.frame = CGRectMake(-21, 2, 88, 65);
    [self.view addGestureRecognizer:_tap];
    self.view.backgroundColor = [UIColor blackColor];
}

-(void)loadImageView{
    NSString *url = [NSString stringWithFormat:@"%@%@",self.headerURL,[CommonUtils imageStringWithWidth:self.headerView.width * 2 height:self.headerView.height * 2]];
    [self.headerView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    self.nickNameLab.text = self.nickNameStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hiddenOrShowNavitionItem{
    self.nickNameLab.hidden = !self.nickNameLab.hidden;
    self.backBut.hidden = !self.backBut.hidden;
}

- (IBAction)backBut:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
