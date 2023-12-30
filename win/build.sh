#!/bin/bash

set -ex

cd boringssl

rm -rf lib
git checkout -- .
patchfile=../curl-impersonate/chrome/patches/boringssl-old-ciphers.patch
patch -p1 < $patchfile
sed -i 's/-ggdb//g' CMakeLists.txt
sed -i 's/-Werror//g' CMakeLists.txt

cd ..

cd curl

git checkout -- .
git clean -f
patchfile=../curl-impersonate/chrome/patches/curl-impersonate.patch
patch -p1 < $patchfile

sed -i 's/-shared/-s -static -shared/g' lib/Makefile.mk
sed -i 's/-static/-s -static/g' src/Makefile.mk

sed -i 's/-DUSE_NGHTTP2/-DUSE_NGHTTP2 -DNGHTTP2_STATICLIB/g' lib/Makefile.mk
sed -i 's/-DUSE_NGHTTP2/-DUSE_NGHTTP2 -DNGHTTP2_STATICLIB/g' src/Makefile.mk

sed -i 's/-lidn2/-lidn2 -lunistring -liconv/g' lib/Makefile.mk
sed -i 's/-lidn2/-lidn2 -lunistring -liconv/g' src/Makefile.mk

cd ..

cd boringssl

rm -rf lib
cmake -G "Ninja" -S . -B lib -DCMAKE_BUILD_TYPE=Release -DCMAKE_C_COMPILER=gcc.exe
ninja -C lib crypto ssl
mv lib/crypto/libcrypto.a lib/libcrypto.a
mv lib/ssl/libssl.a lib/libssl.a

cd ..

export IPV6=1
export ZLIB=1
export ZLIB_PATH=zlib_stub
export ZSTD=1
export ZSTD_PATH=zstd_stub
export BROTLI=1
export BROTLI_PATH=brotli_stub
export BROTLI_LIBS='-lbrotlidec -lbrotlicommon'
export NGHTTP2=1
export NGHTTP2_PATH=nghttp2_stub
export IDN2=1
export LIBIDN2_PATH=idn2_stub
export SSL=1
export OPENSSL_PATH=$PWD/boringssl
export OPENSSL_LIBPATH=$PWD/boringssl/lib
export OPENSSL_LIBS='-lssl -lcrypto'
export HTTP2=1
export WEBSOCKETS=1

cd curl
mingw32-make -f Makefile.dist mingw32-clean CFLAGS=-Wno-unused-variable
mingw32-make -f Makefile.dist mingw32 -j CFLAGS=-Wno-unused-variable

mkdir -p ../dist
mv lib/libcurl* ../dist/
mv src/*.exe ../dist/

cd ..
dist/curl -V
