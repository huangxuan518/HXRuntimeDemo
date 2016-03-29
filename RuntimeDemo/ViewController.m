//
//  ViewController.m
//  RuntimeDemo
//
//  Created by 黄轩 on 16/3/18.
//  Copyright © 2016年 黄轩 blog.libuqing.com. All rights reserved.
//

#import "ViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "Person.h"
#import "UILabel+Associate.h"
#import "NSMutableArray+Extension.h"

@interface ViewController () <PersonDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self test10];
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

/**
 *  动态添加方法
 */
- (void)test6 {
    Person *person = [Person new];
    [person performSelector:@selector(run)];
}

/**
 *  动态添加属性
 */
- (void)test7 {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 100, 30)];
    [label setFlashColor:[UIColor redColor]];
    [self.view addSubview:label];
}

/**
 *  方法交换
 */
- (void)test8 {

    //通过runtime的method_exchangeImplementations(Method m1, Method m2)方法，可以进行交换方法的实现；一般用自己写的方法（常用在自己写的框架中，添加某些防错措施）来替换系统的方法实现，常用的地方有：
    
    //在数组中，越界访问程序会崩，可以用自己的方法添加判断防止程序出现崩溃数组或字典中不能添加nil，如果添加程序会崩，用自己的方法替换系统防止系统崩溃
    
    NSMutableArray *ary = [NSMutableArray new];
    [ary addObject:nil];
    [ary addObject:@"字符串"];
    
    NSLog(@"%@",ary);
}

/**
 *  消息
 */
- (void)test9 {
    Person *person = [Person new];
    objc_msgSend(person,@selector(work));
}

/**
 *  二分查找法
 */
- (void)test10 {
    int arr[] = {0,1,2,3,5,4,6,7,8,9,10};
    int length = sizeof(arr) / sizeof(arr[0]);
    
    
    int i;
    int j;
    int temp;
    for (i = 0;i < length;i++) {
        for (j = 0;j < length-i;j++) {
            if (arr[j] > arr[j+1]) {
                temp = arr[j+1];
                arr[j+1] = arr[j];
                arr[j] = temp;
            }
        }
    }

    int value = 5;
    int index = search(arr, length, value);
    if (index < 0) {
        NSLog(@"未找到");
    } else {
        printf("值:%d 位置:%d \n",value,index);
    }
}

int search(int arr[],int length,int value) {
    int startIndex = 0;
    int middleIndex;
    int endIndex = length - 1;
    
    while (startIndex <= endIndex) {
        
        middleIndex = (startIndex + endIndex)/2;

        int currentValue = arr[middleIndex];
        if (value == currentValue) {
            return middleIndex;
        } else {
            if (value < currentValue) {
                endIndex = middleIndex - 1;
            } else {
                startIndex = middleIndex + 1;
            }
        }
    }
    return -1;
}

#pragma mark - PersonDelegate

- (void)personDelegateToWork {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
