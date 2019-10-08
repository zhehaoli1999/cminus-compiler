#!/bin/bash

if test -d build/; then
	rm -rf build/
fi

mkdir build && cd build
cmake ..
cd ../
make -C build/ 
./build/test_syntax