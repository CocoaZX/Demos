//
//  McEventSignTableViewCell.h
//  Mocha
//
//  Created by renningning on 15-4-7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol McEventSignTableViewCellDelegate <NSObject>

@optional
- (void)actionDone:(NSString *)msg isReload:(BOOL)isReload;

@end

@interface McEventSignTableViewCell : UITableViewCell

@property (nonatomic, assign) id<McEventSignTableViewCellDelegate> cellDelegate;

- (void)setItemValueWithDict:(NSDictionary *)itemDict;

@end
