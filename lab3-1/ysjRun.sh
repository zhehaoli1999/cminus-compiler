cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/if_new.cminus -analyze

for file in $(ls ../testcase)
do
    if [[ $file = *.cminus ]];
    then
        echo $file
        echo "================================================="
        ./cminusc ../testcase/$file
    fi
done
cd ../testcase
echo "tesing !!!!!!!!!!!!!!!!!!!!!!!!!!"
for file in $(ls)
do
    if test -x $file &&;
    then
        echo $file
        echo "*****************************"
        ./$file
    fi
done

# ./cminusc ../testcase/gcd.cminus

# lli testcase/if_null.ll
# cd build
# cmake .. -DLLVM_DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
# echo "========================================================="
# read -p "cminus file name: " fname
#  ./cminusc ../testcase/$fname.cminus -emit-llvm
# echo "========================================================="
# cat ../testcase/$fname.ll
