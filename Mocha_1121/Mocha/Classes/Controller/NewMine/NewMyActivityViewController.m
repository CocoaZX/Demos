//
//  NewMyActivityViewController.m
//  Mocha
//
//  Created by sunqichao on 15/8/30.
//  Copyright (c) 2015年 renningning. All rights reserved.
//

#import "NewMyActivityViewController.h"
#import "NewActivityTableViewCell.h"
#import "NewActivityDetailViewController.h"

@interface NewMyActivityViewController ()

@property (nonatomic, assign) NSInteger selectedSegIndex;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (copy, nonatomic) NSString *lastIndex;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UILabel *numberLabel;

@property (strong, nonatomic) UIView *zanwuView;

@end

@implementation NewMyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"";
    self.dataArray = @[].mutableCopy;
    self.lastIndex = @"0";
    
    UISegmentedControl *segControl = [[UISegmentedControl alloc] initWithItems:@[@"已报名",@"已发布"]];
    segControl.frame = CGRectMake((kScreenWidth - 160)/2, 10.0, 160, 30.0);
    segControl.selectedSegmentIndex = 0;
    segControl.tintColor = [UIColor colorForHex:kLikeRedColor];
    [segControl addTarget:self action:@selector(doSelectSegment:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segControl;
    [self requestBaoMingActivity];

    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 45)];
    view.backgroundColor = [UIColor colorForHex:kLikeWhiteColor];
    
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, view.frame.size.width - 30, 20)];
    self.numberLabel.textColor = [UIColor colorForHex:kLikeGrayColor];
    self.numberLabel.textAlignment = NSTextAlignmentCenter;
    self.numberLabel.font = kFont14;
    [view addSubview:self.numberLabel];
    
    self.zanwuView = view;
    self.zanwuView.hidden = YES;
    [self.view addSubview:self.zanwuView];
}

- (void)doSelectSegment:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    self.selectedSegIndex = segControl.selectedSegmentIndex;

    
    if (segControl.selectedSegmentIndex == 0) {
        NSLog(@"已报名");
        [self requestBaoMingActivity];
    }
    else{
        
        NSLog(@"已发布");
        [self requestPublishedActivity];
    }
}

- (void)requestPublishedActivity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    

    [dict setValue:@"15" forKey:@"pagesize"];
    
    NSDictionary *param = [AFParamFormat formatEventListParams_own:dict];
    [AFNetwork eventMyRelease:param success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            [self.dataArray removeAllObjects];

            if ([arr count] > 0) {
                self.zanwuView.hidden = YES;

                self.dataArray = [NSMutableArray arrayWithArray:arr];
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"orderindex"]];
            }else{
                self.zanwuView.hidden = NO;
                self.numberLabel.text = @"暂无已发布活动";
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                    
                }
            }
            [self.tableView reloadData];

            
        }else
        {
            [LeafNotification showInController:self withText:data[@"msg"]];
        }
    }failed:^(NSError *error){
        [LeafNotification showInController:self withText:@"当前网络不太顺畅哟"];
    }];

}

- (void)requestBaoMingActivity
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{}];
    
    [dict setValue:@"15" forKey:@"pagesize"];
    
    NSDictionary *param = [AFParamFormat formatEventListParams_own:dict];
    [AFNetwork eventUserSignUp:param success:^(id data){
        if ([data[@"status"] integerValue] == kRight) {
            NSArray *arr = data[@"data"];
            [self.dataArray removeAllObjects];

            if ([arr count] > 0) {
                self.zanwuView.hidden = YES;

                self.dataArray = [NSMutableArray arrayWithArray:arr];
                self.lastIndex = [NSString stringWithFormat:@"%@",data[@"orderindex"]];
            }else{
                self.zanwuView.hidden = NO;
                self.numberLabel.text = @"暂无已报名活动";
                NSString *message = [NSString stringWithFormat:@"%@",data[@"msg"]];
                if (message.length>0) {
                    [LeafNotification showInController:self withText:message];
                    
                }
            }
            
            [self.tableView reloadData];

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
    return 220;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewActivityTableViewCell *cell = nil;
    NSString *identifier = @"NewActivityTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [NewActivityTableViewCell getNewActivityCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (self.dataArray.count>indexPath.row) {
        [cell setCelldataWithDiction:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewActivityDetailViewController *newActivity = [[NewActivityDetailViewController alloc] initWithNibName:@"NewActivityDetailViewController" bundle:[NSBundle mainBundle]];

    newActivity.eventId = getSafeString(self.dataArray[indexPath.row][@"id"]);
    [self.navigationController pushViewController:newActivity animated:YES];
    
}


@end
