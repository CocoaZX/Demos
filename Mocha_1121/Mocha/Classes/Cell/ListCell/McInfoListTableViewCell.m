//
//  McMainTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-11-19.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

/*
 sectionSecondArray = @[@{@"imageName":@"",@"title":@"账户与安全",@"num":@"0"},
 @{@"imageName":@"",@"title":@"客户中心",@"num":@"0"},
 @{@"imageName":@"",@"title":@"设置信息",@"num":@"0"}];
 */


#import "McInfoListTableViewCell.h"

@implementation McInfoListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McInfoListTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [nameLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
        
        [numLabel setBackgroundColor:[UIColor colorForHex:kLikeRedColor]];
        [numLabel setTextColor:[UIColor colorForHex:kLikeWhiteColor]];
        [numLabel.layer setCornerRadius:10];
        [numLabel.layer setMasksToBounds:YES];
        
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

- (void)setNum:(NSString *)num
{
    [numLabel.layer setCornerRadius:10];
//    numLabel.frame = CGRectMake(kScreenWidth-100,15, 20, 20);

    [numLabel setText:num];
    [numLabel setHidden:NO];
}



- (void)setItemValueWithDict:(NSDictionary *)itemDict
{
    [iconImageView setImage:[UIImage imageNamed:[itemDict valueForKey:@"imageName"]]];
    [nameLabel setText:[itemDict valueForKey:@"title"]];
    NSString *num = [itemDict valueForKey:@"num"];
    if ([num integerValue] == 0) {
        [numLabel setHidden:YES];
    }
    else {
        [numLabel setHidden:NO];
        [numLabel setText:num];
//        numLabel.frame = CGRectMake(kScreenWidth-55, 15, numLabel.frame.size.width, numLabel.frame.size.height);
    }
}

- (void)setSystem
{
    [numLabel setText:@""];
    [numLabel setHidden:NO];
    [numLabel.layer setCornerRadius:5];
//    numLabel.frame = CGRectMake(kScreenWidth-55, 20, 10, 10);
}

- (void)setBangDingWithString:(NSString *)string
{
    self.bangDingLabel.hidden = NO;
    self.bangDingLabel.text = string;
    
}

@end
