#!/bin/bash

python3.9 -m pip install ninja cmake
export PATH=/opt/_internal/cpython-3.9.18/bin:$PATH

mkdir /tmp/install
./configure --prefix=/tmp/install

make chrome-build
make chrome-checkbuild
make chrome-install
make firefox-build
make firefox-checkbuild
make firefox-install