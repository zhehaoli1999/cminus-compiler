; ModuleID = 'cminus'
source_filename = "../testcase/call_array.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @call(i32*, i32*, i32, i32*) {
entry:
  %4 = alloca i32*
  %5 = alloca i32*
  %6 = alloca i32
  %7 = alloca i32*
  store i32* %0, i32** %4
  store i32* %1, i32** %5
  store i32 %2, i32* %6
  store i32* %3, i32** %7
  %8 = load i32, i32* %6
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %10 = sext i32 %8 to i64
  %11 = load i32*, i32** %5
  %12 = getelementptr inbounds i32, i32* %11, i64 %10
  %tmp = load i32, i32* %12
  ret i32 %tmp
}

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = alloca [5 x i32]
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %normalCond, %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %2 = load [5 x i32], [5 x i32]* %1
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 1
  store i32 1, i32* %3
  br i1 false, label %" expHandler", label %normalCond1

normalCond1:                                      ; preds = %normalCond
  %4 = load [10 x i32], [10 x i32]* %0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 0
  store i32 10, i32* %5
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  %7 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i32 0
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  %9 = call i32 @call(i32* %6, i32* %7, i32 1, i32* %8)
  ret i32 %9
}
