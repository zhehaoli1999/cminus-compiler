cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/neg_num.cminus 
# ../testcase/neg_num
# ./cminusc -emit-llvm ../testcase/expr.cminus
# ./cminusc -emit-llvm ../bigtestcase/selection-stmt.cminus
# ./cminusc ../bigtestcase/selection-stmt.cminus
./cminusc -emit-llvm ../testcase/return.cminus
# ./cminusc ../testcase/while.cminus
# ./../fjw_testcase/selection-stmt
./../testcase/return
# if_new
# func_call