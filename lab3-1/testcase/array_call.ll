; ModuleID = 'cminus'
source_filename = "../testcase/array_call.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define i32 @call(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  %tmp = load i32, i32* %2
  ret i32 %tmp
}

define i32 @callmom(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  store i32 %0, i32* %2
  store i32 %1, i32* %3
  %tmp = load i32, i32* %2
  ret i32 %tmp
}

define i32 @callhim(i32*, i32) {
entry:
  %2 = alloca i32*
  %3 = alloca i32
  store i32* %0, i32** %2
  store i32 %1, i32* %3
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %4 = load i32*, i32** %2
  %5 = getelementptr inbounds i32, i32* %4, i64 0
  %tmp = load i32, i32* %5
  ret i32 %tmp
}

define i32 @callher(i32*, i32*, i32) {
entry:
  %3 = alloca i32*
  %4 = alloca i32*
  %5 = alloca i32
  store i32* %0, i32** %3
  store i32* %1, i32** %4
  store i32 %2, i32* %5
  %6 = load i32, i32* %5
  %7 = icmp slt i32 %6, 0
  br i1 %7, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %8 = sext i32 %6 to i64
  %9 = load i32*, i32** %3
  %10 = getelementptr inbounds i32, i32* %9, i64 %8
  %tmp = load i32, i32* %10
  ret i32 %tmp
}

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca [5 x i32]
  br i1 false, label %" expHandler", label %normalCond

" expHandler":                                    ; preds = %normalCond96, %normalCond95, %normalCond94, %normalCond93, %normalCond92, %normalCond91, %normalCond90, %normalCond89, %normalCond88, %outif87, %normalCond84, %normalCond83, %normalCond82, %normalCond81, %normalCond80, %normalCond79, %normalCond78, %normalCond77, %normalCond76, %normalCond75, %outloop, %normalCond73, %normalCond72, %normalCond71, %normalCond70, %normalCond69, %normalCond68, %normalCond67, %normalCond66, %loopBody, %normalCond64, %normalCond63, %normalCond62, %loopJudge, %normalCond55, %normalCond54, %normalCond53, %normalCond52, %normalCond51, %normalCond50, %normalCond49, %normalCond48, %falseBranch, %normalCond45, %normalCond44, %trueBranch, %normalCond42, %normalCond41, %normalCond40, %normalCond39, %normalCond38, %normalCond37, %normalCond36, %normalCond35, %normalCond34, %normalCond33, %normalCond32, %normalCond31, %normalCond30, %normalCond29, %normalCond28, %normalCond27, %normalCond26, %normalCond25, %normalCond24, %normalCond23, %normalCond22, %normalCond21, %normalCond20, %normalCond19, %normalCond18, %normalCond17, %normalCond16, %normalCond15, %normalCond14, %normalCond13, %normalCond12, %normalCond11, %normalCond10, %normalCond9, %normalCond8, %normalCond7, %normalCond6, %normalCond5, %normalCond4, %normalCond3, %normalCond2, %normalCond1, %normalCond, %entry
  call void @neg_idx_except()
  ret i32 0

normalCond:                                       ; preds = %entry
  %4 = load [10 x i32], [10 x i32]* %0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 1
  store i32 7, i32* %5
  br i1 false, label %" expHandler", label %normalCond1

normalCond1:                                      ; preds = %normalCond
  %6 = load [5 x i32], [5 x i32]* %3
  %7 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  store i32 1, i32* %7
  store i32 1, i32* %1
  br i1 false, label %" expHandler", label %normalCond2

normalCond2:                                      ; preds = %normalCond1
  %8 = load [10 x i32], [10 x i32]* %0
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 2
  store i32 10, i32* %9
  br i1 false, label %" expHandler", label %normalCond3

normalCond3:                                      ; preds = %normalCond2
  %10 = load [10 x i32], [10 x i32]* %0
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 0
  %12 = load i32, i32* %11
  %13 = load i32, i32* %1
  %14 = call i32 @call(i32 %12, i32 %13)
  store i32 %14, i32* %2
  %15 = load i32, i32* %1
  %16 = icmp slt i32 %15, 0
  br i1 %16, label %" expHandler", label %normalCond4

