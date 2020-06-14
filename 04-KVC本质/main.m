//
//  main.m
//  04-KVC本质
//
//  Created by 刘光强 on 2020/2/4.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"
#import "CustomObserver.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        
        // 创建一个监听者对象
        CustomObserver *observer = [[CustomObserver alloc] init];
        
        // 添加KVO监听
        [person addObserver:observer forKeyPath:@"age" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:@"111"];
        
        // KVC设置值
        [person setValue:@(20) forKey:@"age"];
        
        NSLog(@"---%@",[person valueForKey:@"age"]);
        
        // 移除监听
        [person removeObserver:observer forKeyPath:@"age"];
    }
    return 0;
}
