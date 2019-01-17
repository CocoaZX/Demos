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

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "MessageModel.h"
#import "EaseMob.h"
#import "EMChatViewBaseCell.h"
@implementation MessageModelManager

+ (id)modelWithMessage:(EMMessage *)message
{
    id<IEMMessageBody> messageBody = [message.messageBodies firstObject];
    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
    NSString *login = [userInfo objectForKey:kSDKUsername];
    NSString *sender = (message.messageType == eMessageTypeChat) ? message.from : message.groupSenderName;
    BOOL isSender = [login isEqualToString:sender] ? YES : NO;
    
    MessageModel *model = [[MessageModel alloc] init];
    model.isRead = message.isRead;
    model.messageBody = messageBody;
    model.message = message;
    model.type = messageBody.messageBodyType;
    model.isSender = isSender;
    model.isPlaying = NO;
    model.messageType = message.messageType;
    //群聊
    if (model.messageType != eMessageTypeChat) {
        ///群聊消息里的发送者用户名
        model.username = message.groupSenderName;
    }
    else{
        //单聊时也同样设置username为消息发出者的id
        model.username = message.from;
    }
    
    switch (messageBody.messageBodyType) {
        case eMessageBodyType_Text:
        {
            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.content = didReceiveText;
        }
            break;
        case eMessageBodyType_Image:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailSize = imgMessageBody.thumbnailSize;
            model.size = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {   //自己发送的图片，显示本地的
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                //接收对方的图片，使用网络加载
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case eMessageBodyType_Location:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case eMessageBodyType_Voice:
        {
            model.time = ((EMVoiceMessageBody *)messageBody).duration;
            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isPlayed = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
                [message updateMessageExtToDB];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
        }
            break;
        case eMessageBodyType_Video:{
            EMVideoMessageBody *videoMessageBody = (EMVideoMessageBody*)messageBody;
            model.thumbnailSize = videoMessageBody.size;
            model.size = videoMessageBody.size;
            model.localPath = videoMessageBody.thumbnailLocalPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:videoMessageBody.thumbnailLocalPath];
            model.image = model.thumbnailImage;
        }
            break;
            //自定义部分
        case eMessageBodyType_YuePai:{
            
        }
            break;
        case eMessageBodyType_DaShang:{
        }
            break;

        default:
            
            
            break;
    }
    NSDictionary *dic = message.ext;
    if (dic.allKeys.count>0) {
        //自定义cell:约拍类型
        NSString *type = getSafeString(dic[@"objectType"]);
        if ([type isEqualToString:@"4"]) {
            NSLog(@"ext:%@",dic);
            NSString *typeStep = getSafeString(dic[@"step"]);
            if ([typeStep isEqualToString:@"1"]) {
                model.type = eMessageBodyType_YuePai;
                
                model.thumbnailSize = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
                model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
                model.localPath = nil;
                model.thumbnailImage = [self getYuepaiViewWithData:dic title:((EMTextMessageBody *)messageBody).text isTaoXi:NO];
                if (isSender)
                {
                    model.image = [self getYuepaiViewWithData:dic title:((EMTextMessageBody *)messageBody).text isTaoXi:NO];
                }else {
                    
                }
            }else if ([typeStep isEqualToString:@"2"])
            {
//                model.type = eMessageBodyType_YuePai;
//                model.thumbnailSize = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT/4);
//                model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT/4);
//                model.localPath = nil;
//                model.thumbnailImage = [self getYuepaiAcceptViewWithData:dic title:((EMTextMessageBody *)messageBody).text];
//                if (isSender)
//                {
//                    model.image = [self getYuepaiAcceptViewWithData:dic title:((EMTextMessageBody *)messageBody).text];
//                }else {
//                    
//                }
                //接受约拍单元格
                model.type = eMessageBodyType_YuePai;
                //重新设定了消息的内容
                if (isSender) {
                    //这条消息是我发送的，我是接受者
                    model.content = model.message.ext[@"tips"];
                }else{
                    model.content = model.message.ext[@"to_tips"];
                }
            }
            
        }else if ([type isEqualToString:@"2"]){
            //自定义cell:旧版本：打赏图片类型
            model.type = eMessageBodyType_DaShang;
            model.thumbnailSize = CGSizeMake(DASHANGVIEWWIDTH, DASHANGVIEWHEIGHT);
            model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
            model.localPath = nil;
            model.thumbnailImage = [self getDaShangViewWithData:dic];
            model.thumbnailImage = [UIImage imageNamed:@"canBack"];

             if (isSender)
            {
                model.image = [self getDaShangViewWithData:dic];
                model.image = [UIImage imageNamed:@"canBack"];
            }else {

            }
        }else if([type isEqualToString:@"3"]){
            //自定义cell:新版本增加金币打赏类型
            model.type = eMessageBodyType_GoldCoin;
            
            model.thumbnailSize = CGSizeMake(DASHANGVIEWWIDTH, DASHANGVIEWHEIGHT);
            model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
            model.localPath = nil;
            model.thumbnailImage = [self getDaShangViewWithData:dic];
            model.thumbnailImage = [UIImage imageNamed:@"canBack"];
            
            if (isSender)
            {
                model.image = [self getDaShangViewWithData:dic];
                model.image = [UIImage imageNamed:@"canBack"];
            }else {
            }
        }else if([type isEqualToString:@"0"]){
            //设置消息类型，此为系统消息
            model.type = eMessageBodyType_system;

        }else if ([type isEqualToString:@"10"]){
            NSString *typeStep = getSafeString(dic[@"step"]);
            if ([typeStep isEqualToString:@"1"]) {
                model.type = eMessageBodyType_TaoXi;
                
                model.thumbnailSize = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
                model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT);
                model.localPath = nil;
                model.thumbnailImage = [self getYuepaiViewWithData:dic title:((EMTextMessageBody *)messageBody).text isTaoXi:YES];
                if (isSender)
                {
                    model.image = [self getYuepaiViewWithData:dic title:((EMTextMessageBody *)messageBody).text isTaoXi:YES];
                }else {
                    
                }
            }else if ([typeStep isEqualToString:@"2"])
            {
                //                model.type = eMessageBodyType_YuePai;
                //                model.thumbnailSize = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT/4);
                //                model.size = CGSizeMake(YUEPAIVIEWWIDTH, YUEPAIVIEWHEIGHT/4);
                //                model.localPath = nil;
                //                model.thumbnailImage = [self getYuepaiAcceptViewWithData:dic title:((EMTextMessageBody *)messageBody).text];
                //                if (isSender)
                //                {
                //                    model.image = [self getYuepaiAcceptViewWithData:dic title:((EMTextMessageBody *)messageBody).text];
                //                }else {
                //
                //                }
                //接受约拍单元格
                model.type = eMessageBodyType_TaoXi;
                //重新设定了消息的内容
                if (isSender) {
                    //这条消息是我发送的，我是接受者
                    model.content = model.message.ext[@"tips"];
                }else{
                    model.content = model.message.ext[@"to_tips"];
                }
            }
        }
    }
    return model;
}


