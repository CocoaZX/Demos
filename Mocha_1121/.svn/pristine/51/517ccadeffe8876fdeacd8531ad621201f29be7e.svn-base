//
//  AlbumTableViewCell.m
//  Mocha
//
//  Created by sunqichao on 15/9/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

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
    self.nameLabel.frame = CGRectMake(165, 45, kScreenWidth-200, 21);
    self.rightArrow.frame = CGRectMake(kScreenWidth-30, 58, 30, 30);
    self.imageNum.frame = CGRectMake(165, 74, kScreenWidth-200, 21);

}

- (void)initWithDiction:(NSDictionary *)diction
{
    self.dataDic = diction;
    NSString *nameString = [NSString stringWithFormat:@"%@",diction[@"title"]];
    NSString *numString = [NSString stringWithFormat:@"%@作品",diction[@"numPhotoes"]];

    NSString *urlString = @"";
    NSDictionary *dic = diction;

    NSString *cover = [NSString stringWithFormat:@"%@",dic[@"cover"]];
    if ([cover isEqualToString:@"0"]) {
        
    }else
    {
        NSArray *photos = dic[@"photos"];
        for (int i=0; i<photos.count; i++) {
            NSDictionary *diction = photos[i];
            NSString *photoid = [NSString stringWithFormat:@"%@",diction[@"photoId"]];
            if ([cover isEqualToString:photoid]) {
                urlString = [NSString stringWithFormat:@"%@",diction[@"url"]];
            }
        }
    }
    self.nameLabel.text = nameString;
    self.imageNum.text = numString;
    urlString = [NSString stringWithFormat:@"%@@1e_300w_150h_1c_0i_1o_80Q_1x.jpg",urlString];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@""]];
    
    
}



+ (AlbumTableViewCell *)getAlbumTableViewCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AlbumTableViewCell" owner:self options:nil];
    AlbumTableViewCell *cell = array[0];
    return cell;
    
}

 
@end
