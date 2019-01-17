//
//  NewFeedbackCellTwoTableViewCell.h
//  Mocha
//
//  Created by 小猪猪 on 16/4/24.
//  Copyright © 2016年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewFeedbackCellTwoTableViewCell : UITableViewCell<UITextViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *backView;

@property (weak, nonatomic) IBOutlet UITextView *textView;


+ (NewFeedbackCellTwoTableViewCell *)getNewFeedbackCellTwoTableViewCell;



@end
