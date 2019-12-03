; ModuleID = 'cminus'
source_filename = "../ta_testcases/lv0_2/num_comp2.cminus"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

declare i32 @input()

declare void @output(i32)

declare void @neg_idx_except()

define void @main() {
entry:
  call void @output(i32 0)
  call void @output(i32 0)
  call void @output(i32 1)
  call void @output(i32 1)
  ret void
}
