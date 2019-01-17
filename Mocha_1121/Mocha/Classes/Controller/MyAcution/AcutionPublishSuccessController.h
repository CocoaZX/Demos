//
//  AcutionPublishSuccessController.h
//  Mocha
//
//  Created by zhoushuai on 16/4/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McBaseViewController.h"
#import "AcutionInfoView.h"

@interface AcutionPublishSuccessController : McBaseViewController

//xib视图组件
@property (weak, nonatomic) IBOutlet AcutionInfoView *acutionInfoView;

@property (weak, nonatomic) IBOutlet UILabel *successInfoDescLabel;

@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
 
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomLine_width;



//竞拍详情
@property(nonatomic,strong)NSDictionary *acutionDic;

@end
