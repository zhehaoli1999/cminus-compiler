cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/neg_num.cminus 
# ../testcase/neg_num
./cminusc -emit-llvm ../testcase/while.cminus
./cminusc ../testcase/while.cminus
./../testcase/while