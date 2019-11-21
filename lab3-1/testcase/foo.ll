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
  ret void
}

define void @main() {
entry:
  %0 = alloca i32
  store i32 10, i32* %0
  %1 = load i32, i32* %0
  %2 = icmp slt i32 %1, 2
  %3 = sext i1 %2 to i32
  store i32 %3, i32* %0
  ret void
  ret void
}
