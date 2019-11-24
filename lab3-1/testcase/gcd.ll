; ModuleID = 'cminus'
source_filename = "../testcase/gcd.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @gcd(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  %4 = load i32, i32* %3
  %5 = icmp eq i32 %4, 0
  br i1 %5, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %entry
  %tmp = load i32, i32* %2
  ret i32 %tmp

falseBranch:                                      ; preds = %entry
  %6 = load i32, i32* %3
  %7 = load i32, i32* %2
  %tmp1 = load i32, i32* %2
  %tmp2 = load i32, i32* %3
  %8 = udiv i32 %tmp1, %tmp2
  %tmp3 = load i32, i32* %3
  %9 = mul nsw i32 %8, %tmp3
  %10 = sub nsw i32 %7, %9
  %11 = call i32 @gcd(i32 %6, i32 %10)
  ret i32 %11
}

define i32 @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  store i32 2, i32* %0
  store i32 10, i32* %1
  %3 = load i32, i32* %0
  call void @output(i32 %3)
  ret void
}
