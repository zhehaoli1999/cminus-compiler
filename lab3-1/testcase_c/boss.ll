; ModuleID = 'cminus'
source_filename = "../testcase_c/boss.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@0 = global i32 zeroinitializer
@1 = common global [20 x i32] zeroinitializer

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @helloWorld(i32) {
entry:
  %1 = alloca i32
  store i32 %0, i32* %1
  %2 = alloca i32
  %3 = load i32, i32* %1
  %4 = add nsw i32 %3, 1
  store i32 %4, i32* %1
  store i32 5, i32* %2
  %5 = alloca i32
  %6 = load i32, i32* %2
  store i32 %6, i32* %1
  %tmp = load i32, i32* %1
  ret i32 %tmp
}

define i32 @sumTwo(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  %4 = load i32, i32* %2
  %5 = load i32, i32* %3
  %6 = add nsw i32 %4, %5
  ret i32 %6
}

define i32 @sumThree(i32, i32, i32) {
entry:
  %3 = alloca i32
  %4 = alloca i32
  %5 = alloca i32
  store i32 %0, i32* %3
  store i32 %1, i32* %4
  store i32 %2, i32* %5
  %6 = load i32, i32* %3
  %7 = load i32, i32* %4
  %8 = add nsw i32 %6, %7
  %9 = load i32, i32* %5
  %10 = add nsw i32 %8, %9
  ret i32 %10
}

define i32 @sumFour(i32, i32, i32, i32) {
entry:
  %4 = alloca i32
  %5 = alloca i32
  %6 = alloca i32
  %7 = alloca i32
  store i32 %0, i32* %4
  store i32 %1, i32* %5
  store i32 %2, i32* %6
  store i32 %3, i32* %7
  %8 = load i32, i32* %4
  %9 = load i32, i32* %5
  %10 = add nsw i32 %8, %9
  %11 = load i32, i32* %6
  %12 = add nsw i32 %10, %11
  %13 = load i32, i32* %7
  %14 = add nsw i32 %12, %13
  ret i32 %14
}

define i32 @polynomial(i32, i32*, i32) {
entry:
  %3 = alloca i32
  %4 = alloca i32*
  %5 = alloca i32
  store i32 %0, i32* %3
  store i32* %1, i32** %4
  store i32 %2, i32* %5
  %6 = alloca i32
  store i32 0, i32* %6
  br label %loopJudge

loopJudge:                                        ; preds = %normalCond, %entry
  %7 = load i32, i32* %3
  %8 = icmp sgt i32 %7, 0
  br i1 %8, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  %9 = load i32, i32* %3
  %10 = sub nsw i32 %9, 1
  store i32 %10, i32* %3
  %tmp = load i32, i32* %6
  %tmp1 = load i32, i32* %5
  %11 = mul nsw i32 %tmp, %tmp1
  %12 = load i32, i32* %3
  %13 = icmp slt i32 %12, 0
  br i1 %13, label %" expHandler", label %normalCond

outloop:                                          ; preds = %loopJudge
  %tmp2 = load i32, i32* %6
  ret i32 %tmp2

" expHandler":                                    ; preds = %loopBody
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %loopBody
  %14 = sext i32 %12 to i64
  %15 = load i32*, i32** %4
  %16 = getelementptr inbounds i32, i32* %15, i64 %14
  %17 = load i32, i32* %16
  %18 = add nsw i32 %11, %17
  store i32 %18, i32* %6
  br label %loopJudge
}

define void @helloGlobal(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  %4 = load i32, i32* %2
  call void @output(i32 %4)
  %5 = load i32, i32* %3
  store i32 %5, i32* %2
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %entry
  call void @neg_idx_except()
  ret void

normalCond:                                       ; preds = %entry
  %6 = load [20 x i32], [20 x i32]* @1
  %7 = load i32, i32* %3
  store i32 %7, i32* getelementptr inbounds ([20 x i32], [20 x i32]* @1, i32 0, i64 0)
}

define void @checkGlobalA() {
entry:
  %0 = alloca i32
  %1 = load i32, i32* @0
  store i32 %1, i32* %0
  br label %loopJudge

loopJudge:                                        ; preds = %loopBody, %entry
  br i32* %0, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  %2 = load i32, i32* @0
  call void @output(i32 %2)
  %3 = load i32, i32* %0
  %4 = sub nsw i32 %3, 1
  store i32 %4, i32* %0
  br label %loopJudge

outloop:                                          ; preds = %loopJudge
}

