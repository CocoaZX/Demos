//
//  StartYuePaiViewController.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/13.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McBaseViewController.h"

@interface StartYuePaiViewController : McBaseViewController

@property (nonatomic, copy) NSString *receiveUid;
@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receiveHeader;
@property (nonatomic, assign)BOOL     isTaoxi;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *taoXiID;
@property (nonatomic, copy) NSString *taoXiName;

@property (weak, nonatomic) IBOutlet UIView *taoXiView;

@property (weak, nonatomic) IBOutlet UIView *yuePaiView;

@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXinameLabel;

@property (weak, nonatomic) IBOutlet UITextField *moneyTextfield;

@end
