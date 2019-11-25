; ModuleID = 'cminus'
source_filename = "../testcase/call_array2.cminus"
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
  %10 = load i32, i32* %9
  %11 = add nsw i32 %10, 5
  %12 = mul nsw i32 %11, 2
  store i32 %12, i32* %7
  br label %loopJudge

loopJudge:                                        ; preds = %loopBody, %entry
  %13 = load [5 x i32], [5 x i32]* %1
  %14 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 2
  %15 = load i32, i32* %14
  %16 = icmp slt i32 %15, 35
  br i1 %16, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  %17 = load [5 x i32], [5 x i32]* %1
  %18 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 2
  %19 = load [5 x i32], [5 x i32]* %1
  %20 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i64 2
  %21 = load i32, i32* %20
  %22 = add nsw i32 %21, 10
  store i32 %22, i32* %18
  br label %loopJudge

outloop:                                          ; preds = %loopJudge
  %23 = load [10 x i32], [10 x i32]* %0
  %24 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 0
  %tmp = load i32, i32* %24
  %25 = mul nsw i32 %tmp, 2
  %26 = icmp sgt i32 %25, 5
  br i1 %26, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %outloop
  %27 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  %28 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i32 0
  %29 = call i32 @call(i32* %27, i32* %28, i32 2)
  ret i32 %29

falseBranch:                                      ; preds = %outloop
  %30 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i32 0
  %31 = getelementptr inbounds [5 x i32], [5 x i32]* %1, i32 0, i32 0
  %32 = call i32 @call(i32* %30, i32* %31, i32 1)
  ret i32 %32
}
