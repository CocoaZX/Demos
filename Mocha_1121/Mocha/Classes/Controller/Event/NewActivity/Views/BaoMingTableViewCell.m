//
//  BaoMingTableViewCell.m
//  Mocha
//
//  Created by sun on 15/8/28.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BaoMingTableViewCell.h"

@implementation BaoMingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerImageView.layer.cornerRadius = 20;
    float nameWidth = [SQCStringUtils getTxtLength:self.nameLabel.text font:15 limit:200];
    self.nameLabel.frame = CGRectMake(67, 17, nameWidth+5, 31);
    float userTypeWidth = [SQCStringUtils getTxtLength:self.userType.text font:14 limit:200];
    self.userType.frame = CGRectMake(67+nameWidth+15, 23, userTypeWidth+5, 21);
    self.userType.layer.cornerRadius = 3;
    self.firstLine.frame = CGRectMake(0, 73, kScreenWidth, 0.5);
    self.secondLine.frame = CGRectMake(kScreenWidth/2, 74, 0.5, 42);
    self.thirdLine.frame = CGRectMake(0, 115, kScreenWidth, 0.5);
    self.confirmButton.frame = CGRectMake(0, 73, kScreenWidth/2, 43);
    self.refuseButton.frame = CGRectMake(kScreenWidth/2, 73, kScreenWidth/2, 43);
    if (self.confirmButton.hidden) {
        self.refuseButton.hidden = NO;
        self.refuseButton.frame = CGRectMake(0, 73, kScreenWidth, 43);
        [self.refuseButton setTitle:getSafeString(self.dataDiction[@"statusName"]) forState:UIControlStateNormal];
        
        [self.refuseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        NSString *status = [NSString stringWithFormat:@"%@",self.dataDiction[@"status"]];
        if ([status isEqualToString:@"1"]) {
            [self.refuseButton setBackgroundColor:RGB(157, 198, 83)];

        }else if([status isEqualToString:@"-1"])
        {
            [self.refuseButton setBackgroundColor:[UIColor lightGrayColor]];

        }
        [self.refuseButton setEnabled:NO];
    }
}

- (void)setDataWithDiction:(NSDictionary *)diction
{
    self.dataDiction = diction;
    
    NSString *headerUrl = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
    NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"nickname"]];
    NSString *userType = [NSString stringWithFormat:@"%@",diction[@"type"]];
    
    
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerUrl] placeholderImage:[UIImage imageNamed:@""]];
    self.nameLabel.text = nameString;
    self.userType.text = userType;
    
    NSString *status = [NSString stringWithFormat:@"%@",diction[@"status"]];
    if ([status isEqualToString:@"1"]) {
        self.firstLine.hidden = YES;
        self.secondLine.hidden = YES;
        self.thirdLine.hidden = YES;
        self.confirmButton.hidden = YES;
        self.refuseButton.hidden = YES;
    }else if ([status isEqualToString:@"-1"]) {
        self.firstLine.hidden = YES;
        self.secondLine.hidden = YES;
        self.thirdLine.hidden = YES;
        self.confirmButton.hidden = YES;
        self.refuseButton.hidden = YES;
    }else
    {
        self.firstLine.hidden = NO;
        self.secondLine.hidden = NO;
        self.thirdLine.hidden = NO;
        self.confirmButton.hidden = NO;
        self.refuseButton.hidden = NO;
    }
    
    
}

- (IBAction)confirmMethod:(id)sender {
    NSLog(@"confirmMethod");
    NSString *eventId = [NSString stringWithFormat:@"%@",self.dataDiction[@"eventid"]];
    NSString *puid = [NSString stringWithFormat:@"%@",self.dataDiction[@"uid"]];
    NSString *status = @"1";
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:eventId forKey:@"id"];
    [dict setValue:puid forKey:@"uid"];
    [dict setValue:status forKey:@"status"];
    NSDictionary *param = [AFParamFormat formatEventApperalParams:dict];
    [AFNetwork eventApperal:param success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self.supCon withText:data[@"msg"]];
            [self.supCon refreshView];

        }else
        {
            [LeafNotification showInController:self.supCon withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [LeafNotification showInController:self.supCon withText:@"当前网络不太顺畅哟"];
        
    }];
    
}


- (IBAction)refuseMethod:(id)sender {
    NSLog(@"refuseMethod");
    NSString *eventId = [NSString stringWithFormat:@"%@",self.dataDiction[@"eventid"]];
    NSString *puid = [NSString stringWithFormat:@"%@",self.dataDiction[@"uid"]];
    NSString *status = @"-1";
    
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:eventId forKey:@"id"];
    [dict setValue:puid forKey:@"uid"];
    [dict setValue:status forKey:@"status"];
    NSDictionary *param = [AFParamFormat formatEventApperalParams:dict];
    [AFNetwork eventApperal:param success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            [LeafNotification showInController:self.supCon withText:data[@"msg"]];
            [self.supCon refreshView];

            
        }else
        {
            [LeafNotification showInController:self.supCon withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [LeafNotification showInController:self.supCon withText:@"当前网络不太顺畅哟"];
        
    }];
    
}





+ (BaoMingTableViewCell *)getBaoMingTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BaoMingTableViewCell" owner:self options:nil];
    BaoMingTableViewCell *cell = array[0];
    
    return cell;
    
}




@end
