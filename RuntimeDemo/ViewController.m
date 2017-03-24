//
//  ViewController.m
//  RuntimeDemo
//
//  Created by Wyman Chen on 2017/3/24.
//  Copyright © 2017年 NotesOfYouth. All rights reserved.
//

#import "ViewController.h"
#import "OWModel.h"
#import "NSMutableArray+Extension.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *MArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /*
     
     1. 什么是runtime?
     -- runtime是一套底层的C语言API，包含很多强大实用的C语言数据类型和C语言函数，平时我们编写的OC代码，底层都是基于runtime实现的。例如[target doSomething];会被转化成objc_msgSend(target, @selector(doSomething));。
     
     2.runtime的作用有哪些？
     -- 能动态产生一个类，一个成员变量，一个方法
     -- 能动态修改一个类，一个成员变量，一个方法
     -- 能动态删除一个类，一个成员变量，一个方法
     
     3.常用的头文件
     -- #import <objc/runtime.h> 包含对类、成员变量、属性、方法的操作
     -- #import <objc/message.h> 包含消息机制
     
     4.常用方法
     -- class_copyIvarList（）返回一个指向类的成员变量数组的指针
     -- class_copyPropertyList（）返回一个指向类的属性数组的指针
     [注意：根据Apple官方runtime.h文档所示，上面两个方法返回的指针，在使用完毕之后必须free()。]
     -- ivar_getName（）获取成员变量名-->C类型的字符串
     -- property_getName（）获取属性名-->C类型的字符串
     -------------------------------------
     typedef struct objc_method *Method;
     -- class_getInstanceMethod（）
     -- class_getClassMethod（）以上两个函数传入返回Method类型
     ---------------------------------------------------
     -- method_exchangeImplementations（）交换两个方法的实现
     
     5.runtime在开发中的用途
     -- 动态的遍历一个类的所有成员变量，用于字典转模型,归档解档操作
     代码如下：- (void)getAllNames; 
             - (void)getAllProperties;
     
     -- 交换方法
        通过runtime的method_exchangeImplementations(Method m1, Method m2)方法，可以进行交换方法的实现；一般用自己写的方法（常用在自己写的框架中，添加某些防错措施）来替换系统的方法实现，常用的地方有：
        在数组中，越界访问程序会崩，可以用自己的方法添加判断防止程序出现崩溃数组或字典中不能添加nil，如果添加程序会崩，用自己的方法替换系统防止系统崩溃
            - (void)methodExchangeTest;
     */
    
    [self getAllNames];
    
    [self getAllProperties];
    
    [self methodExchangeTest];
}

/** 利用runtime遍历一个类的全部成员变量
 1.导入头文件<objc/runtime.h>     */
- (void)getAllNames
{
    unsigned int count = 0;
    /** Ivar:表示成员变量类型 */
    Ivar *ivars = class_copyIvarList([OWModel class], &count);//获得一个指向该类成员变量的指针
    for (int i =0; i < count; i ++) {
        //获得Ivar
        Ivar ivar = ivars[i];        //根据ivar获得其成员变量的名称--->C语言的字符串
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"1: %d----%@",i,key);
    }
    
    free(ivars);
}

/*获取一个类的全部属性*/
- (void)getAllProperties
{
    unsigned int count = 0;
    //获取指向该类的所有属性的指针
    objc_property_t *properties = class_copyPropertyList([OWModel class], &count);
    for (int i = 0; i < count; i ++) {
        //获得
        objc_property_t property = properties[i];
        const char *name = property_getName(property);
        NSString *key = [NSString stringWithUTF8String:name];
        NSLog(@"2: %d----%@",i ,key);
    }
    
    free(properties);
}

- (void)methodExchangeTest
{
    _MArray = [NSMutableArray array];
    [_MArray addObject:@"Owen"];
    [_MArray addObject:@"Harold"];
    [_MArray addObject:nil];//不会报错，因为这个方法在被替换了，新方法中对是否是nil做了判断
    
    NSLog(@"--:%@",_MArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