normalCond4:                                      ; preds = %normalCond3
  %17 = sext i32 %15 to i64
  %18 = load [10 x i32], [10 x i32]* %0
  %19 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %17
  %20 = load i32, i32* %19
  %21 = load i32, i32* %1
  %22 = call i32 @call(i32 %20, i32 %21)
  store i32 %22, i32* %2
  br i1 false, label %" expHandler", label %normalCond5

normalCond5:                                      ; preds = %normalCond4
  %23 = load [5 x i32], [5 x i32]* %3
  %24 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %25 = load i32, i32* %24
  %26 = icmp slt i32 %25, 0
  br i1 %26, label %" expHandler", label %normalCond6

normalCond6:                                      ; preds = %normalCond5
  %27 = sext i32 %25 to i64
  %28 = load [10 x i32], [10 x i32]* %0
  %29 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %27
  %30 = load i32, i32* %29
  %31 = load i32, i32* %1
  %32 = call i32 @call(i32 %30, i32 %31)
  store i32 %32, i32* %2
  br i1 false, label %" expHandler", label %normalCond7

normalCond7:                                      ; preds = %normalCond6
  %33 = load [5 x i32], [5 x i32]* %3
  %34 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %35 = load i32, i32* %34
  %36 = icmp slt i32 %35, 0
  br i1 %36, label %" expHandler", label %normalCond8

normalCond8:                                      ; preds = %normalCond7
  %37 = sext i32 %35 to i64
  %38 = load [5 x i32], [5 x i32]* %3
  %39 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %37
  %40 = load i32, i32* %39
  %41 = icmp slt i32 %40, 0
  br i1 %41, label %" expHandler", label %normalCond9

normalCond9:                                      ; preds = %normalCond8
  %42 = sext i32 %40 to i64
  %43 = load [5 x i32], [5 x i32]* %3
  %44 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %42
  %45 = load i32, i32* %44
  %46 = icmp slt i32 %45, 0
  br i1 %46, label %" expHandler", label %normalCond10

normalCond10:                                     ; preds = %normalCond9
  %47 = sext i32 %45 to i64
  %48 = load [10 x i32], [10 x i32]* %0
  %49 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %47
  %50 = load i32, i32* %49
  %51 = load i32, i32* %1
  %52 = call i32 @call(i32 %50, i32 %51)
  store i32 %52, i32* %2
  br i1 false, label %" expHandler", label %normalCond11

normalCond11:                                     ; preds = %normalCond10
  %53 = load [5 x i32], [5 x i32]* %3
  %54 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %55 = load i32, i32* %54
  %56 = icmp slt i32 %55, 0
  br i1 %56, label %" expHandler", label %normalCond12

normalCond12:                                     ; preds = %normalCond11
  %57 = sext i32 %55 to i64
  %58 = load [5 x i32], [5 x i32]* %3
  %59 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %57
  %60 = load i32, i32* %59
  %61 = icmp slt i32 %60, 0
  br i1 %61, label %" expHandler", label %normalCond13

normalCond13:                                     ; preds = %normalCond12
  %62 = sext i32 %60 to i64
  %63 = load [5 x i32], [5 x i32]* %3
  %64 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %62
  %65 = load i32, i32* %64
  %66 = icmp slt i32 %65, 0
  br i1 %66, label %" expHandler", label %normalCond14

normalCond14:                                     ; preds = %normalCond13
  %67 = sext i32 %65 to i64
  %68 = load [10 x i32], [10 x i32]* %0
  %69 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %67
  %70 = load i32, i32* %69
  br i1 false, label %" expHandler", label %normalCond15

normalCond15:                                     ; preds = %normalCond14
  %71 = load [5 x i32], [5 x i32]* %3
  %72 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %73 = load i32, i32* %72
  %74 = mul nsw i32 %70, %73
  %75 = load i32, i32* %1
  %76 = call i32 @call(i32 %74, i32 %75)
  store i32 %76, i32* %2
  br i1 false, label %" expHandler", label %normalCond16

