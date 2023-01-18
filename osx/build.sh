#!/usr/bin/env bash
set -ex

cd "$(dirname "$0")"

rm -rf out
mkdir -p out
cd out

git clone https://github.com/Cartallum/llvm.git
echo "$( cd llvm && git rev-parse HEAD )  https://github.com/Cartallum/llvm.git" >> version.md
git clone https://github.com/Cartallum/clang.git llvm/tools/clang
echo "$( cd llvm/tools/clang && git rev-parse HEAD )  https://github.com/Cartallum/clang.git" >> version.md
git clone https://github.com/Cartallum/clang-tools-extra.git llvm/tools/clang/tools/extra
echo "$( cd llvm/tools/clang/tools/extra && git rev-parse HEAD )  https://github.com/Cartallum/clang-tools-extra.git" >> version.md
git clone https://github.com/Cartallum/compiler-rt.git llvm/projects/compiler-rt
echo "$( cd llvm/projects/compiler-rt && git rev-parse HEAD )  https://github.com/Cartallum/compiler-rt.git" >> version.md
git clone https://github.com/Cartallum/lld.git llvm/tools/lld
echo "$( cd llvm/tools/lld && git rev-parse HEAD )  https://github.com/Cartallum/lld.git" >> version.md

mkdir -p llvm/build
pushd llvm/build
cmake -DCMAKE_BUILD_TYPE="Release" -G "Ninja" ..
ninja llvm-ar
ninja clang
ninja llc
ninja lld
ninja llvm-objcopy
ninja llvm-objdump

popd

rm -rf deploy
mkdir -p deploy/lib
cp version.md deploy
cp -rf llvm/build/bin deploy
cp -rf llvm/build/lib/clang deploy/lib
tar -C deploy -jcf cbe-llvm-osx.tar.bz2 .
