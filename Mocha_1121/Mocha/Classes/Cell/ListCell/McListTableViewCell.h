//
//  McListTableViewCell.h
//  Mocha
//
//  Created by renningning on 14-12-4.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface McListTableViewCell : UITableViewCell
{
    UIImageView *headImageView;
    UILabel *nameLabel;
    UILabel *contentLabel;
    UILabel *timeLabel;
    UILabel *numLabel;
    UIButton *numBtn;
    UIImageView *photoImageView;
    UIImageView *lineImageView;
    
    UIImageView *likeImageView;
    UILabel *zanLabel;
    
    UILabel *plusLable;
    UIImageView *goodsImageView;
}

- (float)getContentViewHeightWithDict:(NSDictionary *)itemDict;

- (void)setItemValueWithDict:(NSDictionary *)itemDict;

- (void)setItemValueWithDict_shang:(NSDictionary *)itemDict;

- (float)getContentViewHeightWithDict_shang:(NSDictionary *)itemDict;

@end
