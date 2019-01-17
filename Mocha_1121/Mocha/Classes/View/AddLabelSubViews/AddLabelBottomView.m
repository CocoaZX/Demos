//
//  AddLabelBottomView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "AddLabelBottomView.h"

@implementation AddLabelBottomView

- (void)addLabelArray:(NSArray *)array
{
    for (int i=0; i<self.buttonArray.count; i++) {
        UIButton *button = self.buttonArray[i];
        [button removeFromSuperview];
    }
    [self.buttonArray removeAllObjects];
    [self.addNewLabelButton removeFromSuperview];
    self.addNewLabelButton = nil;
    
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton addTarget:self action:@selector(addNewLabel:) forControlEvents:UIControlEventTouchUpInside];
    [newButton setBackgroundImage:[UIImage imageNamed:@"addNewLabel"] forState:UIControlStateNormal];
    self.addNewLabelButton = nil;
    
    self.allLabelArray = array.mutableCopy;
    [self.allLabelArray addObject:@""];
    float line1 = 62;
    float line2 = 90;
    float line3 = 120;
    int currentX = 103;
    for (int i=0; i<self.allLabelArray.count; i++) {
        float theX = 0;
        float theY = line1;
        float theW = 60;
        float theH = 22;
        theX = currentX + (theW+10)*i;
        if (kScreenWidth==320) {
            if (i>2&&i<=6) {
                theY = line2;
                theX = 20+(theW+10)*(i-3);
            }else if (i>6)
            {
                theY = line3;
                theX = 20+(theW+10)*(i-7);
                
            }
        }else
        {
            if (i>3&&i<=8) {
                theY = line2;
                theX = 18+(theW+10)*(i-4);
            }else if (i>8)
            {
                theY = line3;
                theX = 18+(theW+10)*(i-9);
                
            }
        }
        CGRect frame = CGRectMake(theX, theY, theW, theH);
        UIButton *labelButton = [UIButton buttonWithType:UIButtonTypeCustom];

        if (i!=(self.allLabelArray.count-1)) {
            [labelButton addTarget:self action:@selector(selectLabel:) forControlEvents:UIControlEventTouchUpInside];
            [labelButton setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
            [labelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [labelButton setTitle:self.allLabelArray[i] forState:UIControlStateNormal];
            labelButton.titleLabel.font = [UIFont systemFontOfSize:12];
            [labelButton setFrame:frame];
            [labelButton setTag:i];
        }

        int maxcount = 11;
        if (kScreenWidth==320) {
            maxcount = 11;
        }else
        {
            maxcount = 13;
        }
        if (i<maxcount) {
            [self addSubview:labelButton];
            [self.buttonArray addObject:labelButton];
        }
        
        [self.addNewLabelButton setFrame:CGRectMake(theX, theY, 75, theH)];
        [self addSubview:self.addNewLabelButton];

    }
}

- (void)selectLabel:(id)sender
{
    UIButton *button = (UIButton *)sender;
    if (button.titleLabel.textColor == [UIColor lightGrayColor]) {
        [button setBackgroundImage:[UIImage imageNamed:@"labelBack"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:237/255.0f green:59/255.0f blue:78/255.0f alpha:1.0] forState:UIControlStateNormal];
        NSString *titleStr = self.allLabelArray[button.tag];
        if (![self isInTheArrayWithTitle:titleStr]) {
            [self.selectLabelArray addObject:titleStr];

        }

    }else
    {
        [button setBackgroundImage:[UIImage imageNamed:@"addLabelBack"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        NSString *titleStr = self.allLabelArray[button.tag];
        if ([self isInTheArrayWithTitle:titleStr]) {
            [self.selectLabelArray removeObject:titleStr];
            
        }
    }
   
}

- (BOOL)isInTheArrayWithTitle:(NSString *)titleStr
{
    BOOL isInArray = NO;
    for (int i=0; i<self.selectLabelArray.count; i++) {
        NSString *title = self.selectLabelArray[i];
        if ([titleStr isEqualToString:title]) {
            isInArray = YES;
        }
    }
    return isInArray;
}

- (void)addNewLabel:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddNewLabel" object:nil];
    
}

+ (AddLabelBottomView *)getBottomView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AddLabelBottomView" owner:self options:nil];
    AddLabelBottomView *view = array[0];
    view.allLabelArray = @[].mutableCopy;
    view.selectLabelArray = @[].mutableCopy;
    view.buttonArray = @[].mutableCopy;
    return view;
}

@end