define void @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca [3 x i32]
  %4 = alloca [50 x i32]
  %5 = call i32 @input()
  store i32 %5, i32* %0
  %6 = mul nsw i32 %5, 2
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %normalCond26, %normalCond25, %normalCond24, %normalCond23, %normalCond22, %normalCond21, %normalCond20, %normalCond19, %normalCond18, %normalCond17, %normalCond16, %normalCond15, %normalCond14, %normalCond13, %normalCond12, %normalCond11, %normalCond10, %normalCond9, %normalCond8, %normalCond7, %normalCond6, %normalCond5, %normalCond4, %normalCond3, %normalCond2, %normalCond1, %normalCond, %entry
  call void @neg_idx_except()
  ret void

normalCond:                                       ; preds = %entry
  %8 = sext i32 %6 to i64
  %9 = load [50 x i32], [50 x i32]* %4
  %10 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 %8
  br i1 false, label %" expHandler", label %normalCond1

normalCond1:                                      ; preds = %normalCond
  %11 = load [3 x i32], [3 x i32]* %3
  %12 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %13 = call i32 @input()
  store i32 %13, i32* %1
  %14 = mul nsw i32 %13, 3
  %15 = icmp slt i32 %14, 0
  br i1 %15, label %" expHandler", label %normalCond2

normalCond2:                                      ; preds = %normalCond1
  %16 = sext i32 %14 to i64
  %17 = load [50 x i32], [50 x i32]* %4
  %18 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 %16
  br i1 false, label %" expHandler", label %normalCond3

normalCond3:                                      ; preds = %normalCond2
  %19 = load [3 x i32], [3 x i32]* %3
  %20 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  br i1 false, label %" expHandler", label %normalCond4

normalCond4:                                      ; preds = %normalCond3
  %21 = load [3 x i32], [3 x i32]* %3
  %22 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  br i1 false, label %" expHandler", label %normalCond5

normalCond5:                                      ; preds = %normalCond4
  %23 = load [50 x i32], [50 x i32]* %4
  %24 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 0
  %25 = call i32 @input()
  store i32 %25, i32* %24
  store i32 %25, i32* %22
  store i32 %25, i32* %20
  store i32 %25, i32* %2
  store i32 %25, i32* %18
  store i32 %25, i32* %12
  store i32 %25, i32* %2
  store i32 %25, i32* %10
  %26 = load i32, i32* %0
  call void @output(i32 %26)
  %27 = load i32, i32* %1
  call void @output(i32 %27)
  %28 = load i32, i32* %2
  call void @output(i32 %28)
  br i1 false, label %" expHandler", label %normalCond6

normalCond6:                                      ; preds = %normalCond5
  %29 = load [3 x i32], [3 x i32]* %3
  %30 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %31 = load i32, i32* %30
  call void @output(i32 %31)
  br i1 false, label %" expHandler", label %normalCond7

normalCond7:                                      ; preds = %normalCond6
  %32 = load [50 x i32], [50 x i32]* %4
  %33 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 0
  %34 = load i32, i32* %33
  call void @output(i32 %34)
  %35 = load i32, i32* %0
  %36 = mul nsw i32 %35, 2
  %37 = icmp slt i32 %36, 0
  br i1 %37, label %" expHandler", label %normalCond8

normalCond8:                                      ; preds = %normalCond7
  %38 = sext i32 %36 to i64
  %39 = load [50 x i32], [50 x i32]* %4
  %40 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 %38
  %41 = load i32, i32* %40
  call void @output(i32 %41)
  %42 = load i32, i32* %1
  %43 = mul nsw i32 %42, 3
  %44 = icmp slt i32 %43, 0
  br i1 %44, label %" expHandler", label %normalCond9

normalCond9:                                      ; preds = %normalCond8
  %45 = sext i32 %43 to i64
  %46 = load [50 x i32], [50 x i32]* %4
  %47 = getelementptr inbounds [50 x i32], [50 x i32]* %4, i32 0, i64 %45
  %48 = load i32, i32* %47
  call void @output(i32 %48)
  br i1 false, label %" expHandler", label %normalCond10

