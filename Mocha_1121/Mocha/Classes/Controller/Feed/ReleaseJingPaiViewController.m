//
//  ReleaseJingPaiViewController.m
//  Mocha
//
//  Created by yfw－iMac on 16/4/15.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "ReleaseJingPaiViewController.h"
#import "JingPaiPartOneTableViewCell.h"
#import "JingPaiPartTwoTableViewCell.h"
#import "JingPaiPartThreeTableViewCell.h"
#import "JingPaiPartFourTableViewCell.h"
#import "McWebViewController.h"
#import "UploadVideoManager.h"
#import "ChoseJingPaiTypeViewController.h"
#import "MCPublicJingPaiModel.h"
#import "MCJingPiaLabelsModel.h"
@interface ReleaseJingPaiViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (strong, nonatomic) JingPaiPartOneTableViewCell *partOneCell;
@property (strong, nonatomic) JingPaiPartTwoTableViewCell *partTwoCell;
@property (strong, nonatomic) JingPaiPartThreeTableViewCell *partThreeCell;
@property (strong, nonatomic) JingPaiPartFourTableViewCell *partFourCell;

@property (strong, nonatomic) MCPublicJingPaiModel *dataModel;

@end

@implementation ReleaseJingPaiViewController

- (MCPublicJingPaiModel *)dataModel
{
    if (!_dataModel) {
        _dataModel = [[MCPublicJingPaiModel alloc] init];
    }
    return _dataModel;
}

- (JingPaiPartOneTableViewCell *)partOneCell
{
    if (!_partOneCell) {
        _partOneCell = [JingPaiPartOneTableViewCell getJingPaiPartOneTableViewCell];
        _partOneCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partOneCell.backgroundColor = [UIColor clearColor];
        _partOneCell.releaseController = self;
    }
    return _partOneCell;
}

- (JingPaiPartTwoTableViewCell *)partTwoCell
{
    if (!_partTwoCell) {
        _partTwoCell = [JingPaiPartTwoTableViewCell getJingPaiPartTwoTableViewCell];
        _partTwoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partTwoCell.backgroundColor = [UIColor clearColor];
        _partTwoCell.controller = self;
    }
    return _partTwoCell;
}

- (JingPaiPartThreeTableViewCell *)partThreeCell
{
    if (!_partThreeCell) {
        _partThreeCell = [JingPaiPartThreeTableViewCell getJingPaiPartThreeTableViewCell];
        _partThreeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partThreeCell.backgroundColor = [UIColor clearColor];
        _partThreeCell.controller = self;
    }
    return _partThreeCell;
}

