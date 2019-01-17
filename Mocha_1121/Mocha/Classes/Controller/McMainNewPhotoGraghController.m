//
//  McMainNewPhotoGraghController.m
//  Mocha
//
//  Created by TanJian on 16/5/13.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "McMainNewPhotoGraghController.h"
#import "McMainPhotographerViewController.h"


static CGFloat const titleH = 44;
static CGFloat const navBarH = 64;

static CGFloat const maxTitleScale = 1.3;


@interface McMainNewPhotoGraghController ()<UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *titleScrollView;
@property (nonatomic, weak) UIScrollView *contentScrollView;
// 选中按钮
@property (nonatomic, weak) UIButton *selTitleButton;

@property (nonatomic, strong) NSMutableArray *buttons;

@property (nonatomic, strong) UIView *segView;


@property (nonatomic,strong)McMainPhotographerViewController *mainPhotographerVC;
@property (nonatomic,copy) NSString *currentCamID;


@end


@implementation McMainNewPhotoGraghController


- (NSMutableArray *)buttons
{
    if (!_buttons)
    {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //设置导航视图
    [self setupTitleScrollView];
    //设置内容视图
    [self setupContentScrollView];
    //添加子视图控制器
    [self addChildViewController];
    //设置按钮
    [self setupTitle];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * kDeviceWidth, 0);
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
}



#pragma mark - 设置头部标题栏
- (void)setupTitleScrollView
{
    // 判断是否存在导航控制器来判断y值
    CGFloat y = self.navigationController ? navBarH : 0;
    CGRect rect = CGRectMake(0, y, kDeviceWidth, titleH);
    
    UIScrollView *titleScrollView = [[UIScrollView alloc] initWithFrame:rect];
    titleScrollView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:titleScrollView];
    
    self.titleScrollView = titleScrollView;
}

#pragma mark - 设置内容
- (void)setupContentScrollView
{
    CGFloat y = CGRectGetMaxY(self.titleScrollView.frame);
    CGRect rect = CGRectMake(0, y, kDeviceWidth, kDeviceHeight - navBarH);
    
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:rect];
    //    contentScrollView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:contentScrollView];
    
    self.contentScrollView = contentScrollView;
}

#pragma mark - 添加子控制器
- (void)addChildViewController
{
    
    
    
    NSString *cameristType = getSafeString([USER_DEFAULT objectForKey:@"option_camerist_id"]);
    
    NSMutableArray *listArr = [NSMutableArray array];
    
    NSArray *userAttrsList = [USER_DEFAULT objectForKey:@"userAttrs"];
    for (NSDictionary *dict in userAttrsList) {
        if ([cameristType isEqualToString:getSafeString(dict[@"id"])]) {
            
            for (NSDictionary *typeDict in dict[@"list"]) {
                [listArr addObject:getSafeString(typeDict[@"name"])];
                self.currentCamID = getSafeString(typeDict[@"id"]);
            }
            
            break;
        }
    }
    
    if (listArr.count <= 0) {
        [LeafNotification showInController:self withText:@"获取数据失败"];
    }
    
    McMainPhotographerViewController *vc = [[McMainPhotographerViewController alloc] init];
    vc.title = @"全部";
    vc.superNVC = self.superNVC;
    vc.typeID = nil;
    vc.workStyleID = nil;
    [self addChildViewController:vc];
    
    for (int i = 0 ; i<listArr.count; i++) {
        McMainPhotographerViewController *vc = [[McMainPhotographerViewController alloc] init];
        vc.title = listArr[i];
        vc.superNVC = self.superNVC;
        vc.typeID = cameristType;
        vc.workStyleID = _currentCamID;
        [self addChildViewController:vc];
    }
    
//    McMainPhotographerViewController *vc = [[McMainPhotographerViewController alloc] init];
//    vc.title = @"今日头条";
//    vc.superNVC = self.superNVC;
//    [self addChildViewController:vc];
//    
//    McMainPhotographerViewController *vc1 = [[McMainPhotographerViewController alloc] init];
//    vc1.title = @"热点";
//    vc1.superNVC = self.superNVC;
//    [self addChildViewController:vc1];
//    
//    McMainPhotographerViewController *vc2 = [[McMainPhotographerViewController alloc] init];
//    vc2.title = @"视频";
//    [self addChildViewController:vc2];
//    
//    McMainPhotographerViewController *vc3 = [[McMainPhotographerViewController alloc] init];
//    vc3.title = @"社会";
//    [self addChildViewController:vc3];
//    
//    McMainPhotographerViewController *vc4 = [[McMainPhotographerViewController alloc] init];
//    vc4.title = @"订阅";
//    [self addChildViewController:vc4];
//    
//    McMainPhotographerViewController *vc5 = [[McMainPhotographerViewController alloc] init];
//    vc5.title = @"科技";
//    [self addChildViewController:vc5];
}

