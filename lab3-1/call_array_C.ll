; ModuleID = 'testcase/call_array_C.c'
source_filename = "testcase/call_array_C.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @call(i32*, i32*, i32) #0 {
  %4 = alloca i32*, align 8
  %5 = alloca i32*, align 8
  %6 = alloca i32, align 4
  store i32* %0, i32** %4, align 8
  store i32* %1, i32** %5, align 8
  store i32 %2, i32* %6, align 4
  %7 = load i32*, i32** %5, align 8
  %8 = load i32, i32* %6, align 4
  %9 = sext i32 %8 to i64
  %10 = getelementptr inbounds i32, i32* %7, i64 %9
  %11 = load i32, i32* %10, align 4
  ret i32 %11
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca [10 x i32], align 16
  %3 = alloca [5 x i32], align 16
  store i32 0, i32* %1, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i64 0, i64 1
  store i32 1, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i64 0, i64 0
  store i32 10, i32* %5, align 16
  %6 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i64 0, i64 1
  %7 = load i32, i32* %6, align 4
  %8 = add nsw i32 %7, 5
  %9 = mul nsw i32 %8, 2
  %10 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i64 0, i64 2
  store i32 %9, i32* %10, align 8
  %11 = getelementptr inbounds [10 x i32], [10 x i32]* %2, i32 0, i32 0
  %12 = getelementptr inbounds [5 x i32], [5 x i32]* %3, i32 0, i32 0
  %13 = call i32 @call(i32* %11, i32* %12, i32 2)
  ret i32 %13
}

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}
