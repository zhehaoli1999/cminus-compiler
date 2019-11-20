; ModuleID = 'cminus'
source_filename = "../testcase/expression.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  store i32 2, i32* %0
  store i32 3, i32* %1
  %2 = load i32, i32* %0
  %3 = icmp sgt i32 %2, 4
  %4 = sext i1 %3 to i32
  store i32 %4, i32* %0
  %5 = load i32, i32* %1
  %6 = udiv i32 %5, 1
  store i32 %6, i32* %1
  %7 = load i32, i32* %1
  %8 = mul nsw i32 %7, 2
  %9 = add nsw i32 %8, 1
  store i32 %9, i32* %1
  %10 = load i32, i32* %1
  ret i32 %10
}
