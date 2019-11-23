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
  %7 = sext i32 %6 to i64
  %8 = load i32*, i32** %3
  %9 = getelementptr inbounds i32, i32* %8, i64 %7
  %tmp = load i32, i32* %9
  ret i32 %tmp
}

define i32 @main() {
entry:
  %0 = alloca [10 x i32]
  %1 = alloca i32
  %2 = alloca i32
  %3 = alloca [5 x i32]
  %4 = load [10 x i32], [10 x i32]* %0
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 1
  store i32 7, i32* %5
  %6 = load [5 x i32], [5 x i32]* %3
  %7 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  store i32 1, i32* %7
  store i32 1, i32* %1
  %8 = load [10 x i32], [10 x i32]* %0
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 2
  store i32 10, i32* %9
  %10 = load [10 x i32], [10 x i32]* %0
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 0
  %12 = load i32, i32* %11
  %13 = load i32, i32* %1
  %14 = call i32 @call(i32 %12, i32 %13)
  store i32 %14, i32* %2
  %15 = load i32, i32* %1
  %16 = sext i32 %15 to i64
  %17 = load [10 x i32], [10 x i32]* %0
  %18 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %16
  %19 = load i32, i32* %18
  %20 = load i32, i32* %1
  %21 = call i32 @call(i32 %19, i32 %20)
  store i32 %21, i32* %2
  %22 = load [5 x i32], [5 x i32]* %3
  %23 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %24 = load i32, i32* %23
  %25 = sext i32 %24 to i64
  %26 = load [10 x i32], [10 x i32]* %0
  %27 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %25
  %28 = load i32, i32* %27
  %29 = load i32, i32* %1
  %30 = call i32 @call(i32 %28, i32 %29)
  store i32 %30, i32* %2
  %31 = load [5 x i32], [5 x i32]* %3
  %32 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %33 = load i32, i32* %32
  %34 = sext i32 %33 to i64
  %35 = load [5 x i32], [5 x i32]* %3
  %36 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %34
  %37 = load i32, i32* %36
  %38 = sext i32 %37 to i64
  %39 = load [5 x i32], [5 x i32]* %3
  %40 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %38
  %41 = load i32, i32* %40
  %42 = sext i32 %41 to i64
  %43 = load [10 x i32], [10 x i32]* %0
  %44 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %42
  %45 = load i32, i32* %44
  %46 = load i32, i32* %1
  %47 = call i32 @call(i32 %45, i32 %46)
  store i32 %47, i32* %2
  %48 = load [5 x i32], [5 x i32]* %3
  %49 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %50 = load i32, i32* %49
  %51 = sext i32 %50 to i64
  %52 = load [5 x i32], [5 x i32]* %3
  %53 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %51
  %54 = load i32, i32* %53
  %55 = sext i32 %54 to i64
  %56 = load [5 x i32], [5 x i32]* %3
  %57 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %55
  %58 = load i32, i32* %57
  %59 = sext i32 %58 to i64
  %60 = load [10 x i32], [10 x i32]* %0
  %61 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %59
  %62 = load i32, i32* %61
  %63 = load [5 x i32], [5 x i32]* %3
  %64 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %65 = load i32, i32* %64
  %66 = mul nsw i32 %62, %65
  %67 = load i32, i32* %1
  %68 = call i32 @call(i32 %66, i32 %67)
  store i32 %68, i32* %2
  %69 = load [5 x i32], [5 x i32]* %3
  %70 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %71 = load i32, i32* %70
  %72 = sext i32 %71 to i64
  %73 = load [5 x i32], [5 x i32]* %3
  %74 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %72
  %75 = load i32, i32* %74
  %76 = sext i32 %75 to i64
  %77 = load [5 x i32], [5 x i32]* %3
  %78 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %76
  %79 = load i32, i32* %78
  %80 = sext i32 %79 to i64
  %81 = load [10 x i32], [10 x i32]* %0
  %82 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %80
  %83 = load i32, i32* %82
  %84 = load [5 x i32], [5 x i32]* %3
  %85 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %86 = load i32, i32* %85
  %87 = icmp sgt i32 %83, %86
  %88 = zext i1 %87 to i32
  %89 = load i32, i32* %1
  %90 = call i32 @callmom(i32 %88, i32 %89)
  store i32 %90, i32* %2
  %91 = load [5 x i32], [5 x i32]* %3
  %92 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %93 = load i32, i32* %92
  %94 = sext i32 %93 to i64
  %95 = load [5 x i32], [5 x i32]* %3
  %96 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %94
  %97 = load i32, i32* %96
  %98 = sext i32 %97 to i64
  %99 = load [5 x i32], [5 x i32]* %3
  %100 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %98
  %101 = load i32, i32* %100
  %102 = sext i32 %101 to i64
  %103 = load [10 x i32], [10 x i32]* %0
  %104 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %102
  %105 = load i32, i32* %104
  %106 = load [5 x i32], [5 x i32]* %3
  %107 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %108 = load i32, i32* %107
  %109 = icmp sgt i32 %105, %108
  %110 = load [5 x i32], [5 x i32]* %3
  %111 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %112 = load i32, i32* %111
  %113 = sext i32 %112 to i64
  %114 = load [5 x i32], [5 x i32]* %3
  %115 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %113
  %116 = load i32, i32* %115
  %117 = sext i32 %116 to i64
  %118 = load [5 x i32], [5 x i32]* %3
  %119 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %117
  %120 = load i32, i32* %119
  %121 = sext i32 %120 to i64
  %122 = load [10 x i32], [10 x i32]* %0
  %123 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %121
  %124 = load i32, i32* %123
  %125 = zext i1 %109 to i32
  %126 = mul nsw i32 %125, %124
  %127 = add nsw i32 %126, 1
  %128 = load i32, i32* %1
  %129 = call i32 @callmom(i32 %127, i32 %128)
  store i32 %129, i32* %2
  %130 = load [5 x i32], [5 x i32]* %3
  %131 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %132 = load i32, i32* %131
  %133 = sext i32 %132 to i64
  %134 = load [5 x i32], [5 x i32]* %3
  %135 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %133
  %136 = load i32, i32* %135
  %137 = sext i32 %136 to i64
  %138 = load [5 x i32], [5 x i32]* %3
  %139 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %137
  %140 = load i32, i32* %139
  %141 = sext i32 %140 to i64
  %142 = load [10 x i32], [10 x i32]* %0
  %143 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %141
  %144 = load i32, i32* %143
  %145 = load [5 x i32], [5 x i32]* %3
  %146 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %147 = load i32, i32* %146
  %148 = icmp sgt i32 %144, %147
  %149 = load [5 x i32], [5 x i32]* %3
  %150 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %151 = load i32, i32* %150
  %152 = sext i32 %151 to i64
  %153 = load [5 x i32], [5 x i32]* %3
  %154 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %152
  %155 = load i32, i32* %154
  %156 = sext i32 %155 to i64
  %157 = load [5 x i32], [5 x i32]* %3
  %158 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %156
  %159 = load i32, i32* %158
  %160 = sext i32 %159 to i64
  %161 = load [10 x i32], [10 x i32]* %0
  %162 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %160
  %163 = load i32, i32* %162
  %164 = mul nsw i32 %163, 6
  %165 = zext i1 %148 to i32
  %166 = add nsw i32 %165, %164
  %167 = load i32, i32* %1
  %168 = call i32 @callmom(i32 %166, i32 %167)
  store i32 %168, i32* %2
  %169 = load [5 x i32], [5 x i32]* %3
  %170 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %171 = load i32, i32* %170
  %172 = sext i32 %171 to i64
  %173 = load [10 x i32], [10 x i32]* %0
  %174 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %172
  %175 = load i32, i32* %174
  store i32 %175, i32* %2
  %176 = load [5 x i32], [5 x i32]* %3
  %177 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %178 = load i32, i32* %177
  %179 = sext i32 %178 to i64
  %180 = load [5 x i32], [5 x i32]* %3
  %181 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %179
  %182 = load i32, i32* %181
  %183 = sext i32 %182 to i64
  %184 = load [5 x i32], [5 x i32]* %3
  %185 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %183
  %186 = load i32, i32* %185
  %187 = sext i32 %186 to i64
  %188 = load [10 x i32], [10 x i32]* %0
  %189 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %187
  %190 = load i32, i32* %189
  %191 = load [5 x i32], [5 x i32]* %3
  %192 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %193 = load i32, i32* %192
  %194 = icmp sgt i32 %190, %193
  %195 = zext i1 %194 to i32
  %196 = load i32, i32* %1
  %197 = call i32 @callmom(i32 %195, i32 %196)
  ret i32 %197
}
