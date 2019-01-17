//
//  CommentView.h
//  Mocha
//
//  Created by 小猪猪 on 14/12/15.
//  Copyright (c) 2014年 renningning. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentView : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *commentTopHeader;

@property (strong, nonatomic) NSString *uid;

- (void)setCommentDataByPid:(NSString *)pid;

@end
