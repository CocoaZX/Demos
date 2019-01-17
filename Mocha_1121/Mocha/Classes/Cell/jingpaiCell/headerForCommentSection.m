//
//  headerForCommentSection.m
//  Mocha
//
//  Created by TanJian on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "headerForCommentSection.h"

@implementation headerForCommentSection

-(instancetype)init{
    return [[NSBundle mainBundle]loadNibNamed:@"headerForCommentSection" owner:self options:nil].lastObject;
}

-(void)awakeFromNib{
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
}

@end
