//
//  EventTableViewCell.h
//  Mocha
//
//  Created by renningning on 15-3-19.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol McEventTableViewCellDelegate <NSObject>

@optional
- (void)actionDone:(NSString *)msg isReload:(BOOL)isReload;

- (void)doShowSignUpList:(NSString *)eid;

- (void)doShareTo:(NSDictionary *)itemdict;

- (void)doJumpDetail:(NSDictionary *)itemDict;

- (void)doZanMessage:(NSDictionary *)itemDict;

- (void)doJumpPersonCenter:(NSDictionary *)itemDict;

@end

@interface McEventTableViewCell : UITableViewCell
{
    IBOutlet UIImageView *bgHImageView;
    IBOutlet UIImageView *iconImageView;
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *typeLabel;
    IBOutlet UILabel *companyLabel;
    IBOutlet UIImageView *lineImageView;
    IBOutlet UIImageView *horImageView;
    
    IBOutlet UIImageView *logoImageView;
    IBOutlet UILabel *infoLabel;
    
    IBOutlet UILabel *publishTimeLab;
    
    IBOutlet UIView  *infoView;
    IBOutlet UILabel *moneyLabel;
    IBOutlet UILabel *eventTimeLab;
    IBOutlet UILabel *areaLabel;
    IBOutlet UILabel *numberLab;
    IBOutlet UIImageView *infoLineView;
    
    IBOutlet UIImageView *lookImageView;
    
    IBOutlet UIImageView *lineImageView2;
    IBOutlet UIImageView *divisionImageView;
    IBOutlet UIView  *clickView;
    IBOutlet UIView  *signupUsersView;
    
    
    
    IBOutlet UIImageView *iconSign;
    IBOutlet UIImageView *iconCommet;
    IBOutlet UIImageView *iconLike;
    
    IBOutlet UIButton *signUpBtn;
    IBOutlet UIButton *likeBtn;
    IBOutlet UIButton *commentBtn;
    IBOutlet UIButton *shareBtn;
    
    IBOutlet UILabel *signNumLabel;
    IBOutlet UILabel *commetNumLabel;
    IBOutlet UILabel *likeNumLabel;
    
    NSArray *allAreaInfoArray;
    NSDictionary *roleTypeDict;
}

@property (nonatomic, assign) id<McEventTableViewCellDelegate> cellDelegate;

@property (nonatomic, retain) NSDictionary *itemDict;

- (void)setShowType:(NSUInteger)_type;

- (void)setItemValueWithDict:(NSDictionary *)itemDict publisherKey:(NSString *)key;

- (float)getContentViewHeightWithDict:(NSDictionary *)itemDict;

- (void)setLookIconHidden:(BOOL)isHidden;


@end
