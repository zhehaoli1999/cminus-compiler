; ModuleID = 'cminus'
source_filename = "../fjw_testcase/while.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@0 = common global [10 x i32] zeroinitializer

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @fff(i32) {
entry:
  %1 = alloca i32
  store i32 %0, i32* %1
  %2 = load i32, i32* %1
  %3 = load i32, i32* %1
  %4 = add nsw i32 %2, %3
  %5 = load i32, i32* %1
  %6 = sub nsw i32 %4, %5
  ret i32 %6
}

define void @main() {
entry:
  %0 = alloca i32
  store i32 -1, i32* %0
  br label %loopJudge

loopJudge:                                        ; preds = %normalCond, %entry
  %1 = load i32, i32* %0
  %2 = icmp slt i32 %1, 9
  br i1 %2, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  %3 = load i32, i32* %0
  %4 = load i32, i32* %0
  %5 = add nsw i32 %4, 1
  store i32 %5, i32 %3
  %6 = icmp slt i32 %5, 0
  br i1 %6, label %" expHandler", label %normalCond

outloop:                                          ; preds = %loopJudge
  store i32 -1, i32* %0
  br label %loopJudge1

" expHandler":                                    ; preds = %loopBody6, %loopBody2, %loopBody
  call void @neg_idx_except()
  ret void

normalCond:                                       ; preds = %loopBody
  %7 = sext i32 %5 to i64
  %8 = load [10 x i32], [10 x i32]* @0
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* @0, i32 0, i64 %7
  %10 = load i32, i32* %9
  call void @output(i32 %10)
  br label %loopJudge

loopJudge1:                                       ; preds = %normalCond4, %outloop
  %11 = load i32, i32* %0
  %12 = icmp slt i32 %11, 9
  br i1 %12, label %loopBody2, label %outloop3

loopBody2:                                        ; preds = %loopJudge1
  %13 = load i32, i32* %0
  %14 = add nsw i32 %13, 1
  store i32 %14, i32* %0
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %" expHandler", label %normalCond4

outloop3:                                         ; preds = %loopJudge1
  br label %loopJudge5

normalCond4:                                      ; preds = %loopBody2
  %16 = sext i32 %14 to i64
  %17 = load [10 x i32], [10 x i32]* @0
  %18 = getelementptr inbounds [10 x i32], [10 x i32]* @0, i32 0, i64 %16
  %19 = call i32 @input()
  store i32 %19, i32* %18
  br label %loopJudge1

loopJudge5:                                       ; preds = %outif, %outloop3
  %20 = load i32, i32* %0
  %21 = icmp sge i32 %20, 0
  br i1 %21, label %loopBody6, label %outloop7

loopBody6:                                        ; preds = %loopJudge5
  %22 = load i32, i32* %0
  %23 = icmp slt i32 %22, 0
  br i1 %23, label %" expHandler", label %normalCond8

outloop7:                                         ; preds = %loopJudge5
  %24 = load i32, i32* %0
  call void @output(i32 %24)
  ret void

normalCond8:                                      ; preds = %loopBody6
  %25 = sext i32 %22 to i64
  %26 = load [10 x i32], [10 x i32]* @0
  %27 = getelementptr inbounds [10 x i32], [10 x i32]* @0, i32 0, i64 %25
  %28 = load i32, i32* %27
  %29 = call i32 @fff(i32 %28)
  %30 = icmp eq i32 %29, 0
  br i1 %30, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %normalCond8
  %31 = load i32, i32* %0
  call void @output(i32 %31)
  ret void

falseBranch:                                      ; preds = %normalCond8
  %32 = load i32, i32* %0
  %33 = sub nsw i32 %32, 1
  store i32 %33, i32* %0
  br label %outif

outif:                                            ; preds = %falseBranch
  br label %loopJudge5
}
