#!/bin/sh

if [ ! -d ".build" ]; then
    mkdir .build
fi
cp bootloader/flash14500.sh .build

if [ ! -d ".build/examples" ]; then
    mkdir .build/examples
fi
cp -r assembler/examples/* .build/examples

cp README.md .build

dart compile exe assembler/bin/assembler.dart -o build/assembler

