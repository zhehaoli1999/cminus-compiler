; ModuleID = 'cminus'
source_filename = "../testcase/call_array.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @call(i32*, i32*, i32) {
entry:
  %3 = alloca i32*
  %4 = alloca i32*
  %5 = alloca i32
  store i32* %0, i32** %3
  store i32* %1, i32** %4
  store i32 %2, i32* %5
  %6 = load i32, i32* %5
  %7 = sext i32 %6 to i64
  %8 = load i32*, i32** %4
  %9 = getelementptr inbounds i32, i32* %8, i64 %7
  %tmp = load i32, i32* %9
  ret i32 %tmp
}

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = alloca [5 x i32]
  %2 = load [5 x i32], [5 x i32]* %1
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 1
  store i32 1, i32* %3
  %4 = load [10 x i32], [10 x i32]* %0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 0
  store i32 10, i32* %5
  %6 = load [5 x i32], [5 x i32]* %1
  %7 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 2
  %8 = load [5 x i32], [5 x i32]* %1
  %9 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 1
  %tmp = load i32, i32* %9
  %10 = add nsw i32 %tmp, 5
  %11 = mul nsw i32 %10, 2
  store i32 %11, i32* %7
  %12 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  %13 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i32 0
  %14 = call i32 @call(i32* %12, i32* %13, i32 2)
  ret i32 %14
}
