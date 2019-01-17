//
//  PhotoEngine.m
//  Mocha
//
//  Created by 小猪猪 on 15/1/4.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "PhotoEngine.h"
#import "CoreData+MagicalRecord.h"
#import "PhotoInfo.h"
#import "PersonInfo.h"

@implementation PhotoEngine

+ (void)savePhotoInfoWithArray:(NSArray *)photos uid:(NSString *)uid block:(saveFinishCallBack)block
{
    NSArray *photoArray = photos.copy;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary * photo in photoArray) {
            if ([photo isKindOfClass:[NSDictionary class]]) {
                [self savePhotoItemWithDict:photo localContext:localContext];

            }
        }
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//            NSArray *fetched = [PhotoInfo MR_findAllSortedBy:@"createline" ascending:NO inContext:localContext];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@" uid = %@ ", uid];  //查询条件

            NSArray *fetched = [PhotoInfo MR_findAllSortedBy:@"createline" ascending:NO withPredicate:predicate inContext:localContext];

            for (int i=0; i<fetched.count; i++) {
                PhotoInfo *photo = fetched[i];
                
                photo.index = [NSNumber numberWithInt:i];
                
            }
            
            
        } completion:^(BOOL contextDidSave, NSError *error) {
            block(YES,error);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
        }];
        
    }];
    
    
}

+ (void)savePhotoItemWithDict:(NSDictionary *)diction localContext:(NSManagedObjectContext *)localContext
{
    NSDictionary *photoDiction = diction.copy;
    PhotoInfo *photo = nil;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid = %@",photoDiction[@"id"]];
    NSArray *check = [PhotoInfo MR_findAllWithPredicate:predicate inContext:localContext];
    if (check.count>0) {
        photo = check[0];
    }else
    {
        photo = [PhotoInfo MR_createEntityInContext:localContext];
        
        
    }
    
    photo.pid = [NSString stringWithFormat:@"%@",photoDiction[@"id"]?photoDiction[@"id"]:@""];
    photo.commentscount = [NSString stringWithFormat:@"%@",photoDiction[@"commentcount"]?photoDiction[@"commentcount"]:@"0"];
    photo.createline = [NSString stringWithFormat:@"%@",photoDiction[@"createline"]?photoDiction[@"createline"]:@""];
    photo.detail = [NSString stringWithFormat:@"%@",photoDiction[@"detail"]?photoDiction[@"detail"]:@""];
    photo.favoritecount = [NSString stringWithFormat:@"%@",photoDiction[@"favoritecount"]?photoDiction[@"favoritecount"]:@"0"];
    photo.height = [NSString stringWithFormat:@"%@",photoDiction[@"height"]?photoDiction[@"height"]:@""];
    photo.isfavorite = [NSString stringWithFormat:@"%@",photoDiction[@"isfavorite"]?photoDiction[@"isfavorite"]:@"0"];
    photo.islike = [NSString stringWithFormat:@"%@",photoDiction[@"islike"]?photoDiction[@"islike"]:@"0"];
    photo.latitude = [NSString stringWithFormat:@"%@",photoDiction[@"latitude"]?photoDiction[@"latitude"]:@""];
    photo.likecount = [NSString stringWithFormat:@"%@",photoDiction[@"likecount"]?photoDiction[@"likecount"]:@"0"];
    photo.longitude = [NSString stringWithFormat:@"%@",photoDiction[@"longitude"]?photoDiction[@"longitude"]:@""];
    photo.status = [NSString stringWithFormat:@"%@",photoDiction[@"status"]?photoDiction[@"status"]:@""];
    photo.tags = [NSString stringWithFormat:@"%@",photoDiction[@"tags"]?photoDiction[@"tags"]:@""];
    photo.title = [NSString stringWithFormat:@"%@",photoDiction[@"title"]?photoDiction[@"title"]:@""];
    photo.type = [NSString stringWithFormat:@"%@",photoDiction[@"type"]?photoDiction[@"type"]:@""];
    photo.uid = [NSString stringWithFormat:@"%@",photoDiction[@"uid"]?photoDiction[@"uid"]:@""];
    photo.url = [NSString stringWithFormat:@"%@",photoDiction[@"url"]?photoDiction[@"url"]:@""];
    photo.width = [NSString stringWithFormat:@"%@",photoDiction[@"width"]?photoDiction[@"width"]:@""];
    
    NSArray *likeUsers = photoDiction[@"likeusers"];
    if ([likeUsers isKindOfClass:[NSArray class]]) {
        for (NSDictionary *likeUserDiction in likeUsers) {
            NSString *itemUid = likeUserDiction[@"id"];
            if (check.count>0) {
                if (photo.likeUsers.count>0) {
                    NSMutableArray *userArray = @[].mutableCopy;
                    for (PersonInfo *user in photo.likeUsers) {
                        [userArray addObject:user];
                    }
                    for (int i=0; i<userArray.count; i++) {
                        PersonInfo *user = userArray[i];
                        if ([user.uid isEqualToString:itemUid]) {
                            
                        }else
                        {
                            [self savePersonItemWithDiction:likeUserDiction localContext:localContext superEntity:photo];
                        }
                    }
                    
                }else
                {
                    [self savePersonItemWithDiction:likeUserDiction localContext:localContext superEntity:photo];
                    
                }
                
            }else
            {
                [self savePersonItemWithDiction:likeUserDiction localContext:localContext superEntity:photo];
                
            }
        }
    }

    
}


