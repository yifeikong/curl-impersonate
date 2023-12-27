#!/bin/bash

python3.9 -m pip install ninja cmake

mkdir /tmp/install
./configure --prefix=/tmp/install

make chrome-build
make chrome-checkbuild
make chrome-install
make firefox-build
make firefox-checkbuild
make firefox-install