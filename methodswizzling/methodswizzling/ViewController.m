//
//  ViewController.m
//  methodswizzling
//
//  Created by 张鑫 on 2018/11/30.
//  Copyright © 2018 com.6art.www. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "MyClass.h"
#import "MySubClass.h"

@interface ViewController ()
{
    
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self testMethod];
    SEL sel1 = @selector(testMethod);
    NSLog(@"sel : %p", sel1);
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)testMethod{
    MyClass *myClass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myClass.class;
    // 类名
    NSLog(@"class name: %s", class_getName(cls));
    NSLog(@"==========================================================");
    // 父类
    NSLog(@"super class name: %s", class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    // 是否是元类
    NSLog(@"MyClass is %@ a meta-class", (class_isMetaClass(cls) ? @"" : @"not"));
    NSLog(@"==========================================================");
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s's meta-class is %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    // 变量实例大小
    NSLog(@"instance size: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    // 成员变量,包含属性等
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"instance variable's name: %s at index: %d", ivar_getName(ivar), i);
    }
    free(ivars);
    Ivar string = class_getInstanceVariable(cls, "_integer");
    if (string != NULL) {
        NSLog(@"instace variable %s", ivar_getName(string));
    }
    NSLog(@"==========================================================");
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    free(properties);
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"method's signature: %s", method_getName(method));
    }
    free(methods);
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    NSLog(@"==========================================================");
    // 协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    NSLog(@"==========================================================");
    
    float a[] = {1.0, 2.0, 3.0};
    NSLog(@"array encoding type: %s", @encode(typeof(a)));
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(mrc_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            //被替换的方法是父类实现的，class_addMethod添加成功.class_getInstanceMethod返回的Method就是父类的实现。需要替换父类的方法
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            //被替换的方法如果本类实现了，class_addMethod就不会成功.class_getInstanceMethod返回的Method就是本类的实现。直接替换
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

//关联对象
//- (void)setTapActionWithBlock:(void (^)(void))block
//{
//    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kDTActionHandlerTapGestureKey);
//
//    if (!gesture)
//    {
//        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
////        [self addGestureRecognizer:gesture];
//        objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
//    }
//    objc_setAssociatedObject(self, &kDTActionHandlerTapGestureKey, block, OBJC_ASSOCIATION_COPY);
//}
//
//- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
//{
//    if (gesture.state == UIGestureRecognizerStateRecognized)
//    {
//        void(^action)(void) = objc_getAssociatedObject(self, &kDTActionHandlerTapBlockKey);
//        if (action)
//        {
//            action();
//        }
//    }
//}

#pragma mark - Method Swizzling

- (void)mrc_viewWillAppear:(BOOL)animated {
    [self mrc_viewWillAppear:animated];
//    [MobClick beginLogPageView:NSStringFromClass([self class])];
}

@end
