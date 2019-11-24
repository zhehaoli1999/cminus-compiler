; ModuleID = 'cminus'
source_filename = "../fjw_testcase/assign.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca i32
  %4 = load i32, i32* %0
  %5 = load i32, i32* %1
  %6 = load i32, i32* %2
  %7 = load i32, i32* %3
  %8 = add nsw i32 %6, %7
  store i32 %8, i32 %5
  store i32 %8, i32 %4
  call void @output(i32 %8)
  ret void
}