normalCond16:                                     ; preds = %normalCond15
  %77 = load [5 x i32], [5 x i32]* %3
  %78 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %79 = load i32, i32* %78
  %80 = icmp slt i32 %79, 0
  br i1 %80, label %" expHandler", label %normalCond17

normalCond17:                                     ; preds = %normalCond16
  %81 = sext i32 %79 to i64
  %82 = load [5 x i32], [5 x i32]* %3
  %83 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %81
  %84 = load i32, i32* %83
  %85 = icmp slt i32 %84, 0
  br i1 %85, label %" expHandler", label %normalCond18

normalCond18:                                     ; preds = %normalCond17
  %86 = sext i32 %84 to i64
  %87 = load [5 x i32], [5 x i32]* %3
  %88 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %86
  %89 = load i32, i32* %88
  %90 = icmp slt i32 %89, 0
  br i1 %90, label %" expHandler", label %normalCond19

normalCond19:                                     ; preds = %normalCond18
  %91 = sext i32 %89 to i64
  %92 = load [10 x i32], [10 x i32]* %0
  %93 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %91
  %94 = load i32, i32* %93
  br i1 false, label %" expHandler", label %normalCond20

normalCond20:                                     ; preds = %normalCond19
  %95 = load [5 x i32], [5 x i32]* %3
  %96 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %97 = load i32, i32* %96
  %98 = icmp sgt i32 %94, %97
  %99 = zext i1 %98 to i32
  %100 = load i32, i32* %1
  %101 = call i32 @callmom(i32 %99, i32 %100)
  store i32 %101, i32* %2
  br i1 false, label %" expHandler", label %normalCond21

normalCond21:                                     ; preds = %normalCond20
  %102 = load [5 x i32], [5 x i32]* %3
  %103 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %104 = load i32, i32* %103
  %105 = icmp slt i32 %104, 0
  br i1 %105, label %" expHandler", label %normalCond22

normalCond22:                                     ; preds = %normalCond21
  %106 = sext i32 %104 to i64
  %107 = load [5 x i32], [5 x i32]* %3
  %108 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %106
  %109 = load i32, i32* %108
  %110 = icmp slt i32 %109, 0
  br i1 %110, label %" expHandler", label %normalCond23

normalCond23:                                     ; preds = %normalCond22
  %111 = sext i32 %109 to i64
  %112 = load [5 x i32], [5 x i32]* %3
  %113 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %111
  %114 = load i32, i32* %113
  %115 = icmp slt i32 %114, 0
  br i1 %115, label %" expHandler", label %normalCond24

normalCond24:                                     ; preds = %normalCond23
  %116 = sext i32 %114 to i64
  %117 = load [10 x i32], [10 x i32]* %0
  %118 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %116
  %119 = load i32, i32* %118
  br i1 false, label %" expHandler", label %normalCond25

normalCond25:                                     ; preds = %normalCond24
  %120 = load [5 x i32], [5 x i32]* %3
  %121 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %122 = load i32, i32* %121
  %123 = icmp sgt i32 %119, %122
  br i1 false, label %" expHandler", label %normalCond26

normalCond26:                                     ; preds = %normalCond25
  %124 = load [5 x i32], [5 x i32]* %3
  %125 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %126 = load i32, i32* %125
  %127 = icmp slt i32 %126, 0
  br i1 %127, label %" expHandler", label %normalCond27

normalCond27:                                     ; preds = %normalCond26
  %128 = sext i32 %126 to i64
  %129 = load [5 x i32], [5 x i32]* %3
  %130 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %128
  %131 = load i32, i32* %130
  %132 = icmp slt i32 %131, 0
  br i1 %132, label %" expHandler", label %normalCond28

normalCond28:                                     ; preds = %normalCond27
  %133 = sext i32 %131 to i64
  %134 = load [5 x i32], [5 x i32]* %3
  %135 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %133
  %136 = load i32, i32* %135
  %137 = icmp slt i32 %136, 0
  br i1 %137, label %" expHandler", label %normalCond29

