//
//  MCNewDongtaiCell.m
//  Mocha
//
//  Created by TanJian on 16/5/23.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCNewDongtaiCell.h"

@interface MCNewDongtaiCell ()<UIActionSheetDelegate>

@property (nonatomic,strong)UIActionSheet *actionSheet;
@property (nonatomic,copy) NSString *currentUid;
@property (nonatomic,assign) BOOL isSelf;
@property (nonatomic,strong) NSDictionary *dataDict;


@end

@implementation MCNewDongtaiCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor colorForHex:kLikeGrayReleaseColor];
    
    _pointView.layer.cornerRadius = _pointView.width*0.5;
    _pointView.clipsToBounds = YES;
    
    if (_isHiddenLine) {
        _hiddenLine.hidden = YES;
    }else{
        _hiddenLine.hidden = NO;
    }
    
    
}

+(float)getNewDongtaiCellHeight:(NSDictionary *)dict{
    
    float hiddenLineH = kDeviceWidth/25*2;
    float shareBtnH = 18;
    float zanAreaH = 32;
    float bottomGrayH = 10;
    
    float imgViewH = 0;
    float imgViewW = kDeviceWidth/15*13 - 41;
    float imgH ;
    float imgW ;
    float scale ;
    
    NSString *objectType = getSafeString(dict[@"object_type"]);
    if ([objectType isEqualToString:@"15"]) {
        
        NSArray *imgArr = dict[@"info"][@"img_urls"];
        if (imgArr.count) {
            NSDictionary *imgDict = imgArr[0];
            imgH = getSafeString(imgDict[@"height"]).floatValue;
            imgW = getSafeString(imgDict[@"width"]).floatValue;
        }
        
    }else{
        NSDictionary *infoDict = dict[@"info"];
        if (infoDict) {
            
            imgH = getSafeString(infoDict[@"height"]).floatValue;
            imgW = getSafeString(infoDict[@"width"]).floatValue;

        }else{
            //动态图片高度计算
            imgH = getSafeString(dict[@"height"]).floatValue;
            imgW = getSafeString(dict[@"width"]).floatValue;

        }
        
        
    }
    
    scale = imgH/imgW;
    if (imgW<=0) {
        scale = 0;
    }
    imgViewH = imgViewW*scale;
    
    if (scale>4) {
        return 0;
    }else{
        return hiddenLineH+shareBtnH+zanAreaH+bottomGrayH+imgViewH;
    }
   
}

