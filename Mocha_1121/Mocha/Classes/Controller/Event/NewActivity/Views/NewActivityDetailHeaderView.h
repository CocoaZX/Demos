//
//  NewActivityDetailHeaderView.h
//  Mocha
//
//  Created by sun on 15/8/25.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGFocusImageFrame.h"
#import "SGFocusImageItem.h"

/*
 {
 address = "\U968f\U65f6";
 "chart_id" = 98735623703101876;
 city = "\U901a\U8fbd\U5e02";
 commentscount = 1;
 content = "DSG\U6280\U672f\U76d1\U7763\U5c40\U5730\Uff0c\U548c\U7ecf\U6d4e\U7684\U6297\U65e57979979";
 enddate = "2016-01-26";
 id = 11;
 img =     (
 "http://cdn.q8oils.cc/5bcec6fad2d947928ed16dbf7d3a0ea8",
 "http://cdn.q8oils.cc/d459e280a32731cf8e8b2bd3d794f81b"
 );
 "interview_method" = "\U7167\U7247\U9762\U8bd5";
 ispublisher = 0;
 issignuped = 0;
 "last_enrol_date" = "2015-12-26";
 number = 55;
 optionCode = 1;
 payment = 3;
 province = "\U5185\U8499\U53e4";
 publisher =     {
 "head_pic" = "http://cdn.q8oils.cc/e22887121a4dadb265c3e4a07e9ddc6c";
 nickname = "\U5c0f\U77ee\U4eba";
 uid = 346;
 "user_type" = "\U8ba4\U8bc1\U5316\U5986\U5e08";
 };
 sex = "\U5973";
 signcount = 0;
 signuplist =     (
 );
 startdate = "2015-08-26";
 statusName = "\U7acb\U5373\U62a5\U540d";
 title = "\U6d4b\U8bd5\U6d3b\U52a8\U56fe\U7247\U6a21\U7279";
 uid = 346;
 "user_type" = "\U6a21\U7279";
 }
 
 */

//1440722708409

@interface NewActivityDetailHeaderView : UIView<SGFocusImageFrameDelegate>

@property (weak, nonatomic) IBOutlet UILabel *huodongqunliao;

@property (weak, nonatomic) IBOutlet UIView *imagesView;

@property (weak, nonatomic) IBOutlet UIView *informationView;

@property (weak, nonatomic) IBOutlet UIView *talkView;

@property (weak, nonatomic) IBOutlet UIView *deacriptionView;

@property (weak, nonatomic) IBOutlet UIView *activityDescView;

@property (weak, nonatomic) IBOutlet UIView *commentTitleView;

@property (weak, nonatomic) IBOutlet UIView *clickCommentView;

@property (weak, nonatomic) IBOutlet UILabel *info_title;

@property (weak, nonatomic) IBOutlet UIView *info_firstLine;

@property (weak, nonatomic) IBOutlet UILabel *info_feiyong;

@property (weak, nonatomic) IBOutlet UILabel *info_peopleNumber;

@property (weak, nonatomic) IBOutlet UILabel *info_time;

@property (weak, nonatomic) IBOutlet UILabel *info_address;

@property (weak, nonatomic) IBOutlet UILabel *info_sex;

@property (weak, nonatomic) IBOutlet UILabel *info_baomingjiezhi;

@property (weak, nonatomic) IBOutlet UILabel *info_shenfen;

@property (weak, nonatomic) IBOutlet UIImageView *jiaVView;


@property (weak, nonatomic) IBOutlet UIButton *info_fabuButton;

@property (weak, nonatomic) IBOutlet UIImageView *info_fabuArrow;

@property (weak, nonatomic) IBOutlet UIView *info_secondLine;

@property (weak, nonatomic) IBOutlet UIImageView *info_headerImageView;

@property (weak, nonatomic) IBOutlet UILabel *info_name;

@property (weak, nonatomic) IBOutlet UILabel *info_renzhengType;

@property (weak, nonatomic) IBOutlet UIButton *info_submitButton;

@property (weak, nonatomic) IBOutlet UILabel *talk_peopleNumber;

@property (weak, nonatomic) IBOutlet UIView *talk_firstLine;

@property (weak, nonatomic) IBOutlet UIView *talk_secondLine;

@property (weak, nonatomic) IBOutlet UIImageView *talk_arrowImageView;

@property (weak, nonatomic) IBOutlet UILabel *desc_jianjie;

@property (weak, nonatomic) IBOutlet UIView *desc_firstLline;

@property (weak, nonatomic) IBOutlet UIView *desc_secondLine;

@property (weak, nonatomic) IBOutlet UIView *desc_thirdLine;

@property (weak, nonatomic) IBOutlet UILabel *desc_baomingrenshu;

@property (weak, nonatomic) IBOutlet UILabel *desc_baomingTitle;

@property (weak, nonatomic) IBOutlet UIButton *desc_baomingButton;

@property (weak, nonatomic) IBOutlet UIView *desc_headImagesView;

@property (weak, nonatomic) IBOutlet UIButton *com_leaveMessage;

@property (weak, nonatomic) IBOutlet UIImageView *com_leaveMessageImageView;

@property (weak, nonatomic) IBOutlet UIView *com_firstLine;


@property (weak, nonatomic) UIViewController *supCon;

@property (strong, nonatomic) NSDictionary *dataDiction;



- (void)initViewWithData:(NSDictionary *)diction;

+ (NewActivityDetailHeaderView *)getNewActivityDetailHeaderView;

- (float)getViewHeight;



@end
