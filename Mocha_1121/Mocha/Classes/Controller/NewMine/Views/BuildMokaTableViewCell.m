//
//  BuildMokaTableViewCell.m
//  Mocha
//
//  Created by sun on 15/9/1.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "BuildMokaTableViewCell.h"

@implementation BuildMokaTableViewCell

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
    
    self.titleLabel.frame = CGRectMake(10, self.backgroundImage.frame.origin.y+ self.backgroundImage.frame.size.height, kScreenWidth-20, 30);
    self.grayView.frame = CGRectMake(0, self.titleLabel.bottom, kDeviceWidth, 15);
    self.grayView.alpha = 0.3;
}

- (void)initViewWithData:(NSDictionary *)diction
{
    self.titleLabel.text = diction[@"name"];
    self.backgroundImage.image= [UIImage imageNamed:diction[@"image"]];
    
}


+ (BuildMokaTableViewCell *)getBuildMokaTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BuildMokaTableViewCell" owner:self options:nil];
    BuildMokaTableViewCell *cell = array[0];
    return cell;
    
}



+ (BuildMokaTableViewCell *)getBuildMokaTableViewCellWith:(NSIndexPath *)indexPath
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"BuildMokaTableViewCell" owner:self options:nil];
    BuildMokaTableViewCell *cell = array[0];
    if (indexPath.row == 9) {
        cell.grayView.hidden = YES;
    }else{
        cell.grayView.hidden = NO;
    }
    return cell;
    
}









@end
