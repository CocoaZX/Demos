//
//  BuildMokaTableViewCell.h
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildMokaTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *grayView;


- (void)initViewWithData:(NSDictionary *)diction;

+ (BuildMokaTableViewCell *)getBuildMokaTableViewCellWith:(NSIndexPath *)indexPath;





+ (BuildMokaTableViewCell *)getBuildMokaTableViewCell;




















@end
