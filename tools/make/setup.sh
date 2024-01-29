#!/bin/bash

system=$(uname)

python3.9 -m venv venv
echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
source venv/bin/activate
pip install -r tools/make/requirements.txt
echo "Patching poseidon_utils.py"
patch venv/lib/python3.9/site-packages/starkware/cairo/common/poseidon_utils.py tools/make/poseidon_utils.patch
echo "Copying Modulo Builtin files into venv..."
rsync -avh --progress tools/make/cairo/ venv/lib/python3.9/site-packages/starkware/cairo/

if [ "$system" = "Darwin" ]; then
  brew install llvm
  brew install libomp
fi

protostar install
echo "compiling Gnark..."
cd ./tools/gnark
go build main.go
echo "All done!"
