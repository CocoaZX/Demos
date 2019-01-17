//
//  PictureView.m
//  Mocha
//
//  Created by 小猪猪 on 14/12/10.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import "PictureView.h"

@implementation PictureView

- (void)initViews
{
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 100) collectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeadView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    
    self.informationView = [PersonInforView getPersonInforView];
    self.informationView.personalInfView.hidden = NO;
    self.informationView.workStyleView.hidden = YES;
    self.informationView.delegate = self;
    
    self.workStyleView = [WorkStyleView getWorkStyleView];
    
    self.workExpView = [WorkExpView getWorkExpView];
    
    self.workTagsView = [PersonInforView getPersonInforView];
    self.workTagsView.workStyleView.hidden = NO;
    self.workTagsView.personalInfView.hidden = YES;
    
    self.lineView3 = [[UIImageView alloc] init];

    self.lineView1 = [[UIImageView alloc] init];

    self.lineView2 = [[UIImageView alloc] init];

}

- (void)resetViewData:(NSDictionary *)diction
{
    self.informationView.infoStatusArr = diction[@"infoStatus"];//必须在前
    
    [self.informationView setDataArray:diction[@"personInfor"]];
    [self.workStyleView setDataArray:diction[@"workStyleResults"]];

    [self.workExpView setWorkExpString:diction[@"workExp"]];
    [self.workTagsView setDataArray:diction[@"workTagsResult"]];
    
    
    [self resetViewFrame];
}

- (void)resetViewFrame
{
    self.currentHeight = 0.0;
    
    float height = (kScreenWidth - 20)/3;

    int arrayCount = (int)self.pictureArray.count;
    if (self.isCurrentUser && arrayCount < 9) {
        arrayCount = arrayCount + 1;
    }
    
    int row = 1;
    
    if (arrayCount%3==0) {
        row = arrayCount/3;
    }else
    {
        row = arrayCount/3 + 1;
    }
    
    height = height * row;

    self.collectionView.frame = CGRectMake(0, 0, kScreenWidth, height + 10 * row);
    [self addSubview:self.collectionView];
    
    self.currentHeight = height + 10 * row;
    
    
    //基本个人资料
    float inforViewHeight = self.informationView.selfHeight;
    
    self.informationView.frame = CGRectMake(0, self.currentHeight, kScreenWidth, inforViewHeight);
    [self addSubview:self.informationView];
    
    self.currentHeight = self.currentHeight+inforViewHeight;
    self.lineView3.frame = CGRectMake(10, self.currentHeight-2, kScreenWidth-20, 2);
    self.lineView3.image = [UIImage imageNamed:@"backLine"];
    [self addSubview:self.lineView3];
    
    //工作经验／个人介绍
    float workExpViewHeight = self.workExpView.selfHeight;
    self.workExpView.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workExpViewHeight);
    [self addSubview:self.workExpView];
    
    
    UIButton *editBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn1.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workExpViewHeight);
    editBtn1.tag = 101;
    [editBtn1 addTarget:self action:@selector(doEditData:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn1];

    
    self.currentHeight = self.currentHeight+workExpViewHeight;
    
    self.lineView2.frame = CGRectMake(10, self.currentHeight-2, kScreenWidth-20, 2);
    self.lineView2.image = [UIImage imageNamed:@"backLine"];
    [self addSubview:self.lineView2];
    
    
    
    //工作风格／形象标签
    float workStyleViewHeight = self.workStyleView.selfHeight;
    self.workStyleView.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workStyleViewHeight);
    [self addSubview:self.workStyleView];
    
    
    UIButton *editBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn2.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workStyleViewHeight);
    editBtn2.tag = 102;
    [editBtn2 addTarget:self action:@selector(doEditData:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn2];
    
    self.currentHeight = self.currentHeight+workStyleViewHeight;

    self.lineView1.frame = CGRectMake(10, self.currentHeight-2, kScreenWidth-20, 2);
    self.lineView1.image = [UIImage imageNamed:@"backLine"];
    [self addSubview:self.lineView1];
    
    
    
    
    //工作标签
    float workTagsViewHeight = self.workTagsView.selfHeight;
    
    self.workTagsView.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workTagsViewHeight);
    [self addSubview:self.workTagsView];
    
    
    UIButton *editBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn3.frame = CGRectMake(0, self.currentHeight, kScreenWidth, workTagsViewHeight);
    editBtn3.tag = 103;
    [editBtn3 addTarget:self action:@selector(doEditData:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:editBtn3];
    
    
    self.currentHeight = self.currentHeight+workTagsViewHeight;

    
    self.frame = CGRectMake(0, 0, kScreenWidth, self.currentHeight);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
}



- (float)getPictureHeight
{
    float selfHeight = self.currentHeight;
    
    
    
    return selfHeight+110;
}




+ (PictureView *)getPictureView
{
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"PictureView" owner:self options:nil];
    PictureView *view = array[0];
    view.pictureArray = @[].mutableCopy;
    [view initViews];
    return view;
}


#pragma mark dele
- (void)didSelectedInfo:(NSString *)stringtitle infoStatus:(NSInteger)status
{
    if ([self.delegate respondsToSelector:@selector(doJumpEditVC:)]) {
        [self.delegate doJumpEditVC:status];
    }
}


#pragma mark UICollectionViewDelegate UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    int count = 0;
    if(self.pictureArray.count>9)
    {
        count = 9;

    }else
    {
        if (self.isCurrentUser) {
            count = (int)self.pictureArray.count+1;
            if (count>9) {
                count = 9;
            }
        }else
        {
            count = (int)self.pictureArray.count;
        }

    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UICollectionViewCell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];

    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth)/3, (kScreenWidth)/3)];
    if (indexPath.row==self.pictureArray.count) {
        imageV.image = [UIImage imageNamed:@"cameraIcon"];
    }else
    {
        NSString *urlString = self.pictureArray[indexPath.row][@"url"];
        if (urlString) {
            NSInteger wid = CGRectGetWidth(imageV.frame) * 2;
            NSInteger hei = CGRectGetHeight(imageV.frame) * 2;
            NSString *jpg = [CommonUtils imageStringWithWidth:wid height:hei];
            NSString *url = [NSString stringWithFormat:@"%@%@",urlString,jpg];
            [imageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"defaultImage"]];
            NSLog(@"%@",url);
        }
    }
    
    [cell.contentView addSubview:imageV];
    
    
    return cell;
}

//元素框的大小,指定区的内边距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {5,0,5,5};
    return top;
}



//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            return CGSizeMake((kDeviceWidth - 30)/3,(kDeviceWidth - 30)/3 + 3);
            break;
        case 1:
            return CGSizeMake(kDeviceWidth,60);
            break;
        case 2:
            return CGSizeMake(kDeviceWidth,60);
            break;
        default:
            break;
    }
    return CGSizeZero;
}





//选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.row:%ld",(long)indexPath.row);
    if ([self.delegate respondsToSelector:@selector(AppearPhotoBrowseWith:)]) {
        [self.delegate AppearPhotoBrowseWith:(int)indexPath.row];
    }
}


- (void)doEditData:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([self.delegate respondsToSelector:@selector(doJumpEditVC:)]) {
        [self.delegate doJumpEditVC:btn.tag];
    }
}


@end
