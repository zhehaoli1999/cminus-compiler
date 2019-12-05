# lab3-2实验报告

杨舒静 PB17151774

袁旷 PB17081543

李喆昊 PB17050941

## 实验要求

了解 LLVM Pass 相关的基础知识（包括 Pass 的类型，接口与使用方法），尝试构造能被优化的 LLVM IR 代码，用所选的 Pass 对代码进行优化，找出被优化的部分并说明 Pass 的行为。最后阅读所选 Pass 的源代码，理解该 Pass 优化的流程并叙述。

## 报告内容 

### 集合1 —— dce

#### 1. Pass 的类型与作用

`DCE` 按功能划分属于`Tranform Pass`，按子类进行划分属于 `Function Pass`，它的作用是对函数进行遍历，删除函数中的死代码。

#### 2. 用 Pass 进行优化的实例说明

源 LLVM IR:

```l
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  %4 = add nsw i32 %3, 1
  %5 = load i32, i32* %2, align 4
  ret i32 %5
}
```

可以看到，函数体内的第五第六行关于 %3，%4 的两条代码是死代码，即 %3，%4 被创建之后并不会被再次引用，这两行代码并不影响程序执行结果。

使用 DCE 优化后的 LLVM IR:

```
define dso_local i32 @main() {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  store i32 0, i32* %1, align 4
  store i32 0, i32* %2, align 4
  %3 = load i32, i32* %2, align 4
  ret i32 %3
}
```

可以看到，通过 DCE Pass 的作用，上述两条死代码成功被删除，程序得到优化。

#### 3. Pass 流程叙述

该结构体`DECLegacyPass`中包含三个函数：

- `initializeDCELegacyPassPass`的作用是 Pass 运行前的初始化。
- `getAnalysisUsage`的作用是获取其他 Pass 的分析信息，保证与其他 Pass 进行交互的正确性
- `runOnFunction`是 Pass 运行的主要函数，通过对 LLVM IR 代码中的函数进行遍历，删除死代码。

下面主要对 `runOnFunction`函数的流程进行说明。

在`runOnFunction`函数中，将所需分析的函数 F 传入 `eliminateDeadCode`函数中，进行死代码删除，流程为：

1. 对函数中的每一条指令进行遍历，每当发现一条死指令时，就检查与该指令的每一个操作数相关的其他指令，若这些指令也是死指令，那就把它们放入一个向量`WorkList`中保存，最后将当前遍历的这条死指令删除。
2. 在对函数中的指令遍历时，检查当前遍历的指令是否在`WorkList`中，若是，则跳过（这些指令最后被集中处理，不必重复操作）。
3. 在对函数遍历完成后，对`WorkList`中的指令进行再进行 1 中的操作（检查该指令相关的其他指令是否为死指令，若是则放入`WorkList`中，最后把自身删除），直至`WorkList`为空。

### 集合2 —— adce

#### 1. Pass 的类型与作用

`ADCE` 按功能划分属于`Tranform Pass`，按子类进行划分属于 `Function Pass`，它的作用是对函数进行遍历，以更加激进的方式删除函数中的死代码。它先假定所有指令都是死的，直到某一指令被证明不是死指令。相比于 `DCE`，`ADCE`能删除更多死的计算指令，尤其是在循环计算中。

#### 2. 用 Pass 进行优化的实例说明



#### 3. Pass 流程叙述



## 实验总结

此次实验有什么收获

## 实验反馈

对本次实验的建议（可选 不会评分）
