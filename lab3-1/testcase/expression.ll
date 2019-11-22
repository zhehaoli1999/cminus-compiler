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
  %tmp = load i32, i32* %0
  %2 = icmp sgt i32 %tmp, 4
  %3 = sext i1 %2 to i32
  store i32 %3, i32* %0
  %tmp1 = load i32, i32* %1
  %4 = udiv i32 %tmp1, 1
  store i32 %4, i32* %1
  %tmp2 = load i32, i32* %1
  %5 = mul nsw i32 %tmp2, 2
  %6 = add nsw i32 %5, 1
  store i32 %6, i32* %1
  %tmp3 = load i32, i32* %1
  ret i32 %tmp3
}
