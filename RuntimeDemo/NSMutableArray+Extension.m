//
//  NSMutableArray+Extension.m
//  RuntimeDemo
//
//  Created by Wyman Chen on 2017/3/24.
//  Copyright © 2017年 NotesOfYouth. All rights reserved.
//

#import "NSMutableArray+Extension.h"

@implementation NSMutableArray (Extension)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(addObject:));
    Method newMethod = class_getInstanceMethod(NSClassFromString(@"__NSArrayM"), @selector(OW_AddObject:));
    
    //交换方法
    method_exchangeImplementations(originalMethod, newMethod);
}

- (void)OW_AddObject:(id)object
{
    if (object != nil) {
        [self OW_AddObject:object];
    }
}

@end
