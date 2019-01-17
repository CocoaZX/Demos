//
//  McPreviewViewController.m
//  Mocha
//
//  Created by renningning on 14-11-21.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McPreviewViewController.h"

@interface McPreviewViewController ()

@property (nonatomic, strong) NSString *currentPhotoId;

@end

@implementation McPreviewViewController

- (instancetype)initWithArray:(NSArray *)imageArray index:(NSInteger)index
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];

    [self loadSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
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
#pragma mark Privite

- (void)loadSubViews
{
    
    
    
}




@end
