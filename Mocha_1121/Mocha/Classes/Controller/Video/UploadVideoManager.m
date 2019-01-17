//
//  UploadVideoManager.m
//  Mocha
//
//  Created by yfw－iMac on 16/1/27.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "UploadVideoManager.h"
#import "TXYUploadManager.h"

//#define  SIGN_URL @"http://1.mokavideo.sinaapp.com/mokaVideoAuth.php"
#define  SIGN_URL @"http://1.mokavideo.sinaapp.com/mokaVideoAuthTest.php"

#define DECLARE_WEAK_SELF __typeof(&*self) __weak weakSelf = self
#define DECLARE_STRONG_SELF __typeof(&*self) __strong strongSelf = weakSelf

@interface UploadVideoManager ()
{
    
    NSString *appId;
    NSString *persistenceId;
    NSString *bucket;
    TXYVideoUploadTaskRsp *photoResp;
    NSString *videoPath;
    TXYVideoUploadTask *uploadVideoTask;

}

@property (nonatomic,strong) TXYUploadManager *uploadVideoManager;
@property (nonatomic,strong) TXYVideoUploadTask *uploadVideoTask;
@property (nonatomic,copy) NSString *sign;


@end



@implementation UploadVideoManager
static UploadVideoManager *videoMan;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoMan = [[UploadVideoManager alloc] init];
        [videoMan initState];
    });
    return videoMan;
}

- (void)initState
{
    self.client = [[HttpClient alloc] init];
    self.client.vc = self;
    
    // 上传视频总共五步之    第一步： 注册产品信息
//    appId = @"10019527";
//    bucket = @"mokaspace";
    appId = @"10017412";
    bucket = @"mokavideo";
//    bucket = @"systemcover";

    persistenceId = @"videoID";
    
    //上传视频总共五步之     第二步 向自己的业务服务器请求 上传image所需要的签名
    [self getUploadImageSign];
    
    //上传视频总共五步之     第三步: 初始化上传工具
    _uploadVideoManager = [[TXYUploadManager alloc] initWithCloudType:TXYCloudTypeForVideo
                                                        persistenceId:persistenceId
                                                                appId:appId];
}

-(void)getUploadImageSign
{
//    [self.client getSignWithUrl:SIGN_URL callBack:@selector(getSignFinis:)];
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{}];
    [AFNetwork postRequeatDataParams:params path:PathGetSign success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {

            self.sign = getSafeString(data[@"sign"]);
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];

}

#pragma mark －network
-(void)getSignFinis:(NSString *)string
{
    self.sign = string;
}

#pragma mark - SDK Method
// 上传方法
-(void)uploadVideo
{
    if(!self.sign){
        [self getUploadImageSign];
    }
    TXYVideoFileInfo *videoFileInfo = [[TXYVideoFileInfo alloc]init];
    videoFileInfo.title = @"video2";
    videoFileInfo.desc = @"videodesc1";
    
    
    
    //上传视频总共四步之    第四步: 初始化上传化上传任务
    NSString *dir =[NSString stringWithFormat:@"/123"];//[NSString stringWithFormat:@"/12",bucket];
    uploadVideoTask = [[TXYVideoUploadTask alloc] initWithPath:videoPath
                                                          sign:_sign
                                                        bucket:bucket
                                               customAttribute:@"customAttribute"
                                               uploadDirectory:dir
                                                 videoFileInfo:videoFileInfo
                                                    msgContext:@"msgContext"];
    [self showLoadingWithView:self.view];
    //上传视频总共五步之   第五步: 上传任务
    DECLARE_WEAK_SELF;
    [_uploadVideoManager upload:uploadVideoTask
                       complete:^(TXYTaskRsp *resp, NSDictionary *context) {
                           DECLARE_STRONG_SELF;
                           if (!strongSelf) return;
                           [self hiddenLoadingWihtView:self.view];
                           photoResp = (TXYVideoUploadTaskRsp *)resp;
                           NSLog(@"上传视频的url%@ 上传视频的fileid = %@",photoResp.fileURL,photoResp.fileId);

                           NSLog(@"upload return=%d",photoResp.retCode);
                       }
                       progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {
                           //命中妙传，不走这里的！
                           NSLog(@" totalSize %lld",totalSize);
                           NSLog(@" sendSize %lld",sendSize);
                           NSLog(@" sendSize %@",context);
                       }
                    stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                        switch (state) {
                            case TXYUploadTaskStateWait:
                                NSLog(@"任务等待中");
                                break;
                            case TXYUploadTaskStateConnecting:
                                NSLog(@"任务连接中");
                                break;
                            case TXYUploadTaskStateFail:
                                NSLog(@"任务失败");
                                break;
                            case TXYUploadTaskStateSuccess:
                                NSLog(@"任务成功");
                                break;
                            default:
                                break;
                        }}];
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
    videoPath = videoUrl.description;
    if(!self.sign){
        [self getUploadImageSign];
    }
    TXYVideoFileInfo *videoFileInfo = [[TXYVideoFileInfo alloc]init];
    videoFileInfo.title = @"video2";
    videoFileInfo.desc = @"videodesc1";
    
    
    
    //上传视频总共四步之    第四步: 初始化上传化上传任务
    NSString *dir =[NSString stringWithFormat:@"/moka"];//[NSString stringWithFormat:@"/12",bucket];
    uploadVideoTask = [[TXYVideoUploadTask alloc] initWithPath:videoPath
                                                          sign:_sign
                                                        bucket:bucket
                                               customAttribute:@"customAttribute"
                                               uploadDirectory:dir
                                                 videoFileInfo:videoFileInfo
                                                    msgContext:@"msgContext"];
    [self showLoadingWithView:self.view];
    //上传视频总共五步之   第五步: 上传任务
    DECLARE_WEAK_SELF;
    [_uploadVideoManager upload:uploadVideoTask
                       complete:^(TXYTaskRsp *resp, NSDictionary *context) {
                           DECLARE_STRONG_SELF;
                           if (!strongSelf) return;
                           [self hiddenLoadingWihtView:self.view];
                           photoResp = (TXYVideoUploadTaskRsp *)resp;
                           NSLog(@"上传视频的url%@ 上传视频的fileid = %@",photoResp.fileURL,photoResp.fileId);
                           NSString *urlString = [NSString stringWithFormat:@"%@",photoResp.fileURL];
                           block(urlString);
                           NSLog(@"upload return=%d",photoResp.retCode);
                       }
                       progress:^(int64_t totalSize, int64_t sendSize, NSDictionary *context) {
                           //命中妙传，不走这里的！
                           NSLog(@" totalSize %lld",totalSize);
                           NSLog(@" sendSize %lld",sendSize);
                           NSLog(@" sendSize %@",context);
                       }
                    stateChange:^(TXYUploadTaskState state, NSDictionary *context) {
                        switch (state) {
                            case TXYUploadTaskStateWait:
                                NSLog(@"任务等待中");
                                break;
                            case TXYUploadTaskStateConnecting:
                                NSLog(@"任务连接中");
                                break;
                            case TXYUploadTaskStateFail:
                                NSLog(@"任务失败");
                                block(nil);

                                break;
                            case TXYUploadTaskStateSuccess:
                                NSLog(@"任务成功");
                                break;
                            default:
                                break;
                        }}];
 
}


@end
