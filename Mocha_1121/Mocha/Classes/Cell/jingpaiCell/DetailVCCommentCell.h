//
//  DetailVCCommentCell.h
//  Mocha
//
//  Created by TanJian on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailVCCommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIButton *headerButton;

@property (nonatomic,strong) UIViewController *superVC;

-(void)setupUI:(NSDictionary *)dict;

+(float)getHeightWithDict:(NSDictionary *)dict;

@end
