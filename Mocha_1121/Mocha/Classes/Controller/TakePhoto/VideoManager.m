//
//  VideoManager.m
//  Mocha
//
//  Created by sun on 15/8/12.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "VideoManager.h"
#import "JSONKit.h"
@implementation VideoManager

static VideoManager *videoMan;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoMan = [[VideoManager alloc] init];
        videoMan.upManager = [QNUploadManager sharedInstanceWithConfiguration:nil];

    });
    return videoMan;
}


- (NSString *)getVideoUUid
{
    NSString *uuid = getRandomUUID();
    
    return [NSString stringWithFormat:@"%@.mov",uuid];
}


NSString* getRandomUUID() {
    NSDate *datenow = [NSDate date];
    NSTimeZone *zone =[NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:datenow];
    NSDate *localDate =[datenow  dateByAddingTimeInterval:interval];
    //    NSTimeInterval timeHaoMiao=[localDate timeIntervalSince1970];
    long x = arc4random() % 10000000;
    NSString *timeStr = localDate.description;
    if (timeStr.length>20) {
        timeStr = [[timeStr substringFromIndex:0] substringToIndex:19];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@":" withString:@""];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        
    }
    NSString *photoUUID = [NSString stringWithFormat:@"%@%ld",timeStr,x];
    
    return photoUUID;
    
}


- (void)uploadWithVideo:(NSURL *)videoUrl block:(ChangeFinishBlock)block
{
    NSData *videoData = [NSData dataWithContentsOfURL:videoUrl];
    
    NSString *string = [[NSString alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://1.mokavideo.sinaapp.com/bootstrap.php"] encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *diction = [string objectFromJSONString];
    
    
    [self.upManager putData:videoData key:[self getVideoUUid] token:getSafeString([NSString stringWithFormat:@"%@",diction[@"token"]]) complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        NSLog(@"%@", info);
        NSLog(@"%@", resp);
        if (resp) {
            NSString *urlString = [NSString stringWithFormat:@"http://7fvjzt.com1.z0.glb.clouddn.com/%@",key];
            block(urlString);
        }else
        {
            block(nil);

        }
        
    } option:nil];
    
    
}




@end
