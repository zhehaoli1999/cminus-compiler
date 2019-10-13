# lab2 report 
PB17151774 杨舒静

## 实验内容
利用bison语法分析器生成分析树

## 实现设计
### 移进-归约冲突解决
通过bison 编译中产生的`OUTPUT`报告, 可以知道`C_MINUS`语法中存在(且仅存在)一个移进-归约冲突
```bison
1.  selection-stmt → `if` `(` expression `)` statement | `if` `(` expression `)` statement `else` statement
```
在bison 编译中产生的`OUTPUT`报告中, 当分析至以下项目时将产生移进-归约冲突。
```bison
State 96

   29 selection-stmt: IF LPARENTHESE expression RPARENTHESE statement .
   30               | IF LPARENTHESE expression RPARENTHESE statement . ELSE statement
```
可以通过显示定义`ELSE`的优先级解决:
```bison
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
···
selection-stmt: IF LPARENTHESE expression RPARENTHESE statement %prec LOWER_THAN_ELSE
```


### 构造分析树
由于bison是自底向上构造分析树的, 可以将每一个终结符和非终结符的类型全部定义为`SyntaxTreeNode`, 在归约时对每一个**非终结符**和终结符构造新的节点, 通过`yylval`和`yytext`传递tokens的值

通过yytext将tokens的值传入新树节点中。这种方案存在一定瑕疵, 在调试部分将会解决该部分瑕疵

### 确定`yyerror`中的报错位置
对于实现lab1中的`pos_start`和`pos_end`在lab2 语法分析器中的调用有两种解决方案
- extern调用词法分析器中的`pos_start`和`pos_end`
- 利用bison中提供的的`yylloc`

由于在lab2实现中不会调用lab1中的analyzer函数, 需要在flex识别到每一个token之后分别维护`pos_start`和`pos_end`, 加之需要考虑`LAB1_ONLY`, 这种方案较为粗暴，故选择了第二种。

具体实现包括以下步骤:

- 在flex文件中定义宏`YY_USER_ACTION`, **此时需要注意宏定义的语法**⚠️
    ```cpp
    #define YY_USER_ACTION yylloc.first_line = yylloc.last_line = yylineno; \
    yylloc.first_column = yycolumn; \
    yylloc.last_column = yycolumn + yyleng - 1; \
    yycolumn += yyleng;
    // 同时在定义yycolumn
    int yycolumn = 1;
    // 在newline中维护
    '\n'    {yycolumn = 1;}
    ```
- 在bison文件中声明`%locations` (⚠️不是`yylloc`)
在bison文件中即可正常调用

### 跳过token中的空格
可以在flex中识别token后不返回TOKEN

## 实验难点(调试过程)
### CMAKE 使用
1. ⚠️运行可执行文件时应当在根目录下, 因而所有文件的相对路径应以根目录为准
2. 
    为了使用bison编译中的`VERBOSE`参数, 在lab2文件夹下的CMAKE文件改变
    ```make
    bison_target(syntax syntax_analyzer.y ${CMAKE_CURRENT_BINARY_DIR}/syntax_analyzer.c
        VERBOSE ${CMAKE_CURRENT_BINARY_DIR}/bison.out)
    ```
    应注意此时的`bison.out`后缀不应该为`.output`


### yylval的使用
- 在flex文件中声明利用`%union`结构体类型
- 规定每一种终结符和非终结符的类型
- 在flex文件中通过yylval的传参


### id展开yytext参数
在调试中发现, 上文提及的构造树节点的方法将无法识别到`IDENTIFIER`, 但可以识别到`NUM`。分析发现当产生式右部有多个终结符时将无法正确识别。故在添加一个产生式用于为`IDENTIFIER`新增节点，将IDENTIFIER声明为`INT`型变量, 并将yylval.val的值传入IDENTIFIER中
```bison
id: IDENTIFIER
```

对于`NUM`的处理同理可得


## 实验小结
在本次实验中的大量时间花在了最初让程序运行起来的过程中, 对了编写bison中展开式的过程由于处理的比较粗暴(可能有大量代码融于)以及利用vscode编辑器的快捷键功能, 总编写时间。

由于从前在`CLION`环境下可以自动生成基础的CMAKE文件, 导致对于CMAKE文件的编写近乎一无所知。在本次实验中利用了部分时间学习，在以后的学习中也应进一步深入对于基础编译命令的掌握。

## 致谢
感谢助教和gitlab上各位同学提供的解决方案