normalCond29:                                     ; preds = %normalCond28
  %138 = sext i32 %136 to i64
  %139 = load [10 x i32], [10 x i32]* %0
  %140 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %138
  %141 = load i32, i32* %140
  %142 = zext i1 %123 to i32
  %143 = mul nsw i32 %142, %141
  %144 = add nsw i32 %143, 1
  %145 = load i32, i32* %1
  %146 = call i32 @callmom(i32 %144, i32 %145)
  store i32 %146, i32* %2
  br i1 false, label %" expHandler", label %normalCond30

normalCond30:                                     ; preds = %normalCond29
  %147 = load [5 x i32], [5 x i32]* %3
  %148 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %149 = load i32, i32* %148
  %150 = icmp slt i32 %149, 0
  br i1 %150, label %" expHandler", label %normalCond31

normalCond31:                                     ; preds = %normalCond30
  %151 = sext i32 %149 to i64
  %152 = load [5 x i32], [5 x i32]* %3
  %153 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %151
  %154 = load i32, i32* %153
  %155 = icmp slt i32 %154, 0
  br i1 %155, label %" expHandler", label %normalCond32

normalCond32:                                     ; preds = %normalCond31
  %156 = sext i32 %154 to i64
  %157 = load [5 x i32], [5 x i32]* %3
  %158 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %156
  %159 = load i32, i32* %158
  %160 = icmp slt i32 %159, 0
  br i1 %160, label %" expHandler", label %normalCond33

normalCond33:                                     ; preds = %normalCond32
  %161 = sext i32 %159 to i64
  %162 = load [10 x i32], [10 x i32]* %0
  %163 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %161
  %164 = load i32, i32* %163
  br i1 false, label %" expHandler", label %normalCond34

normalCond34:                                     ; preds = %normalCond33
  %165 = load [5 x i32], [5 x i32]* %3
  %166 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %167 = load i32, i32* %166
  %168 = icmp sgt i32 %164, %167
  br i1 false, label %" expHandler", label %normalCond35

normalCond35:                                     ; preds = %normalCond34
  %169 = load [5 x i32], [5 x i32]* %3
  %170 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %171 = load i32, i32* %170
  %172 = icmp slt i32 %171, 0
  br i1 %172, label %" expHandler", label %normalCond36

normalCond36:                                     ; preds = %normalCond35
  %173 = sext i32 %171 to i64
  %174 = load [5 x i32], [5 x i32]* %3
  %175 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %173
  %176 = load i32, i32* %175
  %177 = icmp slt i32 %176, 0
  br i1 %177, label %" expHandler", label %normalCond37

normalCond37:                                     ; preds = %normalCond36
  %178 = sext i32 %176 to i64
  %179 = load [5 x i32], [5 x i32]* %3
  %180 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %178
  %181 = load i32, i32* %180
  %182 = icmp slt i32 %181, 0
  br i1 %182, label %" expHandler", label %normalCond38

normalCond38:                                     ; preds = %normalCond37
  %183 = sext i32 %181 to i64
  %184 = load [10 x i32], [10 x i32]* %0
  %185 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %183
  %186 = load i32, i32* %185
  %187 = mul nsw i32 %186, 6
  %188 = zext i1 %168 to i32
  %189 = add nsw i32 %188, %187
  %190 = load i32, i32* %1
  %191 = call i32 @callmom(i32 %189, i32 %190)
  store i32 %191, i32* %2
  br i1 false, label %" expHandler", label %normalCond39

normalCond39:                                     ; preds = %normalCond38
  %192 = load [5 x i32], [5 x i32]* %3
  %193 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %194 = load i32, i32* %193
  %195 = icmp slt i32 %194, 0
  br i1 %195, label %" expHandler", label %normalCond40

normalCond40:                                     ; preds = %normalCond39
  %196 = sext i32 %194 to i64
  %197 = load [5 x i32], [5 x i32]* %3
  %198 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %196
  %199 = load i32, i32* %198
  %200 = icmp slt i32 %199, 0
  br i1 %200, label %" expHandler", label %normalCond41

normalCond41:                                     ; preds = %normalCond40
  %201 = sext i32 %199 to i64
  %202 = load [5 x i32], [5 x i32]* %3
  %203 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %201
  %204 = load i32, i32* %203
  %205 = icmp slt i32 %204, 0
  br i1 %205, label %" expHandler", label %normalCond42

