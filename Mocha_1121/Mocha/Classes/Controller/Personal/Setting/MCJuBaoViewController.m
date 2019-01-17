//
//  MCJuBaoViewController.m
//  Mocha
//
//  Created by 小猪猪 on 16/4/28.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "MCJuBaoViewController.h"
#import "JuBaoTableViewCell.h"
#import "JuBaoPartTwoTableViewCell.h"
#import "JuBaoPartThreeTableViewCell.h"

@interface MCJuBaoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (strong, nonatomic) NSArray *dataArray;

@property (strong, nonatomic) JuBaoTableViewCell *partOneCell;

@property (strong, nonatomic) JuBaoPartTwoTableViewCell *partTwoCell;

@property (strong, nonatomic) JuBaoPartThreeTableViewCell *partThreeCell;


@end

@implementation MCJuBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"举报";

    self.dataArray = @[@"partOneCell",@"partTwoCell",@"partThreeCell"].mutableCopy;
    
    self.mainTableView.backgroundColor = NewbackgroundColor;
    
    self.mainTableView.tableFooterView = [self getFootView];
    
    
}

- (UIView *)getFootView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setFrame:CGRectMake(40, 20, kScreenWidth-80, 50)];
    [submit setTitle:@"确认提交" forState:UIControlStateNormal];
    [submit setClipsToBounds:YES];
    submit.layer.cornerRadius = 10.0f;
    [submit setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    [submit addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submit];
    
    return bottomView;
}

