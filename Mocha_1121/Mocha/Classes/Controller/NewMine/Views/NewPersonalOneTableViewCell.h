//
//  NewPersonalOneTableViewCell.h
//  Mocha
//
//  Created by sun on 15/8/31.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewPersonalOneTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *titleView;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (assign, nonatomic) BOOL isAppearXiong;

@property (strong, nonatomic)  UIView *xiongView;

@property (strong, nonatomic) NSDictionary *dataDiction;

- (void)initViewWithData:(NSDictionary *)diction;

+ (NewPersonalOneTableViewCell *)getNewPersonalOneTableViewCell;

+ (float)getCellheightWithString:(NSString *)content;











@end
