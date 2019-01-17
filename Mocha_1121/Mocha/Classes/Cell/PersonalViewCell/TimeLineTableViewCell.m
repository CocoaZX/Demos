//
//  TimeLineTableViewCell.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "TimeLineTableViewCell.h"

#define kPhotoOrightX 50

@implementation TimeLineTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setCellViewWithDiction:(PhotoInfo *)diction indexpath:(NSIndexPath *)indexPath dataDiction:(NSDictionary *)dataDiction
{
    

}


- (void)setCellViewWithDiction:(PhotoInfo *)diction indexpath:(NSIndexPath *)indexPath 
{
    self.tagsLabel.text = @"";
    self.timeLabel.text = @"";
    self.nameLabel.text = @"";
    self.dataObject = diction;
    if (indexPath.row==0) {
        self.bgTopImageView.hidden = YES;
        self.divView.backgroundColor = [UIColor whiteColor];
    }else
    {
        self.bgTopImageView.hidden = NO;
        self.divView.backgroundColor = [UIColor clearColor];
    }
    self.likeButton.tag = indexPath.row;
    self.privateButton.tag = indexPath.row;
    self.commentButton.tag = indexPath.row;
    
    
    
    NSString *urlString = diction.url;
    NSString *title = diction.title;
    if (title.length==0) {
        title = @"";
    }
    NSString *createline = diction.createline;
    
    
    NSString *timeTitle = [CommonUtils formatDate:@"MM\ndd" string:createline];
    
    
    _timeTitleLab.text = timeTitle;
    
    NSMutableArray *userArray = @[].mutableCopy;

    for (PersonInfo *person in diction.likeUsers) {
        [userArray addObject:person];
    }
    
    [self addUsersHeaderImage:userArray];

    self.themeLabel.text = title;
    
    self.timeLabel.text = [CommonUtils dateTimeIntervalString:createline];
    
    NSString *islike = [NSString stringWithFormat:@"%@",diction.islike];
    NSString *isfavorite = [NSString stringWithFormat:@"%@",diction.isfavorite];
    if ([islike isEqualToString:@"1"]) {
        [self.likeButton setImage:[UIImage imageNamed:@"likedButton"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
        
        [self.likeButton setTitleColor:[UIColor colorWithRed:239/255.0 green:59/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }else
    {
        [self.likeButton setImage:[UIImage imageNamed:@"likeButton"] forState:UIControlStateNormal];
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
        [self.likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    
    if ([isfavorite isEqualToString:@"1"]) {
        [self.privateButton setImage:[UIImage imageNamed:@"unCollection"] forState:UIControlStateNormal];
        [self.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonRed"] forState:UIControlStateNormal];
        
        [self.privateButton setTitleColor:[UIColor colorWithRed:239/255.0 green:59/255.0 blue:77/255.0 alpha:1.0] forState:UIControlStateNormal];
        
    }else
    {
        [self.privateButton setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        [self.privateButton setBackgroundImage:[UIImage imageNamed:@"cellButtonGray"] forState:UIControlStateNormal];
        
        [self.privateButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        
    }
    
//    NSDictionary *userdict = [USER_DEFAULT valueForKey:MOKA_USER_VALUE];
//    if (userdict) {
//        NSString *selfuid = userdict[@"id"];
//        if ([diction.uid isEqualToString:selfuid]) {
//            self.commentButton.hidden = YES;
//        }
//        else{
//            self.commentButton.hidden = NO;
//        }
//    }
    
    
    NSString *width = [NSString stringWithFormat:@"%@",diction.width];
    NSString *heih = [NSString stringWithFormat:@"%@",diction.height];
    
    float imgH = kPhotoHeight;
    float wid = (kPhotoHeight/[heih floatValue])*[width floatValue];
    wid = MIN(kScreenWidth - kPhotoOrightX - 15, wid);
    [self resetCellFrameWithHeight:imgH photoWidth:wid photoInfo:diction];
    [self addTagsView:[NSString stringWithFormat:@"%@",diction.tags]];
    
    NSInteger wid_l = CGRectGetWidth(self.contentImageView.frame) * 2;
    NSInteger hei_l = CGRectGetHeight(self.contentImageView.frame) * 2;
    NSString *jpg = [CommonUtils imageStringWithWidth:wid_l height:hei_l];
    NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
    
    [self.contentImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

}

- (void)resetCellFrameWithHeight:(float)height photoWidth:(float)width photoInfo:(PhotoInfo *)photoInfo
{
    NSString *tags = [NSString stringWithFormat:@"%@",self.dataObject.tags];
    NSString *title = [NSString stringWithFormat:@"%@",self.dataObject.title];
    
    float thisHeight = 130;
    
    float photoOrightX = kPhotoOrightX;
    float photoOrightY = 15;
    
    float bottomY = 55;
    float bottomH = 135;
    float themeY = 31;
    float tagsY = 6;
    
    thisHeight = thisHeight+height;
    
    self.headerListView.hidden = NO;

    if (self.headerArray.count==0) {

        bottomH = bottomH - 40;
        self.headerListView.hidden = YES;
        thisHeight = thisHeight - 40;
    }
    
    if (tags.length==0) {
        thisHeight = thisHeight-20;
        bottomH = bottomH - 20;
        bottomY = bottomY-20;
        themeY = themeY-20;
    }
    if (title.length==0) {
        thisHeight = thisHeight-20;
        bottomH = bottomH - 20;
        bottomY = bottomY - 20;

    }
    
    self.frame = CGRectMake(0, 0, kScreenWidth, thisHeight);
    self.bgTopImageView.frame = CGRectMake(0, 0, kScreenWidth, 5);
    self.divView.frame = CGRectMake(0, 10, kScreenWidth, 50);
    
    self.contentImageView.frame = CGRectMake(photoOrightX, photoOrightY, width, height);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(_contentImageView.frame), kScreenWidth, bottomH);
    
    self.tagsLabel.frame = CGRectMake(photoOrightX, tagsY, kScreenWidth - photoOrightX - 15, 21);
    self.themeLabel.frame = CGRectMake(photoOrightX, themeY, kScreenWidth - photoOrightX - 15, 21);
    
    self.lineImageView.frame = CGRectMake(10, bottomY, kScreenWidth-20, 3);
    
    self.likeButton.frame = CGRectMake(13, bottomY+8, 60,26);
    self.privateButton.frame = CGRectMake(85, bottomY+8, 60,26);
    self.commentButton.frame = CGRectMake(158, bottomY+8, 60,26);

    self.headerListView.frame = CGRectMake(15, bottomY+38, kScreenWidth-15, 36);
    self.timeLabel.frame = CGRectMake(kScreenWidth-120, bottomY+13, 100, 21);
}

//http://cdn.q8oils.cc/af8345c1b83ec400ada48aa9eb7dcbf1
- (void)addUsersHeaderImage:(NSArray *)array
{
    [self.headerMoreButton removeFromSuperview];
    for (int i=0; i<self.headerArray.count; i++) {
        UIImageView *imgView = self.headerArray[i];
        [imgView removeFromSuperview];
    }
    [self.headerArray removeAllObjects];
    
    float x = 0;
    float y = 8;
    float w = 25;
    float h = 25;
    int space = 7;
    int count = (kScreenWidth-20)/(w+space);
    if (count>array.count) {
        count = (int)array.count;
    }
    
    for (int i=0; i<count; i++) {
        x = i*(w+space);
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        PersonInfo *per = array[i];
        NSString *urlString = per.head_pic;
        NSInteger wid = CGRectGetWidth(imgView.frame) * 2;
        NSInteger hei = CGRectGetHeight(imgView.frame) * 2;
        NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
        NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
        imgView.layer.cornerRadius = 3;
        imgView.clipsToBounds = YES;
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
        [self.headerArray addObject:imgView];
        [self.headerListView addSubview:imgView];
        
    }
    
    x = count*(w+space);

    UIButton *numberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numberBtn setBackgroundColor:[UIColor grayColor]];
    [numberBtn setTintColor:[UIColor whiteColor]];

    [numberBtn setTitle:[NSString stringWithFormat:@"%d",(int)array.count] forState:UIControlStateNormal];

    numberBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    numberBtn.layer.cornerRadius = 3;
    [numberBtn setFrame:CGRectMake(x, y, w, h)];
    if (array.count!=0) {
        [self.headerListView addSubview:numberBtn];
        self.headerMoreButton = numberBtn;
    }
    
}

- (void)addTagsView:(NSString *)tagstr
{
    NSMutableString *tagstring = @"".mutableCopy;
    
    NSString *tags = tagstr;
    if (tags.length>0) {
        self.contentView.hidden = NO;
        
        NSArray *tagsArr = [tags componentsSeparatedByString:@","];
        
        NSMutableArray *tagResults = @[].mutableCopy;
        //path 读取当前程序定义好的文件
        NSString *pathW = [[NSBundle mainBundle] pathForResource:@"workTags" ofType:@"plist"];
        NSDictionary *workTagDict = [NSDictionary dictionaryWithContentsOfFile:pathW];
        for (int i=0; i<tagsArr.count; i++) {
            NSString *styleKey = tagsArr[i];
            if (!styleKey) {
                styleKey = @"0";
            }
            NSString *value = workTagDict[styleKey];
            if (!value) {
                value = styleKey;
            }
            [tagResults addObject:value];
        }
        
        for (int i=0; i<tagResults.count; i++) {
            NSString *tag = tagResults[i];
            if (i==0) {
                [tagstring appendFormat:@"#%@",tag];
            }else
            {
                [tagstring appendFormat:@" | %@",tag];
            }
        }
        
        self.tagsLabel.text = tagstring.copy;
        
    }else
    {
        
        
    }
    
}

- (MPMoviePlayerController *)player
{
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] init];
    }
    return _player;
}

- (UIButton *)playerButton
{
    if (!_playerButton) {
        _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playerButton setImage:[UIImage imageNamed:@"playButton"] forState:UIControlStateNormal];
    }
    return _playerButton;
}

- (void)addVideoPlayer
{
    [self.playerButton setFrame:self.contentImageView.frame];
    
    [self.playerButton addTarget:self action:@selector(playMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.playerButton];
    
}

- (void)playMethod:(id)sender
{
    NSURL *videoURL = [NSURL URLWithString:self.dataObject.tags];
    NSLog(@"%@",[videoURL description]);
    self.player.contentURL = videoURL;
    self.player.controlStyle = MPMovieControlStyleNone;
    self.player.view.frame = self.contentImageView.frame;
//    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentImageView.frame.size.width, self.contentImageView.frame.size.height)];
//    UIImageView *backImageView = [[UIImageView alloc] initWithFrame:backView.frame];
//    backImageView.image = self.contentImageView.image;
//    [backView addSubview:backImageView];
    
    [self.player play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStates) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    self.player.repeatMode = MPMovieRepeatModeOne;
    
    [self addSubview:self.player.view];
    
}

- (void)removePlayer
{
    [self.playerButton removeFromSuperview];
    [self.player stop];
    [self.player.view removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didChangeStates
{
    
    NSLog(@"did change ");
    
}

+ (TimeLineTableViewCell *)getTimeLineCell
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"TimeLineTableViewCell" owner:self options:nil];
    TimeLineTableViewCell *cell = array[0];
    cell.headerArray = @[].mutableCopy;
    cell.bgTopImageView.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    cell.timeTitleLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    cell.mouthLab.textColor = [UIColor colorForHex:kLikeGrayTextColor];
    return cell;
}

@end