#pragma mark - 设置标题
- (void)setupTitle
{
    NSUInteger count = self.childViewControllers.count;
    
    CGFloat x = 0;
    CGFloat w = 60;
    if (kDeviceWidth > w*count) {
        w = kDeviceWidth/count;
    }
    
    CGFloat h = titleH;
    
    for (int i = 0; i < count; i++)
    {
        UIViewController *vc = self.childViewControllers[i];
        
        x = i * w;
        CGRect rect = CGRectMake(x, 0, w, h);
        UIButton *btn = [[UIButton alloc] initWithFrame:rect];
        
        btn.tag = i;
        [btn setTitle:vc.title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorForHex:kLikeGrayTextColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        [btn addTarget:self action:@selector(chick:) forControlEvents:UIControlEventTouchDown];
        
        [self.buttons addObject:btn];
        [self.titleScrollView addSubview:btn];
        
        
        if (i == 0)
        {
            //默认第一次选中的按钮
            [self chick:btn];
        }
        
    }
    self.titleScrollView.contentSize = CGSizeMake(count * w, 0);
    self.titleScrollView.showsHorizontalScrollIndicator = NO;
}

// 按钮点击
- (void)chick:(UIButton *)btn
{
    [self selTitleBtn:btn];
    
    NSUInteger i = btn.tag;
    CGFloat x = i * kDeviceWidth;
    
    //调整选中的内容视图
    [self setUpOneChildViewController:i];
    self.contentScrollView.contentOffset = CGPointMake(x, 0);
    
}
// 选中按钮
- (void)selTitleBtn:(UIButton *)btn
{
    //恢复原来选中的按钮
    [self.selTitleButton setTitleColor:[UIColor colorForHex:kLikeGrayTextColor] forState:UIControlStateNormal];

    
    //设置当前被选中的按钮
    [btn setTitleColor:[UIColor colorForHex:kLikeRedColor] forState:UIControlStateNormal];

    
    self.selTitleButton = btn;
    [self setupTitleCenter:btn];
}

- (void)setUpOneChildViewController:(NSUInteger)i
{
    CGFloat x = i * kDeviceWidth;
    
    UIViewController *vc = self.childViewControllers[i];
    
    if (vc.view.superview) {
        return;
    }
    vc.view.frame = CGRectMake(x, 0, kDeviceWidth, kDeviceHeight - self.contentScrollView.frame.origin.y);
    
    [self.contentScrollView addSubview:vc.view];
    
}

- (void)setupTitleCenter:(UIButton *)btn
{
    CGFloat offset = btn.center.x - kDeviceWidth * 0.5;
    
    if (offset < 0)
    {
        offset = 0;
    }
    
    CGFloat maxOffset = self.titleScrollView.contentSize.width - kDeviceWidth;
    if (offset > maxOffset)
    {
        offset = maxOffset;
    }
    
    [self.titleScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    [self.segView removeFromSuperview];
    UIView *segView = [[UIView alloc]init];
    segView.backgroundColor = [UIColor redColor];
    segView.frame = CGRectMake(CGRectGetMinX(btn.frame)+4, 40, CGRectGetWidth(btn.frame)-8, 2);
    self.segView = segView ;
    
    [self.titleScrollView addSubview:segView];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger i = self.contentScrollView.contentOffset.x / kDeviceWidth;
    [self selTitleBtn:self.buttons[i]];
    [self setUpOneChildViewController:i];
}

// 只要滚动UIScrollView就会调用
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger leftIndex = offsetX / kDeviceWidth;
    NSInteger rightIndex = leftIndex + 1;
    
    //    NSLog(@"%zd,%zd",leftIndex,rightIndex);
    
    UIButton *leftButton = self.buttons[leftIndex];
    
    UIButton *rightButton = nil;
    if (rightIndex < self.buttons.count) {
        rightButton = self.buttons[rightIndex];
    }
    
    CGFloat scaleR = offsetX / kDeviceWidth - leftIndex;
    
    CGFloat scaleL = 1 - scaleR;
    
    
    CGFloat transScale = maxTitleScale - 1;
//    leftButton.transform = CGAffineTransformMakeScale(scaleL * transScale + 1, scaleL * transScale + 1);
    
//    rightButton.transform = CGAffineTransformMakeScale(scaleR * transScale + 1, scaleR * transScale + 1);
    
    
//    UIColor *rightColor = [UIColor colorWithRed:scaleR green:0 blue:0 alpha:1];
//    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    UIColor *rightColor = [UIColor colorForHex:kLikeRedColor];
    UIColor *leftColor = [UIColor colorForHex:kLikeGrayTextColor];
    
//    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
//    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}



@end
