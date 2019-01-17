//
//  McLeftSideViewController.m
//  Mocha
//
//  Created by renningning on 14-11-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McLeftSideViewController.h"
#import "UIViewController+MMDrawerController.h"

#import "McAccountViewController.h"
#import "McMainViewController.h"
#import "McInfoViewController.h"
#import "McSettingViewcontroller.h"
#import "McSeachViewController.h"

@interface McLeftSideViewController ()

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UIView *msgView;
@property (weak, nonatomic) IBOutlet UIView *followView;
@property (weak, nonatomic) IBOutlet UIView *favorView;
@property (weak, nonatomic) IBOutlet UIView *uploadView;
@property (weak, nonatomic) IBOutlet UIView *settingView;
@property (weak, nonatomic) IBOutlet UIView *signOutView;

@end

@implementation McLeftSideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)doLoginUp:(id)sender
{
    McAccountViewController *accountVc = [[McAccountViewController alloc] init];
    accountVc.actionType = 1;
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:accountVc];
    [self.mm_drawerController setCenterViewController:naVC withCloseAnimation:YES completion:nil];
}

- (IBAction)doRegister:(id)sender
{
    McAccountViewController *accountVc = [[McAccountViewController alloc] init];
    accountVc.actionType = 0;
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:accountVc];
    [self.mm_drawerController setCenterViewController:naVC withCloseAnimation:YES completion:nil];
}

- (IBAction)doSignOut:(id)sender
{
    
}

- (IBAction)doPersonInfo:(id)sender
{
    McInfoViewController *personVC = [[McInfoViewController alloc] init];
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:personVC];
    [self.mm_drawerController setCenterViewController:naVC withCloseAnimation:YES completion:nil];
}

- (IBAction)doUploadPhoto:(id)sender
{
    
}

//主页
- (IBAction)doMain:(id)sender
{
    [self.mm_drawerController setCenterViewController:APPDELEGATE.mainNavController withCloseAnimation:YES completion:nil];
    
}

- (IBAction)doSetting:(id)sender
{
    McSettingViewController *setVC = [[McSettingViewController alloc] init];
    UINavigationController * naVC = [[UINavigationController alloc] initWithRootViewController:setVC];
    [self.mm_drawerController setCenterViewController:naVC withCloseAnimation:YES completion:nil];
}

@end
