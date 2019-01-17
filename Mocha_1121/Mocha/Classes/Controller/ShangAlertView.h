//
//  ShangAlertView.h
//  Mocha
//
//  Created by yfw－iMac on 15/10/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShangAlertView : UIView

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (weak, nonatomic) IBOutlet UITextField *inputTextfield;

@property (weak, nonatomic) IBOutlet UIButton *payButton;






+ (ShangAlertView *)getShangView;







@end
