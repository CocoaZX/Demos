//
//  YuePaiTwoTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuePaiListViewController.h"

typedef void (^payBlock)(int index);

@interface YuePaiTwoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *payButton;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *paisheLabel;
@property (weak, nonatomic) IBOutlet UIImageView *faqiHeader;
@property (weak, nonatomic) IBOutlet UIImageView *jieshouHeader;
@property (weak, nonatomic) IBOutlet UILabel *faqiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jieshouLabel;
@property (weak, nonatomic) IBOutlet UILabel *creatLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *startTitleUserName;
@property (weak, nonatomic) IBOutlet UILabel *accecptTitleUserName;

@property (copy, nonatomic) payBlock payMethod;

@property (assign, nonatomic) int currentIndex;

@property (copy, nonatomic) NSString *opCode;

@property (assign,nonatomic) BOOL *isTaoXi;

@property (assign,nonatomic) YuePaiListViewController *supCon;

@property (weak, nonatomic) IBOutlet UIView *taoXiView;

@property (weak, nonatomic) IBOutlet UILabel *taoXiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXiPersonNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *taoXiTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *taoxiMark;

@property (copy, nonatomic) NSString *object_id;

@property (copy, nonatomic) NSString *covenant_id;

- (void)setData:(id)dict;


+ (YuePaiTwoTableViewCell *)getYuePaiTwoTableViewCell;




@end
