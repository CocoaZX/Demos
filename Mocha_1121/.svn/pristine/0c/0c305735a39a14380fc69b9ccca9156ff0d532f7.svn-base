//
//  ManageActivityViewController.m
//  Mocha
//
//  Created by sun on 15/8/28.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "ManageActivityViewController.h"
#import "BaoMingTableViewCell.h"
@interface ManageActivityViewController ()

@property (weak, nonatomic) IBOutlet UIView *segmentView;

@property (weak, nonatomic) IBOutlet UIButton *daishenheButton;

@property (weak, nonatomic) IBOutlet UIButton *daizhifuButton;

@property (weak, nonatomic) IBOutlet UIButton *daipingjiaButton;

@property (weak, nonatomic) IBOutlet UIButton *allButton;

@property (weak, nonatomic) IBOutlet UIView *daishenheView;

@property (weak, nonatomic) IBOutlet UIView *daizhifuView;

@property (weak, nonatomic) IBOutlet UIView *daipingjiaView;

@property (weak, nonatomic) IBOutlet UIView *quanbuView;

@property (weak, nonatomic) IBOutlet UITableView *listView;

//顶部无数据时提示Label
@property (weak, nonatomic) IBOutlet UILabel *descLabel;


@property (strong, nonatomic) NSMutableArray *dataArray;




@end

@implementation ManageActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报名管理";
    self.dataArray = @[].mutableCopy;
    //[self setUpSegmentView];
    [self setViews];
    [self requestManageActivityData];
}


- (void)setViews{
    self.listView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    self.status = @"0";
    self.descLabel.text = @"暂无可管理数据";
    self.descLabel.frame = CGRectMake(0, 0, kDeviceWidth, 30);
    [self.view bringSubviewToFront:self.descLabel];
    self.descLabel.hidden  = YES;

}

- (void)setUpSegmentView
{
    self.segmentView.frame = CGRectMake(0, 0, kScreenWidth, 50);
    self.listView.frame = CGRectMake(0, 50, kScreenWidth, kScreenHeight-64-50);

    [self resetState];
    float perWidth = kScreenWidth/4;
    self.daishenheButton.frame = CGRectMake(0, 10, perWidth, 30);
    self.daizhifuButton.frame = CGRectMake(perWidth, 10, perWidth, 30);
    self.daipingjiaButton.frame = CGRectMake(perWidth*2, 10, perWidth, 30);
    self.allButton.frame = CGRectMake(perWidth*3, 10, perWidth, 30);
    
    self.daishenheView.frame = CGRectMake(0, 48, perWidth, 2);
    self.daizhifuView.frame = CGRectMake(perWidth, 48, perWidth, 2);
    self.daipingjiaView.frame = CGRectMake(perWidth*2, 48, perWidth, 2);
    self.quanbuView.frame = CGRectMake(perWidth*3, 48, perWidth, 2);

    [self.daishenheButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.daishenheView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];
    self.status = @"0";

}

- (void)resetState
{
    [self.daishenheButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daishenheView setBackgroundColor:[UIColor clearColor]];

    [self.daizhifuButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daizhifuView setBackgroundColor:[UIColor clearColor]];

    [self.daipingjiaButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.daipingjiaView setBackgroundColor:[UIColor clearColor]];

    [self.allButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.quanbuView setBackgroundColor:[UIColor clearColor]];

}

- (IBAction)daishenhe:(id)sender {
    [self resetState];
    self.status = @"0";
    
    [self.daishenheButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.daishenheView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];

    [self.dataArray removeAllObjects];
    [self.listView reloadData];
    [self requestManageActivityData];
    
}

- (IBAction)daizhifu:(id)sender {
    [self resetState];
    self.status = @"2";

    [self.daizhifuButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.daizhifuView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];

    [self.dataArray removeAllObjects];
    [self.listView reloadData];
    [self requestManageActivityData];
}

- (IBAction)daipingjia:(id)sender {
    [self resetState];
    self.status = @"3";

    [self.daipingjiaButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.daipingjiaView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];

    [self.dataArray removeAllObjects];
    [self.listView reloadData];
    [self requestManageActivityData];
}

- (IBAction)quanbu:(id)sender {
    [self resetState];
    self.status = @"5";

    [self.allButton setTitleColor:[CommonUtils colorFromHexString:kLikeRedColor] forState:UIControlStateNormal];
    [self.quanbuView setBackgroundColor:[CommonUtils colorFromHexString:kLikeRedColor]];

    [self.dataArray removeAllObjects];
    [self.listView reloadData];
    [self requestManageActivityData];
}


#pragma  mark - 请求数据
- (void)requestManageActivityData
{
    NSMutableDictionary *dict = @{}.mutableCopy;
    [dict setValue:self.eventId forKey:@"id"];
    if (![self.status isEqualToString:@"5"]) {
        [dict setValue:self.status forKey:@"status"];

    }
//    [dict setValue:@"" forKey:@"lastindex"];
    NSDictionary *param = [AFParamFormat formatEventListParams:dict];
    [AFNetwork eventSignList:param success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            self.dataArray = [NSMutableArray arrayWithArray:data[@"data"]];
            [self.listView reloadData];
            
            //是否显示无数据提示
            if([self.dataArray count] == 0){
                self.descLabel.hidden = NO;
            }else{
                self.descLabel.hidden = YES;
            }
            
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];

    }];
    
}


#pragma mark - uitableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaoMingTableViewCell *cell = nil;
    NSString *identifier = @"BaoMingTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [BaoMingTableViewCell getBaoMingTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.supCon = self;
    [cell setDataWithDiction:self.dataArray[indexPath.row]];
    
    return cell;
}


- (void)refreshView
{
    [self requestManageActivityData];

    
}


@end
