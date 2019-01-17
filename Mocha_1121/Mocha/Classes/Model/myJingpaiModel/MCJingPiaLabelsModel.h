//
//  MCJingPiaLabelsModel.h
//  Mocha
//
//  Created by yfw－iMac on 16/4/19.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import "BaseJsonModel.h"

@class JingPiaLabelModel;
@interface MCJingPiaLabelsModel : BaseJsonModel

@property (retain,nonatomic) JingPiaLabelModel *data;


@end

@protocol JingPiaLabelItemModel;
@interface JingPiaLabelModel : BaseJsonModel

@property (retain,nonatomic) NSArray<JingPiaLabelItemModel> *tagList;

@end

@interface JingPiaLabelItemModel : BaseJsonModel

@property (retain,nonatomic) NSString *tag_id;
@property (retain,nonatomic) NSString *uid;
@property (retain,nonatomic) NSString *tag_name;
@property (retain,nonatomic) NSString *labelstatus;
@property (retain,nonatomic) NSString *update_time;
@property (retain,nonatomic) NSString *tag_type;
@property (retain,nonatomic) NSString *create_time;
@property (retain,nonatomic) NSString *is_custom;

@end
