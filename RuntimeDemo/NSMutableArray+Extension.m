//
//  NSMutableArray+Extension.m
//  RuntimeDemo
//
//  Created by 黄轩 on 16/3/21.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "NSMutableArray+Extension.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Extension)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method oldMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
        Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addSafeObject:));
        //交换方法
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

//自己写的方法
- (void)addSafeObject:(id)anObject {
    if (anObject != nil) {
        [self addSafeObject:anObject];
    } else {
        NSLog(@"数组不能添加空对象");
    }
}

@end
