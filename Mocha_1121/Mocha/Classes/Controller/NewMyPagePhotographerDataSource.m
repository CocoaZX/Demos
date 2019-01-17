//
//  NewMyPagePhotographerDataSource.m
//  Mocha
//
//  Created by XIANPP on 16/3/3.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "NewMyPagePhotographerDataSource.h"
#import "NewPersonalOneTableViewCell.h"
#import "NewMokaCardTableViewCell.h"
#import "BuildNewMcTableViewCell.h"
#import "TaoXiTableViewCell.h"
#import "XiangCeTableViewCell.h"
#import "XiangCeCollectionTableViewCell.h"

@implementation NewMyPagePhotographerDataSource

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //自己
    if (_isMaster) {
        //多一个添加模卡的单元格
        //相册显示在一个单元格,如果不为空的话加一个单元格
        if (self.xiangCeArray.count == 0) {
            return self.taoxiArray.count +self.albumsArray.count +1 + self.dataArray.count;
        }else{
            return self.taoxiArray.count +self.albumsArray.count +1 + 1 + self.dataArray.count;
        }
    }
    
    //当前界面不是自己，没有创建的单元格
    if (self.xiangCeArray.count == 0) {
        return self.taoxiArray.count +self.albumsArray.count + self.dataArray.count;
     }else{
        return self.taoxiArray.count +self.albumsArray.count + 1 + self.dataArray.count;
    }
    
}


//返回单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float cellHeight = 84;
    //套系
    if (indexPath.row < self.taoxiArray.count) {
        //图片高度跟随秀里面套系图片的比例
        CGFloat imgH = kDeviceWidth /375*200;
        NSDictionary *diction = [NSDictionary dictionaryWithDictionary:self.taoxiArray[indexPath.row]];
        if (indexPath.row == 0) {
            if (diction[@"albumId"]) {
                return  50 + imgH + 60;
            }else{
                return  50 + imgH;
            }
        }else{
            return  imgH +60;
        }
        return  50 + imgH + 60;
    }
    
    //模卡
    if (!(indexPath.row < self.taoxiArray.count) && indexPath.row < self.taoxiArray.count + self.albumsArray.count) {
        NSDictionary *albumDic = @{};
        //显示模
        if (self.albumsArray.count>indexPath.row - self.taoxiArray.count) {
            albumDic = self.albumsArray[indexPath.row - self.taoxiArray.count];
        }
        height = 500;
        NSString *style = [NSString stringWithFormat:@"%@",albumDic?albumDic[@"style"]:@"0"];
        
        int indexP = [style intValue];
        //四种模特卡,再加五种
        switch (indexP) {
            case 0:
                height = 365;//照片
                break;
            case 1:
                height = kScreenWidth - 32;//五图
                break;
            case 2:
                height = kScreenWidth - 40;//六图
                break;
            case 3:
                height = kScreenWidth + 60;//九宫格
                break;
            case 4:
                height = kScreenWidth - 7;//十图
                break;
            case 5:
                height = kScreenWidth - 22;//八图
                break;
            case 6:
                height = kScreenWidth - 42;//一加六
                break;
            case 7:
                height = kScreenWidth - 42;//一加八
                break;
            case 8:
                height = kScreenWidth - 42;//经典六图
                break;
            case 9:
                height = kScreenWidth - 42;//新式6
                break;
            case 11:
                height = kScreenWidth - 42;
                break;

            case 14:
                height = kScreenWidth - 42;//上大
                break;
            case 12:
                height = kScreenWidth - 42;
            case 13:
                height = kScreenWidth -42;
                break;
            default:
                height = kDeviceWidth - 89;
                break;
        }
        int y = -40;
        int footHeight = 55;
        cellHeight = height + y + footHeight;
        return cellHeight;
    }
    

    if (_isMaster) {
        //主人态添加MOka的按钮
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count) {
            cellHeight = 70;
            return cellHeight;
        }
        
        NSInteger addJieShaoValue = 1;
        NSInteger addJingYanvalue = 2;
        NSInteger addGongzuoShi = 3;
        
        //是否有相册
        if (self.xiangCeArray.count == 0){
            
        }else{
            //相册单元格
            if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + 1) {
                //return [XiangCeTableViewCell getXiangCeTableViewCellHeight:self.xiangCeArray];
                return [XiangCeCollectionTableViewCell getXiangCeTableViewCellHeight:self.xiangCeArray];

            }
            addJieShaoValue = 2;
            addJingYanvalue = 3;
            addGongzuoShi = 4;
        }
        //个人介绍
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJieShaoValue) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jieshao];
        }
        //工作经验
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJingYanvalue) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jingyan];
        }
        //工作室
        if (indexPath.row == self.taoxiArray.count +self.albumsArray.count +addGongzuoShi) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.gongzuoshi];
        }
        return cellHeight;
    }else{
        //非自己情况的处理
        NSInteger addJieShaoValue = 0;
        NSInteger addJingYanvalue = 1;
        NSInteger addGongzuoShi = 2;
        
        if(self.xiangCeArray.count == 0){
            
        }else{
            if (indexPath.row == self.taoxiArray.count +self.albumsArray.count) {
                //return [XiangCeTableViewCell getXiangCeTableViewCellHeight:self.xiangCeArray];
                return [XiangCeCollectionTableViewCell getXiangCeTableViewCellHeight:self.xiangCeArray];

            }
            addJieShaoValue = 1;
            addJingYanvalue = 2;
            addGongzuoShi = 3;

        }
        //个人介绍
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count +addJieShaoValue) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jieshao];
        }
        //工作经验
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJingYanvalue) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.jingyan];
        }
        
        //工作室
        if (indexPath.row == self.taoxiArray.count +self.albumsArray.count +addGongzuoShi) {
            cellHeight = [NewPersonalOneTableViewCell getCellheightWithString:self.gongzuoshi];
        }

    }
    return cellHeight;
}


