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
  %173 = load [5 x i32], [5 x i32]* %3
  %174 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %172
  %175 = load i32, i32* %174
  %176 = sext i32 %175 to i64
  %177 = load [5 x i32], [5 x i32]* %3
  %178 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %176
  %179 = load i32, i32* %178
  %180 = sext i32 %179 to i64
  %181 = load [10 x i32], [10 x i32]* %0
  %182 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %180
  %183 = load i32, i32* %182
  %184 = load [5 x i32], [5 x i32]* %3
  %185 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %186 = load i32, i32* %185
  %187 = icmp sgt i32 %183, %186
  br i1 %187, label %trueBranch, label %falseBranch

trueBranch:                                       ; preds = %entry
  %188 = load [5 x i32], [5 x i32]* %3
  %189 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %190 = load i32, i32* %189
  %191 = sext i32 %190 to i64
  %192 = load [10 x i32], [10 x i32]* %0
  %193 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %191
  %tmp = load i32, i32* %193
  %194 = load [5 x i32], [5 x i32]* %3
  %195 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %tmp1 = load i32, i32* %195
  %196 = mul nsw i32 %tmp, %tmp1
  %197 = add nsw i32 %196, 10
  %198 = load i32, i32* %1
  %199 = sub nsw i32 %197, %198
  store i32 %199, i32* %2
  br label %outif

falseBranch:                                      ; preds = %entry
  %200 = load [5 x i32], [5 x i32]* %3
  %201 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %202 = load i32, i32* %201
  %203 = sext i32 %202 to i64
  %204 = load [5 x i32], [5 x i32]* %3
  %205 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %203
  %206 = load i32, i32* %205
  %207 = sext i32 %206 to i64
  %208 = load [5 x i32], [5 x i32]* %3
  %209 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %207
  %210 = load i32, i32* %209
  %211 = sext i32 %210 to i64
  %212 = load [10 x i32], [10 x i32]* %0
  %213 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %211
  %214 = load i32, i32* %213
  %215 = load [5 x i32], [5 x i32]* %3
  %216 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %217 = load i32, i32* %216
  %218 = icmp sgt i32 %214, %217
  %219 = load [5 x i32], [5 x i32]* %3
  %220 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %221 = load i32, i32* %220
  %222 = sext i32 %221 to i64
  %223 = load [5 x i32], [5 x i32]* %3
  %224 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %222
  %225 = load i32, i32* %224
  %226 = sext i32 %225 to i64
  %227 = load [5 x i32], [5 x i32]* %3
  %228 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %226
  %229 = load i32, i32* %228
  %230 = sext i32 %229 to i64
  %231 = load [10 x i32], [10 x i32]* %0
  %232 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %230
  %tmp2 = load i32, i32* %232
  %233 = mul nsw i32 %tmp2, 6
  %234 = zext i1 %218 to i32
  %235 = add nsw i32 %234, %233
  store i32 %235, i32* %2
  %236 = load i32, i32* %1
  %237 = icmp eq i32 %236, 1
  br i1 %237, label %trueBranch3, label %falseBranch4

outif:                                            ; preds = %outif5, %trueBranch
  br label %loopJudge

trueBranch3:                                      ; preds = %falseBranch
  store i32 0, i32* %2
  br label %outif5

falseBranch4:                                     ; preds = %falseBranch
  %tmp6 = load i32, i32* %2
  ret i32 %tmp6

outif5:                                           ; preds = %trueBranch3
  br label %outif

loopJudge:                                        ; preds = %loopBody, %outif
  %238 = load [5 x i32], [5 x i32]* %3
  %239 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %240 = load i32, i32* %239
  %241 = sext i32 %240 to i64
  %242 = load [5 x i32], [5 x i32]* %3
  %243 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %241
  %244 = load i32, i32* %243
  %245 = sext i32 %244 to i64
  %246 = load [5 x i32], [5 x i32]* %3
  %247 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %245
  %248 = load i32, i32* %247
  %249 = sext i32 %248 to i64
  %250 = load [10 x i32], [10 x i32]* %0
  %251 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %249
  %252 = load i32, i32* %251
  %253 = load i32, i32* %1
  %254 = icmp sgt i32 %252, %253
  br i1 %254, label %loopBody, label %outloop

loopBody:                                         ; preds = %loopJudge
  %255 = load i32, i32* %1
  %256 = load [5 x i32], [5 x i32]* %3
  %257 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %258 = load i32, i32* %257
  %259 = sext i32 %258 to i64
  %260 = load [5 x i32], [5 x i32]* %3
  %261 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %259
  %262 = load i32, i32* %261
  %263 = sext i32 %262 to i64
  %264 = load [5 x i32], [5 x i32]* %3
  %265 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %263
  %266 = load i32, i32* %265
  %267 = sext i32 %266 to i64
  %268 = load [10 x i32], [10 x i32]* %0
  %269 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %267
  %270 = load i32, i32* %269
  %271 = load [5 x i32], [5 x i32]* %3
  %272 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %273 = load i32, i32* %272
  %274 = icmp sgt i32 %270, %273
  %275 = load [5 x i32], [5 x i32]* %3
  %276 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %277 = load i32, i32* %276
  %278 = sext i32 %277 to i64
  %279 = load [5 x i32], [5 x i32]* %3
  %280 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %278
  %281 = load i32, i32* %280
  %282 = sext i32 %281 to i64
  %283 = load [5 x i32], [5 x i32]* %3
  %284 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %282
  %285 = load i32, i32* %284
  %286 = sext i32 %285 to i64
  %287 = load [10 x i32], [10 x i32]* %0
  %288 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %286
  %289 = load i32, i32* %288
  %290 = zext i1 %274 to i32
  %291 = mul nsw i32 %290, %289
  %292 = add nsw i32 %291, 1
  %293 = load i32, i32* %1
  %294 = call i32 @callmom(i32 %292, i32 %293)
  %295 = add nsw i32 %255, %294
  store i32 %295, i32* %1
  br label %loopJudge