-(void)setupNewDongtaiCellView:(NSDictionary *)dict{
    
    _playImg.hidden = YES;
    
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    //计算图片宽高
    float imgViewH = 0;
    float imgViewW = kDeviceWidth/15*13 - 41;
    float imgH ;
    float imgW ;
    float scale ;
    NSString *type = getSafeString(dict[@"object_type"]);
    if ([type isEqualToString:@"15"]) {
        
        NSArray *imgArr = dict[@"info"][@"img_urls"];
        if (imgArr) {
            NSDictionary *imgDict = imgArr[0];
            imgH = getSafeString(imgDict[@"height"]).floatValue;
            imgW = getSafeString(imgDict[@"width"]).floatValue;
        }
        //点赞数和评论数
        _zanLabel.text = getSafeString(dict[@"info"][@"likecount"]);
        _commentCountLabel.text = getSafeString(dict[@"info"][@"commentcount"]);
        
    }else{
        NSDictionary *infoDict = dict[@"info"];
        if (infoDict) {
            
            imgH = getSafeString(infoDict[@"height"]).floatValue;
            imgW = getSafeString(infoDict[@"width"]).floatValue;
            
        }else{
            //动态图片高度计算
            imgH = getSafeString(dict[@"height"]).floatValue;
            imgW = getSafeString(dict[@"width"]).floatValue;
            
        }
        //点赞数和评论数
        _zanLabel.text = getSafeString(dict[@"likecount"]);
        _commentCountLabel.text = getSafeString(dict[@"commentcount"]);
    }
    
    scale = imgH/imgW;
    if (imgW<=0) {
        scale = 0;
    }
    imgViewH = imgViewW*scale;

    
    _dataDict = dict;
    //设置几月几号发布时间
    NSString *dayStr = [CommonUtils getReturnDateString:getSafeString(dict[@"createline"]) withDay:YES];
    _dayLabel.text = dayStr;
    NSString *monthStr = [CommonUtils getReturnDateString:getSafeString(dict[@"createline"]) withDay:NO];
    _monthLabel.text = [NSString stringWithFormat:@"%@月",monthStr];
    
    

    //设置图片//如果是竞拍，用竞拍的数据结构刷新界面
    NSString *urlStr;
    NSString *objectType = getSafeString(dict[@"object_type"]);
    
    switch (objectType.integerValue) {
            
        case 15:
        {
            _currentUid = getSafeString(dict[@"user"][@"id"]);
            
            NSArray *imgArr = dict[@"info"][@"img_urls"];
            
            if (imgArr) {
                NSDictionary *imgDict = imgArr[0];
                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                urlStr = getSafeString(imgDict[@"url"]);
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            }
            _tagImgView.image = [UIImage imageNamed:@"auctionTag"];
        }
            break;
        case 6:
        {
            _currentUid = getSafeString(dict[@"user"][@"id"]);
            
            NSDictionary *parentDict = dict[@"info"][@"album_setting"];
            
            if (parentDict) {
                
                NSString *currentID = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
                NSArray *uidList = parentDict[@"open"][@"is_forever_uids_list"];
                if ([_currentUid isEqualToString:uid]) {
                    
                    NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                    urlStr = getSafeString(dict[@"url"]);
                    urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
                }else{
                    if (uidList.count == 0) {
                        float imgViewW = kDeviceWidth/15*13 - 41;
                        NSString *tempStr = getSafeString(dict[@"url"]);
                        NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                        NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@|50-25bl",tempStr,jpg];
                        urlStr = [imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                        
                    }else{
                        for (NSString *Cuid in uidList) {
                            if (![Cuid isEqualToString:currentID]) {
                                
                                float imgViewW = kDeviceWidth/15*13 - 41;
                                NSString *tempStr = getSafeString(dict[@"url"]);
                                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                                NSString *imgUrlStr = [NSString stringWithFormat:@"%@%@|50-25bl",tempStr,jpg];
                                urlStr = [imgUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                            }else{
                                
                                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                                urlStr = getSafeString(dict[@"url"]);
                                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
                                break;
                            }
                        }
                    }
                    
                }
                
                _tagImgView.image = [UIImage imageNamed:@"privateTag"];
                
            }else{
                _tagImgView.image = [UIImage imageNamed:@"imgTag"];
                NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
                urlStr = getSafeString(dict[@"url"]);
                urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            }
        }
            break;
            
        case 11:
        {
            
            _tagImgView.image = [UIImage imageNamed:@"VideoTag"];
            NSString *jpg = [CommonUtils imageStringWithWidth:imgViewW*2 height:imgViewH*2];
            urlStr = getSafeString(dict[@"cover_url"]);
            urlStr = [NSString stringWithFormat:@"%@%@",urlStr,jpg];
            
            _playImg.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    
    if ([_currentUid isEqualToString:uid]) {
        _isSelf = YES;
    }else{
        _isSelf = NO;
    }

    [_dynamicImgView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
   
    //最后按图片大小拉伸图片
    CGFloat top = 25; // 顶端盖高度
    CGFloat bottom = 25 ; // 底端盖高度
    CGFloat left = 25; // 左端盖宽度
    CGFloat right = 25; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    // 指定为拉伸模式，伸缩后重新赋值
    UIImage *image = [[UIImage imageNamed:@"personDynamicBg"] resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    _bgImg.image = image;
}

//主人态删除客人态举报
- (IBAction)doActionSheet:(id)sender {
    
    [self.actionSheet showInView:self];
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


//UIActionSheet 代理
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if (_isSelf) {
                NSLog(@"执行删除");
                
                NSDictionary *dict = _dataDict;
                NSString *objectType = getSafeString(dict[@"object_type"]);
                
                switch (objectType.integerValue) {
                        
                    case 15:{
                        [self deleteAuction];
                    }
                        break;
                    case 6:
                        [self deleteDynamic];
                        break;
                    case 11:
                        [self deleteVideo];
                        break;
                        
                    default:
                        break;
                }
                
            }else{
                NSLog(@"举报");
                [self jubaoMethod];
            }
            break;
            
        default:
            break;
    }
}

-(void)deleteVideo{
    NSString *vid = getSafeString(_dataDict[@"id"]);
    NSString *uid = getSafeString([NSString stringWithFormat:@"%@", [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]]);
    NSDictionary *param = [AFParamFormat formatDeleteVideoParams:vid uid:uid];
    
    [AFNetwork getRequeatData:param path:PathDeleteVideo success:^(id data) {
        
        if([data[@"status"] integerValue] == kRight){
            NSLog(@"删除");
            [LeafNotification showInController:self.superVC withText:@"已成功删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePictureSuccess" object:param];
        }
        else{
            [LeafNotification showInController:self.superVC withText:data[@"msg"]];
//            NSLog(@"%@",data[@"msg"]);
        }

    } failed:^(NSError *error) {
        [LeafNotification showInController:self.superVC withText:@"当前网络不太顺畅哟"];
    }];
    
}

-(void)deleteDynamic{

    NSString *uid = getSafeString([NSString stringWithFormat:@"%@", [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"]]);
    
    NSDictionary *dict = [AFParamFormat formatDeleteActionParams:getSafeString(_dataDict[@"id"]) userId:uid];
    [AFNetwork deletePicture:dict success:^(id data){
        
        if([data[@"status"] integerValue] == kRight){
            NSLog(@"删除");
            [LeafNotification showInController:self.superVC withText:@"已成功删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePictureSuccess" object:dict];
        }
        else{
            [LeafNotification showInController:self.superVC withText:data[@"msg"]];
//            NSLog(@"%@",data[@"msg"]);
        }
        
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self.superVC withText:@"当前网络不太顺畅哟"];
        
    }];
    
}


-(void)deleteAuction{
    
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    
    [mdic setObject:_dataDict[@"id"] forKey:@"auctionId"];
    NSDictionary *params = [AFParamFormat formatTempleteParams:mdic];
    [AFNetwork postRequeatDataParams:params path:PathGetDeleteAuction success:^(id data) {
        
        if ([data[@"status"] integerValue] == kRight) {
            //删除成功，执行刷新
            [LeafNotification showInController:self.superVC withText:@"已成功删除"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"deletePictureSuccess" object:params];
        }else{
            [LeafNotification showInController:self.superVC withText:data[@"msg"]];
        }
        
    } failed:^(NSError *error) {
         [LeafNotification showInController:self.superVC withText:@"当前网络不太顺畅哟"];
    }];
}

-(void)jubaoMethod{
    [self showJuBaoViewController];

}

- (void)showJuBaoViewController
{
    NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
    if (uid) {
        
        MCJuBaoViewController *report = [[MCJuBaoViewController alloc] initWithNibName:@"MCJuBaoViewController" bundle:[NSBundle mainBundle]];

        report.auctionID = getSafeString(_dataDict[@"id"]);
        report.reportuid = self.currentUid;
        [self.superVC.navigationController pushViewController:report animated:YES];
    }else
    {
        [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self.superVC];
        
    }
    
}



-(UIActionSheet *)actionSheet{
    if (!_actionSheet) {
        
        if (_isSelf) {
            _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        }else{
            _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
        }

    }
    return _actionSheet;
}




@end
