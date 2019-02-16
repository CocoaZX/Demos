//
//  ViewController.m
//  testDynamic
//
//  Created by 张鑫 on 2018/5/8.
//  Copyright © 2018年 CrowForRui. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "EOCSubClass.h"

@interface ViewController ()

id autoDictionaryGetter(id self, SEL _cmd);
void autoDictionarySetter(id self, SEL _cmd, id value);


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    id genericTypedString = @"Some string";
    EOCSubClass *class = [[EOCSubClass alloc] init];

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//+ (BOOL)resolveInstanceMethod:(SEL)selector{
//    NSString *selectorString = NSStringFromSelector(selector);
//    if([selectorString hasPrefix:@"set"]){
//        class_addMethod(self,
//                        selector,
//                        (IMP)autoDictionarySetter,
//                        "V@:@");
//         return YES;
//    }else{
//        class_addMethod(self,
//                        selector,
//                        (IMP)autoDictionaryGetter,
//                        "@@:");
//         return YES;
//    }
//    return [super resolveInstanceMethod:selector];
//}

void fooMethod(id obj, SEL _cmd)
{
    NSLog(@"Doing foo");
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = invocation.selector;
    
//    if([alternateObject respondsToSelector:sel]) {
//        [invocation invokeWithTarget:alternateObject];
//    }
//    else {
//        [self doesNotRecognizeSelector:sel];
//    }
}

//+ (BOOL)resolveInstanceMethod:(SEL)aSEL
//{
//    if(aSEL == @selector(foo:)){
//        class_addMethod([self class], aSEL, (IMP)fooMethod, "v@:");
//        return YES;
//    }
//    return [super resolveInstanceMethod:aSEL];
//}
//
//- (id)forwardingTargetForSelector:(SEL)aSelector
//{
//    if (aSelector == @selector(sendMessage:)) {
//        return [ViewController new];
//    }
//    return nil;
//}



@end
