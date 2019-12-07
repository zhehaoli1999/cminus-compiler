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

**激进地删除死代码：给定程序先认为所有块均为死代码，初始化其中一定为活的块(如入口块等), 迭代地找到所有可以证明可能为活的块, 直到不再能找到新的活的块。在程序的最后删除除活的块以外的块**



## 关键变量及所设计的概念
1. **PDT**(post dominance tree): 指后向支配树。其以`Exit Program`的节点为根
2. **WorkList**: 已知为活的指令集合，有待标记其定值指令(及$\Phi$节点为活)为活
3. **BlobcksWithDeadTerminator**: 目前没有发现有live terminator 的BasicBlock
4. **DEAD terminator**: 指程序**一定不会**达到的terminator 
5. **LIVE terminator**: 指程序**可能**到达的terminator 
6. **A dead region**: 
   1. > the set of dead blocks with a common live post-dominator. 
   2. 含有共同活后继支配块的死块集合

### 分析
1. 为什么需要分别维护`DEAD terminator` 和`DEAD Block`
// TODO:



## 总体框架
与其他pass类相同，主要需要重载以下三个函数。在优化过程中顺序调用
//TODO: 补充每个函数的主要思想
1. Initialization()
2. markLiveInstructions()
3. removeDeadInstructions()

以下将分别介绍三个函数的主要含义，具体步骤以及分析其中一些步骤需要执行的原因。

### 主要函数1:Initialization
1. 初始化阶段认为是live的terminator
   1. // TODO: isAlwaysAlive的节点
   2. 认为是含有return的bb是live(这个在isAlwayslive中已经标注)
   3. 其他PDT的第一层孩子bb(即到PDT的不是无条件跳转的)的孩子全部为live
   4. 不含无条件跳转的entrybb是live
   5. 
2. 记录的信息
   1. 记录其terminator的类别
   2. 标记是否是UncondBr

#### 分析
1. 初始化时为什么需要将PDT第一层不含有无条件跳转的孩子块标记为live ?
   第一层孩子指可以exit program的
   而对于有条件跳转的块
2. 为什么需要将回边标记为live ?
// TODO:



### 主要函数2: markLiveInstructions
对worklist进行迭代处理，分别标记数据流和控制流中的活指令，具体步骤如下
1. 取出一个worklist, 将其中所有操作数的定值指令标记为live，将其涉及的$\Phi$指令标记为live
2. 不断重复`1`直到没有新增的worklist
3. 根据控制流的依赖关系，标记控制流中的活分支(`markLiveBranchesFromControlDependences`)

#### markLiveBranchesFromControlDependences
该函数总体利用后向推理，要义是：迭代地考虑NewLiveBlocks, 找到依赖的控制流块(即在控制流中为其支配的块)，则标记为live(相关注释如下所示)。可以发现如果一个块为live，即程序可能执行到该处，则其控制依赖的块也可能执行到该处，则通过这种思想则可以根据初始化中判断的常活(isAlwaysLive)的块后向推理出活块。

>The dominance frontier of a live block X in the reversecontrol graph is the set of blocks upon which X is controldependent. 
>The following sequence computes the set of blockswhich currently have dead terminators that are controldependence sources of a block which is in NewLiveBlocks.


NewLiveBlocks指在初始化和数据流分析过程中新发现的活块; 将块加入NewLiveBlocks集合的情况有以下两种
  - UD链中标记定值语句所在的块为NewLiveBlock
  - 将含有PhiNode的块的所有前驱块均NewLiveBlock

实例化一个`ReverseIDFCalculator`计算器, 利用它计算当前NewLiveBlock的控制支配前驱(dominance frontier)。具体步骤如下

1. 将当前NewLiveBlocks初始化给计算器
2. 计算NewLiveBlocks中在控制流上依赖的块，存放在IDFBlocks中
3. 清除NewLiveBlocks
4. 将IDFBlocks中的块的终结符标记为live, 并加入NewLiveBlocks(检查原来是否是活块，避免重复加入)

##### 分析
在最后一步中标记终结符为live时，如果该终结符是非条件跳转语句会触发将其所在的块所有后继块全部标记为活的操作，即将其将其加入NewLiveBlocks。在函数的哪一部分迭代计算了NewLiveBlocks的控制前驱？

### 主要函数3: removeDeadInstructions
由于死代码的删除可能涉及控制流语句，故需要找到在控制流图中与含有死终结符的块相关的块(如其后继), 重写其相关的控制流图(control flow graph), 以确保在删除相关死代码后，控制流可正常跳转。以上操作主要封装在`updateDeadRegions`函数中



#### updateDeadRegions
此时，程序已经标记所有活块，则当前仍然含有死终结符的块一定为为死块。如果在保证控制流逻辑不变的情况下删除该部分的死块需要考虑
// TODO: 涉及死终结符和死块

基于以上分析，该函数完成了以下操作
1. 遍历所有含有死终结符的块
2. 如果该块的终结符是无条件跳转语句，则将其直接标记为活，并return。如果不是继续执行以下步骤
3. 找到后序意义上最近的后继, 创建一条无条件跳转到该块的指令，并将该指令标记为活
4. 告知其在PDT上的所有孩子节点，该前驱为死(使得该孩子块中的PhiNode知道应该选择哪个值)
5. 删除块到孩子块的边(除了该块到最大后继的块)


##### 分析
// TODO:
1. 为什么如果块含有无条件跳转终结符，则直接将该终结符标记为活并跳过剩余步骤？
   考虑无条件跳转终结符, 其自然地符合了上述步骤，因而不需要重复操作。
   



## 实验总结

此次实验有什么收获

## 实验反馈

对本次实验的建议（可选 不会评分）
