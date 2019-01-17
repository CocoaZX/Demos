//
//  YuePaiListViewController.m
//  Mocha
//
//  Created by yfw－iMac on 15/11/15.
//  Copyright © 2015年 renningning. All rights reserved.
//

#import "YuePaiListViewController.h"
#import "YuePaiDataSource.h"
#import "YuePaiDelegate.h"

@interface YuePaiListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;


@property (strong, nonatomic) YuePaiDataSource *mkDataSource;
@property (strong, nonatomic) YuePaiDelegate *mkDelegate;
@property (assign, nonatomic) int selectedSegIndex;
@property (copy, nonatomic) NSString *lastindex;

@property (strong, nonatomic) UILabel *footerView;

@end

@implementation YuePaiListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"我收到的",@"我发起的"]];
    if (_isTaoXi) {
        [segControl setTitle:@"我预约的" forSegmentAtIndex:1];
    }
    segControl.frame = CGRectMake((kScreenWidth - 160)/2, 10.0, 160, 30.0);
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [segControl addTarget:self action:@selector(doSelectSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segControl;
    self.isNeedPay = YES;
    self.lastindex = @"0";
    self.selectedSegIndex = 0;
    _mkDataSource = [[YuePaiDataSource alloc] init];
    _mkDataSource.isNeedPay = self.isNeedPay;
    _mkDataSource.controller = self;

    _mkDelegate = [[YuePaiDelegate alloc] init];
    _mkDelegate.isNeedPay = self.isNeedPay;
    _mkDelegate.controller = self;

    _mainTableView.dataSource = _mkDataSource;
    _mainTableView.delegate = _mkDelegate;

    [self initFooterView];
    
    _mainTableView.tableFooterView = self.footerView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lastindex = @"0";

    if (self.selectedSegIndex == 0) {
        NSLog(@"我收到的");
        self.isNeedPay = YES;
        [self getYuePaiListDataWithType:@"2"];
    }
    else{
        NSLog(@"我发起的");
        self.isNeedPay = NO;
        [self getYuePaiListDataWithType:@"1"];
    }
}

- (void)initFooterView
{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0];
    label.text = @"";
    label.textColor = [UIColor lightGrayColor];
    self.footerView = label;
    
}

- (void)updateFootView
{
    self.footerView.text = @"";
    if (self.selectedSegIndex==0) {
        if (_mkDelegate.dataArray.count==0) {
            self.footerView.text = @"暂无我收到的约拍";
        }
    }else
    {
        if (_mkDelegate.dataArray.count==0) {
            self.footerView.text = @"暂无我发起的约拍";
        }
    }
    if (_isTaoXi) {
        if (self.selectedSegIndex==0) {
            if (_mkDelegate.dataArray.count==0) {
                self.footerView.text = @"暂无我收到的专题订单";
            }
        }else
        {
            if (_mkDelegate.dataArray.count==0) {
                self.footerView.text = @"暂无我发起的专题订单";
            }
        }
    }
}

- (void)getYuePaiListDataWithType:(NSString *)t
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSString *type = getSafeString(t);
    NSString *lastindex = getSafeString(self.lastindex);
    NSString *pagesize = @"20";
    NSString *object_type = @"10";
    NSDictionary *params = [NSDictionary dictionary];
    if (_isTaoXi) {
        params = [AFParamFormat formatTempleteParams:@{@"type":type,@"lastindex":lastindex,@"pagesize":pagesize,@"object_type":object_type}];
    }else{
        params = [AFParamFormat formatTempleteParams:@{@"type":type,@"lastindex":lastindex,@"pagesize":pagesize}];
    }
    [AFNetwork postRequeatDataParams:params path:PathUserYuePaiList success:^(id data){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([data[@"status"] integerValue] == kRight) {
            _mkDataSource.dataArray = [NSArray arrayWithArray:data[@"data"]].mutableCopy;
            _mkDelegate.dataArray = [NSArray arrayWithArray:data[@"data"]].mutableCopy;
            _mkDelegate.isNeedPay = self.isNeedPay;
            _mkDataSource.isNeedPay = self.isNeedPay;
            _mkDataSource.isTaoXi = self.isTaoXi;
            _mkDelegate.isTaoXi = self.isTaoXi;
            [_mainTableView reloadData];
            self.lastindex = getSafeString(data[@"lastindex"]);
        }
        else {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
        
        [self updateFootView];
        
    }failed:^(NSError *error){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
        
        [self updateFootView];

    }];
    
}


- (NSMutableArray *)getRightArray:(NSArray *)array
{
    NSString *uid = getCurrentUid();

    NSMutableArray *marr = @[].mutableCopy;
    for (int i=0; i<array.count; i++) {
        NSDictionary *dic = array[i];
        NSString *to_uid = getSafeString(dic[@"to_uid"]);
        if (self.selectedSegIndex==0) {
            if ([to_uid isEqualToString:uid]) {
                [marr addObject:dic];
            }
        }else
        {
            if (![to_uid isEqualToString:uid]) {
                [marr addObject:dic];
            }
        }
    }
    return marr;
}

- (void)doSelectSegment:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    self.selectedSegIndex = (int)segControl.selectedSegmentIndex;
    self.lastindex = @"0";

    if (segControl.selectedSegmentIndex == 0) {
        NSLog(@"我收到的");
        self.isNeedPay = YES;
        [self getYuePaiListDataWithType:@"2"];
    }
    else{
        NSLog(@"我发起的");
        self.isNeedPay = NO;
        [self getYuePaiListDataWithType:@"1"];
    }
}

-(void)deleteYuePaiWithId:(NSString *)PaiId{
    NSDictionary *params = [NSDictionary dictionary];
    if (PaiId) { 
        params = [AFParamFormat formatTempleteParams:@{@"covenant_id":PaiId}];
        [AFNetwork postRequeatDataParams:params path:PathUserYuePaiDelete success:^(id data) {
            NSLog(@"%@",data);
            if ([data[@"status"] integerValue] == kRight) {
                [LeafNotification showInController:self withText:@"删除成功"];
                self.lastindex = @"0";
                if (self.isNeedPay) {
                    [self getYuePaiListDataWithType:@"2"];
                }else{
                    [self getYuePaiListDataWithType:@"1"];
                }
            }else{
                [LeafNotification showInController:self withText:data[@"msg"]];
            }
        } failed:^(NSError *error) {
            NSLog(@"%@",error);
            [LeafNotification showInController:self withText:@"当前网络不顺畅哟"];
        }];
    }
}

-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
