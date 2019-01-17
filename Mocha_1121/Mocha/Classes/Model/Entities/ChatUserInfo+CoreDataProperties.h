//
//  ChatUserInfo+CoreDataProperties.h
//  Mocha
//
//  Created by zhoushuai on 15/12/21.
//  Copyright © 2015年 renningning. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ChatUserInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatUserInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *chatId;
@property (nullable, nonatomic, retain) NSString *nickName;
@property (nullable, nonatomic, retain) NSString *headPic;

@end

NS_ASSUME_NONNULL_END
