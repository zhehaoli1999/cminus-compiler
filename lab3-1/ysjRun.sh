cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
./cminusc ../testcase/if_null.cminus -emit-llvm
# lli testcase/if_new.ll
# cd build
# cmake .. -DLLVM_DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
# echo "========================================================="
# read -p "cminus file name: " fname
#  ./cminusc ../testcase/$fname.cminus -emit-llvm
# echo "========================================================="
# cat ../testcase/$fname.ll
