//
//  McImageCollectionViewCell.m
//  Mocha
//
//  Created by renningning on 14-12-10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McImageCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

#define leftX 0
#define rightX 0
#define topY 0
#define labelBgheight 40

@interface McImageCollectionViewCell()
{
    UIImageView *imageView;
    UILabel *nameLabel;
    UILabel *timeLabel;
}
@end

@implementation McImageCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self _init];
    }
    return self;
}

- (void)_init
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(leftX, topY, CGRectGetWidth(self.contentView.frame) - leftX - rightX , CGRectGetWidth(self.contentView.frame) - leftX - rightX + labelBgheight)];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView.layer setCornerRadius:8.0];
    [bgView.layer setMasksToBounds:YES];
    [self.contentView addSubview:bgView];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgView.frame), CGRectGetWidth(bgView.frame))];
    [imageView setBackgroundColor:[UIColor clearColor]];
    [bgView addSubview:imageView];

    
    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame) /2, labelBgheight)];
    nameLabel.textAlignment = kTextAlignmentLeft_SC;
    nameLabel.font = kFont14;
    nameLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    [bgView addSubview:nameLabel];
    
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(imageView.frame)/2+5, CGRectGetMaxY(imageView.frame), CGRectGetWidth(imageView.frame) /2 - 10, 40)];
    timeLabel.textAlignment = kTextAlignmentRight_SC;
    timeLabel.font = kFont11;
    timeLabel.textColor = [UIColor colorForHex:kLikeLightGrayColor];
    [bgView addSubview:timeLabel];
    
    CGRect contentFrame = self.contentView.frame;
    contentFrame.size.height = CGRectGetMaxY(bgView.frame);
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    
}

- (CGSize)cellHeight
{
    return CGSizeMake((kDeviceWidth - 30)/2,(kDeviceWidth - 30)/2 + 40);
}

- (void)setCollectionViewCellWithValue:(NSDictionary *)dict
{
//    NSLog(@"dict:%@",dict);//createline
    [self _init];
    nameLabel.text = dict[@"nickname"];
    NSInteger wid = CGRectGetWidth(imageView.frame) * 2;
    NSInteger hei = CGRectGetHeight(imageView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
    NSString *url = [NSString stringWithFormat:@"%@%@",dict[@"url"],jpg];
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    timeLabel.text = [CommonUtils dateTimeIntervalString:dict[@"createline"]];
}

@end
