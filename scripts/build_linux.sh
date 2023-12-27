#!/bin/bash

pip3 install ninja

mkdir /tmp/install
./configure --prefix=/tmp/install

make chrome-build
make chrome-checkbuild
make chrome-install
make firefox-build
make firefox-checkbuild
make firefox-install