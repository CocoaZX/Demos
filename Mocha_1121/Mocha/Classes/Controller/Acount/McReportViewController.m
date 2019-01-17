//
//  McReportViewController.m
//  Mocha
//
//  Created by renningning on 14-12-22.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McReportViewController.h"

@interface McReportViewController ()<UITextViewDelegate>
{
    UITextView *contentTextView;
    
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation McReportViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"举报";
    [self loadSubViews];
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

- (void)loadSubViews
{
    float bgViewHeight = 70;
    float btnHeight = 40;
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - bgViewHeight)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width - 20, 20)];
    label.text = @"举报内容";
    label.font = kFont16;
    [_scrollView addSubview:label];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 5, self.view.frame.size.width - 20, 150)];
    contentTextView.delegate = self;
    [_scrollView addSubview:contentTextView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 190, CGRectGetWidth(self.view.frame), bgViewHeight)];
    [bgView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(55, (CGRectGetHeight(bgView.frame)-btnHeight)/2, CGRectGetWidth(self.view.frame) - 55*2, btnHeight)];
    [btn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setCornerRadius:20];
    [btn setTitle:@"举报" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doReportInfo:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
}

- (void)doReportInfo:(id)sender
{
    if (contentTextView.text.length>0) {
//        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        NSDictionary *dict = nil;
        if (_targetUid) {
            //人
            dict = @{@"content":contentTextView.text,@"objectid":self.targetUid,@"type":@"1"};

        }else if(_photoUid)
        {
            //图片
            dict = @{@"content":contentTextView.text,@"objectid":self.photoUid,@"type":@"2"};

        }else if(_groupID){
            //
            dict = @{@"content":contentTextView.text,@"objectid":self.groupID,@"type":@"3"};
        }else if(_videoUid){
            //视频
            dict = @{@"content":contentTextView.text,@"objectid":self.videoUid,@"type":@"11"};

        }
        
        
        
        NSDictionary *param = [AFParamFormat formatSystemReportParams:dict];
        NSLog(@"%@",param);
        [AFNetwork systemReport:param success:^(id data){
            NSLog(@"%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state integerValue] == kRight) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"举报已收到 我们会尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
            else if ([state integerValue] == kReLogin) {
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@",data[@"msg"]];

                [LeafNotification showInController:self withText:msg];

            }
        }failed:^(NSError *error){
            
        }];
    }else
    {
        [LeafNotification showInController:self withText:@"请填写举报内容"];

//        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        self.hud.mode = MBProgressHUDModeText;
//        self.hud.detailsLabelText = @"请填写举报内容";
//        self.hud.removeFromSuperViewOnHide = YES;
//        
//        [self.hud hide:YES afterDelay:2.0];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    done.tintColor = [UIColor colorForHex:kLikeRedColor];
    self.navigationItem.rightBarButtonItem = done;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)leaveEditMode {
    
    [contentTextView resignFirstResponder];
    
}

@end