+ (void)savePersonItemWithDiction:(NSDictionary *)diction localContext:(NSManagedObjectContext *)localContext superEntity:(PhotoInfo *)photo
{
    NSDictionary *personDiction = diction.copy;
    PersonInfo *person = nil;

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@",personDiction[@"id"]];
    NSArray *check = [PersonInfo MR_findAllWithPredicate:predicate inContext:localContext];
    if (check.count>0) {
        person = check[0];
    }else
    {
        person = [PersonInfo MR_createEntityInContext:localContext];
        

    }
    person.uid = [NSString stringWithFormat:@"%@",personDiction[@"id"]?personDiction[@"id"]:@""];
    person.birth = [NSString stringWithFormat:@"%@",personDiction[@"birth"]?personDiction[@"birth"]:@""];
    person.bust = [NSString stringWithFormat:@"%@",personDiction[@"bust"]?personDiction[@"bust"]:@""];
    person.city = [NSString stringWithFormat:@"%@",personDiction[@"city"]?personDiction[@"city"]:@""];
    person.createline = [NSString stringWithFormat:@"%@",personDiction[@"createline"]?personDiction[@"createline"]:@""];
    person.fanscount = [NSString stringWithFormat:@"%@",personDiction[@"fanscount"]?personDiction[@"fanscount"]:@""];
    person.followcount = [NSString stringWithFormat:@"%@",personDiction[@"followcount"]?personDiction[@"followcount"]:@""];
    person.foot = [NSString stringWithFormat:@"%@",personDiction[@"foot"]?personDiction[@"foot"]:@""];
    person.hair = [NSString stringWithFormat:@"%@",personDiction[@"hair"]?personDiction[@"hair"]:@""];
    person.head_pic = [NSString stringWithFormat:@"%@",personDiction[@"head_pic"]?personDiction[@"head_pic"]:@""];
    person.height = [NSString stringWithFormat:@"%@",personDiction[@"height"]?personDiction[@"height"]:@""];
    person.hipline = [NSString stringWithFormat:@"%@",personDiction[@"hipline"]?personDiction[@"hipline"]:@""];
    person.job = [NSString stringWithFormat:@"%@",personDiction[@"job"]?personDiction[@"job"]:@""];
    person.lastindex = [NSString stringWithFormat:@"%@",personDiction[@"lastindex"]?personDiction[@"lastindex"]:@""];
    person.lastlogin = [NSString stringWithFormat:@"%@",personDiction[@"lastlogin"]?personDiction[@"lastlogin"]:@""];
    person.leg = [NSString stringWithFormat:@"%@",personDiction[@"leg"]?personDiction[@"leg"]:@""];
    person.major = [NSString stringWithFormat:@"%@",personDiction[@"major"]?personDiction[@"major"]:@""];
    person.mark = [NSString stringWithFormat:@"%@",personDiction[@"mark"]?personDiction[@"mark"]:@""];
    person.mobile = [NSString stringWithFormat:@"%@",personDiction[@"mobile"]?personDiction[@"mobile"]:@""];
    person.nickname = [NSString stringWithFormat:@"%@",personDiction[@"nickname"]?personDiction[@"nickname"]:@""];
    person.payment = [NSString stringWithFormat:@"%@",personDiction[@"payment"]?personDiction[@"payment"]:@""];
    person.province = [NSString stringWithFormat:@"%@",personDiction[@"province"]?personDiction[@"province"]:@""];
    person.sex = [NSString stringWithFormat:@"%@",personDiction[@"sex"]?personDiction[@"sex"]:@""];
    person.type = [NSString stringWithFormat:@"%@",personDiction[@"type"]?personDiction[@"type"]:@""];
    person.waist = [NSString stringWithFormat:@"%@",personDiction[@"waist"]?personDiction[@"waist"]:@""];
    person.weight = [NSString stringWithFormat:@"%@",personDiction[@"weight"]?personDiction[@"weight"]:@""];
    person.workhistory = [NSString stringWithFormat:@"%@",personDiction[@"workhistory"]?personDiction[@"workhistory"]:@""];
    person.workstyle = [NSString stringWithFormat:@"%@",personDiction[@"workstyle"]?personDiction[@"workstyle"]:@""];
    person.worktags = [NSString stringWithFormat:@"%@",personDiction[@"worktags"]?personDiction[@"worktags"]:@""];
    
    [photo addLikeUsersObject:person];
    
}



+ (void)deletePhotoWithPid:(NSString *)pid
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"pid = %@",pid];
        [PhotoInfo MR_deleteAllMatchingPredicate:predicate inContext:localContext];
        
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"delete finish");
        
        
    }];
    
}



+ (NSArray *)changeSetToArray:(NSSet *)sets
{
    NSMutableArray *persons = @[].mutableCopy;
    for (PersonInfo *person in sets) {
        [persons addObject:person];
        
    }
    return persons.copy;
}

+ (void)clearAllPhotoData
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [PhotoInfo MR_deleteAllMatchingPredicate:nil inContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"PhotoInfo clear finish");
    }];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [PersonInfo MR_deleteAllMatchingPredicate:nil inContext:localContext];
    } completion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"PersonInfo clear finish");
    }];
    
}






@end
