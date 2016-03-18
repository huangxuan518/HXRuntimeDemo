//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 黄轩 on 16/3/18.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import "Person.h"

@interface ViewController () <PersonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[self test1];
    
    [self test5];
}

/**
 *  获取一个类的全部成员变量名
 */
- (void)test1 {
    
    unsigned int count;
    
    //获取成员变量的结构体
    Ivar *ivars = class_copyIvarList([Person class], &count);

    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        //根据ivar获得其成员变量的名称
        const char *name = ivar_getName(ivar);
        //C的字符串转OC的字符串
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,key);
    }
    //记得释放
    free(ivars);
}

/**
 *  获取一个类的全部属性名
 */
- (void)test2 {
    unsigned int count;
    
    //获得指向该类所有属性的指针
    objc_property_t *properties = class_copyPropertyList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        //获得该类的一个属性的指针
        objc_property_t property = properties[i];
        //获取属性的名称
        const char *name = property_getName(property);
        //将C的字符串转为OC的
        NSString *key = [NSString stringWithUTF8String:name];

        NSLog(@"%d == %@",i,key);
    }
    //记得释放
    free(properties);
}

/**
 *  获取一个类的全部方法
 */
- (void)test3 {
    unsigned int count;
    //获取指向该类所有方法的指针
    Method *methods = class_copyMethodList([Person class], &count);
    
    for (int i = 0; i < count; i++) {
        //获取该类的一个方法的指针
        Method method = methods[i];
        //获取方法
        SEL methodSEL = method_getName(method);
        //将方法转换为C字符串
        const char *name = sel_getName(methodSEL);
        //将C字符串转为OC字符串
        NSString *methodName = [NSString stringWithUTF8String:name];
        
        //获取方法参数个数
        int arguments = method_getNumberOfArguments(method);
        
        NSLog(@"%d == %@ %d",i,methodName,arguments);
    }
    //记得释放
    free(methods);
}

/**
 *  获取一个类遵循的全部协议
 */
- (void)test4 {
    unsigned int count;
    
    //获取指向该类遵循的所有协议的指针
    __unsafe_unretained Protocol **protocols = class_copyProtocolList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        //获取该类遵循的一个协议指针
        Protocol *protocol = protocols[i];
        //获取C字符串协议名
        const char *name = protocol_getName(protocol);
        //C字符串转OC字符串
        NSString *protocolName = [NSString stringWithUTF8String:name];
        NSLog(@"%d == %@",i,protocolName);
    }
    //记得释放
    free(protocols);
}

/**
 *  归档/解档
 */
- (void)test5 {
    Person *person = [[Person alloc] init];
    person.name = @"黄轩";
    person.sex = @"男";
    person.age = 29;
    person.height = 175.1;
    person.education = @"本科";
    person.job = @"iOS工程师";
    person.native = @"湖北";
    
    NSString *path = [NSString stringWithFormat:@"%@/archive",NSHomeDirectory()];
    [NSKeyedArchiver archiveRootObject:person toFile:path];
    
    Person *unarchiverPerson = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    
    NSLog(@"unarchiverPerson == %@ %@",path,unarchiverPerson);
}

#pragma mark - PersonDelegate

- (void)personDelegateToWork {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
