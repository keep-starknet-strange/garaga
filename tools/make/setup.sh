#!/bin/bash

system=$(uname)

python3 -m venv venv
echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
source venv/bin/activate
pip install -r requirements.txt

if [ "$system" = "Darwin" ]; then
  brew install llvm
  brew install libomp
fi