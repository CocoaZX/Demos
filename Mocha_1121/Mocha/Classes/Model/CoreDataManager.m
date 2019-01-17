//
//  CoreDataManager.m
//  Mocha
//
//  Created by zhoushuai on 15/12/19.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "CoreDataManager.h"
static CoreDataManager *instance = nil;

@implementation CoreDataManager


//返回一个操作聊天信息的
+(instancetype)shareInstance{
    if (instance == nil) {
        @synchronized(self){
            //加上锁
            instance = [[CoreDataManager alloc] init];
        }
     }
    return  instance;
}


- (NSManagedObjectContext *)context{
    return  [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
}


//创建MO对象
- (NSManagedObject *)createMO:(NSString *)entityName
{
    if (entityName.length == 0) {
        return nil;
    }
    
    //根据实体名称，创建mo对象
    NSManagedObject *mo = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
    
    return mo;
}



//添加对象
- (void)saveManagerObj:(NSManagedObject *)mo
{
    if (!mo) {
        NSLog(@"mo 为nil ,保存失败");
        return;
    }
    [self.context insertObject:mo];
    
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"%@保存成功",mo);
    }else {
        NSLog(@"%@保存失败：%@",mo, error);
    }
    
}

//查询
- (NSArray *)query:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    
    if (entityName.length == 0) {
        return nil;
    }
    
    //创建查询请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
//    //定义排序字段
//    NSSortDescriptor *soreDesc = [NSSortDescriptor sortDescriptorWithKey:@"age" ascending:YES];
//    request.sortDescriptors = @[soreDesc];
//    
//    //分页查询
//    int page = 0;
//    [request setFetchLimit:5];
//    [request setFetchOffset:page * 5];
    
    //定义查询条件
    request.predicate = predicate;
    
    //执行查询操作
    NSArray *array = [self.context executeFetchRequest:request error:nil];
    
    return array;
}




//修改
- (void)updateManagerObj:(NSManagedObject *)mo
{
    if (!mo) {
        return;
    }
    
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"%@修改成功",mo);
    }else {
        NSLog(@"%@修改失败：%@",mo, error);
    }
}

//删除
- (void)removeManagerObj:(NSManagedObject *)mo
{
    
    if (!mo) {
        return;
    }
    
    [self.context deleteObject:mo];
    
    NSError *error = nil;
    if ([self.context save:&error]) {
        NSLog(@"%@删除成功",mo);
    }else {
        NSLog(@"%@删除失败：%@",mo, error);
    }
    
}


@end