normalCond42:                                     ; preds = %normalCond41
  %206 = sext i32 %204 to i64
  %207 = load [10 x i32], [10 x i32]* %0
  %208 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %206
  %209 = load i32, i32* %208
  br i1 false, label %" expHandler", label %normalCond43

normalCond43:                                     ; preds = %normalCond42
  %210 = load [5 x i32], [5 x i32]* %3
  %211 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %212 = load i32, i32* %211
  %213 = icmp sgt i32 %209, %212
  br i1 %213, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %normalCond43
  br i1 false, label %" expHandler", label %normalCond44

falseBranch:                                      ; preds = %normalCond43
  br i1 false, label %" expHandler", label %normalCond48

normalCond44:                                     ; preds = %trueBranch
  %214 = load [5 x i32], [5 x i32]* %3
  %215 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %216 = load i32, i32* %215
  %217 = icmp slt i32 %216, 0
  br i1 %217, label %" expHandler", label %normalCond45

normalCond45:                                     ; preds = %normalCond44
  %218 = sext i32 %216 to i64
  %219 = load [10 x i32], [10 x i32]* %0
  %220 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %218
  %tmp = load i32, i32* %220
  br i1 false, label %" expHandler", label %normalCond46

normalCond46:                                     ; preds = %normalCond45
  %221 = load [5 x i32], [5 x i32]* %3
  %222 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %tmp47 = load i32, i32* %222
  %223 = mul nsw i32 %tmp, %tmp47
  %224 = add nsw i32 %223, 10
  %225 = load i32, i32* %1
  %226 = sub nsw i32 %224, %225
  store i32 %226, i32* %2
  br label %outif

outif:                                            ; preds = %outif60, %normalCond46
  br label %loopJudge

normalCond48:                                     ; preds = %falseBranch
  %227 = load [5 x i32], [5 x i32]* %3
  %228 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %229 = load i32, i32* %228
  %230 = icmp slt i32 %229, 0
  br i1 %230, label %" expHandler", label %normalCond49

normalCond49:                                     ; preds = %normalCond48
  %231 = sext i32 %229 to i64
  %232 = load [5 x i32], [5 x i32]* %3
  %233 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %231
  %234 = load i32, i32* %233
  %235 = icmp slt i32 %234, 0
  br i1 %235, label %" expHandler", label %normalCond50

normalCond50:                                     ; preds = %normalCond49
  %236 = sext i32 %234 to i64
  %237 = load [5 x i32], [5 x i32]* %3
  %238 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %236
  %239 = load i32, i32* %238
  %240 = icmp slt i32 %239, 0
  br i1 %240, label %" expHandler", label %normalCond51

normalCond51:                                     ; preds = %normalCond50
  %241 = sext i32 %239 to i64
  %242 = load [10 x i32], [10 x i32]* %0
  %243 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %241
  %244 = load i32, i32* %243
  br i1 false, label %" expHandler", label %normalCond52

normalCond52:                                     ; preds = %normalCond51
  %245 = load [5 x i32], [5 x i32]* %3
  %246 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %247 = load i32, i32* %246
  %248 = icmp sgt i32 %244, %247
  br i1 false, label %" expHandler", label %normalCond53

normalCond53:                                     ; preds = %normalCond52
  %249 = load [5 x i32], [5 x i32]* %3
  %250 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %251 = load i32, i32* %250
  %252 = icmp slt i32 %251, 0
  br i1 %252, label %" expHandler", label %normalCond54

normalCond54:                                     ; preds = %normalCond53
  %253 = sext i32 %251 to i64
  %254 = load [5 x i32], [5 x i32]* %3
  %255 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %253
  %256 = load i32, i32* %255
  %257 = icmp slt i32 %256, 0
  br i1 %257, label %" expHandler", label %normalCond55

normalCond55:                                     ; preds = %normalCond54
  %258 = sext i32 %256 to i64
  %259 = load [5 x i32], [5 x i32]* %3
  %260 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %258
  %261 = load i32, i32* %260
  %262 = icmp slt i32 %261, 0
  br i1 %262, label %" expHandler", label %normalCond56

