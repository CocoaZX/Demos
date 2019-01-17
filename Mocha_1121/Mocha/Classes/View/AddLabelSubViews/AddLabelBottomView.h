//
//  AddLabelBottomView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/6.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddLabelBottomView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;
@property (weak, nonatomic) IBOutlet UITextField *contentTextfield;

@property (strong, nonatomic) UIButton *addNewLabelButton;

@property (strong, nonatomic) NSMutableArray *allLabelArray;

@property (strong, nonatomic) NSMutableArray *selectLabelArray;


@property (strong, nonatomic) NSMutableArray *buttonArray;

- (void)addLabelArray:(NSArray *)array;

+ (AddLabelBottomView *)getBottomView;

@end
