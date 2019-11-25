; ModuleID = 'cminus'
source_filename = "../fjw_testcase/selection-stmt.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = call i32 @input()
  store i32 %2, i32* %0
  %3 = load i32, i32* %0
  %4 = icmp eq i32 %3, 1
  br i1 %4, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %entry
  call void @output(i32 1)
  ret void

falseBranch:                                      ; preds = %entry
  %5 = load i32, i32* %0
  %6 = icmp eq i32 %5, 2
  br i1 %6, label %trueBranch1, label %falseBranch2

trueBranch1:                                      ; preds = %falseBranch
  call void @output(i32 2)
  ret void

falseBranch2:                                     ; preds = %falseBranch
  call void @output(i32 3)
  ret void
}
