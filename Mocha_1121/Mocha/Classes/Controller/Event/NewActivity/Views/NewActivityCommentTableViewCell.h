//
//  NewActivityCommentTableViewCell.h
//  Mocha
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 
 data =     (
 {
 content = "\U5b59\U542f\U8d85\U524d\U6765\U62a5\U5230\Uff0c\U8bf7\U591a\U5173\U7167~";
 createline = "2015-08-27";
 "event_id" = 11;
 "head_pic" = "http://cdn.q8oils.cc/c2d921bbab00fe65f8676f3faccdb66e";
 id = 12;
 ip = "27.115.97.178";
 nickname = "\U5b59\U542f\U8d85";
 replies =             (
 {
 content = "\U5ba2\U6c14\U5ba2\U6c14\U263a";
 createline = 1440664345;
 "event_id" = 11;
 id = 13;
 ip = 1971847337;
 "prent_id" = 12;
 uid = 346;
 }
 );
 uid = 9;
 "user_type" = "\U6a21\U7279";
 },
 {
 content = "\U8ddd\U79bb\U611f\U5494\U5494";
 createline = "2015-08-26";
 "event_id" = 11;
 "head_pic" = "http://cdn.q8oils.cc/885489b742ac59c58cd7e5a896aa7938";
 id = 10;
 ip = "124.202.190.68";
 nickname = "\U5927\U61d2\U866b";
 replies =             (
 {
 content = "\U54c7\U54c7\U54c7\U54c7\U54c7";
 createline = "2015-08-27";
 "event_id" = 11;
 "head_pic" = "http://cdn.q8oils.cc/e22887121a4dadb265c3e4a07e9ddc6c";
 id = 14;
 ip = "117.136.0.169";
 nickname = "\U5c0f\U77ee\U4eba";
 uid = 346;
 "user_type" = "\U5316\U5986\U5e08";
 }
 );
 uid = 356;
 "user_type" = "\U6a21\U7279";
 }
 );
 
 */
@interface NewActivityCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *userTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@property (weak, nonatomic) IBOutlet UIImageView *outsideVipImg;

@property (weak, nonatomic) IBOutlet UIImageView *insideVipImg;

@property (weak, nonatomic) IBOutlet UIView *replayView;

@property (weak, nonatomic) IBOutlet UIImageView *replay_headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *replay_nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *replay_userTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *replay_content;

@property (weak, nonatomic) IBOutlet UIButton *oneClickButton;

@property (weak, nonatomic) IBOutlet UIButton *twoClcikButton;

//底部分割线
@property (nonatomic,strong)UIView *bottomLineView;
//数据源
@property (strong, nonatomic) NSDictionary *dataDiction;


@property (weak, nonatomic) UIViewController *supCon;

@property (copy, nonatomic) NSString *replayHeaderURL;

@property (copy, nonatomic) NSString *replayName;

@property (copy, nonatomic) NSString *currentUid;

@property (copy, nonatomic) NSString *replayUserType;

//整体距离左边距
@property (assign, nonatomic)CGFloat leftPadding;

- (void)setDataWithDiction:(NSDictionary *)diction;


+ (NewActivityCommentTableViewCell *)getNewActivityCommentCell;

+ (float)getHeightWithDiction:(NSDictionary *)diction;





@end
