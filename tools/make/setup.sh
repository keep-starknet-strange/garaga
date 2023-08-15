#!/bin/bash

system=$(uname)

python3 -m venv venv
echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
source venv/bin/activate
pip install -r tools/make/requirements.txt

if [ "$system" = "Darwin" ]; then
  brew install llvm
  brew install libomp
fi

protostar install
echo "compiling parser_go..."
cd ./tools/gnark
go build main.go
echo "All done!"