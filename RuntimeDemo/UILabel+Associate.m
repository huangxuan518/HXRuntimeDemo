//
//  UILabel+Associate.m
//  RuntimeDemo
//
//  Created by 黄轩 on 16/3/21.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "UILabel+Associate.h"
#import <objc/runtime.h>

@implementation UILabel (Associate)

static char flashColorKey;

- (void)setFlashColor:(UIColor *)flashColor {
    objc_setAssociatedObject(self, &flashColorKey, flashColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)getFlashColor {
    return objc_getAssociatedObject(self, &flashColorKey);
}

@end
