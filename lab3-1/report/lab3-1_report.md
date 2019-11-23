# lab3-1实验报告

小组成员 姓名 学号

## 实验要求

请按照自己的理解，写明本次实验需要干什么

## 实验难点
1. 理解代码框架，熟悉llvm c++API
2. 如何设计全局变量
3. selection语句中由于产生新的`terminator`所产生的有关basic block的问题
4. 如何将数组传入函数中
5. 如何声明和访问全局变量

## 实验设计

### 对代码框架的理解
在本次实验运行`cminus_builder.cpp`将AST, 利用llvm c++ api转换为中间代码。
主类是`CminusBuilder`, 在`cminus_builder.hpp`中提供了一部分的generator代码可供参考。注意到，在该函数中即是一开始进入了全局范围。

#### 如何控制变量作用域(Scope函数)
Scope函数主要是用于维护不同作用域下的符号表。(具体接口`design.md`所示)

在本次实现维护该符号表的想法如下:
- 在有declaration时，CreateAlloca分配内存空间`pAlloc`
- 将`<id, pAlloc>`加入符号表
- 进入函数时`scope.enter()`
- 考虑到函数中存在嵌套调用的情况，需要在定义`Funcbb`后`scope.exit()`并将函数的二元组加入符号表供`call`调用
- 在函数结束时`scope.exit()`
其中对于数组类型，由于在数组越界的检查中只需检查下界而无需检查上界，因而只需要将`ArrayType`的值压入符号表即可

#### Accpet函数
在访问者模式下，助教的框架已经构建好了AST, 同时在`transform`(`syntax_tree.cpp`文件)中已经将各个结构体的成员变量初始化完成。Accept函数中即是按照对AST的自顶向下遍历，对各个成员变量按照展开式语义进行操作, 如对于变量声明即是插入二元组进入符号表、调用子节点的accept函数等。


### 全局变量的设计
1. `Value* ret`
   1. 对于`expression`型变量，将计算所得的值放入`ret`中， 待下一次需要用到的时候保存下来; 参照`syntax_call`中ret的使用


### 实验总结

此次实验有什么收获

### 实验反馈

对本次实验的建议（可选 不会评分）
