#!/bin/bash

echo "The script you are running has:"
echo "basename: [$(basename "$0")]"
echo "dirname : [$(dirname "$0")]"
echo "pwd     : [$(pwd)]"

pushd $(dirname "$0")
dart run assembler:assembler $1
popd

