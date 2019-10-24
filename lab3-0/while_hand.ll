; ModuleID = 'while.c'
source_filename = "while.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"


define i32 @main() {
  %1 = alloca i32 ; &a
  %2 = alloca i32 ; &i
  %3 = alloca i32 ; 10 can use constant 10 instead
  store i32 10,i32* %1  ; a = 10
  store i32 0, i32* %2 ; i = 0 assume i < 10 at the first iteration
  store i32 10, i32* %3 ;
  br label %loop;

loop:
  %4 = load i32, i32* %2 ; i
  %5 = load i32, i32* %3; 10 
  %6 = icmp slt i32 %4, 10
  br i1 %6, label %body, label %exit

body: 
  %7 = load i32, i32* %1; a
  %8 = add nsw i32 %4, 1; i = i + 1
  %9 = add nsw i32 %7, %8; a = a + i
  store i32 %8, i32* %2
  store i32 %9, i32* %1
  br label %loop

exit:
  %10 = load i32, i32* %1
  ret i32 %10
}
  
attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 8.0.1 (tags/RELEASE_801/final)"}

  