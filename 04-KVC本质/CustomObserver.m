//
//  CustomObserver.m
//  04-KVC本质
//
//  Created by 刘光强 on 2020/2/4.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import "CustomObserver.h"

@implementation CustomObserver

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"observeValueForKeyPath: 监听到KVO:%@",change);
    
    /**
     observeValueForKeyPath: 监听到KVO:{
         kind = 1;
         new = 20;
         old = 0;
     }
     */
}
@end
