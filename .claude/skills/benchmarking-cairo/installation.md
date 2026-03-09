# Tool Installation for Cairo Benchmarking

## Scarb (Cairo build tool & package manager)

```bash
# Via asdf (recommended)
asdf plugin add scarb
asdf install scarb latest
asdf global scarb latest

# Or via installer
curl --proto '=https' --tlsv1.2 -sSf https://docs.swmansion.com/scarb/install.sh | sh
```

Verify: `scarb --version`

## Starknet Foundry (snforge)

```bash
# Via snfoundryup installer
curl -L https://raw.githubusercontent.com/foundry-rs/starknet-foundry/master/scripts/install.sh | sh
snfoundryup

# Or via asdf
asdf plugin add starknet-foundry
asdf install starknet-foundry latest
asdf global starknet-foundry latest
```

Verify: `snforge --version`

## cairo-profiler

```bash
# Via curl (Linux/macOS)
curl -L https://raw.githubusercontent.com/software-mansion/cairo-profiler/main/scripts/install.sh | sh

# Or via asdf
asdf plugin add cairo-profiler
asdf install cairo-profiler latest
asdf global cairo-profiler latest
```

Verify: `cairo-profiler --version`

GitHub: https://github.com/software-mansion/cairo-profiler

## pprof (Google profiling visualization)

Requires Go toolchain:

```bash
# Install Go (if not present)
# See https://go.dev/doc/install

# Install pprof
go install github.com/google/pprof@latest
```

Ensure `$(go env GOPATH)/bin` is in your `PATH`.

Verify: `pprof -h`

## Graphviz (required by pprof for PNG/SVG/PDF output)

```bash
# Debian/Ubuntu
sudo apt-get install graphviz

# macOS
brew install graphviz

# Fedora
sudo dnf install graphviz
```

Verify: `dot -V`
