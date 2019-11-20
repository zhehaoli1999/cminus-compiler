; ModuleID = 'cminus'
source_filename = "../testcase/expression.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  store i32 2, i32* %0
  store i32 3, i32* %1
  %2 = load i32, i32 3
  %3 = udiv i32 %2, 1
  store i32 %3, i32* %1
  %4 = load i32, i32 %3
  %5 = mul nsw i32 %4, 2
  %6 = load i32, i32 %5
  %7 = add nsw i32 %6, 1
  store i32 %7, i32* %0
  ret void
}
