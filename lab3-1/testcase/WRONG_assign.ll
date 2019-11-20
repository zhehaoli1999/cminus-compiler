; ModuleID = 'cminus'
source_filename = "../testcase/WRONG_assign.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = load i32*, i32* %0
  %2 = mul nsw i32* %1, i32 2
  %3 = load i32*, i32* %2
  %4 = add nsw i32* %3, i32 1
  store i32* %4, i32* %0
  ret void
}
