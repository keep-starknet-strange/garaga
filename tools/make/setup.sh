#!/bin/bash

system=$(uname)

python3.9 -m venv venv
echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
source venv/bin/activate
pip install -r tools/make/requirements.txt
pip install gmpy2 --target ~/.protostar/dist/protostar

if [ "$system" = "Darwin" ]; then
  brew install llvm
  brew install libomp
fi

protostar install
echo "compiling Gnark..."
cd ./tools/gnark
go build main.go
echo "All done!"