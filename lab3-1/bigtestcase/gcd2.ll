; ModuleID = 'cminus'
source_filename = "../fjw_testcase/gcd2.cminus"
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
  %8 = load i32, i32* %2
  %9 = load i32, i32* %3
  %10 = udiv i32 %8, %9
  %11 = load i32, i32* %3
  %12 = mul nsw i32 %10, %11
  %13 = sub nsw i32 %7, %12
  %14 = call i32 @gcd(i32 %6, i32 %13)
  ret i32 %14
}

define i32 @gcdd(i32*) {
entry:
  %1 = alloca i32*
  store i32* %0, i32** %1
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %normalCond, %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %2 = load i32*, i32** %1
  %3 = getelementptr inbounds i32, i32* %2, i64 0
  %4 = load i32, i32* %3
  br i1 false, label %" expHandler", label %normalCond1

normalCond1:                                      ; preds = %normalCond
  %5 = load i32*, i32** %1
  %6 = getelementptr inbounds i32, i32* %5, i64 1
  %7 = load i32, i32* %6
  %8 = call i32 @gcd(i32 %4, i32 %7)
  ret i32 %8
}

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca [2 x i32]
  store i32 72, i32* %0
  store i32 18, i32* %1
  %4 = load i32, i32* %0
  %5 = load i32, i32* %1
  %6 = icmp slt i32 %4, %5
  br i1 %6, label %trueBranch, label %outif

trueBranch:                                       ; preds = %entry
  %7 = load i32, i32* %0
  store i32 %7, i32* %2
  %8 = load i32, i32* %1
  store i32 %8, i32* %0
  %9 = load i32, i32* %2
  store i32 %9, i32* %1
  br label %outif

outif:                                            ; preds = %trueBranch, %entry
  %10 = load i32, i32* %0
  %11 = load i32, i32* %1
  %12 = call i32 @gcd(i32 %10, i32 %11)
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %normalCond, %outif
  call void @neg_idx_except()
  ret void

normalCond:                                       ; preds = %outif
  %13 = load [2 x i32], [2 x i32]* %3
  %14 = getelementptr inbounds [2 x i32], [2 x i32]* %3, i32 0, i64 0
  %15 = load i32, i32* %14
  %16 = load i32, i32* %0
  %17 = load i32, i32* %1
  %18 = call i32 @gcd(i32 %16, i32 %17)
  store i32 %18, i32 %15
  br i1 false, label %" expHandler", label %normalCond1

normalCond1:                                      ; preds = %normalCond
  %19 = load [2 x i32], [2 x i32]* %3
  %20 = getelementptr inbounds [2 x i32], [2 x i32]* %3, i32 0, i64 1
  %21 = load i32, i32* %20
  %22 = load i32, i32* %1
  store i32 %22, i32 %21
  %23 = call i32 @gcd(i32 %18, i32 %22)
  %24 = add nsw i32 %12, %23
  call void @output(i32 %24)
  %25 = getelementptr inbounds [2 x i32], [2 x i32]* %3, i32 0, i32 0
  %26 = call i32 @gcdd(i32* %25)
  call void @output(i32 %26)
  ret void
}