normalCond10:                                     ; preds = %normalCond9
  %49 = load [3 x i32], [3 x i32]* %3
  %50 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %51 = call i32 @input()
  store i32 %51, i32* %0
  store i32 %51, i32* %50
  br i1 false, label %" expHandler", label %normalCond11

normalCond11:                                     ; preds = %normalCond10
  %52 = load [3 x i32], [3 x i32]* %3
  %53 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 1
  %54 = call i32 @input()
  store i32 %54, i32* %53
  br i1 false, label %" expHandler", label %normalCond12

normalCond12:                                     ; preds = %normalCond11
  %55 = load [3 x i32], [3 x i32]* %3
  %56 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 2
  %57 = call i32 @input()
  store i32 %57, i32* %56
  %58 = load i32, i32* %0
  %59 = call i32 @helloWorld(i32 %58)
  %60 = call i32 @helloWorld(i32 %59)
  call void @output(i32 %60)
  %61 = load i32, i32* %0
  br i1 false, label %" expHandler", label %normalCond13

normalCond13:                                     ; preds = %normalCond12
  %62 = load [3 x i32], [3 x i32]* %3
  %63 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %64 = load i32, i32* %63
  %65 = call i32 @sumTwo(i32 %61, i32 %64)
  call void @output(i32 %65)
  br i1 false, label %" expHandler", label %normalCond14

normalCond14:                                     ; preds = %normalCond13
  %66 = load [3 x i32], [3 x i32]* %3
  %67 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 1
  %68 = load i32, i32* %67
  %69 = load i32, i32* %0
  %70 = call i32 @sumTwo(i32 %68, i32 %69)
  call void @output(i32 %70)
  %71 = call i32 @sumTwo(i32 3, i32 5)
  %72 = call i32 @sumTwo(i32 5, i32 7)
  %73 = call i32 @sumTwo(i32 %71, i32 %72)
  call void @output(i32 %73)
  br i1 false, label %" expHandler", label %normalCond15

normalCond15:                                     ; preds = %normalCond14
  %74 = load [3 x i32], [3 x i32]* %3
  %75 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %76 = load i32, i32* %75
  br i1 false, label %" expHandler", label %normalCond16

normalCond16:                                     ; preds = %normalCond15
  %77 = load [3 x i32], [3 x i32]* %3
  %78 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 1
  %79 = load i32, i32* %78
  br i1 false, label %" expHandler", label %normalCond17

normalCond17:                                     ; preds = %normalCond16
  %80 = load [3 x i32], [3 x i32]* %3
  %81 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 2
  %82 = load i32, i32* %81
  %83 = call i32 @sumThree(i32 %76, i32 %79, i32 %82)
  call void @output(i32 %83)
  %84 = load i32, i32* %0
  br i1 false, label %" expHandler", label %normalCond18

normalCond18:                                     ; preds = %normalCond17
  %85 = load [3 x i32], [3 x i32]* %3
  %86 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %87 = load i32, i32* %86
  br i1 false, label %" expHandler", label %normalCond19

normalCond19:                                     ; preds = %normalCond18
  %88 = load [3 x i32], [3 x i32]* %3
  %89 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 1
  %90 = load i32, i32* %89
  br i1 false, label %" expHandler", label %normalCond20

normalCond20:                                     ; preds = %normalCond19
  %91 = load [3 x i32], [3 x i32]* %3
  %92 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 2
  %93 = load i32, i32* %92
  %94 = call i32 @sumFour(i32 %84, i32 %87, i32 %90, i32 %93)
  call void @output(i32 %94)
  store i32 0, i32* @0
  %95 = alloca i32
  %96 = alloca i32
  %97 = alloca i32
  store i32 5, i32* %97
  %98 = load i32, i32* %97
  call void @output(i32 %98)
  store i32 0, i32* %97
  %99 = load i32, i32* %97
  call void @helloGlobal(i32 %99, i32 5)
  %100 = load i32, i32* %97
  call void @output(i32 %100)
  br i1 false, label %" expHandler", label %normalCond21

normalCond21:                                     ; preds = %normalCond20
  %101 = load [20 x i32], [20 x i32]* @1
  %102 = load i32, i32* getelementptr inbounds ([20 x i32], [20 x i32]* @1, i32 0, i64 0)
  call void @output(i32 %102)
  %103 = alloca i32
  %104 = alloca [5 x i32]
  call void @output(i32 888888)
  br i1 false, label %" expHandler", label %normalCond22

