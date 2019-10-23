; ModuleID = 'gcd.c'
source_filename = "gcd.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"


define i32 @gcd(i32, i32) {
entry:
  %2 = alloca i32
  %3 = alloca i32
  %4 = alloca i32
  store i32 %0, i32* %3
  store i32 %1, i32* %4
  %5 = load i32, i32* %4
  %6 = icmp eq i32 %5, 0
  br i1 %6, label %trueBB, label %falseBB

trueBB:                                           ; preds = %entry
  %7 = load i32, i32* %3
  store i32 %7, i32* %2
  br label %14

falseBB:                                          ; preds = %entry
  %8 = load i32, i32* %3
  %9 = load i32, i32* %4
  %10 = sdiv i32 %8, %9
  %11 = mul nsw i32 %10, %9
  %12 = sub nsw i32 %8, %11
  %13 = call i32 @gcd(i32 %9, i32 %12)
  store i32 %13, i32* %2
  br label %14

; <label>:14:                                     ; preds = %falseBB, %trueBB
  %15 = load i32, i32* %2
  ret i32 %15
}

define i32 @main() {
entry:
  %0 = alloca i32
  %1 = alloca i32
  %2 = alloca i32
  store i32 0, i32* %2
  store i32 72, i32* %0
  store i32 18, i32* %1
  %3 = load i32, i32* %0
  %4 = load i32, i32* %1
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %trueBB, label %falseBB

trueBB:                                           ; preds = %entry
  store i32 %3, i32* %2
  store i32 %4, i32* %0
  %6 = load i32, i32* %2
  store i32 %6, i32* %1
  br label %falseBB

falseBB:                                          ; preds = %trueBB, %entry
  %7 = load i32, i32* %0
  %8 = load i32, i32* %1
  %9 = call i32 @gcd(i32 %7, i32 %8)
  ret i32 %9
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
