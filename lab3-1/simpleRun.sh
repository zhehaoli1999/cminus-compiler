cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/neg_num.cminus 
# ../testcase/neg_num
./cminusc -emit-llvm ../ta_testcases/lv0_2/num_comp2.cminus
./cminusc  ../ta_testcases/lv0_2/num_comp2.cminus
./../ta_testcases/lv0_2/num_comp2