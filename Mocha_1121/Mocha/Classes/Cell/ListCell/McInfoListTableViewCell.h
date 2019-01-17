//
//  McMainTableViewCell.h
//  Mocha
//
//  Created by renningning on 14-11-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McInfoListTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *iconImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *numLabel;
    IBOutlet UIButton *numBtn;
    
}
@property (weak, nonatomic) IBOutlet UILabel *bangDingLabel;

- (void)setBangDingWithString:(NSString *)string;

- (void)setNum:(NSString *)num;

- (void)setItemValueWithDict:(NSDictionary *)itemDict;

- (void)setSystem;

@end
