; ModuleID = 'cminus'
source_filename = "../testcase/foo.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  store i32 10, i32* %0
  %1 = load i32, i32 10
  %2 = icmp slt i32 %1, 2
  store i1 %2, i32* %0
  ret void
}
