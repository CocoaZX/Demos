//
//  YuePaiTableViewCell.h
//  Mocha
//
//  Created by yfw－iMac on 15/11/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuePaiListViewController.h"

@interface YuePaiTableViewCell : UITableViewCell

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

@property (assign,nonatomic) BOOL *isTaoXi;

@property (weak, nonatomic) IBOutlet UIView *taoXIView;

- (void)setData:(id)dict;

@property (weak, nonatomic) IBOutlet UILabel *TaoXiNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *TaoXiPersonNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *TaoXiTimeLabel;

@property (weak, nonatomic) IBOutlet UITextView *TaoXiMarkText;

@property (assign, nonatomic) YuePaiListViewController *supCon;

@property (copy, nonatomic) NSString *object_id;

@property (copy, nonatomic) NSString *covenant_id;
+ (YuePaiTableViewCell *)getYuePaiTableViewCell;



@end
