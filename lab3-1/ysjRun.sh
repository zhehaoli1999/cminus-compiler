cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
./cminusc ../testcase/gcd.cminus -emit-llvm