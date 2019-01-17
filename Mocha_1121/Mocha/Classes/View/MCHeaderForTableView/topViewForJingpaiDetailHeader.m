//
//  topViewForJingpaiDetailHeader.m
//  Mocha
//
//  Created by TanJian on 16/4/16.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "topViewForJingpaiDetailHeader.h"
#import "NewMyPageViewController.h"

@interface topViewForJingpaiDetailHeader ()

@property(nonatomic,assign)int secondsCountDown;
@property(nonatomic,strong)NSTimer *countDownTimer;

@end


@implementation topViewForJingpaiDetailHeader

-(void)awakeFromNib{
    
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    self.headerImageView.layer.cornerRadius = self.headerImageView.width*0.5;
    self.headerImageView.clipsToBounds = YES;
    self.jingpaiCountLabel.layer.cornerRadius = 5;
    self.jingpaiCountLabel.clipsToBounds = YES;
    self.contentView.layer.cornerRadius = 3;
    self.contentView.clipsToBounds = YES;
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.headerButton addTarget:self action:@selector(jumpToPersonalPage) forControlEvents:UIControlEventTouchUpInside];
}

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"topViewForJingpaiDetailHeader" owner:self options:nil].lastObject;
}

-(void)setupUI:(MCJingpaiDetailModel *)model{
    
    self.model = model;
    
    
    [self.headerImageView setImageWithURL:[NSURL URLWithString:model.publisher.head_pic?model.publisher.head_pic:@""] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nicknameLabel.text = model.publisher.nickname;
    self.userType.text = model.publisher.user_type;
    if ([model.publisher.member isEqualToString:@"0"]) {
        self.memberImage.hidden = YES;
    }
    
    self.jingpaiCountLabel.text = [NSString stringWithFormat:@"%ld人次竞拍",(unsigned long)(model.auctors.count?model.auctors.count:0)];
    self.browseCountLabel.text = [NSString stringWithFormat:@"浏览:%@",model.view_number?model.view_number:@"0"];
    self.jingpaiStatus.text = [NSString stringWithFormat:@" %@: ",model.opName];
    
    if ([model.opCode isEqualToString:@"0"] || [model.opCode isEqualToString:@"2"]) {
        [self setCountdownTime];
    }else{
        self.remainTimeLabel.text = @"00:00:00";
    }
    
}

-(void)jumpToPersonalPage{
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
//    newMyPage.currentTitle = userName;
    newMyPage.currentUid = self.model.publisher.uid;
    [self.superVC.navigationController pushViewController:newMyPage animated:YES];
}

#pragma mark 需要每个cell分别显示倒计时的方法
-(void)setCountdownTime{
    
    //设置倒计时总时长
    NSString *currentTimeStr = self.model.currentTimestamp;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[currentTimeStr floatValue]];
    NSTimeInterval currentInterVal = fabs([currentDate timeIntervalSinceNow]);
    
    NSString *endTimeStr = self.model.end_time;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTimeStr floatValue]];
    NSTimeInterval endInterVal = fabs([endDate timeIntervalSinceNow]);
    
    NSString *startTimeStr = self.model.start_time;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTimeStr floatValue]];
    NSTimeInterval startInterVal = fabs([startDate timeIntervalSinceNow]);
    
    int temp = 0;
    if ([self.model.opCode isEqualToString:@"0"]) {
        temp = endInterVal - currentInterVal;
    }else{
        temp = startInterVal - currentInterVal;
    }
    
    self.secondsCountDown = temp;//60秒倒计时
    //开始倒计时
    if (_countDownTimer) {
        [_countDownTimer invalidate];
    }
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    //设置倒计时显示的时间
    self.remainTimeLabel.text= [NSString stringWithFormat:@"%@", [CommonUtils formatDateInterval:temp type:1]];
    
}

-(void)timeFireMethod{
    //倒计时-1
    self.secondsCountDown--;//60秒倒计时
    //修改倒计时标签现实内容
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%@", [CommonUtils formatDateInterval:self.secondsCountDown type:1]];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        //再加一个界面刷新方法
    }
    
}

@end
