# 团队工作记录

成员:李喆昊 袁旷 杨舒静

## 学习过程
- [ ] 了解lab3-1框架及实验目标
- [ ] 确定全局变量
- [ ] 分工
- [ ] coding
- [ ] 测试及调试
- [ ] 报告

## 讨论1: 预备讨论

时间：11.6 17:30~18:30
地点：芳华
参与者：李喆昊 袁旷 杨舒静
主题：确定完成实验的时间
结果: 在11.15晚(*左右*)进行第二次会议, 会议前小组成员应熟知lab3-1的实验框架、明确基本的实验内容

### 讨论2
时间：11.6 15:30~18:30
地点：研讨室208
参与者：李喆昊 袁旷 杨舒静
主题：熟悉实验框架，确定实验分钟
结果: 实验方案

#### 实验方案

##### 实验总体框架
在本次实验运行`cminus_builder.cpp`将AST, 利用llvm c++ api转换为中间代码。
主类是`CminusBuilder`, 在`cminus_builder.hpp`中提供了一部分的generator代码可供参考。注意到，在该函数中即是一开始进入了全局范围。

##### 共享变量
1. 全局变量`ret`
   1. 对于`expression`型变量，将计算所得的值放入`ret`中， 待下一次需要用到的时候保存下来; 参照`syntax_call`中ret的使用
   2. 暂时还没有考虑需要共享的情况(此部分实现中还没有考虑到其他共享的情况)

#### Scope函数
Scope函数主要是用于维护不同作用域下的符号表。(具体接口如`design.md`所示)

在本次实现维护该符号表的想法如下:
- 在有declaration时，CreateAlloca分配内存空间`pAlloc`
- 将`<id, pAlloc>`加入符号表
- 进入函数时`scope.enter()`
- 退出函数域时`scope.exit()`并将函数的二元组加入符号表供`call`调用

#### Accpet函数
在访问者模式下，助教的框架已经构建好了AST, 同时在`transform`(`syntax_tree.cpp`文件)中已经将各个结构体的成员变量初始化完成。Accept函数中即是对各个成员变量按照展开式语义进行操作, 如对于变量声明即是插入二元组进入符号表、调用子节点的accept函数等。

### 过程描述

#### 需要尽快达成统一的问题
若在实验过程中碰到问题(i.e. 需要重新定义接口、碰到疑难杂症难以解决的bug、等待测试等)请尽快在群聊中沟通并提交到此部分以确保其他人在后续开发中熟知仓库中的此变化

1. sjyang: 在声明数组时应当将id的类型设置为`ARRAY`还是`PTR`
2. sjyang: 在参数函数参数的模块`syntax_param`中, 对数组变量定义了`isArray`的变量，没有定义数组长度。在`syntax_declaration`中没有定义`isArray`但定义了num。

#### 完成情况
请在各自分支下开发，并将测试完成的部分merge到master分支


- [x] syntax_program: sjyang
- [x] syntax_num: sjyang
- [ ] syntax_var_declaration: sjyang **TODO**
- [x] syntax_fun_declaration: sjyang
- [x] syntax_param: sjyang
- [x] syntax_compound_stmt: sjyang
- [x] syntax_expresion_stmt: sjyang
- [ ] syntax_selection_stmt
- [ ] syntax_iteration_stmt
- [ ] syntax_return_stmt: sjyang **TODO**
- [ ] syntax_var: 
- [ ] syntax_assign_expression
- [ ] syntax_simple_expression: sjyang **TODO**
- [ ] syntax_additive_expression: sjyang **TODO**
- [ ] syntax_term: sjyang **TODO**
- [x] syntax_call: sjyang


##### 2019116 sjyang(目前在sjyang分支下)
这部分实现中主要考虑了以下样例中的功能, 具体涉及的模块如checklist所示。整体上包括调用函数，参数传递，基本表达式。
```cpp
void call(int a, int b){
    return ;
}
void main(void){
    call(10, 20);
    return ;
}
```


各个模块间相互调用关系如下所示。
```
program
--fun-declaration: call
----param: a
----param: b
----compound-stmt
------return-stmt: void
--fun-declaration: main
----compound-stmt
------expression-stmt
--------simple-expression
----------additive-expression
------------term
--------------call: call()
----------------simple-expression
------------------additive-expression
--------------------term
----------------------num: 10
----------------simple-expression
------------------additive-expression
--------------------term
----------------------num: 20
------return-stmt: void
```

**TODO**中的没有解决的部分有两种情况: 
- 产生式右部有多个选择时, 比如在`// additive-expression → additive-expression addop term | term `中为了尽快验证结果，只解决了第二种展开式
- 在变量声明`syntax_var`中, 没有解决全局变量和数组的情况

TIPS: 
- 在实现过程中可以首先参考`gcd_generator.cpp`的实现, 结合产生式将每产生式动作放进对应的模块中
- 可以通过自动补全的功能(如`node.xx`)成员变量的引用来快读获知该类所继承的所有成员变量
- 可以通过vscode `TODO`插件查找所有TODO项

##### 测试样例1: foo.cminus
主要用于测试函数定义、函数调用、参数传递、简单表达式
```cpp
void call(int a, int b){
    return ;
}
void main(void){
    call(10, 20);
    return ;
}
```

### docs

[这篇中有一些全局变量的使用方法]](https://gist.github.com/alloy/d86b007b1b14607a112f)