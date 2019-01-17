//
//  McChatFromYouTableViewCell.h
//  Mocha
//
//  Created by renningning on 14-12-12.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McMsgContent.h"

@interface McChatFromYouTableViewCell : UITableViewCell
{
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *headImageView;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UILabel *contentLabel;
}
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

- (float)setValueWithItem:(McMsgContent *)item;

@end
