//
//  JinBiSuccessViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/3/18.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "JinBiSuccessViewController.h"
#import "DaShangViewController.h"
#import "JinBiViewController.h"
@interface JinBiSuccessViewController ()

@property (weak,nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation JinBiSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.titleString;
    
    self.descLabel.text = self.descString;

    self.doneButton.layer.cornerRadius = 40;

    self.view.backgroundColor = NewbackgroundColor;

}


- (IBAction)doneMethod:(id)sender
{
//    
//    NSMutableArray *childVCs = self.navigationController.childViewControllers.mutableCopy;
//    NSMutableArray *removeVCs = @[].mutableCopy;
//
//    for (id vc in childVCs) {
//        if ([vc isKindOfClass:[DaShangViewController class]]) {
//            [removeVCs addObject:vc];
//        }
//    }
//    
//    for (id vc in childVCs) {
//        [childVCs removeObject:vc];
//    }
    
    NSMutableArray *removeArr = @[].mutableCopy;
    for (int i=0; i<self.navigationController.childViewControllers.count; i++) {
        id controller = self.navigationController.childViewControllers[i];
        //购买支付界面
        if ([controller isKindOfClass:[DaShangViewController class]] ||
            [controller isKindOfClass:[JinBiViewController class]]
            ) {
            [removeArr addObject:controller];
        }
      }
    NSMutableArray *tempArr = self.navigationController.childViewControllers.mutableCopy;
    
    for (int i=0; i<removeArr.count; i++) {
        id controller = removeArr[i];
        [tempArr removeObject:controller];
    }
    [self.navigationController setViewControllers:tempArr];
    
    [self.navigationController popViewControllerAnimated :YES];
    
    
}


@end