- (JingPaiPartFourTableViewCell *)partFourCell
{
    if (!_partFourCell) {
        _partFourCell = [JingPaiPartFourTableViewCell getJingPaiPartFourTableViewCell];
        _partFourCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _partFourCell.backgroundColor = [UIColor clearColor];
        _partFourCell.controller = self;

    }
    return _partFourCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布竞拍";
    
    //导航栏上的搜索功能
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setFrame:CGRectMake(0, 0, 30, 30)];
    [searchBtn setImage:[UIImage imageNamed:@"jingpai_info"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(doJumpInfoVC:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem = rightItem;

    self.dataArray = @[@"partOneCell",@"partTwoCell",@"partThreeCell",@"partFourCell"].mutableCopy;
    
    self.mainTableView.backgroundColor = NewbackgroundColor;
    
    self.mainTableView.tableFooterView = [self getFootView];
    
    //获取标签
    [self getLabelsArrayFromServer];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.mainTableView reloadData];

}

- (void)reloadTableView
{

    [self.mainTableView reloadData];

}

- (UIView *)getFootView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    [submit setFrame:CGRectMake(40, 20, kScreenWidth-80, 50)];
    [submit setTitle:@"确认发布" forState:UIControlStateNormal];
    [submit setClipsToBounds:YES];
    submit.layer.cornerRadius = 10.0f;
    [submit setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    [submit addTarget:self action:@selector(submitData:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submit];
    
    return bottomView;
}

- (void)doJumpInfoVC:(UIButton *)sender
{
    LOG_METHOD;
    NSDictionary *dict = [USER_DEFAULT valueForKey:@"webUrlsDic"];
    NSString *urlString = getSafeString(dict[@"auction_rule"]);
    NSLog(@"%@",urlString);
    McWebViewController *webVC = [[McWebViewController alloc] init];
    webVC.webUrlString = urlString;
    webVC.needAppear = YES;
    webVC.title = @"发布竞拍";
    [self.navigationController pushViewController:webVC animated:YES];
    
}

- (void)submitData:(UIButton *)sender
{
    LOG_METHOD;

    [self postDataToServer];
}

- (void)postDataToServer
{
    NSString *content = getSafeString(self.partOneCell.contentTextView.text);
    if (content.length==0) {
        [LeafNotification showInController:self withText:@"请填写竞拍内容"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.dataModel.content = content;
    self.dataModel.initial_price = [self.partThreeCell getStartPrice];
    self.dataModel.auction_type = getSafeString(self.partThreeCell.diction[@"auction_type"]);
    self.dataModel.up_range = [self.partThreeCell getAddPrice];
    if (self.dataModel.up_range.length==0) {
        self.dataModel.up_range = @"10";
    }
    NSString *video = getSafeString(self.partTwoCell.videoString);
    NSString *videoUrl = getSafeString(self.partTwoCell.videoImageString);
    if (video.length==0) {
//        video = @"http://mokavideo-10017412.video.myqcloud.com/201641445716.mp4";
        
    }
    if (videoUrl.length==0) {
//        videoUrl = @"http://cdn.q8oils.cc/c664eecfc75bcc677bd1ff8c0f27ca77";
    }

    self.dataModel.video_url = [SQCStringUtils JSONStringWithDiction:@{@"video_url":video,@"cover_url":videoUrl}];
    self.dataModel.tag_ids = [self.partFourCell getIdString];//["1","2","3"]
    
    if (self.dataModel.tag_ids.length==2) {
        [LeafNotification showInController:self withText:@"请选择标签"];
        return;
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
                
                successCount++;
//                NSString *dictionURL = [NSString stringWithFormat:@"%@",data[@"data"][@"url"]];
                NSString *dictionURL = [NSString stringWithFormat:@"%@",data[@"data"][@"id"]];
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
    
    self.dataModel.img_urls = [SQCStringUtils JSONStringWithArray:imagesURL];
    CLLocationDegrees lat = Latitude;
    CLLocationDegrees lng = Longitude;
    self.dataModel.latitude = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:lat]];
    self.dataModel.longitude = [NSString stringWithFormat:@"%@",[NSNumber numberWithDouble:lng]];
    
    
    NSDictionary *params = [AFParamFormat formatTempleteParams:[self.dataModel getParam]];
    
    [AFNetwork postRequeatDataParams:params path:PathPostAuctionCreate success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            
            [LeafNotification showInController:self withText:data[@"msg"]];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}



- (void)getLabelsArrayFromServer
{
    NSDictionary *params = [AFParamFormat formatTempleteParams:@{}];
    [AFNetwork postRequeatDataParams:params path:PathPostAuctionTagList success:^(id data){
        
        if ([data[@"status"] integerValue] == kRight) {

            MCJingPiaLabelsModel *info = [[MCJingPiaLabelsModel alloc] initWithDictionary:data error:NULL];
            
            [self setPartFourArrayWith:info];
            
        }
        else{
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        
    }failed:^(NSError *error){
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];
    
}

- (void)setPartFourArrayWith:(MCJingPiaLabelsModel *)model
{
    NSMutableArray *dataArr = @[].mutableCopy;
    for (int i=0;i<model.data.tagList.count;i++)
    {
        JingPiaLabelItemModel *item = model.data.tagList[i];
        NSMutableDictionary *diction = @{@"type":@"0",@"title":@"中",@"item":item,@"selected":@"0",@"tagid":getSafeString(item.tag_id)}.mutableCopy;
        [dataArr addObject:diction];
    }
    NSMutableDictionary *diction = @{@"type":@"2",@"title":@"自定义",@"item":@"",@"selected":@"0",@"tagid":@""}.mutableCopy;
    [dataArr addObject:diction];
    self.partFourCell.labelsArray = dataArr;
    [self.partFourCell resetLabelsView];
    [self.mainTableView reloadData];
}

#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        
        return 170;

    }else if(indexPath.row==1)
    {
        return self.partTwoCell.cellHeight;

    }else if (indexPath.row==2)
    {
        return 100;

    }else if (indexPath.row==3)
    {
        return self.partFourCell.cellHeight;

    }

    return 44;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
 
        return self.partOneCell;

    }else if(indexPath.row==1)
    {
        return self.partTwoCell;

    }else if (indexPath.row==2)
    {
        return self.partThreeCell;

    }else if (indexPath.row==3)
    {
        return self.partFourCell;
    }
    
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


@end