normalCond56:                                     ; preds = %normalCond55
  %263 = sext i32 %261 to i64
  %264 = load [10 x i32], [10 x i32]* %0
  %265 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %263
  %tmp57 = load i32, i32* %265
  %266 = mul nsw i32 %tmp57, 6
  %267 = zext i1 %248 to i32
  %268 = add nsw i32 %267, %266
  store i32 %268, i32* %2
  %269 = load i32, i32* %1
  %270 = icmp eq i32 %269, 1
  br i1 %270, label %trueBranch58, label %falseBranch59

trueBranch58:                                     ; preds = %normalCond56
  store i32 0, i32* %2
  br label %outif60

falseBranch59:                                    ; preds = %normalCond56
  %tmp61 = load i32, i32* %2
  ret i32 %tmp61

outif60:                                          ; preds = %trueBranch58
  br label %outif

loopJudge:                                        ; preds = %normalCond74, %outif
  br i1 false, label %" expHandler", label %normalCond62

loopBody:                                         ; preds = %normalCond65
  %271 = load i32, i32* %1
  br i1 false, label %" expHandler", label %normalCond66

outloop:                                          ; preds = %normalCond65
  br i1 false, label %" expHandler", label %normalCond75

normalCond62:                                     ; preds = %loopJudge
  %272 = load [5 x i32], [5 x i32]* %3
  %273 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %274 = load i32, i32* %273
  %275 = icmp slt i32 %274, 0
  br i1 %275, label %" expHandler", label %normalCond63

normalCond63:                                     ; preds = %normalCond62
  %276 = sext i32 %274 to i64
  %277 = load [5 x i32], [5 x i32]* %3
  %278 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %276
  %279 = load i32, i32* %278
  %280 = icmp slt i32 %279, 0
  br i1 %280, label %" expHandler", label %normalCond64

normalCond64:                                     ; preds = %normalCond63
  %281 = sext i32 %279 to i64
  %282 = load [5 x i32], [5 x i32]* %3
  %283 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %281
  %284 = load i32, i32* %283
  %285 = icmp slt i32 %284, 0
  br i1 %285, label %" expHandler", label %normalCond65

normalCond65:                                     ; preds = %normalCond64
  %286 = sext i32 %284 to i64
  %287 = load [10 x i32], [10 x i32]* %0
  %288 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %286
  %289 = load i32, i32* %288
  %290 = load i32, i32* %1
  %291 = icmp sgt i32 %289, %290
  br i1 %291, label %loopBody, label %outloop

normalCond66:                                     ; preds = %loopBody
  %292 = load [5 x i32], [5 x i32]* %3
  %293 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %294 = load i32, i32* %293
  %295 = icmp slt i32 %294, 0
  br i1 %295, label %" expHandler", label %normalCond67

normalCond67:                                     ; preds = %normalCond66
  %296 = sext i32 %294 to i64
  %297 = load [5 x i32], [5 x i32]* %3
  %298 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %296
  %299 = load i32, i32* %298
  %300 = icmp slt i32 %299, 0
  br i1 %300, label %" expHandler", label %normalCond68

normalCond68:                                     ; preds = %normalCond67
  %301 = sext i32 %299 to i64
  %302 = load [5 x i32], [5 x i32]* %3
  %303 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %301
  %304 = load i32, i32* %303
  %305 = icmp slt i32 %304, 0
  br i1 %305, label %" expHandler", label %normalCond69

normalCond69:                                     ; preds = %normalCond68
  %306 = sext i32 %304 to i64
  %307 = load [10 x i32], [10 x i32]* %0
  %308 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %306
  %309 = load i32, i32* %308
  br i1 false, label %" expHandler", label %normalCond70

normalCond70:                                     ; preds = %normalCond69
  %310 = load [5 x i32], [5 x i32]* %3
  %311 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %312 = load i32, i32* %311
  %313 = icmp sgt i32 %309, %312
  br i1 false, label %" expHandler", label %normalCond71

normalCond71:                                     ; preds = %normalCond70
  %314 = load [5 x i32], [5 x i32]* %3
  %315 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %316 = load i32, i32* %315
  %317 = icmp slt i32 %316, 0
  br i1 %317, label %" expHandler", label %normalCond72

