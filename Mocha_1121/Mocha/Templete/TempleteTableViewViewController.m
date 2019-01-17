//
//  TempleteTableViewViewController.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "TempleteTableViewViewController.h"
#import "MyMokaTableViewCell.h"


@interface TempleteTableViewViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation TempleteTableViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"模版";
    self.dataArray = @[@"1",@"2",@"2",@"2",@"2",@"2",@"2"].mutableCopy;
    
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    
    //获取当前uid
//    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        
    });
    
    
    if (kScreenWidth==320) {
        
    }else if(kScreenWidth==375)
    {
        
        
    }else
    {
        
        
    }
    
    // 右边剪头  oicon031
    
    //   系统红色  [CommonUtils colorFromHexString:kLikeRedColor]
    BOOL isAviary = UserDefaultGetBool(@"isUseAviary");
    if (isAviary) {
        
        
    }else
    {
       
        
    }
    
    BOOL isAppearThirdLogin = UserDefaultGetBool(ConfigThird);
    if (isAppearThirdLogin) {
        
        
    }else
    {
        
        
    }
    BOOL isAppearDaShang = UserDefaultGetBool(ConfigShang);
    if (isAppearDaShang) {
        
        
    }else
    {
        
        
    }
    BOOL isAppearYuePai = UserDefaultGetBool(ConfigYuePai);
    if (isAppearYuePai) {
        
        
    }else
    {
        
        
    }
    
#ifdef TencentRelease
    
    
    
#else
    
    
    
#endif
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
    });
    

    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 44, 44)];
    NSString *title = NSLocalizedString(@"setting", nil);
    [rightButton setTitle:title forState:UIControlStateNormal];
    if ([title isEqualToString:@"设置"]) {
        rightButton.frame = CGRectMake(40, 0, 44, 44);
    }
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(settingMethod) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [self.navigationItem setRightBarButtonItem:rightItem];
    
    [SVProgressHUD showInfoWithStatus:@"订单生成中"];

    [SVProgressHUD dismiss];

    
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        if ([controller isKindOfClass:[UIViewController class]]) {
            NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
            [tempArr removeObject:controller];
            [self.navigationController setViewControllers:tempArr];
        }
    }
}

-(void)settingMethod{
    
}
/*
 
 - (void)viewWillAppear:(BOOL)animated
 {
 [super viewWillAppear:animated];
 self.navigationController.navigationBarHidden = NO;
 [self.customTabBarController hidesTabBar:NO animated:NO];
 }
 
 - (void)viewWillDisappear:(BOOL)animated
 {
 [super viewWillDisappear:animated];
 [self.customTabBarController hidesTabBar:YES animated:NO];
 
 
 }
 
 */

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
}


- (void)requestMyMokaData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *photoId = @"";
    NSString *amount = @"";
    NSString *total_fee = @"";
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{}];
    NSDictionary *paramss = [AFParamFormat formatPostDaShangParams:photoId amount:amount total_fee:total_fee];
    [AFNetwork postRequeatDataParams:params path:PathUserReward success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            NSDictionary *dict = data[@"data"];
            
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];        
    }];
    
}


#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyMokaTableViewCell *cell = nil;
    NSString *identifier = @"MyMokaTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [MyMokaTableViewCell getMyMokaTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = @"123";
    
    
    return cell;
}

@end
