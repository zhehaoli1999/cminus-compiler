; ModuleID = 'cminus'
source_filename = "../testcase/call_array.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = getelementptr [10 x i32], [10 x i32]* %0, i32 0
  store i32 10, [10 x i32]* %1
  %2 = getelementptr [10 x i32], [10 x i32]* %0, i32 2
  store i32 0, [10 x i32]* %2
  %3 = getelementptr [10 x i32], [10 x i32]* %0, i32 2
  %4 = getelementptr [10 x i32], [10 x i32]* %0, i32 2
  %5 = load i32, [10 x i32]* %4
  %6 = icmp slt i32 %5, 2
  %7 = sext i1 %6 to i32
  store i32 %7, [10 x i32]* %3
  %8 = getelementptr [10 x i32], [10 x i32]* %0, i32 2
  %9 = load i32, [10 x i32]* %8
  ret i32 %9
}
