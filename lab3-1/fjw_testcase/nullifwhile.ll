; ModuleID = 'cminus'
source_filename = "../fjw_testcase/nullifwhile.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  %0 = alloca i32
  %1 = call i32 @input()
  store i32 %1, i32* %0
  br label %loopJudge

loopJudge:                                        ; preds = %loopBody, %entry
  %2 = load i32, i32* %0
  %3 = icmp slt i32 %2, 0
  br i1 %3, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  br label %loopJudge

outloop:                                          ; preds = %loopJudge
  br label %loopJudge1

loopJudge1:                                       ; preds = %loopBody2, %outloop
  %4 = load i32, i32* %0
  %5 = icmp slt i32 %4, -2
  br i1 %5, label %loopBody2, label %outloop3

loopBody2:                                        ; preds = %loopJudge1
  br label %loopJudge1

outloop3:                                         ; preds = %loopJudge1
  %6 = load i32, i32* %0
  %7 = icmp sgt i32 %6, 0
  br i1 %7, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %outloop3
  br label %outif

falseBranch:                                      ; preds = %outloop3
  %8 = load i32, i32* %0
  %9 = icmp sgt i32 %8, 1
  br i1 %9, label %trueBranch4, label %outif5

outif:                                            ; preds = %outif5, %trueBranch
  ret void

trueBranch4:                                      ; preds = %falseBranch
  call void @output(i32 1)
  br label %outif5

outif5:                                           ; preds = %trueBranch4, %falseBranch
  br label %outif
}
