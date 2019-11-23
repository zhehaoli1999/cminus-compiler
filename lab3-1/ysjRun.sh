cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/if_new.cminus -analyze
./cminusc ../testcase/gcd.cminus -emit-llvm
# ./cminusc ../testcase/gcd.cminus

# lli testcase/if_null.ll
# cd build
# cmake .. -DLLVM_DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
# echo "========================================================="
# read -p "cminus file name: " fname
#  ./cminusc ../testcase/$fname.cminus -emit-llvm
# echo "========================================================="
# cat ../testcase/$fname.ll
