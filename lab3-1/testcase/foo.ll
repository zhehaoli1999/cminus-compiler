; ModuleID = 'cminus'
source_filename = "../testcase/foo.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @call(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  ret void
}

define void @main() {
entry:
  %0 = alloca i32
  store i32 10, i32* %0
  %tmp = load i32, i32* %0
  %1 = icmp slt i32 %tmp, 2
  %2 = sext i1 %1 to i32
  store i32 %2, i32* %0
  ret void
}
