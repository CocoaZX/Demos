//
//  McMsgListTableViewCell.h
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McMsgListTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *headImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *contentLabel;
    IBOutlet UILabel *timeLabel;
    IBOutlet UILabel *numLabel;
    IBOutlet UIButton *numBtn;
    IBOutlet UIImageView *lineImageView;
}

- (void)setItemValueWithDict:(NSDictionary *)itemDict;

@end