//获取到打赏的自定义视图
+(UIImage *)getDaShangViewWithData:(NSDictionary *)dic{
    
    float Twidth =  DASHANGVIEWWIDTH*1.5;
    float Theight = DASHANGVIEWHEIGHT*1.5;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UILabel *topLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/2)];
    topLabel.text = @"10元";
    [view addSubview:topLabel];
    
    UILabel *downLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, Theight/2, Twidth, Theight/2)];
    downLabel.text = @"图片打赏红包";
    [view addSubview:downLabel];
    
    return [self changeViewToImage:view];

}






//约拍：step = 1
+ (UIImage *)getYuepaiViewWithData:(NSDictionary *)diction title:(NSString *)titleString isTaoXi:(BOOL)isTaoXi
{
    float Twidth =  YUEPAIVIEWWIDTH*1.5;
    float Theight = YUEPAIVIEWHEIGHT*1.5;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight)];
    view.backgroundColor = [UIColor lightGrayColor];
    //上部分
    UIView *partOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/4*3)];
    partOne.backgroundColor = [UIColor whiteColor];
    partOne.layer.borderColor = RGB(210, 210, 210).CGColor;
    partOne.layer.borderWidth = 1;
    partOne.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Twidth-20, Theight/4)];
    titleLabel.text = getSafeString(titleString);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, Theight/4, Twidth, 1)];
    lineView.backgroundColor = RGB(210, 210, 210);
    
    UILabel *dateTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, Theight/4, 100, Theight/4)];
    dateTitle.text = @"拍摄日期";
    dateTitle.textColor = [UIColor darkGrayColor];
    dateTitle.textAlignment = NSTextAlignmentLeft;
    dateTitle.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:dateTitle];
    
    UILabel *dateDesc = [[UILabel alloc] initWithFrame:CGRectMake(Twidth-150-10, Theight/4, 150, Theight/4)];
    dateDesc.text = getSafeString(diction[@"covenantDay"]);
    dateDesc.textColor = [UIColor darkGrayColor];
    dateDesc.textAlignment = NSTextAlignmentRight;
    dateDesc.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:dateDesc];
    
    UILabel *moneyTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, Theight/4*2, 100, Theight/4)];
    moneyTitle.text = @"拍摄价格";
    moneyTitle.textColor = [UIColor darkGrayColor];
    moneyTitle.textAlignment = NSTextAlignmentLeft;
    moneyTitle.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:moneyTitle];
    
    UILabel *moneyDesc = [[UILabel alloc] initWithFrame:CGRectMake(Twidth-150-10, Theight/4*2, 150, Theight/4)];
    moneyDesc.text = getSafeString(diction[@"money"]);
    moneyDesc.textColor = [UIColor darkGrayColor];
    moneyDesc.textAlignment = NSTextAlignmentRight;
    moneyDesc.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:moneyDesc];
    
    UIView *partTwo = [[UIView alloc] initWithFrame:CGRectMake(0, Theight/4*3, Twidth, Theight/4)];
    partTwo.backgroundColor = [CommonUtils colorFromHexString:kLikeRedColor];
    
    UILabel *mokaTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, Theight/4)];
    mokaTitle.text = @"MOKA约拍";
    if (isTaoXi) {
        mokaTitle.text = @"专题订单";
    }
    mokaTitle.textColor = [UIColor whiteColor];
    mokaTitle.textAlignment = NSTextAlignmentLeft;
    mokaTitle.font = [UIFont systemFontOfSize:18];
    [partTwo addSubview:mokaTitle];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(Twidth-Theight/4, 8, Theight/4-16, Theight/4-16)];
    imageView.image = [UIImage imageNamed:@"Icon-60.png"];
    [partTwo addSubview:imageView];
    
    
    [view addSubview:partOne];
    [view addSubview:partTwo];
    
    return [self changeViewToImage:view];
}



//约拍：step = 2
+ (UIImage *)getYuepaiAcceptViewWithData:(NSDictionary *)diction title:(NSString *)titleString
{
    float Twidth =  YUEPAIVIEWWIDTH*1.5;
    float Theight = YUEPAIVIEWHEIGHT*1.5;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/4)];
    view.backgroundColor = [UIColor lightGrayColor];
    
    UIView *partOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Twidth, Theight/4)];
    partOne.backgroundColor = RGB(122, 180, 28);
    partOne.layer.borderColor = RGB(210, 210, 210).CGColor;
    partOne.layer.borderWidth = 1;
    partOne.clipsToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Twidth-20, Theight/4)];
    titleLabel.text = getSafeString(titleString);
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:18];
    [partOne addSubview:titleLabel];
    
    
    [view addSubview:partOne];
    return [self changeViewToImage:view];
    
}





+ (UIImage *)changeViewToImage:(UIView *)view
{
    UIImage *image = [SQCImageUtils convertViewToImage:view];
    
    return image;
}


@end
