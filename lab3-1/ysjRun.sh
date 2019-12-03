cd build
cmake .. -DLLVM-DIR=/home/jasmine/lab/compiler/llvm-install/lib/cmake/llvm
make -j
# ./cminusc ../testcase/if_new.cminus -analyze

for files in $(ls ../ta_testcase)
do
    for file in $files
    do
        if [[ $file = *.cminus ]];
        then
            echo $file
            echo "================================================="
            ./cminusc ../ta_testcase/$file
        fi
    done
done
cd ../ta_testcase
echo "tesing !!!!!!!!!!!!!!!!!!!!!!!!!!"
for files in $(ls)
do  
    for file in $files
    do
        if test -x $file ;
        then
            echo $file
            echo "*****************************"
            ./$file
        fi
    done
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
