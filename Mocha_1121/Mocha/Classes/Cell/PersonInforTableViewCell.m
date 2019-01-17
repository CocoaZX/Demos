//
//  PersonInforTableViewCell.m
//  Mocha
//
//  Created by XIANPP on 16/2/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "PersonInforTableViewCell.h"
#import "NewMyPageViewController.h"

@interface PersonInforTableViewCell ()
{
    NSString *uidStr;

}
@end

@implementation PersonInforTableViewCell

- (void)awakeFromNib {
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 40
    ;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+(PersonInforTableViewCell *)getPersonInforTableViewCell{
    PersonInforTableViewCell * cell = [[NSBundle mainBundle] loadNibNamed:@"PersonInforTableViewCell" owner:self options:nil].lastObject;
    return cell;
}

-(void)initWithDictionary:(NSDictionary *)dictionary{
    //调整分割线和name显示
    _fengeLineLabel.backgroundColor = [CommonUtils colorFromHexString:kLikeWhiteColor];
    
    //设置头像
    NSString *urlStr = [NSString stringWithFormat:@"%@%@",dictionary[@"headerURL"],[CommonUtils imageStringWithWidth:kDeviceWidth height:kDeviceWidth]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
//    NSLog(@"%@",urlStr);
    //设置昵称
     self.nameLabel.text = getSafeString(dictionary[@"nickname"]);

    //获取id
    uidStr = getSafeString(dictionary[@"uid"]);
    
}



- (IBAction)jumpToNewMyPage:(id)sender {
    if (self.supCon) {
        
        NewMyPageViewController *newMypage = [[NewMyPageViewController alloc]init];
        newMypage.currentUid = uidStr.copy;
        [self.supCon.navigationController pushViewController:newMypage animated:YES];
    }

}

@end
