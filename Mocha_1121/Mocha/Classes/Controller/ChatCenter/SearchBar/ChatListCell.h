/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface ChatListCell : UITableViewCell
//图片的url和链接
//@property (nonatomic, strong) NSURL *imageURL;
@property(nonatomic,copy)NSString *imgUrlString;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;

@property (nonatomic) NSInteger unreadCount;

@property (nonatomic, assign) BOOL isRequest;

//是否是群聊
@property(nonatomic,assign)BOOL isQunLiao;


+(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath;
@end