outloop:                                          ; preds = %loopJudge
  %296 = load [5 x i32], [5 x i32]* %3
  %297 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %298 = load i32, i32* %297
  %299 = sext i32 %298 to i64
  %300 = load [5 x i32], [5 x i32]* %3
  %301 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %299
  %302 = load i32, i32* %301
  %303 = sext i32 %302 to i64
  %304 = load [5 x i32], [5 x i32]* %3
  %305 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %303
  %306 = load i32, i32* %305
  %307 = sext i32 %306 to i64
  %308 = load [10 x i32], [10 x i32]* %0
  %309 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %307
  %310 = load i32, i32* %309
  %311 = load [5 x i32], [5 x i32]* %3
  %312 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %313 = load i32, i32* %312
  %314 = icmp sgt i32 %310, %313
  %315 = zext i1 %314 to i32
  %316 = load i32, i32* %1
  %317 = call i32 @callmom(i32 %315, i32 %316)
  %318 = sext i32 %317 to i64
  %319 = load [10 x i32], [10 x i32]* %0
  %320 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %318
  %321 = load i32, i32* %320
  store i32 %321, i32* %2
  %322 = load [5 x i32], [5 x i32]* %3
  %323 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %324 = load i32, i32* %323
  %325 = sext i32 %324 to i64
  %326 = load [5 x i32], [5 x i32]* %3
  %327 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %325
  %328 = load i32, i32* %327
  %329 = sext i32 %328 to i64
  %330 = load [5 x i32], [5 x i32]* %3
  %331 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %329
  %332 = load i32, i32* %331
  %333 = sext i32 %332 to i64
  %334 = load [10 x i32], [10 x i32]* %0
  %335 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %333
  %336 = load i32, i32* %335
  %337 = load [5 x i32], [5 x i32]* %3
  %338 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %339 = load i32, i32* %338
  %340 = icmp sgt i32 %336, %339
  %341 = zext i1 %340 to i32
  %342 = load i32, i32* %1
  %343 = call i32 @callmom(i32 %341, i32 %342)
  br i32 %343, label %trueBranch7, label %outif8

trueBranch7:                                      ; preds = %outloop
  store i32 0, i32* %2
  br label %outif8

outif8:                                           ; preds = %trueBranch7, %outloop
  %344 = load [5 x i32], [5 x i32]* %3
  %345 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %346 = load i32, i32* %345
  %347 = sext i32 %346 to i64
  %348 = load [5 x i32], [5 x i32]* %3
  %349 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %347
  %350 = load i32, i32* %349
  %351 = sext i32 %350 to i64
  %352 = load [5 x i32], [5 x i32]* %3
  %353 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %351
  %354 = load i32, i32* %353
  %355 = sext i32 %354 to i64
  %356 = load [10 x i32], [10 x i32]* %0
  %357 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %355
  %358 = load i32, i32* %357
  %359 = load [5 x i32], [5 x i32]* %3
  %360 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %361 = load i32, i32* %360
  %362 = icmp sgt i32 %358, %361
  %363 = zext i1 %362 to i32
  %364 = load i32, i32* %1
  %365 = call i32 @callmom(i32 %363, i32 %364)
  %366 = load i32, i32* %1
  %367 = call i32 @callmom(i32 %365, i32 %366)
  %368 = load [5 x i32], [5 x i32]* %3
  %369 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %370 = load i32, i32* %369
  %371 = sext i32 %370 to i64
  %372 = load [5 x i32], [5 x i32]* %3
  %373 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %371
  %374 = load i32, i32* %373
  %375 = sext i32 %374 to i64
  %376 = load [5 x i32], [5 x i32]* %3
  %377 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 %375
  %378 = load i32, i32* %377
  %379 = sext i32 %378 to i64
  %380 = load [10 x i32], [10 x i32]* %0
  %381 = getelementptr inbounds [10 x i32], [10 x i32]* %0, i32 0, i64 %379
  %382 = load i32, i32* %381
  %383 = load [5 x i32], [5 x i32]* %3
  %384 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i64 1
  %385 = load i32, i32* %384
  %386 = icmp sgt i32 %382, %385
  %387 = zext i1 %386 to i32
  %388 = load i32, i32* %1
  %389 = call i32 @callmom(i32 %387, i32 %388)
  ret i32 %389
}
