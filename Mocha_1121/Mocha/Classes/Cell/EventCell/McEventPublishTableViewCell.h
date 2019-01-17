//
//  McEventPublishTableViewCell.h
//  Mocha
//
//  Created by renningning on 15-4-7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McEventPublishTableViewCell : UITableViewCell

@property (nonatomic ,retain) IBOutlet UILabel *contentLabel;

@property (nonatomic, retain) IBOutlet UITextField *textField;

- (void)setItemValueWithDict:(NSDictionary *)itemDict;

- (void)setContent:(NSString *)content;

@end
