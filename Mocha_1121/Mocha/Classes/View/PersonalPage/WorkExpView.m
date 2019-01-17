//
//  WorkExpView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "WorkExpView.h"

@implementation WorkExpView


- (void)setWorkExpString:(NSString *)content
{
    float height = [SQCStringUtils getStringHeight:content width:kScreenWidth-90 font:13];
    self.contentTextView.text = content;
    self.contentTextView.frame = CGRectMake(22, 25, kScreenWidth-40, height+30);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, kScreenWidth, height+60);
    if (content.length==0) {
        self.selfHeight = height+30;

    }else
    {
        self.selfHeight = height+50;

    }

}




+ (WorkExpView *)getWorkExpView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WorkExpView" owner:self options:nil];
    WorkExpView *view = array[0];
    return view;
}



@end