- (void)submitData:(id)sender
{
    NSString *content = [self.partThreeCell getContentString];

    if (content.length>0) {
        //        NSString *uid = [[USER_DEFAULT valueForKey:MOKA_USER_VALUE] valueForKey:@"id"];
        NSMutableDictionary *dict = nil;
        if (_targetUid) {
            //人
            dict = @{@"content":content,@"object_id":self.targetUid,@"object_type":@"1"}.mutableCopy;
            
        }else if(_photoUid)
        {
            //图片
            dict = @{@"content":content,@"object_id":self.photoUid,@"object_type":@"2"}.mutableCopy;
            
        }else if(_groupID){
            //
            dict = @{@"content":content,@"object_id":self.groupID,@"object_type":@"3"}.mutableCopy;
        }else if(_videoUid){
            //视频
            dict = @{@"content":content,@"object_id":self.videoUid,@"object_type":@"11"}.mutableCopy;
            
        }else if(_auctionID){
            dict = @{@"content":content,@"object_id":self.auctionID,@"object_type":@"15"}.mutableCopy;
        }
//        if (_targetUid) {
//            //人
//            dict = @{@"content":content,@"objectid":self.targetUid,@"type":@"1"}.mutableCopy;
//            
//        }else if(_photoUid)
//        {
//            //图片
//            dict = @{@"content":content,@"objectid":self.photoUid,@"type":@"2"}.mutableCopy;
//            
//        }else if(_groupID){
//            //
//            dict = @{@"content":content,@"objectid":self.groupID,@"type":@"3"}.mutableCopy;
//        }else if(_videoUid){
//            //视频
//            dict = @{@"content":content,@"objectid":self.videoUid,@"type":@"11"}.mutableCopy;
//            
//        }
        [dict setObject:getSafeString(self.partOneCell.choseType) forKey:@"report_type"];
        if (self.photoid) {
            [dict setObject:getSafeString(self.photoid) forKey:@"photoid"];

        }
        if (self.reportuid) {
            [dict setObject:getSafeString(self.reportuid) forKey:@"reportuid"];

        }

        __block NSMutableArray *imagesURL = @[].mutableCopy;
        NSMutableArray *imageArray = self.partTwoCell.picturesArray;
        //首先上传图片，获取到图片链接数组
        if (imageArray.count>0) {
            __block int successCount = 0;
            for (int i=0; i<imageArray.count; i++) {
                //NSData *imageData = UIImageJPEGRepresentation(self.imageArray[i], 0.3);
                NSData *imageData = UIImageJPEGRepresentation(imageArray[i], 1.0);
                NSLog(@"\n\n\n%.1luKB\n\n\n",(unsigned long)imageData.length/1024);
                //    //2M以下不压缩
                while (imageData.length/1024 > 2048) {
                    imageData = UIImageJPEGRepresentation(imageArray[i], 0.8);
                    imageArray[i] = [UIImage imageWithData:imageData];
                }
                
                NSDictionary *dict = [AFParamFormat formatPostUploadParamWithFileJingPai:@"file"];
                [AFNetwork uploadPhoto:dict fileData:imageData success:^(id data){
                    NSLog(@"uploadPhoto:%@ test SVN",data);
                    successCount++;
                    NSString *dictionURL = [NSString stringWithFormat:@"%@",data[@"data"][@"url"]];
                    [imagesURL addObject:getSafeString(dictionURL)];
                    
                }failed:^(NSError *error){
                    successCount++;
                    
                }];
                
            }
            NSLog(@"************  wait upload images");
            
            while (imagesURL.count<imageArray.count) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"************  start upload teach info");
            
        }
        NSString *img_urls = [SQCStringUtils JSONStringWithArray:imagesURL];
        
        [dict setObject:getSafeString(img_urls) forKey:@"img_urls"];

        
        NSDictionary *param = [AFParamFormat formatSystemReportParams:dict];
        NSLog(@"%@",param);
        [AFNetwork systemReport:param success:^(id data){
            NSLog(@"%@",data);
            NSString *state = [NSString stringWithFormat:@"%@",data[@"status"]];
            if ([state integerValue] == kRight) {
                [[[UIAlertView alloc] initWithTitle:@"提示" message:@"举报已收到 我们会尽快处理" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil] show];
            }
            else if ([state integerValue] == kReLogin) {
                [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
                [USER_DEFAULT synchronize];
                [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
            }
            else
            {
                NSString *msg = [NSString stringWithFormat:@"%@",data[@"msg"]];
                
                [LeafNotification showInController:self withText:msg];
                
            }
        }failed:^(NSError *error){
            
        }];
    }else
    {
        [LeafNotification showInController:self withText:@"请填写举报内容"];
        
        //        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //        self.hud.mode = MBProgressHUDModeText;
        //        self.hud.detailsLabelText = @"请填写举报内容";
        //        self.hud.removeFromSuperViewOnHide = YES;
        //        
        //        [self.hud hide:YES afterDelay:2.0];
    }
    
}

- (void)reloadTableView
{
    [self.mainTableView reloadData];
}

- (void)resetFrame
{
    self.mainTableView.frame = CGRectMake(0, -100, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);
    
}

- (void)resetBackFrame
{
    self.mainTableView.frame = CGRectMake(0, 0, self.mainTableView.frame.size.width, self.mainTableView.frame.size.height);
    
}

- (JuBaoTableViewCell *)partOneCell
{
    if (!_partOneCell) {
        _partOneCell = [JuBaoTableViewCell getJuBaoTableViewCell];
        _partOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partOneCell.backgroundColor = [UIColor clearColor];
    }
    return _partOneCell;
}

- (JuBaoPartTwoTableViewCell *)partTwoCell
{
    if (!_partTwoCell) {
        _partTwoCell = [JuBaoPartTwoTableViewCell getJuBaoPartTwoTableViewCell];
        _partTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partTwoCell.backgroundColor = [UIColor clearColor];
        _partTwoCell.controller = self;
    }
    return _partTwoCell;
}

- (JuBaoPartThreeTableViewCell *)partThreeCell
{
    if (!_partThreeCell) {
        _partThreeCell = [JuBaoPartThreeTableViewCell getJuBaoPartThreeTableViewCell];
        _partThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partThreeCell.backgroundColor = [UIColor clearColor];
        _partThreeCell.controller = self;
    }
    return _partThreeCell;
}


#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return self.partOneCell.cellHeight;
        
    }else if (indexPath.row==1)
    {
    
        return self.partTwoCell.cellHeight;
        
    }else if (indexPath.row==2)
    {
    
        return 140;
    }
    
    
    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return self.partOneCell;
        
    }else if (indexPath.row==1)
    {
        return self.partTwoCell;
    }else if (indexPath.row==2)
    {
        return self.partThreeCell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
}





@end
