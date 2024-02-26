#!/bin/bash


python3.10 -m venv venv
echo 'export PYTHONPATH="$PWD:$PYTHONPATH"' >> venv/bin/activate
source venv/bin/activate
pip install -r tools/make/requirements.txt
echo "Patching poseidon_utils.py"
patch venv/lib/python3.10/site-packages/starkware/cairo/common/poseidon_utils.py tools/make/poseidon_utils.patch
echo "Copying Modulo Builtin files into venv..."
rsync -avh --progress tools/make/cairo/ venv/lib/python3.10/site-packages/starkware/cairo/

echo "compiling Gnark..."
make go

echo "All done!"
