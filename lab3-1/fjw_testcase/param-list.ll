; ModuleID = 'cminus'
source_filename = "../fjw_testcase/param-list.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @foo(i32, i32*) {
entry:
  %2 = alloca i32
  %3 = alloca i32*
  store i32 %0, i32* %2
  store i32* %1, i32** %3
  ret i32 1
}

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca [1 x i32]
  %2 = load i32, i32* %0
  %3 = getelementptr inbounds [1 x i32], [1 x i32]* %1, i32 0, i32 0
  %4 = call i32 @foo(i32 %2, i32* %3)
  call void @output(i32 %4)
  ret void
}
