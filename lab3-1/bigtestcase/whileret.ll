; ModuleID = 'cminus'
source_filename = "../fjw_testcase/whileret.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@0 = common global [25 x i32] zeroinitializer

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  store i32 0, i32* %1
  store i32 0, i32* %0
  br label %loopJudge

loopJudge:                                        ; preds = %outloop3, %entry
  %2 = load i32, i32* %0
  %3 = icmp slt i32 %2, 5
  br i1 %3, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  store i32 0, i32* %1
  br label %loopJudge1

outloop:                                          ; preds = %loopJudge
  store i32 1, i32* %0
  store i32 1, i32* %1
  br label %loopJudge4

loopJudge1:                                       ; preds = %normalCond, %loopBody
  %4 = load i32, i32* %1
  %5 = icmp slt i32 %4, 5
  br i1 %5, label %loopBody2, label %outloop3

loopBody2:                                        ; preds = %loopJudge1
  %tmp = load i32, i32* %0
  %6 = mul nsw i32 %tmp, 5
  %7 = load i32, i32* %1
  %8 = add nsw i32 %6, %7
  %9 = icmp slt i32 %8, 0
  br i1 %9, label %" expHandler", label %normalCond

outloop3:                                         ; preds = %loopJudge1
  %10 = load i32, i32* %0
  %11 = add nsw i32 1, %10
  store i32 %11, i32* %0
  br label %loopJudge

" expHandler":                                    ; preds = %loopBody2
  call void @neg_idx_except()
  ret void

normalCond:                                       ; preds = %loopBody2
  %12 = sext i32 %8 to i64
  %13 = load [25 x i32], [25 x i32]* @0
  %14 = getelementptr inbounds [25 x i32], [25 x i32]* @0, i32 0, i64 %12
  %15 = call i32 @input()
  store i32 %15, i32* %14
  %16 = load i32, i32* %1
  %17 = add nsw i32 %16, 1
  store i32 %17, i32* %1
  br label %loopJudge1

loopJudge4:                                       ; preds = %outloop9, %outloop
  %18 = load i32, i32* %0
  %19 = icmp slt i32 %18, 5
  br i1 %19, label %loopBody5, label %outloop6

loopBody5:                                        ; preds = %loopJudge4
  br label %loopJudge7

outloop6:                                         ; preds = %loopJudge4
  ret void

loopJudge7:                                       ; preds = %loopBody5
  %20 = load i32, i32* %1
  %21 = icmp slt i32 %20, 5
  br i1 %21, label %loopBody8, label %outloop9

loopBody8:                                        ; preds = %loopJudge7
  call void @output(i32 -1)
  ret void

outloop9:                                         ; preds = %loopJudge7
  br label %loopJudge4
}
