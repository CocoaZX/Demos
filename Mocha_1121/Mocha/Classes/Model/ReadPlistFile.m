//
//  ReadPlistFile.m
//  Mocha
//
//  Created by renningning on 14-12-16.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "ReadPlistFile.h"
#import "JSONKit.h"

@implementation ReadPlistFile

+ (void)getUserAttrlist
{
    NSDictionary *dict = [AFParamFormat formatGetUserAttrilist];
    [AFNetwork getUserAttrlist:dict success:^(id data){
        [ReadPlistFile getUserAttrilistDone:data];
    }failed:^(NSError *error){
        
    }];
}

+ (void)getUserAttrilistDone:(id)data
{
    if ([data[@"status"] integerValue] == kRight) {
        NSArray *arr = data[@"data"];
        [ReadPlistFile savePlistFile:@"mokaAttrilistData.plist" content:arr];
        
    }
}

+ (NSDictionary *)readPlistFileWithName:(NSString *)name ofType:(NSString *)plist
{
    //path 读取当前程序定义好的文件
    NSString *pathW = [[NSBundle mainBundle] pathForResource:name ofType:plist];
    return [NSDictionary dictionaryWithContentsOfFile:pathW];
}

+ (NSDictionary *)getDictionaryWithType:(NSInteger)type
{
    NSString *fileName = @"mokaAttrilistData.plist";
    NSArray *fileArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [fileArray objectAtIndex:0];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    if ([dataArr count] > 0) {
        for (NSDictionary * itemdict in dataArr) {
            if ([itemdict[@"id"] integerValue] == type) {
                NSArray *list = itemdict[@"list"];
                for (NSDictionary *listDict in list){
                    if (type == 1 || type == 3) {
                        [dict setValue:listDict[@"id"] forKey:listDict[@"name"]];
                    }
                    else{
                       [dict setValue:listDict[@"name"] forKey:listDict[@"id"]];
                    }
                    
                }
                break;
            }
        }
        return dict;
    }
    
    NSDictionary *params = [AFParamFormat formatGetUserAttrilist];
    [AFNetwork getUserAttrlist:params success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            //获取项目下沙盒路径
            NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [pathArray objectAtIndex:0];
            NSString *filePath = [path stringByAppendingPathComponent:fileName];
            BOOL isSuccess = [arr writeToFile:filePath atomically:YES];
            
            if (isSuccess) {
                for (NSDictionary * itemdict in arr) {
                    if ([itemdict[@"id"] integerValue] == type) {
                        NSArray *list = itemdict[@"list"];
                        for (NSDictionary *listDict in list){
                            if (type == 1 || type == 3) {
                                [dict setValue:listDict[@"id"] forKey:listDict[@"name"]];
                            }
                            else{
                                [dict setValue:listDict[@"name"] forKey:listDict[@"id"]];
                            }
                        }
                        break;
                    }
                }

            }
            else{
                [ReadPlistFile deleteFile:fileName];
            }
        }
    }failed:^(NSError *error){
        
    }];
    
    return dict;

}

+ (void)savePlistFile:(NSString *)fileName withContent:(NSDictionary *)dict
{
    //获取项目下沙盒路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [dict writeToFile:filePath atomically:YES];
    
    if (!isSuccess) {
        [ReadPlistFile deleteFile:fileName];
    }
}

+ (void)savePlistFile:(NSString *)fileName content:(NSArray *)array
{
    //获取项目下沙盒路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [array writeToFile:filePath atomically:YES];
    
    if (!isSuccess) {
        [ReadPlistFile deleteFile:fileName];
    }

}

+ (void)deleteFile:(NSString *)fileName{
    NSError *err;
    //获取项目下沙盒路径
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&err];
}


+ (NSArray *)readAreaArray
{
    NSError *error;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"txt"];
    NSString *textFilesStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    // If there are no results, something went wrong
    if (textFilesStr == nil) {
        // an error occurred
        NSLog(@"Error reading text file. %@", [error localizedFailureReason]);
    }
    return [textFilesStr objectFromJSONString];
}

+ (NSDictionary *)readSex
{
    return @{@"1":@"男",@"2":@"女"};
}

+ (NSDictionary *)readWorkTags
{
//    return [ReadPlistFile readPlistFileWithName:@"workTags" ofType:@"plist"];
    return [ReadPlistFile getDictionaryWithType:5];
}

+ (NSDictionary *)readWorkStyles
{
//    return [ReadPlistFile readPlistFileWithName:@"workStyle" ofType:@"plist"];
    return [ReadPlistFile getDictionaryWithType:4];
}

+ (NSDictionary *)readHairs
{
//    return [ReadPlistFile readPlistFileWithName:@"hair" ofType:@"plist"];
    return [ReadPlistFile getDictionaryWithType:3];
}

+ (NSDictionary *)readProfession
{
//    return [ReadPlistFile readPlistFileWithName:@"Profession" ofType:@"plist"];
    return [ReadPlistFile getDictionaryWithType:6];
}

+ (NSDictionary *)readMajor
{
//    return [ReadPlistFile readPlistFileWithName:@"Major" ofType:@"plist"];
    return [ReadPlistFile getDictionaryWithType:7];
}

+ (NSArray *)getTypes
{
    NSArray *array = @[@{@"1":@"模特"},@{@"2":@"摄影师"},@{@"3":@"化妆师"},@{@"4":@"经纪人"},@{@"5":@"其他"}];
    return array;
}
+ (NSDictionary *)getRoleTypes
{
    NSDictionary *dict = @{@"1":@"模特",@"2":@"摄影师",@"3":@"化妆师",@"4":@"经纪人",@"5":@"其他"};
    return dict;
}

+ (NSDictionary *)readFeets
{
    return [ReadPlistFile getDictionaryWithType:1];
}

+ (NSArray *)getFeets
{
//    NSDictionary *dict = [ReadPlistFile readPlistFileWithName:@"feets" ofType:@"plist"];
    
    NSDictionary *dict = [ReadPlistFile getDictionaryWithType:1];
    NSArray *values = [dict allKeys];
    NSArray *sortedKeys = [values sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber*)obj1 compare:(NSNumber*)obj2];
    }];
    
    return sortedKeys;
}

+ (NSArray *)sortedArrayAscending:(NSArray *)array
{
    NSArray *sortedKeys = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber*)obj1 compare:(NSNumber*)obj2];
    }];
    
    return sortedKeys;
}

+ (NSArray *)sortedKeysFrom:(NSDictionary *)dict
{
    NSArray *sortedKeys = [dict  keysSortedByValueUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSNumber*)obj1 compare:(NSNumber*)obj2];
    }];
    
    return sortedKeys;
}

@end
