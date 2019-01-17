//
//  McChatFromYouTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-12-12.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McChatFromYouTableViewCell.h"


#define edgeX 10
#define headSize 38
#define edgeY 25

#define edgeSpace 8
#define contentOrignX 18

@interface McChatFromYouTableViewCell()

@property (nonatomic, retain) McMsgContent *msgItem;

@end

@implementation McChatFromYouTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McChatFromYouTableViewCell" owner:nil options:nil];
        self = nibs[0];
        [self setBackgroundColor:[UIColor clearColor]];
        [self loadSubViews];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];

    // Configure the view for the selected state
}

- (void)loadSubViews
{
    [contentLabel setTextColor:[UIColor colorForHex:kLikeBlackTextColor]];
    [timeLabel setTextColor:[UIColor colorForHex:kLikeGrayTextColor]];
    
    float wid = self.contentView.frame.size.width;
    [timeLabel setFrame:CGRectMake(edgeX + headSize, 5, wid - (edgeX + headSize) * 2, 15)];
    [headImageView setFrame:CGRectMake(edgeX, edgeY, headSize, headSize)];
    
    float orightX = CGRectGetMaxX(headImageView.frame) + 10;
    float bgSizeW = 50;//43
    float bgSizeH = 43;
    [bgImageView setFrame:CGRectMake(orightX, edgeY-2, bgSizeW, bgSizeH)];
    [contentLabel setFrame:CGRectMake(bgImageView.frame.origin.x + contentOrignX, bgImageView.frame.origin.y + edgeSpace , 24, 27)];
    
}

- (float)setValueWithItem:(McMsgContent *)item
{
    self.msgItem = item;
    timeLabel.text = [CommonUtils dateTimeIntervalString:item.time];
    NSString *jpg = [CommonUtils imageStringWithWidth:CGRectGetWidth(headImageView.frame) height:CGRectGetHeight(headImageView.frame)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",item.headPic,jpg]] placeholderImage:[UIImage imageNamed:@"head60"]];
    NSString *text = item.content;
    float wid = self.contentView.frame.size.width - (edgeX + CGRectGetMaxX(headImageView.frame)+ 10 + contentOrignX + edgeSpace);
//    float height = self.frame.size.width - kNavHeight - 50;
    
    CGSize size = [CommonUtils sizeFromText:text textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(wid, MAXFLOAT)];//
    
    
    CGRect bgFrame = bgImageView.frame;
    CGRect contentFrame = contentLabel.frame;
    
    UIImage *image = [UIImage imageNamed:@"chatbg_other"];
    
    if(size.width > 24){
        bgFrame.size.width = size.width + edgeSpace + contentOrignX;
        contentFrame.size.width = size.width;
    }
    if (size.height > 27) {
        bgFrame.size.height = size.height+ edgeSpace * 2;
        contentFrame.size.height = size.height;
    }
    bgImageView.frame = bgFrame;
    contentLabel.frame = contentFrame;
    UIEdgeInsets insets = UIEdgeInsetsMake(28, 22, 10, 10);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    //        [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
    //        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:25];//5.0之前
    contentLabel.text = text;
    [bgImageView setImage:image];
    
    return CGRectGetMaxY(bgImageView.frame) + edgeY;
}

- (float)setValueWithDict:(NSDictionary *)dict
{
    NSString *text = @"好大客户都会佛少男少女改变好大客户都会佛少男少女改变dhhdowhfowhf,对宋翻译的合法的身份iu大会佛";
    float wid = self.contentView.frame.size.width - (edgeX + CGRectGetMaxX(headImageView.frame)+ 10 + contentOrignX + edgeSpace);
    
    
    CGSize size = [CommonUtils sizeFromText:text textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(wid, MAXFLOAT)];//
    
    
    CGRect bgFrame = bgImageView.frame;
    CGRect contentFrame = contentLabel.frame;
    
    UIImage *image = [UIImage imageNamed:@"chatbg_other"];
    
    if(size.width > 24){
        bgFrame.size.width = size.width + edgeSpace + contentOrignX;
        contentFrame.size.width = size.width;
    }
    if (size.height > 27) {
        bgFrame.size.height = size.height+ edgeSpace * 2;
        contentFrame.size.height = size.height;
    }
    bgImageView.frame = bgFrame;
    contentLabel.frame = contentFrame;
    UIEdgeInsets insets = UIEdgeInsetsMake(28, 22, 10, 10);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    //        [UIImage imageWithCGImage:image.CGImage scale:2.0 orientation:image.imageOrientation];
    //        image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:25];//5.0之前
    contentLabel.text = text;
    [bgImageView setImage:image];
    
    return CGRectGetMaxY(bgImageView.frame) + edgeY;
}


@end
