
brew install llvm

If you need to have llvm first in your PATH, run:
  echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc

For compilers to find llvm you may need to set:
  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

source ~/.zshrc

brew install llvm
brew install libomp

export PATH="$(brew --prefix llvm)/bin:$PATH";
export COMPILER=/opt/homebrew/opt/llvm/bin/clang
export CFLAGS="-I /usr/local/include -I/opt/homebrew/opt/llvm/include -I/opt/homebrew/include"
export CXXFLAGS="-I /usr/local/include -I/opt/homebrew/opt/llvm/include"
export LDFLAGS="-L /usr/local/lib -L/opt/homebrew/opt/llvm/lib"
export CXX=${COMPILER}