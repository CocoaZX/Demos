//
//  McCallBackViewController.m
//  Mocha
//
//  Created by renningning on 14-11-28.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McCallBackViewController.h"

@interface McCallBackViewController () <UITextViewDelegate>
{
    UITextView *contentTextView;
    UITextView *contacttextView;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation McCallBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"反馈";
    
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
    label.text = @"反馈意见";
    [label setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    label.font = kFont16;
    [_scrollView addSubview:label];
    
    contentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(label.frame) + 5, self.view.frame.size.width - 20, 150)];
    contentTextView.delegate = self;
    [contentTextView setFont:kFont16];
    contentTextView.scrollEnabled = NO;//是否可以拖动
    [_scrollView addSubview:contentTextView];
    
//    UILabel *cactlabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(contentTextView.frame) + 10, self.view.frame.size.width - 20, 20)];
//    cactlabel.text = @"联系方式";
//    cactlabel.font = kFont16;
//    [cactlabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
//    [_scrollView addSubview:cactlabel];
//    
//    contacttextView = [[UITextView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cactlabel.frame) + 5, self.view.frame.size.width - 20, 50)];
//    contacttextView.delegate = self;
//    [contacttextView setFont:kFont16];
//    [_scrollView addSubview:contacttextView];
    
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) - bgViewHeight-kNavHeight, CGRectGetWidth(self.view.frame), bgViewHeight)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(55, (CGRectGetHeight(bgView.frame)-btnHeight)/2, CGRectGetWidth(self.view.frame) - 55*2, btnHeight)];
    [btn.layer setBorderColor:[UIColor colorForHex:kLikeRedColor].CGColor];
    [btn.layer setBorderWidth:1.0];
    [btn.layer setCornerRadius:20];
    [btn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doSubmitInfo:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:btn];
    
    UITapGestureRecognizer *tapDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboardOfFeedback)];
    [self.view addGestureRecognizer:tapDismiss];
    
}

- (void)dismissKeyboardOfFeedback
{
    [contentTextView resignFirstResponder];
    
}

- (void)doSubmitInfo:(id)sender
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSDictionary *dict = @{@"uid":uid,@"content":contentTextView.text};
    NSDictionary *param = [AFParamFormat formatSystemFeedBackParams:dict];
    [AFNetwork systemFeedback:param success:^(id data){
        if([data[@"status"] integerValue] == kRight){
            [LeafNotification showInController:self withText:@"反馈成功"];
            [self performSelector:@selector(popViewControllerDelay) withObject:nil afterDelay:1.5];
        }
        else if([data[@"status"] integerValue] == kReLogin){
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
    }failed:^(NSError *error){
        
    }];
}

- (void)popViewControllerDelay
{
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark UITextViewDelegate


- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(leaveEditMode) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = done;
    
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
    
}

- (void)leaveEditMode {
   
    [contentTextView resignFirstResponder];
    
}

@end
