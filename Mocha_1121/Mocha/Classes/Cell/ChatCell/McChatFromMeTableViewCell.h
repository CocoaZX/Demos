//
//  McChatTableViewCell.h
//  Mocha
//
//  Created by renningning on 14-11-25.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "McMsgContent.h"

@interface McChatFromMeTableViewCell : UITableViewCell
{
    IBOutlet UILabel *timeLabel;
    IBOutlet UIImageView *headImageView;
    IBOutlet UIImageView *bgImageView;
    IBOutlet UILabel *contentLabel;
}

@property (weak, nonatomic) IBOutlet UIButton *headerButton;


- (float)setValueWithItem:(McMsgContent *)item;

@end
