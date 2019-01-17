//
//  AcutionPublisherCheckController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AcutionInfoView.h"
#import "McBaseViewController.h"

@interface AcutionPublisherCheckController : McBaseViewController

//xib组件
@property (weak, nonatomic) IBOutlet AcutionInfoView *acutionInfoView;

@property (weak, nonatomic) IBOutlet UITextField *auctionNumTextField;



//竞拍详情
@property(nonatomic,strong)NSDictionary *acutionDic;

@end
