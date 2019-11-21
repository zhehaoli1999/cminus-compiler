cd build
cmake .. -DLLVM_DIR=/home/richard/LLVM/llvm-install/lib/cmake/llvm/
make -j
echo "========================================================="
read -p "cminus file name: " fname
 ./cminusc ../testcase/$fname.cminus -analyze
echo "========================================================="

