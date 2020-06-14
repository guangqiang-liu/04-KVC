# KVC本质

> `KVC`的全称是Key-Value Coding，俗称"键值编码"，可以通过一个key来访问某个属性

KVC的本质是什么？，KVC的赋值和取值的过程是怎样的？

我们先创建一个工程，来看下`KVC`的基本用法

```
#import <Foundation/Foundation.h>
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        
        // 平时使用属性来设置和访问值
        person.age = 10;
        NSLog(@"--%d", person.age);
        
        // 使用KVC来设置和访问值
        [person setValue:@(20) forKey:@"age"];
        NSLog(@"--%d", [[person valueForKey:@"age"] intValue]);
    }
    return 0;
}
```

`KVC`的用法很简单，常用的就下面四个方法：

```
- (void)setValue:(id)value forKeyPath:(NSString *)keyPath;
- (void)setValue:(id)value forKey:(NSString *)key;
- (id)valueForKeyPath:(NSString *)keyPath;
- (id)valueForKey:(NSString *)key; 
```

现在我们修改下`Person`类的代码如下：

```
@interface Person : NSObject

@end

@implementation Person

- (void)setAge:(int)age {
    NSLog(@"---%d", age); // 打印出20
}
@end
```

`main.m`文件代码如下：

```
int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        
        Person *person = [[Person alloc] init];
        [person setValue:@(20) forKey:@"age"];
    }
    return 0;
}
```

从上面的打印我们可以看出，即使我们没有在`Person`类中定义任何`age`属性，但是在`Person`类中，我们还是可以成功调用`setAge:`方法，这是为什么尼？

因为执行`[person setValue:@(20) forKey:@"age"];`这行代码后，程序就会在`Person`类中按下图顺序查找一系列方法，查找逻辑如下图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200204-145201@2x.png)

我们在来看如果使用`KVC`修改成员变量的值，是否能够触发`KVO`监听？

我们创建一个`CustomObserver`类用来充当KVO的监听者，代码如下：

```
@interface CustomObserver : NSObject

@end

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
```

`Person`类中修改代码如下：

```
@interface Person : NSObject
{
    @public;
    int age;
    int isAge;
    int _isAge;
    int _age;
}
@end

@implementation Person

@end
```

`main.m`中修改代码如下：

```
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
        
        // 移除监听
        [person removeObserver:observer forKeyPath:@"age"];
    }
    return 0;
}
```

从上面`Person`类中的代码可以看出，我们并没有申明`Int age`属性，也没有实现`setAge:`方法，那怎么还是打印了`observeValueForKeyPath:`尼？

这是因为当执行`[person setValue:@(20) forKey:@"age"];`这句代码，在`setValue: forKey:`方法内部相当于手动触发`KVO`如下：

```
[person willChangeValueForKey:@"age"];
person -> _age = 20;
[person didChangeValueForKey:@"age"];
```

这时我们修改`Person`类的.m文件代码如下：

```
@implementation Person

- (void)willChangeValueForKey:(NSString *)key {
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey:");
}

- (void)didChangeValueForKey:(NSString *)key {
    NSLog(@"didChangeValueForKey:---begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey:---end");
}
@end
```

我们发现程序正常打印了上面两个方法，这也证明了在`setValue: forKey:`方法内部确实执行了`willChangeValueForKey:`和`didChangeValueForKey:`方法

我们在来看下`KVC`调用`valueForKey:`方法获取值的流程

`KVC`通过一个`key`获取值的流程和赋值的流程很像，也是顺序查找一系列方法来获取值，顺序查找方法的逻辑如下图所示：

![](https://imgs-1257778377.cos.ap-shanghai.myqcloud.com/QQ20200204-153643@2x.png)


讲解Demo地址：[](https://github.com/guangqiang-liu/04-KVCDemo)


## 更多文章
* ReactNative开源项目OneM(1200+star)：**[https://github.com/guangqiang-liu/OneM](https://github.com/guangqiang-liu/OneM)**：欢迎小伙伴们 **star**
* 简书主页：包含多篇iOS和RN开发相关的技术文章[http://www.jianshu.com/u/023338566ca5](http://www.jianshu.com/u/023338566ca5) 欢迎小伙伴们：**多多关注，点赞**
* ReactNative QQ技术交流群(2000人)：**620792950** 欢迎小伙伴进群交流学习
* iOS QQ技术交流群：**678441305** 欢迎小伙伴进群交流学习