//
//  MyClass.h
//  methodswizzling
//
//  Created by 张鑫 on 2018/12/3.
//  Copyright © 2018 com.6art.www. All rights reserved.
//

#import <Foundation/Foundation.h>

//-----------------------------------------------------------
// MyClass.h
@interface MyClass : NSObject <NSCopying, NSCoding>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;
- (void)method1;
- (void)method2;
+ (void)classMethod1;
@end
