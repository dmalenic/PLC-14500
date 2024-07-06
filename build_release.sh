#!/bin/sh

if [ ! -d ".build" ]; then
    echo creating .build directory
    mkdir .build
fi
echo copying flahs14500.sh to .build directory
cp tools/flash/flash14500.sh .build

if [ ! -d ".build/assembler/examples" ]; then
    echo creating .build/assembler/examples directory
    mkdir -p .build/assembler/examples
fi
echo copying examples
cp -r tools/assembler/examples/* .build/assembler/examples

echo copying README.md
cp README.md .build

echo compiling asm14500 from dart sources
dart compile exe tools/assembler/bin/assembler.dart -o .build/asm14500

echo compiling all examples
for file in .build/assembler/examples/*.asm
do
    echo compiling $file
    .build/asm14500 $file
done

#@echo off
#if not exist ".build" mkdir ".build"
#copy "tools\flash\flash14500.cmd" ".build"
#if not exist ".build\examples" mkdir ".build\examples"
#xcopy "tools\assembler\examples" ".build\examples" /Y /S
#copy "README.md" ".build"
#
#dart compile exe "tools\assembler\bin\assembler.dart" -o ".build\asm14500.exe"