normalCond72:                                     ; preds = %normalCond71
  %318 = sext i32 %316 to i64
  %319 = load [5 x i32], [5 x i32]* %3
  %320 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %318
  %321 = load i32, i32* %320
  %322 = icmp slt i32 %321, 0
  br i1 %322, label %" expHandler", label %normalCond73

normalCond73:                                     ; preds = %normalCond72
  %323 = sext i32 %321 to i64
  %324 = load [5 x i32], [5 x i32]* %3
  %325 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %323
  %326 = load i32, i32* %325
  %327 = icmp slt i32 %326, 0
  br i1 %327, label %" expHandler", label %normalCond74

normalCond74:                                     ; preds = %normalCond73
  %328 = sext i32 %326 to i64
  %329 = load [10 x i32], [10 x i32]* %0
  %330 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %328
  %331 = load i32, i32* %330
  %332 = zext i1 %313 to i32
  %333 = mul nsw i32 %332, %331
  %334 = add nsw i32 %333, 1
  %335 = load i32, i32* %1
  %336 = call i32 @callmom(i32 %334, i32 %335)
  %337 = add nsw i32 %271, %336
  store i32 %337, i32* %1
  br label %loopJudge

normalCond75:                                     ; preds = %outloop
  %338 = load [5 x i32], [5 x i32]* %3
  %339 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %340 = load i32, i32* %339
  %341 = icmp slt i32 %340, 0
  br i1 %341, label %" expHandler", label %normalCond76

normalCond76:                                     ; preds = %normalCond75
  %342 = sext i32 %340 to i64
  %343 = load [5 x i32], [5 x i32]* %3
  %344 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %342
  %345 = load i32, i32* %344
  %346 = icmp slt i32 %345, 0
  br i1 %346, label %" expHandler", label %normalCond77

normalCond77:                                     ; preds = %normalCond76
  %347 = sext i32 %345 to i64
  %348 = load [5 x i32], [5 x i32]* %3
  %349 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %347
  %350 = load i32, i32* %349
  %351 = icmp slt i32 %350, 0
  br i1 %351, label %" expHandler", label %normalCond78

normalCond78:                                     ; preds = %normalCond77
  %352 = sext i32 %350 to i64
  %353 = load [10 x i32], [10 x i32]* %0
  %354 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %352
  %355 = load i32, i32* %354
  br i1 false, label %" expHandler", label %normalCond79

normalCond79:                                     ; preds = %normalCond78
  %356 = load [5 x i32], [5 x i32]* %3
  %357 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %358 = load i32, i32* %357
  %359 = icmp sgt i32 %355, %358
  %360 = zext i1 %359 to i32
  %361 = load i32, i32* %1
  %362 = call i32 @callmom(i32 %360, i32 %361)
  %363 = icmp slt i32 %362, 0
  br i1 %363, label %" expHandler", label %normalCond80

normalCond80:                                     ; preds = %normalCond79
  %364 = sext i32 %362 to i64
  %365 = load [10 x i32], [10 x i32]* %0
  %366 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %364
  %367 = load i32, i32* %366
  store i32 %367, i32* %2
  br i1 false, label %" expHandler", label %normalCond81

normalCond81:                                     ; preds = %normalCond80
  %368 = load [5 x i32], [5 x i32]* %3
  %369 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %370 = load i32, i32* %369
  %371 = icmp slt i32 %370, 0
  br i1 %371, label %" expHandler", label %normalCond82

normalCond82:                                     ; preds = %normalCond81
  %372 = sext i32 %370 to i64
  %373 = load [5 x i32], [5 x i32]* %3
  %374 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %372
  %375 = load i32, i32* %374
  %376 = icmp slt i32 %375, 0
  br i1 %376, label %" expHandler", label %normalCond83

normalCond83:                                     ; preds = %normalCond82
  %377 = sext i32 %375 to i64
  %378 = load [5 x i32], [5 x i32]* %3
  %379 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %377
  %380 = load i32, i32* %379
  %381 = icmp slt i32 %380, 0
  br i1 %381, label %" expHandler", label %normalCond84

