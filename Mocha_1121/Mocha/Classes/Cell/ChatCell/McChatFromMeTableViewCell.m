//
//  McChatTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-11-25.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

/*UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
 
 image2 = [image2 resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
 
 //    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
 
 //    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片 */

#import "McChatFromMeTableViewCell.h"


#define edgeX 10
#define headSize 38
#define edgeY 25

#define edgeSpace 8
#define contentOrignX 18

@interface McChatFromMeTableViewCell()

@property (nonatomic, retain) McMsgContent *msgItem;

@end


@implementation McChatFromMeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McChatFromMeTableViewCell" owner:nil options:nil];
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
    [headImageView setFrame:CGRectMake(wid - edgeX - headSize, edgeY, headSize, headSize)];
    
    float bgSizeW = 50;//43
    float bgSizeH = 43;

    float orightX = wid - headImageView.frame.origin.x - 10 - bgSizeW;
    [bgImageView setFrame:CGRectMake(orightX, edgeY-2, bgSizeW, bgSizeH)];
    [contentLabel setFrame:CGRectMake(bgImageView.frame.origin.x + edgeSpace, bgImageView.frame.origin.y + edgeSpace , 24, 27)];
    
}

- (float)setValueWithItem:(McMsgContent *)item
{
    self.msgItem = item;
    timeLabel.text = [CommonUtils dateTimeIntervalString:item.time];
    NSString *jpg = [CommonUtils imageStringWithWidth:CGRectGetWidth(headImageView.frame) height:CGRectGetHeight(headImageView.frame)];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",item.headPic,jpg]] placeholderImage:[UIImage imageNamed:@"head60"]];
    NSString *text = item.content;
    float wid = self.frame.size.width - (edgeX * 3 + headSize + contentOrignX + edgeSpace);
    
    CGSize size = [CommonUtils sizeFromText:text textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(wid, MAXFLOAT)];
    
    CGRect bgFrame = bgImageView.frame;
    CGRect contentFrame = contentLabel.frame;
    bgFrame.origin.x = 210;//
    contentFrame.origin.x = 220;
    UIImage *image = [UIImage imageNamed:@"chatbg_me"];
    if (size.width > 24) {
        bgFrame.size.width = size.width + contentOrignX + edgeSpace;
        contentFrame.size.width = size.width;
        float getX = headImageView.frame.origin.x - 10 - (size.width + contentOrignX + edgeSpace);
        bgFrame.origin.x = getX;
        contentFrame.origin.x = getX + edgeSpace;
    }
    if(size.height > 27){
        bgFrame.size.height = size.height + edgeSpace * 2;
        contentFrame.size.height = size.height;
    }
    
    bgImageView.frame = bgFrame;
    contentLabel.frame = contentFrame;
    UIEdgeInsets insets = UIEdgeInsetsMake(28, 10, 10, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    contentLabel.text = text;
    [bgImageView setImage:image];
    
    return CGRectGetMaxY(bgImageView.frame) + edgeY;

}

- (float)setValueWithDict:(NSDictionary *)dict
{
    NSString *text = @"好大客户都会佛";
    float wid = self.frame.size.width - (edgeX * 3 + headSize + contentOrignX + edgeSpace);
    
    CGSize size = [CommonUtils sizeFromText:text textFont:kFont14 boundingRectWithSizeOrconstrainedToSize:CGSizeMake(wid, MAXFLOAT)];
    
    CGRect bgFrame = bgImageView.frame;
    CGRect contentFrame = contentLabel.frame;
    UIImage *image = [UIImage imageNamed:@"chatbg_me"];
    if (size.width > 24) {
        bgFrame.size.width = size.width + contentOrignX + edgeSpace;
        contentFrame.size.width = size.width;
        float getX = headImageView.frame.origin.x - 10 - (size.width + contentOrignX + edgeSpace);
        bgFrame.origin.x = getX;
        contentFrame.origin.x = getX + edgeSpace;
    }
    if(size.height > 27){
        bgFrame.size.height = size.height + edgeSpace * 2;
        contentFrame.size.height = size.height;
    }
    
    bgImageView.frame = bgFrame;
    contentLabel.frame = contentFrame;
    UIEdgeInsets insets = UIEdgeInsetsMake(28, 10, 10, 22);
    image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeTile];
    
    contentLabel.text = text;
    [bgImageView setImage:image];
    
    return CGRectGetMaxY(bgImageView.frame) + edgeY;
    
}

@end
