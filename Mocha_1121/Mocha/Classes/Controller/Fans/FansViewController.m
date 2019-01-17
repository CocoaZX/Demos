//
//  FansViewController.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/12.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "FansViewController.h"
#import "WatchedTableViewCell.h"
 
#import "MJRefresh.h"

@interface FansViewController ()

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, assign) BOOL isNeedToRefresh;

@property (nonatomic, strong) NSString *thisUid;

@property (nonatomic, copy) NSString *currentIndex;

@end

@implementation FansViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isNeedToRefresh) {
        [self setFansDataWithUid:self.thisUid];
    }
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initViews];

    [self initLocalData];
    
    
    [self initNotifications];
    
    self.currentIndex = @"0";
    
    [self addFooter];
}

- (void)initLocalData
{
    self.watchedArray = @[].mutableCopy;
    
        
}

- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    [vc.fansTableView addFooterWithCallback:^{
        [vc setFansDataWithUid:vc.thisUid];
    }];
}

- (void)setFansDataWithUid:(NSString *)uid
{
    self.thisUid = uid;
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:uid forKey:@"uid"];
    if (_currentIndex == nil) {
        _currentIndex = @"0";
    }
    NSDictionary *params = [AFParamFormat formatFunListParams:uid index:_currentIndex];
    [AFNetwork getFunList:params  success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *dataArr = data[@"data"];
            _total = [data[@"total"] integerValue];
            self.numberLabel.text =[NSString stringWithFormat:@"全部粉丝(%@):",[NSNumber numberWithInteger:_total]];

            if (dataArr.count==0) {
                //当前索引位置是0，请求的数据个数也是0，说明还没有粉丝
                if ([self.currentIndex isEqualToString:@"0"]){
                    self.numberLabel.text =[NSString stringWithFormat:@"暂无粉丝"];
                    _numberLabel.textAlignment = NSTextAlignmentCenter;
                }

            }else
            {
                if ([self.currentIndex isEqualToString:@"0"]) {
                    self.watchedArray = dataArr.mutableCopy;
                    
                }
                else{
                    [self.watchedArray addObjectsFromArray:dataArr.mutableCopy];
                }
                self.currentIndex = data[@"lastindex"];
                
//                self.watchedArray = dataArr.mutableCopy;
                [self.fansTableView reloadData];
            }
        }
        else if([data[@"status"] integerValue] == kReLogin){
            self.numberLabel.text =[NSString stringWithFormat:@"请重新登录"];
            _numberLabel.textAlignment = NSTextAlignmentCenter;
            [USER_DEFAULT setValue:@"1" forKey:MOKA_USER_OVERDUE];
            [USER_DEFAULT synchronize];
            [(AppDelegate *)[UIApplication sharedApplication].delegate showAccountViewControllerWithCon:self];
        }
        [self.fansTableView footerEndRefreshing];
    }failed:^(NSError *error){
        
    }];
    
}

- (void)processData:(NSArray *)array
{
    [self.watchedArray removeAllObjects];
    
    for (int i=0;i<array.count;i++)
    {
        NSDictionary *diction = array[i];
        NSString *name = [NSString stringWithFormat:@"%@",diction[@"nickname"]];
        NSString *sex = [NSString stringWithFormat:@"%@",diction[@"sex"]];
        NSString *head_pic = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
        if ([sex isEqualToString:@"1"]) {
            sex = @"男";
        }else
        {
            sex = @"女";
        }
        NSDictionary *resultDic = @{@"name":name,@"info":sex,@"url":head_pic};
        [self.watchedArray addObject:resultDic];
    }
    [self.fansTableView reloadData];
}

- (void)initViews
{
    self.title = [NSString stringWithFormat:@"%@的粉丝",self.selfTitle?self.selfTitle:@"我"];
    //粉丝数量显示
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, view.frame.size.width - 30, 20)];
    self.numberLabel.text =[NSString stringWithFormat:@"全部粉丝(%@):",[NSNumber numberWithInteger:_total]];
    self.numberLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    _numberLabel.font = kFont14;
    [view addSubview:self.numberLabel];
    
    self.fansTableView.tableHeaderView = view;
    self.fansTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)initNotifications
{
    
}

#pragma mark - IBAction


//tableview


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.watchedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"WatchedTableViewCell";
    WatchedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [WatchedTableViewCell getWatchedCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
    }
    NSDictionary *diction = self.watchedArray[indexPath.row];

    NSString *name = [NSString stringWithFormat:@"%@",diction[@"nickname"]];
    NSString *sex = [NSString stringWithFormat:@"%@",diction[@"sex"]];
    NSString *head_pic = [NSString stringWithFormat:@"%@",diction[@"head_pic"]];
    if ([sex isEqualToString:@"1"]) {
        sex = @"男";
    }else
    {
        sex = @"女";
    }
    NSString *relationship = [NSString stringWithFormat:@"%@",diction[@"relationship"]];
    if ([relationship isEqualToString:@"1"]) {
        cell.choseImageView.image = [UIImage imageNamed:@"icon006-r13.png"];
    }else
    {
        cell.choseImageView.image = [UIImage imageNamed:@"icon006-r12.png"];
    }
    NSString *newFans = getSafeString(diction[@"newFans"]);
    if ([newFans isEqualToString:@"1"]) {
        cell.backgroundColor = [CommonUtils colorFromHexString:kLikePinkColor];
        cell.alpha = 0.8;
    }
    cell.nameLabel.text = name?name:@"";
    cell.infoLabel.text = sex?sex:@"";
    
    NSString *jpg = [CommonUtils imageStringWithWidth:80 height:80];
    NSString *url = [NSString stringWithFormat:@"%@%@",head_pic,jpg];
    [cell.headerImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"head60.png"]];
    
    cell.choseImageView.frame = CGRectMake(kScreenWidth-45, 21, 29, 28);
    cell.headerImageView.layer.cornerRadius = 3;
    cell.headerImageView.clipsToBounds = YES;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *diction = self.watchedArray[indexPath.row];
    self.isNeedToRefresh = YES;
    
    
    NSString *userName = diction[@"nickname"];
    NSString *uid = diction[@"id"];
    
    UserDefaultSetBool(YES, @"isHiddenTabbar");
    [USER_DEFAULT synchronize];
    
    NewMyPageViewController *newMyPage = [[NewMyPageViewController alloc] initWithNibName:@"NewMyPageViewController" bundle:[NSBundle mainBundle]];
    newMyPage.currentTitle = userName;
    newMyPage.currentUid = uid;

    
    [self.navigationController pushViewController:newMyPage animated:YES];
    
}

@end