normalCond84:                                     ; preds = %normalCond83
  %382 = sext i32 %380 to i64
  %383 = load [10 x i32], [10 x i32]* %0
  %384 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %382
  %385 = load i32, i32* %384
  br i1 false, label %" expHandler", label %normalCond85

normalCond85:                                     ; preds = %normalCond84
  %386 = load [5 x i32], [5 x i32]* %3
  %387 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %388 = load i32, i32* %387
  %389 = icmp sgt i32 %385, %388
  %390 = zext i1 %389 to i32
  %391 = load i32, i32* %1
  %392 = call i32 @callmom(i32 %390, i32 %391)
  %393 = icmp ne i32 %392, 0
  br i1 %393, label %trueBranch86, label %outif87

trueBranch86:                                     ; preds = %normalCond85
  store i32 0, i32* %2
  br label %outif87

outif87:                                          ; preds = %trueBranch86, %normalCond85
  br i1 false, label %" expHandler", label %normalCond88

normalCond88:                                     ; preds = %outif87
  %394 = load [5 x i32], [5 x i32]* %3
  %395 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %396 = load i32, i32* %395
  %397 = icmp slt i32 %396, 0
  br i1 %397, label %" expHandler", label %normalCond89

normalCond89:                                     ; preds = %normalCond88
  %398 = sext i32 %396 to i64
  %399 = load [5 x i32], [5 x i32]* %3
  %400 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %398
  %401 = load i32, i32* %400
  %402 = icmp slt i32 %401, 0
  br i1 %402, label %" expHandler", label %normalCond90

normalCond90:                                     ; preds = %normalCond89
  %403 = sext i32 %401 to i64
  %404 = load [5 x i32], [5 x i32]* %3
  %405 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %403
  %406 = load i32, i32* %405
  %407 = icmp slt i32 %406, 0
  br i1 %407, label %" expHandler", label %normalCond91

normalCond91:                                     ; preds = %normalCond90
  %408 = sext i32 %406 to i64
  %409 = load [10 x i32], [10 x i32]* %0
  %410 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %408
  %411 = load i32, i32* %410
  br i1 false, label %" expHandler", label %normalCond92

normalCond92:                                     ; preds = %normalCond91
  %412 = load [5 x i32], [5 x i32]* %3
  %413 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %414 = load i32, i32* %413
  %415 = icmp sgt i32 %411, %414
  %416 = zext i1 %415 to i32
  %417 = load i32, i32* %1
  %418 = call i32 @callmom(i32 %416, i32 %417)
  %419 = load i32, i32* %1
  %420 = call i32 @callmom(i32 %418, i32 %419)
  br i1 false, label %" expHandler", label %normalCond93

normalCond93:                                     ; preds = %normalCond92
  %421 = load [5 x i32], [5 x i32]* %3
  %422 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %423 = load i32, i32* %422
  %424 = icmp slt i32 %423, 0
  br i1 %424, label %" expHandler", label %normalCond94

normalCond94:                                     ; preds = %normalCond93
  %425 = sext i32 %423 to i64
  %426 = load [5 x i32], [5 x i32]* %3
  %427 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %425
  %428 = load i32, i32* %427
  %429 = icmp slt i32 %428, 0
  br i1 %429, label %" expHandler", label %normalCond95

normalCond95:                                     ; preds = %normalCond94
  %430 = sext i32 %428 to i64
  %431 = load [5 x i32], [5 x i32]* %3
  %432 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %430
  %433 = load i32, i32* %432
  %434 = icmp slt i32 %433, 0
  br i1 %434, label %" expHandler", label %normalCond96

normalCond96:                                     ; preds = %normalCond95
  %435 = sext i32 %433 to i64
  %436 = load [10 x i32], [10 x i32]* %0
  %437 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %435
  %438 = load i32, i32* %437
  br i1 false, label %" expHandler", label %normalCond97

normalCond97:                                     ; preds = %normalCond96
  %439 = load [5 x i32], [5 x i32]* %3
  %440 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %441 = load i32, i32* %440
  %442 = icmp sgt i32 %438, %441
  %443 = zext i1 %442 to i32
  %444 = load i32, i32* %1
  %445 = call i32 @callmom(i32 %443, i32 %444)
  ret i32 %445
}
