//
//  SystemContentViewController.m
//  Mocha
//
//  Created by sunqichao on 15/2/10.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "SystemContentViewController.h"

@interface SystemContentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *contentTextView;

@end

@implementation SystemContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.contentTextView.text = self.contentStr;
    self.view.backgroundColor = [UIColor whiteColor];
    self.contentTextView.font = [UIFont systemFontOfSize:17];
    self.title = self.titleStr;
    
    
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

@end
