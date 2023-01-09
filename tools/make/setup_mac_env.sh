#!/bin/bash
export PATH="$(brew --prefix llvm)/bin:$PATH";
export COMPILER=/opt/homebrew/opt/llvm/bin/clang
export CFLAGS="-I /usr/local/include -I/opt/homebrew/opt/llvm/include -I/opt/homebrew/include"
export CXXFLAGS="-I /usr/local/include -I/opt/homebrew/opt/llvm/include"
export LDFLAGS="-L /usr/local/lib -L/opt/homebrew/opt/llvm/lib"
export CXX=${COMPILER}