//
//  ActionViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/14.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "ActionViewController.h"

@interface ActionViewController ()


@property (weak, nonatomic) IBOutlet UIView *actionBackView;
@property (weak, nonatomic) IBOutlet UIView *blackBackView;


@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setButtonsView];
    
    self.blackBackView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
}

- (void)setButtonsView
{
    for (int i=0; i<self.namesArray.count; i++) {
        float theX = 0;
        float theY = 15;
        float theW = kScreenWidth-70;
        float theH = 45;
        if (kScreenWidth!=320) {
            theH = 50;
        }
        theX = (kScreenWidth-theW)/2;
        theY = theY+(theH+10)*i;
        CGRect frame = CGRectMake(theX, theY, theW, theH);
        UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [labelButton setBackgroundImage:[UIImage imageNamed:@"grayCycleButton"] forState:UIControlStateNormal];
        [labelButton setBackgroundImage:[UIImage imageNamed:@"grayCycleButton"] forState:UIControlStateHighlighted];
//        [labelButton setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
        [labelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [labelButton addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
        [labelButton setTitle:self.namesArray[i] forState:UIControlStateNormal];
        labelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [labelButton setFrame:frame];
        [labelButton setTag:i];
        if ([self.namesArray[i] isEqualToString:@"删除"]) {
            [labelButton setBackgroundImage:[UIImage imageNamed:@"deleteRedButton"] forState:UIControlStateNormal];
            [labelButton setBackgroundImage:[UIImage imageNamed:@"deleteRedButton"] forState:UIControlStateHighlighted];
            [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
        [self.actionBackView addSubview:labelButton];
    }
    
    float theX = 0;
    float theY = 15;
    float theW = kScreenWidth-70;
    float theH = 45;
    if (kScreenWidth!=320) {
        theH = 50;
    }
    theX = (kScreenWidth-theW)/2;
    theY = theY+(theH+10)*self.namesArray.count;
    CGRect frame = CGRectMake(theX, theY, theW, theH);
    UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [labelButton setBackgroundImage:[UIImage imageNamed:@"grayButtonBack"] forState:UIControlStateNormal];
    [labelButton setBackgroundImage:[UIImage imageNamed:@"grayButtonBack"] forState:UIControlStateHighlighted];
    //        [labelButton setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
    [labelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [labelButton addTarget:self action:@selector(actionClick:) forControlEvents:UIControlEventTouchUpInside];
    [labelButton setTitle:@"取消" forState:UIControlStateNormal];
    labelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [labelButton setFrame:frame];
    [labelButton setTag:self.namesArray.count];
    [self.actionBackView addSubview:labelButton];
    
    self.actionBackView.frame = CGRectMake(0, kScreenHeight-theY-60, kScreenWidth, theY+60);

}

- (void)actionClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(actionViewClickWithTag:)]) {
        [self.delegate actionViewClickWithTag:(int)sender.tag];
    }
}

- (IBAction)dismissMethod:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissActionView" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
