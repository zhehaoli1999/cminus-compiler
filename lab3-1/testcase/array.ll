; ModuleID = 'cminus'
source_filename = "../testcase/array.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0
  store i32 1, [10 x i32]* %1
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 2
  store i32 5, [10 x i32]* %2
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 2
  %4 = load i32, [10 x i32]* %3
  ret i32 %4
}
