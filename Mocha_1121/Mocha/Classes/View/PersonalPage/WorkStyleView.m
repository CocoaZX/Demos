//
//  WorkStyleView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "WorkStyleView.h"

@implementation WorkStyleView

- (void)setDataArray:(NSArray *)dataArray
{
    for (id button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    float line1 = 12;
    float line2 = 42;
    float line3 = 72;
    float line4 = 102;
    int currentX = 90;
    int space = 2;
    for (int i=0; i<dataArray.count; i++) {
        float theX = 0;
        float theY = line1;
        float theW = 60;
        float theH = 22;
        theX = currentX + (theW+space)*i;
        if (kScreenWidth==320) {
            if (i>2&&i<10) {
                theY = line2;
                theX = currentX+(theW+space)*(i-3);
            }else if (i>=10&&i<15)
            {
                theY = line3;
                theX = currentX+(theW+space)*(i-10);
                
            }else if (i>=15&&i<20)
            {
                theY = line4;
                theX = currentX+(theW+space)*(i-15);
                
            }else if (i>20)
            {
                theY = line4+30;
                theX = currentX+(theW+space)*(i-21);
                
            }
        }else
        {
            if (i>3&&i<12) {
                theY = line2;
                theX = currentX+(theW+space)*(i-4);
            }else if (i>=12&&i<18)
            {
                theY = line3;
                theX = currentX+(theW+space)*(i-12);
                
            }else if (i>=18&&i<24)
            {
                theY = line4;
                theX = currentX+(theW+space)*(i-18);
                
            }
        }
        CGRect frame = CGRectMake(theX, theY, theW, theH);
        UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *titleStr = [NSString stringWithFormat:@"%@",dataArray[i]];
        
        [labelButton setSelected:NO];
//        [labelButton setBackgroundImage:[UIImage imageNamed:@"inforButtonBack"] forState:UIControlStateNormal];
        [labelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [labelButton setTitle:titleStr forState:UIControlStateNormal];
        labelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [labelButton setFrame:frame];
        [labelButton setTag:i];
        
        
        [self addSubview:labelButton];
        
        
    }
    int count = (int)dataArray.count;
    float height = 0;
    if (kScreenWidth==320) {
        int scale = count/3;
        
        if (count%3==0) {
            height = 30+scale*30;
        }else
        {
            height = 50+scale*30;
            
        }
    }else
    {
        int scale = count/4;
        
        if (count%4==0) {
            height = 30+scale*30;
        }else
        {
            height = 50+scale*30;
            
        }
    }
    
    if(height < 45){
        height = 45;
    }
    self.selfHeight = height;
    

    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}
+ (WorkStyleView *)getWorkStyleView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"WorkStyleView" owner:self options:nil];
    WorkStyleView *view = array[0];
    return view;
}


@end
