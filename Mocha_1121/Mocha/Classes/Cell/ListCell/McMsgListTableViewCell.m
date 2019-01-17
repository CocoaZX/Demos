//
//  McMsgListTableViewCell.m
//  Mocha
//
//  Created by renningning on 14-11-20.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "McMsgListTableViewCell.h"

#define leftX 15
#define topY 15
#define headSize 40

#define iconToContent 10

#define timeWid 100

@interface McMsgListTableViewCell()

@property (nonatomic, retain) NSDictionary *itemDict;

@end

@implementation McMsgListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"McMsgListTableViewCell" owner:nil options:nil];
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
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadSubViews
{
    float width = self.contentView.frame.size.width;
    
    [headImageView setFrame:CGRectMake(leftX, topY, headSize, headSize)];
    [headImageView.layer setBorderColor:[UIColor colorForHex:kLikeLightGrayColor].CGColor];
    [headImageView.layer setBorderWidth:1.0];
    [headImageView.layer setCornerRadius:headSize/2];
    [headImageView.layer setMasksToBounds:YES];
    
    [nameLabel setFrame:CGRectMake(CGRectGetMaxX(headImageView.frame)+iconToContent, topY, width - CGRectGetMaxX(headImageView.frame)-timeWid - leftX, 20)];
    [nameLabel setTextColor:[UIColor colorForHex:kLikeGrayColor]];
    
    [timeLabel setFrame:CGRectMake(width - timeWid-leftX, topY, timeWid, 20)];
    [timeLabel setTextColor:[UIColor colorForHex:kLikeLightGrayColor]];
    
    [contentLabel setFrame:CGRectMake(nameLabel.frame.origin.x, CGRectGetMaxY(nameLabel.frame) + 5, nameLabel.frame.size.width, 18)];
    [contentLabel setTextColor:[UIColor colorForHex:kLikeLightGrayColor]];
    
    [numLabel setFrame:CGRectMake(width - 20 -leftX, contentLabel.frame.origin.y, 20, 20)];
    [numLabel.layer setCornerRadius:10];
    [numLabel.layer setMasksToBounds:YES];
    [numLabel setTextColor:[UIColor whiteColor]];
    numLabel.backgroundColor = [UIColor colorForHex:kLikeGrayColor];
    numLabel.hidden = YES;
    
    [lineImageView setFrame:CGRectMake(10, self.contentView.frame.size.height - 0.5, width - 20, 0.5)];
    lineImageView.backgroundColor = [UIColor colorForHex:kLikeLightGrayColor];
}

- (IBAction)doClearNum:(id)sender
{
    [numLabel setText:@"0"];
    numLabel.hidden = YES;
    [numBtn setHidden:YES];
}

- (void)requestMsgRead
{
    NSString *myUserId = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    NSString *groupId = _itemDict[@"friend"][@"id"];
    NSDictionary *params = [AFParamFormat formatMsgReadParams:myUserId gid:groupId];
    [AFNetwork msgReadList:params success:^(id data){
        NSLog(@"msgReadList:%@",data);
    }failed:^(NSError *error){
        
    }];
    
}

- (void)setItemValueWithDict:(NSDictionary *)itemDict
{
    NSString *name = itemDict[@"friend"][@"nickname"];
    NSString *headerUrl = itemDict[@"friend"][@"nickname"];
    NSString *content = itemDict[@"message"][@"content"];
    NSString *timeStr = itemDict[@"message"][@"createline"];
    NSString *countStr = itemDict[@"message"][@"count"];

    self.itemDict = itemDict;
    NSString *jpg = [CommonUtils imageStringWithWidth:headSize * 2 height:headSize * 2];
    [headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",headerUrl,jpg]] placeholderImage:[UIImage imageNamed:@"head60"]];
    
    nameLabel.text = name;
    
    contentLabel.text = content;
    timeLabel.text = timeStr;
    if ([countStr integerValue] > 0) {
        numLabel.hidden = NO;
        numLabel.text = countStr;
        numBtn.hidden = NO;
    }else{
        [numLabel setText:@"0"];
        numLabel.hidden = YES;
        numBtn.hidden = YES;
    }
    
}

@end
