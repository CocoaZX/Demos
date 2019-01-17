//
//  PersonInforView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PersonInforView.h"

@implementation PersonInforView


- (void)setDataArray:(NSArray *)dataArray
{
    for (id button in self.subviews) {
        if ([button isKindOfClass:[UIButton class]]) {
            [button removeFromSuperview];
        }
    }
    
    float line1 = 37;
    float line2 = 67;
    float line3 = 97;
    float line4 = 127;
    
    int currentX = 20;
    if (self.workStyleView.hidden==NO) {
        currentX = 25;
    }
    for (int i=0; i<dataArray.count; i++) {
        NSString *titleStr = [NSString stringWithFormat:@"%@",dataArray[i]];
        
        float theX = 0;
        float theY = line1;
        
        float theW = [SQCStringUtils getTxtLength:titleStr font:13 limit:120]+20;
//        NSLog(@"%f:%@",theW,titleStr);
        if (theW < 80) {
            theW = 80;
        }
        
        if (self.workStyleView.hidden==NO) {
            theW = 70;
        }
        float theH = 22;
        theX = currentX + (theW+10)*i;
        
        
        if (self.workStyleView.hidden==NO) {
            NSLog(@"%@",titleStr);
            if (kScreenWidth==320) {
                if (i>2&&i<=5) {
                    theY = line2;
                    theX = currentX+(theW+10)*(i-3);
                }else if (i>5&&i<=8)
                {
                    theY = line3;
                    theX = currentX+(theW+10)*(i-6);
                    
                }else if (i>8&&i<=11)
                {
                    theY = line4;
                    theX = currentX+(theW+10)*(i-9);
                    
                }else if (i>11)
                {
                    theY = line4+30;
                    theX = currentX+(theW+10)*(i-12);
                    
                }
            }else
            {
                if (i>3&&i<8) {
                    theY = line2;
                    theX = currentX-2+(theW+10)*(i-4);
                }else if (i>=8&&i<12)
                {
                    theY = line3;
                    theX = currentX-2+(theW+10)*(i-8);
                    
                }else if (i>=12&&i<16)
                {
                    theY = line4;
                    theX = currentX-2+(theW+10)*(i-12);
                    
                }
            }

        }else
        {
            if (kScreenWidth==320) {
                if (i>2&&i<6) {
                    theY = line2;
                    theX = currentX+(theW+10)*(i-3);
                }else if (i>=6&&i<9)
                {
                    theY = line3;
                    theX = currentX+(theW+10)*(i-6);
                    
                }else if (i>=9&&i<12)
                {
                    theY = line4;
                    theX = currentX+(theW+10)*(i-9);
                    
                }else if (i>=12)
                {
                    theY = line4+30;
                    theX = currentX+(theW+10)*(i-12);
                    
                }
            }else
            {
                if (i>3&&i<8) {
                    theY = line2;
                    theX = currentX-2+(theW+10)*(i-4);
                }else if (i>=8&&i<12)
                {
                    theY = line3;
                    theX = currentX-2+(theW+10)*(i-8);
                    
                }else if (i>=12&&i<16)
                {
                    theY = line4;
                    theX = currentX-2+(theW+10)*(i-12);
                    
                }
            }
        }
        
        CGRect frame = CGRectMake(theX, theY, theW, theH);
        UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [labelButton setSelected:NO];
        [labelButton setBackgroundImage:[UIImage imageNamed:@"inforButtonBack"] forState:UIControlStateNormal];
        if (self.workStyleView.hidden==NO) {
            [labelButton setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
            [labelButton setTag:i];
        }
        else {
            [labelButton addTarget:self action:@selector(doEditInfo:) forControlEvents:UIControlEventTouchUpInside];
            [labelButton setTag:[_infoStatusArr[i] integerValue]];
        }
        [labelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [labelButton setTitle:titleStr forState:UIControlStateNormal];
        labelButton.titleLabel.font = [UIFont systemFontOfSize:12];
        [labelButton setFrame:frame];
        
        
        
        [self addSubview:labelButton];

        
    }
    int count = (int)dataArray.count;
    float height = 0;
    if (kScreenWidth==320) {
        if (count%3==0) {
            height = 40+count/3*30;
        }else
        {
            height = 70+count/3*30;
            
        }
    }else
    {
        if (count%4==0) {
            height = 40+count/4*30;
        }else
        {
            height = 70+count/4*30;
            
        }
    }
    
    if (height < 45) {
        height = 45;
    }
    self.selfHeight = height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}



+ (PersonInforView *)getPersonInforView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PersonInforView" owner:self options:nil];
    PersonInforView *view = array[0];
    return view;
}

- (void)doEditInfo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedInfo:infoStatus:)]) {
        [self.delegate didSelectedInfo:[btn titleForState:UIControlStateNormal] infoStatus:btn.tag];
    }
}

@end
