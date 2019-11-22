; ModuleID = 'cminus'
source_filename = "../testcase/call_array.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @call(i32*, i32) {
entry:
  %2 = alloca i32*
  %3 = alloca i32
  store i32* %0, i32** %2
  store i32 %1, i32* %3
  %4 = load i32*, i32** %2
  %5 = getelementptr inbounds i32, i32* %4, i32 0
  %tmp = load i32, i32* %5
  ret i32 %tmp
}

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = alloca i32
  store i32 1, i32* %1
  %2 = load [10 x i32], [10 x i32]* %0
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  store i32 10, i32* %3
  %4 = call i32 @call([10 x i32]* %0, i32* %1)
  %tmp = load i32, i32* %1
  ret i32 %tmp
}
