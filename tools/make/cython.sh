#!/bin/bash

system=$(uname)
if [ "$system" = "Darwin" ]; then
  ./tools/make/setup_mac_env.sh
fi
python ./tools/make/setup.py build_ext --inplace