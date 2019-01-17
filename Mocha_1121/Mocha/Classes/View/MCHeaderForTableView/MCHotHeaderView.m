//
//  MCHotHeaderView.m
//  Mocha
//
//  Created by TanJian on 16/4/12.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCHotHeaderView.h"

#define kScale kDeviceWidth/375

@interface MCHotHeaderView ()

@property(nonatomic,assign)int secondsCountDown;
@property(nonatomic,strong)NSTimer *countDownTimer;

@end

@implementation MCHotHeaderView

-(instancetype)init{
    return [[NSBundle mainBundle] loadNibNamed:@"MCHotHeaderView" owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    
    //设置字体颜色，大小，线宽，阴影等
    [self.mokaJingpaiLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:40*kScale]];
    self.mokaJingpaiLabel.textColor = [UIColor whiteColor];
    self.mokaJingpaiLabel.adjustsFontSizeToFitWidth =YES;
    self.mokaJingpaiLabel.shadowColor = [UIColor lightGrayColor];
    self.mokaJingpaiLabel.shadowOffset =CGSizeMake(1.5,1.5);
    
    [self.jingpaiState setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13*kScale]];
    self.jingpaiState.textColor = [UIColor whiteColor];
    self.mokaJingpaiLabel.adjustsFontSizeToFitWidth =YES;
    self.jingpaiState.shadowColor = [UIColor lightGrayColor];
    self.jingpaiState.shadowOffset =CGSizeMake(1,1);
    
    [self.remainTimeLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15*kScale]];
    self.remainTimeLabel.textColor = [UIColor whiteColor];
    self.remainTimeLabel.adjustsFontSizeToFitWidth =YES;
    self.remainTimeLabel.shadowColor = [UIColor lightGrayColor];
    self.remainTimeLabel.shadowOffset =CGSizeMake(1,1);
    
    [self.jingpaiCountLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13*kScale]];
    self.jingpaiCountLabel.textColor = [UIColor blackColor];
    self.jingpaiCountLabel.backgroundColor = [UIColor colorForHex:kLikeRedColor];
    self.jingpaiCountLabel.adjustsFontSizeToFitWidth =YES;
//    self.jingpaiCountLabel.shadowColor = [UIColor lightGrayColor];
//    self.jingpaiCountLabel.shadowOffset =CGSizeMake(0.7,0.7);
    
}



-(void)setupUIWith:(NSDictionary *)dict withCount:(int)count withBannerImgUrl:(NSString *)url{
    MCHotJingpaiModel *model = [[MCHotJingpaiModel alloc]initWithDictionary:dict error:nil];
    self.model = model;
    
    NSLog(@"%@",dict);
    
    self.jingpaiState.text = model.info.opName;
    
    self.jingpaiCountLabel.text = [NSString stringWithFormat: @"  %@个竞拍进行中  ",model.info.auctionTotal];
    
    NSString *bannerUrl = [NSString stringWithFormat:@"%@%@",url,[CommonUtils imageStringWithWidth:self.imageView.width * 2 height:self.imageView.height * 2]];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",getSafeString(bannerUrl)]] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    NSString *opcode = model.info.opCode;
    if ([opcode isEqualToString:@"0"] || [opcode isEqualToString:@"2"]) {
        [self setCountdownTime];
    }else{
        self.remainTimeLabel.text = @"00:00:00";
    }
    
    
}

-(void)setCountdownTime{
    
    //设置倒计时总时长
    NSString *currentTimeStr = self.model.info.currentTimestamp;
    NSDate *currentDate = [NSDate dateWithTimeIntervalSince1970:[currentTimeStr floatValue]];
    NSTimeInterval currentInterVal = fabs([currentDate timeIntervalSinceNow]);
    
    NSString *endTimeStr = self.model.info.end_time;
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:[endTimeStr floatValue]];
    NSTimeInterval endInterVal = fabs([endDate timeIntervalSinceNow]);
    
    NSString *startTimeStr = self.model.info.start_time;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:[startTimeStr floatValue]];
    NSTimeInterval startInterVal = fabs([startDate timeIntervalSinceNow]);
    
    int temp = 0;
    if (currentInterVal<startInterVal) {
        temp = startInterVal - currentInterVal;
    }else{
        temp = endInterVal - currentInterVal;
    }
    
    
    self.secondsCountDown = temp;//60秒倒计时
    //开始倒计时
    if (_countDownTimer) {
        [_countDownTimer invalidate];
    }
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES]; //启动倒计时后会每秒钟调用一次方法 timeFireMethod
    //设置倒计时显示的时间
    self.remainTimeLabel.text= [NSString stringWithFormat:@"%@", [CommonUtils formatDateInterval:temp type:0]];
    
}


-(void)timeFireMethod{
    //倒计时-1
    self.secondsCountDown--;//60秒倒计时
    //修改倒计时标签现实内容
    self.remainTimeLabel.text = [NSString stringWithFormat:@"%@", [CommonUtils formatDateInterval:self.secondsCountDown type:0]];
    //当倒计时到0时，做需要的操作，比如验证码过期不能提交
    if(self.secondsCountDown==0){
        [self.countDownTimer invalidate];
        NSLog(@"计时结束");
    }
    
}

@end