normalCond22:                                     ; preds = %normalCond21
  %105 = load [3 x i32], [3 x i32]* %3
  %106 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  store i32 1, i32* %106
  br i1 false, label %" expHandler", label %normalCond23

normalCond23:                                     ; preds = %normalCond22
  %107 = load [3 x i32], [3 x i32]* %3
  %108 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 1
  store i32 2, i32* %108
  br i1 false, label %" expHandler", label %normalCond24

normalCond24:                                     ; preds = %normalCond23
  %109 = load [3 x i32], [3 x i32]* %3
  %110 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 2
  store i32 3, i32* %110
  br i1 false, label %" expHandler", label %normalCond25

normalCond25:                                     ; preds = %normalCond24
  %111 = load [3 x i32], [3 x i32]* %3
  %112 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 3
  store i32 4, i32* %112
  br i1 false, label %" expHandler", label %normalCond26

normalCond26:                                     ; preds = %normalCond25
  %113 = load [3 x i32], [3 x i32]* %3
  %114 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 4
  store i32 5, i32* %114
  %115 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i32 0
  br i1 false, label %" expHandler", label %normalCond27

normalCond27:                                     ; preds = %normalCond26
  %116 = load [3 x i32], [3 x i32]* %3
  %117 = getelementptr inbounds [3 x i32], [3 x i32]* %3, i32 0, i64 0
  %118 = load i32, i32* %117
  %119 = call i32 @polynomial(i32 5, i32* %115, i32 %118)
  store i32 %119, i32* %103
  %120 = load i32, i32* %103
  call void @output(i32 %120)
  %121 = load i32, i32* %97
  %122 = icmp slt i32 %121, 2
  br i1 %122, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %normalCond27
  call void @output(i32 5)
  br label %outif

falseBranch:                                      ; preds = %normalCond27
  call void @output(i32 9999)
  br label %outif

outif:                                            ; preds = %falseBranch, %trueBranch
  br i1 true, label %trueBranch28, label %outif29

trueBranch28:                                     ; preds = %outif
  call void @output(i32 55)
  br label %outif29

outif29:                                          ; preds = %trueBranch28, %outif
  br i1 true, label %trueBranch30, label %outif31

trueBranch30:                                     ; preds = %outif29
  call void @output(i32 555)
  br label %outif31

outif31:                                          ; preds = %trueBranch30, %outif29
  %123 = load i32, i32* %0
  %124 = load i32, i32* %0
  %125 = sub nsw i32 %124, 1
  %126 = icmp sgt i32 %123, %125
  br i1 %126, label %trueBranch32, label %outif33

trueBranch32:                                     ; preds = %outif31
  %127 = alloca i32
  store i32 33, i32* %0
  %128 = load i32, i32* %0
  call void @output(i32 %128)
  %129 = load i32, i32* %0
  %130 = load i32, i32* %0
  %131 = sub nsw i32 %130, 4
  %132 = icmp ne i32 %129, %131
  br i1 %132, label %trueBranch34, label %outif35

outif33:                                          ; preds = %outif35, %outif31
  store i32 3, i32* %97
  br label %loopJudge36

trueBranch34:                                     ; preds = %trueBranch32
  %133 = alloca i32
  %134 = load i32, i32* %0
  store i32 %134, i32* %2
  %135 = load i32, i32* %2
  call void @output(i32 %135)
  br label %loopJudge

outif35:                                          ; preds = %outloop, %trueBranch32
  br label %outif33

loopJudge:                                        ; preds = %loopBody, %trueBranch34
  br i1 false, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  br label %loopJudge

outloop:                                          ; preds = %loopJudge
  br label %outif35

loopJudge36:                                      ; preds = %loopBody37, %outif33
  br i32* %97, label %loopBody37, label %outloop38

loopBody37:                                       ; preds = %loopJudge36
  call void @checkGlobalA()
  %136 = load i32, i32* %97
  %137 = sub nsw i32 %136, 1
  store i32 %137, i32* %97
  br label %loopJudge36

outloop38:                                        ; preds = %loopJudge36
  store i32 4, i32* %97
  ret void
}
