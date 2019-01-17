//
//  CoreDataManager.h
//  Mocha
//
//  Created by zhoushuai on 15/12/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (nonatomic, strong)NSManagedObjectContext *context;


+ (instancetype)shareInstance;

//创建MO对象
- (NSManagedObject *)createMO:(NSString *)entityName;

//添加对象
- (void)saveManagerObj:(NSManagedObject *)mo;

//查询
- (NSArray *)query:(NSString *)entityName predicate:(NSPredicate *)predicate;

//修改
- (void)updateManagerObj:(NSManagedObject *)mo;

//删除
- (void)removeManagerObj:(NSManagedObject *)mo;


@end
