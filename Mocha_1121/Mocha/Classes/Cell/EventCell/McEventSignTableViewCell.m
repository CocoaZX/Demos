//
//  McEventSignTableViewCell.m
//  Mocha
//
//  Created by renningning on 15-4-7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McEventSignTableViewCell.h"
#import "ReadPlistFile.h"

@interface McEventSignTableViewCell()
{
    IBOutlet UIImageView *headImageView;
    IBOutlet UILabel *nikeNameLabel;
    IBOutlet UILabel *infoLabel;
    IBOutlet UIButton *agreeBtn;
    IBOutlet UIButton *reBtn;
    
    NSArray *allAreaInfoArray;
    
    NSInteger status;
}

@property (nonatomic, retain) NSDictionary *itemDict;

@end

@implementation McEventSignTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McEventSignTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor whiteColor]];
        status = 0;
        allAreaInfoArray = [ReadPlistFile readAreaArray];
        [self initSubViews];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initSubViews
{
    headImageView.layer.cornerRadius = 8.0;
    headImageView.layer.masksToBounds = YES;
    nikeNameLabel.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    infoLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    agreeBtn.layer.cornerRadius = CGRectGetHeight(agreeBtn.frame)/2;
}

- (IBAction)doAgreeUserSignUp:(id)sender
{
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:nil message:@"接受后不能再取消，请认真选择" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSDictionary *param = [AFParamFormat formatEventSignPassParams:_itemDict[@"eventid"] uid:_itemDict[@"uid"]];
        [AFNetwork eventSignPass:param success:^(id data){
            if ([data[@"status"] integerValue] == kRight) {
                status = 1;
                agreeBtn.enabled = NO;
                [agreeBtn setTitle:@"已通过" forState:UIControlStateNormal];
                [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [agreeBtn setBackgroundColor:[UIColor colorForHex:kLikeLightGrayColor]];
                
                if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                    [self.cellDelegate actionDone:@"操作成功" isReload:YES];
                }
            }
            else{
                status = 0;
                if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(actionDone:isReload:)]) {
                    [self.cellDelegate actionDone:data[@"msg"] isReload:NO];
                }
            }
        }failed:^(NSError *error){
            
        }];
    }
}

//status:0未处理 1接受 2拒绝  signuptime

- (void)setItemValueWithDict:(NSDictionary *)itemDict
{
    self.itemDict = itemDict;
    
    NSString *iconUrl = itemDict[@"user"][@"head_pic"];
    NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
    NSString *url = [NSString stringWithFormat:@"%@%@",iconUrl,jpg];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head.png"]];
    nikeNameLabel.text = itemDict[@"user"][@"nickname"];
    
    NSString *provinceId = itemDict[@"user"][@"province"];
    NSString *cityId = itemDict[@"user"][@"city"];
    NSString *province = @"";
    NSString *city = @"";
    for (NSDictionary *dicts in allAreaInfoArray) {
        if ([dicts[@"id"] integerValue] == [provinceId integerValue]) {
            province = dicts[@"name"];
            NSArray *citys = dicts[@"citys"];
            for (NSDictionary *cityDict in citys) {
                if ([cityDict[@"id"] integerValue] == [cityId integerValue]) {
                    city = cityDict[@"name"];
                }
            }
        }
    }
    
    
    infoLabel.text = [NSString stringWithFormat:@"%@%@",province,city];

    NSString *statusStr = itemDict[@"status"];
    
    status = [statusStr integerValue];
    if (status == 0) {
        agreeBtn.enabled = YES;
        [agreeBtn setTitle:@"接受" forState:UIControlStateNormal];
        [agreeBtn setBackgroundColor:[UIColor clearColor]];
        [agreeBtn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];
        agreeBtn.layer.borderColor = [UIColor colorForHex:kLikeRedColor].CGColor;
        agreeBtn.layer.borderWidth = 1.0;
    }
    else if(status == 1){
        agreeBtn.enabled = NO;
        [agreeBtn setTitle:@"已通过" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn setBackgroundColor:[UIColor colorForHex:kLikeLightGrayColor]];
    }
    else if(status == 2){
        agreeBtn.enabled = NO;
        [agreeBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
        [agreeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [agreeBtn setBackgroundColor:[UIColor colorForHex:kLikeLightGrayColor]];
    }
}

@end
