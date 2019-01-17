//
//  AlbumTableViewCell.h
//  Mocha
//
//  Created by sunqichao on 15/9/7.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *imgView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *imageNum;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (strong, nonatomic) NSDictionary *dataDic;

- (void)initWithDiction:(NSDictionary *)diction;

+ (AlbumTableViewCell *)getAlbumTableViewCell;

@end