//返回的单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //第一部分：套系
    if (indexPath.row < self.taoxiArray.count) {
        NSString *identifier = [NSString stringWithFormat:@"TaoXiTableViewCell"];
        TaoXiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"TaoXiTableViewCell" owner:nil options:nil].lastObject;
            cell.supCon = self.controller;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //第一个单元显示要新建等控件
        if (indexPath.row == 0) {
            cell.isFirstCell = YES;
        }else{
            cell.isFirstCell = NO;
        }
        NSDictionary *diction = [NSDictionary dictionaryWithDictionary:self.taoxiArray[indexPath.row]];
        cell.dic = diction;
        cell.currentUid = self.currentUid;
        return cell;
    }
    
    //第二部分：模卡
    if (!(indexPath.row < self.taoxiArray.count) && indexPath.row < self.taoxiArray.count + self.albumsArray.count) {
        NewMokaCardTableViewCell *cell = nil;
        NSString *identifier = @"NewMokaCardTableViewCell";
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [NewMokaCardTableViewCell getNewMokaCardTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
        }
        cell.currentUserName = self.currentName;
        NSDictionary *albumDic = @{};
        if (self.albumsArray.count>indexPath.row - self.taoxiArray.count) {
            albumDic = self.albumsArray[indexPath.row - self.taoxiArray.count];
        }
        
        NSString *isNeedToAppear = @"0";
        if (![albumDic[@"style"] isEqualToString:@"0"] && albumDic[@"style"]) {
           isNeedToAppear = @"1";
        }
        NSString *style = [NSString stringWithFormat:@"%@",albumDic[@"style"]?albumDic[@"style"]:@"0"];
        //判断是模特
        cell.hiddenFootView = NO;
        //判断主人态
        if (!_isMaster) {
            [cell.clickButton removeFromSuperview];
            [cell.rightArrow removeFromSuperview];
        }else{
            [cell addSubview:cell.clickButton];
            [cell addSubview:cell.rightArrow];
        }
        cell.supCon = self.controller;
        cell.indexpath = indexPath;
        NSNumber *boolNumber = [NSNumber numberWithBool:self.isMaster];
        NSDictionary *diction = nil;
        if (self.moKaMutArr.count>0) {
            diction = @{@"cardType":style,@"uid":self.currentUid,@"username":self.currentTitle,@"isNeedToAppear":isNeedToAppear,@"albums":self.albumsArray?:@[],@"imagesArr":albumDic[@"photos"]?albumDic[@"photos"]:@[],@"albumcount":self.albumcount,@"isModel":self.isModel,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei,@"isMaster":boolNumber,@"mokaListDic":self.moKaMutArr[indexPath.row - self.taoxiArray.count],@"mokaNumber":self.mokaNumber};
        }else{
            diction = @{@"cardType":style,@"uid":self.currentUid,@"username":self.currentTitle,@"isNeedToAppear":isNeedToAppear,@"albums":self.albumsArray?:@[],@"imagesArr":albumDic[@"photos"]?albumDic[@"photos"]:@[],@"albumcount":self.albumcount,@"isModel":self.isModel,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei,@"isMaster":boolNumber,@"mokaNumber":self.mokaNumber};
        }
        cell.hiddenFootView = NO;
        [cell initViewWithData:diction];
        cell.currentUid = self.currentUid;
        return cell;
    }
    
    //第三部分：新建模卡按钮、相册、描述单元格
    NewPersonalOneTableViewCell *cell = nil;
    NSString *identifier = @"NewPersonalOneTableViewCell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [NewPersonalOneTableViewCell getNewPersonalOneTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    if (_isMaster) {
        //主人态添加按钮
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count) {
            BuildNewMcTableViewCell *buildcell = [[[NSBundle mainBundle] loadNibNamed:@"BuildNewMcTableViewCell" owner:nil options:nil] lastObject];
            buildcell.supCon = self.controller;
            return buildcell;
        }

        NSInteger addJieShaoValue  = 1;
        NSInteger addJingYanvalue = 2;
        NSInteger addGongzuoShi = 3;
        //设置相册单元格
        if(self.xiangCeArray.count == 0){
            //没有相册
        }else{
            //返回相册单元格
            if (indexPath.row == self.taoxiArray.count + self.albumsArray.count+1){
                NSString *xiangCeCellID = @"xiangCeCellID";
                //XiangCeTableViewCell *xiangCeCell = [tableView dequeueReusableCellWithIdentifier:xiangCeCellID];
                XiangCeCollectionTableViewCell *xiangCeCell = [tableView dequeueReusableCellWithIdentifier:xiangCeCellID];

                if (xiangCeCell == nil) {
                    //xiangCeCell = [[XiangCeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangCeCellID];
                    xiangCeCell = [[XiangCeCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangCeCellID];

                    xiangCeCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                xiangCeCell.currentUID = self.currentUid;
                xiangCeCell.isMaster = self.isMaster;
                xiangCeCell.dataArray = self.xiangCeArray;
                xiangCeCell.superVC = self.controller;
                return xiangCeCell;            
            }
            
            addJieShaoValue = 2;
            addJingYanvalue = 3;
            addGongzuoShi = 4;
        }
        
        //个人介绍
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJieShaoValue) {
            NSString *title = @"个人介绍";
            NSString *content = self.jieshao;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            
            [cell initViewWithData:diction];
            return cell;
        }
        
        //工作经验
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJingYanvalue) {
            NSString *title = @"工作经验";
            NSString *content = self.jingyan;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            
            [cell initViewWithData:diction];
            return cell;
        }
        
        if (indexPath.row ==  self.taoxiArray.count + self.albumsArray.count + addGongzuoShi) {
            NSString *title = @"工作室";
            NSString *content = self.gongzuoshi;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            [cell initViewWithData:diction];
            return cell;
        }
        
    }else{
        //但前不是本人的情况下
        NSInteger addJieShaoValue  = 0;
        NSInteger addJingYanvalue = 1;
        NSInteger addGongzuoShi = 2;

        if(self.xiangCeArray.count == 0){
            
        }else{
            //返回相册单元格
            if (indexPath.row == self.taoxiArray.count + self.albumsArray.count){
               NSString *xiangCeCellID = @"xiangCeCellID";
               //XiangCeTableViewCell *xiangCeCell = [tableView dequeueReusableCellWithIdentifier:xiangCeCellID];
                XiangCeCollectionTableViewCell *xiangCeCell = [tableView dequeueReusableCellWithIdentifier:xiangCeCellID];

                if (xiangCeCell == nil) {
                    //xiangCeCell = [[XiangCeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangCeCellID];
                    xiangCeCell = [[XiangCeCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:xiangCeCellID];

                    xiangCeCell.selectionStyle = UITableViewCellSelectionStyleNone;

                }
                xiangCeCell.dataArray = self.xiangCeArray;
                xiangCeCell.superVC = self.controller;
                xiangCeCell.isMaster = self.isMaster;
                xiangCeCell.currentUID = self.currentUid;
                return xiangCeCell;
            }
            addJieShaoValue = 1;
            addJingYanvalue = 2;
            addGongzuoShi = 3;
        }

        //个人介绍
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count +addJieShaoValue) {
            NSString *title = @"个人介绍";
            NSString *content = self.jieshao;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            [cell initViewWithData:diction];
            return cell;
        }
        
        //工作经验
        if (indexPath.row == self.taoxiArray.count + self.albumsArray.count + addJingYanvalue) {
            NSString *title = @"工作经验";
            NSString *content = self.jingyan;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            
            [cell initViewWithData:diction];
            return cell;
        }
        //工作室
        if (indexPath.row ==  self.taoxiArray.count + self.albumsArray.count  + addGongzuoShi) {
            NSString *title = @"工作室";
            NSString *content = self.gongzuoshi;
            NSDictionary *diction = @{@"title":title,@"content":content,@"height":self.viewModel.height,@"weight":self.viewModel.weight,@"sanwei":self.viewModel.sanwei};
            [cell initViewWithData:diction];
            return cell;
        }

    }
    return nil;
}

#pragma mark  - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self scrollImage];
}


- (void)scrollImage {
    CGPoint offset = _controller.tableView.contentOffset;
    CGFloat y_offset = offset.y;
    CGRect cardRect =  CGRectMake(kDeviceWidth - 100 - 10, 10, 100, 32);;
    //身价
    CGRect personValueRect = _controller.headerView.personValueCtrol.frame;
    if (y_offset < 0) {
        CGRect rect =  _controller.headerView.backgroundImageView.frame;
        //        rect.origin.x = 0 + y_offset ;
        rect.origin.y = 0 + y_offset ;
        rect.size.height = 190 - y_offset;
        //rect.size.width = imageRect.size.width - y_offset;
        _controller.headerView.backgroundImageView.frame = rect;
        
        cardRect.origin.y = 10 + y_offset;
        _controller.headerView.MokaCardView.frame = cardRect
        ;
        //身价
        personValueRect.origin.y = 10+y_offset;
        _controller.headerView.personValueCtrol.frame = personValueRect;
    }
}


@end
