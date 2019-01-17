//
//  MoreTableViewCell.h
//  Mocha
//
//  Created by XIANPP on 15/12/26.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreTableViewCell : UITableViewCell

//@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;

//@property (weak, nonatomic) IBOutlet UIImageView *enterImageView;

@property (nonatomic , strong) UILabel *commentsLabel;

@property (nonatomic , strong) UIImageView *enterImageView;

+(MoreTableViewCell *)getMoreTableViewCell;

-(void)initWithInt:(int)comments;

@end
