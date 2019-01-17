//
//  MyMokaTableViewCell.h
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyMokaTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *setToDefault;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) UIView *cardDetailView;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (weak, nonatomic) UIViewController *supCon;

@property (weak, nonatomic) IBOutlet UIView *cardView;

@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;

@property (weak, nonatomic) IBOutlet UIButton *touchButton;



@property (strong, nonatomic) NSMutableArray *imgViewArray;

@property (strong, nonatomic) NSMutableArray *buttonArray;

@property (copy, nonatomic) NSString *currentUid;

- (void)initViewWithData:(NSDictionary *)diction;

- (IBAction)gotoMokaDetail:(id)sender;







+ (MyMokaTableViewCell *)getMyMokaTableViewCell;




@end
