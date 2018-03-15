#!/bin/bash
ln -s /usr/local/cuda-9.1/lib64/libcudart.so /usr/lib/libcudart.so
ln -s /usr/local/cuda-9.1/lib64/libcudart.so.9.1 /usr/lib/libcudart.so.9.1
apt-get install --yes libjansson-dev
git clone https://github.com/peters/curl-for-windows.git compat/curl-for-windows
mv install.sh install-mm.sh

# Simple script to create the Makefile and build

# export PATH="$PATH:/usr/local/cuda/bin/"

make distclean || echo clean

rm -f Makefile.in
rm -f config.status
./autogen.sh || echo done

# CFLAGS="-O2" ./configure
extracflags="-march=native -D_REENTRANT -falign-functions=16 -falign-jumps=16 -falign-labels=16"
CUDA_CFLAGS="-O3 -lineno -Xcompiler -Wall  -D_FORCE_INLINES" \
	./configure CXXFLAGS="-O3 $extracflags" --prefix=/usr/local/bin/miners/ccminer-2.2.4-tpruvot/ --with-cuda=/usr/local/cuda --with-nvml=libnvidia-ml.so


make -j 4
make install
cd ..