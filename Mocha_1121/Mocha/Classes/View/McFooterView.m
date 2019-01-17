//
//  McFooterView.m
//  Mocha
//
//  Created by renningning on 14-12-10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McFooterView.h"

@interface McFooterButton()

@property (nonatomic, assign) CGFloat imageX;
@property (nonatomic, assign) CGFloat titleX;

@end

@implementation McFooterButton

- (CGRect )titleRectForContentRect:(CGRect)contentRect{
    CGFloat width       = contentRect.size.width;
    
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize size = CGSizeZero;
    
    if (title) {
        UIFont *font = kFont13;//
        if (IsOSVersionAtLeastiOS7() >= 7.0) {
            NSDictionary *attribute = @{NSFontAttributeName: font};
            size = [title boundingRectWithSize:CGSizeMake(contentRect.size.width, contentRect.size.height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
        }else{
            size = [title sizeWithFont:font
                     constrainedToSize:CGSizeMake(contentRect.size.width, contentRect.size.height)
                         lineBreakMode:NSLineBreakByWordWrapping];
        }
    }
    width = size.width;
    CGRect rect = CGRectMake(_titleX, 0, width,  contentRect.size.height);
    return rect;
}

- (CGRect )imageRectForContentRect:(CGRect)contentRect{
    
    UIImage *image =  [self imageForState:UIControlStateNormal];
    CGFloat imageWidth  = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    _imageX = (contentRect.size.width-imageWidth)/4;
    CGFloat h = (contentRect.size.height-imageHeight)/2;
    _titleX = _imageX + imageWidth;
    
    CGRect rect = CGRectMake(_imageX, h, imageWidth, imageHeight);
    
    return rect;
}

@end

@implementation McFooterView


- (id)initWithFrame:(CGRect)frame buttonTitles:(NSArray *)titleArray buttonImages:(NSArray *)imageArray
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        _backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:_backgroundView];
        
        self.labels = [NSMutableArray arrayWithCapacity:[imageArray count]];
        self.buttons = [NSMutableArray arrayWithCapacity:[imageArray count]];
        self.signNums = [NSMutableArray arrayWithCapacity:[imageArray count]];
        McFooterButton *btn;
        UILabel *lab;
        CGFloat width = kDeviceWidth / [imageArray count];
        for (int i = 0; i < [imageArray count]; i++)
        {
            lab = [[UILabel alloc] init];
            [lab setBackgroundColor:[UIColor clearColor]];
            lab.textColor = [UIColor colorForHex:kLikeWhiteColor];
            lab.font = kFont13;
            lab.textAlignment = kTextAlignmentLeft_SC;
            [self.labels addObject:lab];
            [self addSubview:lab];
            
            btn = [McFooterButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(width * i, 0, width, frame.size.height);
            
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Default"] forState:UIControlStateNormal];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
            [btn setImage:[[imageArray objectAtIndex:i] objectForKey:@"Seleted"] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(footerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [btn setTitle:[titleArray objectAtIndex:i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorForHex:kLikeWhiteColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateHighlighted];
            [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateSelected];
            [btn.titleLabel setFont:kFont13];
            [btn.titleLabel setTextAlignment:kTextAlignmentLeft_SC];
            
            BOOL isAppearShang = UserDefaultGetBool(ConfigShang);
            if (isAppearShang) {
                
                btn.showsTouchWhenHighlighted = YES;
                
            }else
            {
                
                btn.showsTouchWhenHighlighted = NO;
                
            }
            btn.tag = i;
            
            CGRect titleRect = [btn titleRectForContentRect:btn.frame];
            NSLog(@"%f",CGRectGetMaxX(titleRect));
            if (btn.showsTouchWhenHighlighted) {
                [lab setFrame:CGRectMake(width * i + CGRectGetMaxX(titleRect), 0, width, frame.size.height)];
                
            }else
            {
                if (i==0) {
                    [lab setFrame:CGRectMake(width * i + 66, 0, width, frame.size.height)];
                    
                }else
                {
                    [lab setFrame:CGRectMake(width * i + 80, 0, width, frame.size.height)];
                    
                }
                
            }
            
            [self.buttons addObject:btn];
            [self addSubview:btn];
            
            [self.signNums addObject:@"0"];
        }
        
    }
    return self;
}

- (void)setBackgroundImage:(UIImage *)img color:(UIColor *)color
{
    if (img) {
        [_backgroundView setImage:img];
    }
    else{
        [_backgroundView setBackgroundColor:color];
    }
    
}

- (void)footerButtonClicked:(id)sender
{
    UIButton *btn = sender;
    if (btn.selected) {
        [self disSelectFooterAtIndex:btn.tag];
    }
    else{
        [self selectFooterAtIndex:btn.tag];
    }
}

- (void)selectFooterAtIndex:(NSInteger)index
{
    UIButton *btn = [self.buttons objectAtIndex:index];
    //    btn.selected = YES;
    if ([_delegate respondsToSelector:@selector(footerView:didSelectIndex:)])
    {
        [_delegate footerView:self didSelectIndex:btn.tag];
    }
}

- (void)disSelectFooterAtIndex:(NSInteger)index
{
    if (self.buttons.count>index) {
        UIButton *btn = [self.buttons objectAtIndex:index];
        //    btn.selected = NO;
        if ([_delegate respondsToSelector:@selector(footerView:didSelectIndex:)])
        {
            [_delegate footerView:self didNotSelectIndex:btn.tag];
        }
    }
    
}

- (void)removeFooterAtIndex:(NSInteger)index
{
    // Remove button
    [(UIButton *)[self.buttons objectAtIndex:index] removeFromSuperview];
    [self.buttons removeObjectAtIndex:index];
    
    // Re-index the buttons
    CGFloat width = kDeviceWidth / [self.buttons count];
    for (UIButton *btn in self.buttons)
    {
        if (btn.tag > index)
        {
            btn.tag --;
        }
        btn.frame = CGRectMake(width * btn.tag, 0, width, self.frame.size.height);
    }
}

- (void)insertFooterWithImageDic:(NSDictionary *)dict atIndex:(NSUInteger)index
{
    CGFloat width = kDeviceWidth / ([self.buttons count] + 1);
    for (UIButton *b in self.buttons)
    {
        if (b.tag >= index)
        {
            b.tag ++;
        }
        b.frame = CGRectMake(width * b.tag, 0, width, self.frame.size.height);
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.showsTouchWhenHighlighted = YES;
    btn.tag = index;
    btn.frame = CGRectMake(width * index, 0, width, self.frame.size.height);
    [btn setImage:[dict objectForKey:@"Default"] forState:UIControlStateNormal];
    [btn setImage:[dict objectForKey:@"Highlighted"] forState:UIControlStateHighlighted];
    [btn setImage:[dict objectForKey:@"Seleted"] forState:UIControlStateSelected];
    [btn addTarget:self action:@selector(footerButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttons insertObject:btn atIndex:index];
    [self addSubview:btn];
}

- (NSInteger)getCurrentNumAtIndex:(NSInteger)index
{
    NSString *numStr = [_signNums objectAtIndex:index];
    return [numStr integerValue];
}

- (void)setNumsAtLabels:(NSArray *)numArray
{
    NSUInteger i = 0;
    for (UILabel *label in _labels) {
        NSNumber * num = [numArray objectAtIndex:i++];
        if ([num integerValue] > 0) {
            label.text = [NSString stringWithFormat:@"(%@)",num];
        }
        label.text = @"(0)";
        
    }
}

- (void)setNum:(NSString *)numstring atIndex:(NSInteger)index
{
    float num = [numstring floatValue];
    UILabel *label = [_labels objectAtIndex:index];
    if (num > 0) {
        if (index==2) {

            label.text = [NSString stringWithFormat:@"(%.f)",num];
            
        }else
        {
            label.text = [NSString stringWithFormat:@"(%.f)",num];
            
        }
        [_signNums replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%.f",num]];
    }
    else{
        label.text = @"(0)";
        [_signNums replaceObjectAtIndex:index withObject:@"0"];
    }
    
}

- (void)addNumAtIndex:(NSInteger)index
{
    UILabel *label = [_labels objectAtIndex:index];
    NSString *num = [_signNums objectAtIndex:index];
    label.text = [NSString stringWithFormat:@"(%@)",[NSNumber numberWithInteger:[num integerValue] + 1]];
    [_signNums replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[num integerValue] + 1]]];
}

- (void)minusNumAtIndex:(NSInteger)index
{
    UILabel *label = [_labels objectAtIndex:index];
    NSString *num = [NSString stringWithFormat:@"%@",[_signNums objectAtIndex:index]];
    
    label.text = [NSString stringWithFormat:@"(%@)",[NSNumber numberWithInteger:[num intValue] - 1]];
    
    [_signNums replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:[num integerValue] - 1]]];
    
    if (([num intValue] - 1)<0) {
        label.text = @"(0)";
        [_signNums replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@",[NSNumber numberWithInteger:0]]];
        
    }
}

- (void)setStatus:(BOOL)status atIndex:(NSInteger)index
{
    UIButton *btn = [self.buttons objectAtIndex:index];
    btn.selected = status;
    UILabel *label = [_labels objectAtIndex:index];
    if (status) {
        label.textColor = [UIColor colorForHex:kLikeRedColor];
        
    }else
    {
        label.textColor = [UIColor colorForHex:kLikeWhiteColor];
        
    }
    
}

- (void)setHidden:(BOOL)hidden atIndex:(NSInteger)index
{
    UIButton *btn = [self.buttons objectAtIndex:index];
    UILabel *label = [_labels objectAtIndex:index];
    [btn setHidden:hidden];
    [label setHidden:hidden];
}

@end
