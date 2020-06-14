//
//  Person.h
//  04-KVC本质
//
//  Created by 刘光强 on 2020/2/4.
//  Copyright © 2020 guangqiang.liu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject
{
    @public;
    int age;
    int isAge;
    int _isAge;
    int _age;
}
@end

NS_ASSUME_NONNULL_END
