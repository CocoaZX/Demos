//
//  McBottomView.m
//  Mocha
//
//  Created by renningning on 15-4-9.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "McBottomView.h"

@interface McButton()

@property (nonatomic, assign) CGFloat imageX;
@property (nonatomic, assign) CGFloat titleX;

@end

@implementation McButton

- (CGRect )titleRectForContentRect:(CGRect)contentRect{
    CGFloat width       = contentRect.size.width;
    
    NSString *title = [self titleForState:UIControlStateNormal];
    CGSize size = CGSizeZero;
    
    if (title) {
        UIFont *font = kFont15;//
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


@implementation McBottomBarItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame Image:(NSString *)image title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
//        [_iconImageview setImage:[UIImage imageNamed:image]];
        [_clickButton setTitle:title forState:UIControlStateNormal];
        [_clickButton setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    return self;
}

- (void)initSubViews
{
    float width = CGRectGetWidth(self.frame);
    float height = CGRectGetHeight(self.frame);
    
//    _iconImageview = [[UIImageView alloc] init];
//    [self addSubview:_iconImageview];
    
    _infoLabel = [[UILabel alloc] init];
    _infoLabel.font = kFont15;
    _infoLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    [self addSubview:_infoLabel];
    
    _clickButton = [McButton buttonWithType:UIButtonTypeCustom];
    _clickButton.titleLabel.font = kFont15;
    [_clickButton setTitleColor:[UIColor colorForHex:kLikeGrayColor] forState:UIControlStateNormal];
    [self addSubview:_clickButton];
    
//    _iconImageview.frame = CGRectMake(width/4-10, (height - 20)/2, 20, 20);
    
    float oX = 5;
    if (width > 320) {
        oX = 10;
    }
    
    _infoLabel.frame = CGRectMake(width/3 *2, (height - 20)/2, width/3, 20);
    
    
    _clickButton.frame = CGRectMake(oX, 0, width/3 *2, height);
    
    
}

- (void)clickAddTarget:(id)target action:(SEL)action
{
    [_clickButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}



@end

@interface  McBottomView()
{
    NSInteger itemCount;
}

@end

@implementation McBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _buttonItems = [NSArray array];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setItems:(NSArray *)items
{
    self.buttonItems = items;
    itemCount = [items count];
    float width = CGRectGetWidth(self.frame)/itemCount;
    float height = CGRectGetHeight(self.frame);
    for (int i = 0; i < [items count]; i++) {
        McBottomBarItem *itemBar = items[i];
        itemBar.frame = CGRectMake(width * i, 0, width, height);
        if (i> 0 && i < [items count]) {
            UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 2, 0.5, height-5)];
            [lineImageView setBackgroundColor:[UIColor colorForHex:kLikeLineColor]];
            [self addSubview:lineImageView];
        }

        [self addSubview:itemBar];
    }
}

- (void)setImage:(NSString *)str index:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
//    itemBar.iconImageview.image = [UIImage imageNamed:str];
    [itemBar.clickButton setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title index:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
    [itemBar.clickButton setTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color index:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
    [itemBar.clickButton setTitleColor:color forState:UIControlStateNormal];
}

- (void)setItemBackgroundColor:(UIColor *)color index:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
    [itemBar setBackgroundColor:color];
}

- (void)setLabel:(NSString *)string index:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
    [itemBar.infoLabel setText:string];
}

- (void)setAllLabel:(BOOL)hidden
{
    for (McBottomBarItem *item in _buttonItems) {
        [item.infoLabel setHidden:hidden];
        if (hidden) {
            float width = CGRectGetWidth(self.frame)/itemCount;
            float height = CGRectGetHeight(self.frame);
            item.clickButton.frame = CGRectMake(5, 0, width-10, height);
        }
    }
}

- (void)setAllButtonEnabled:(BOOL)isEnabled
{
    for (McBottomBarItem *item in _buttonItems) {
        [item.clickButton setEnabled:isEnabled];
    }
}

- (void)replaceBarItem:(McBottomBarItem *)item atIndex:(NSUInteger)index
{
    McBottomBarItem *itemBar = _buttonItems[index];
    [itemBar.clickButton setTag:item.clickButton.tag];
    [itemBar.clickButton setTitle:[item.clickButton titleForState:UIControlStateNormal] forState:UIControlStateNormal];
    [itemBar.clickButton setImage:[itemBar.clickButton imageForState:UIControlStateNormal] forState:UIControlStateNormal];
}

@end
