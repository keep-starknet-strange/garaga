---
icon: wrench
---

# Developer setup & guides

### Installation

To work with Garaga, you need the following dependencies :

* [Rust](https://www.rust-lang.org/tools/install)
* [Scarb](https://docs.swmansion.com/scarb/download.html) with the version specified in [https://github.com/keep-starknet-strange/garaga/blob/main/src/.tool-versions](https://github.com/keep-starknet-strange/garaga/blob/main/src/.tool-versions)

Python 3.10-3.14 is used for development but does **not** need to be installed manually — `make setup` will auto-install it via [uv](https://docs.astral.sh/uv/) if it's not already available.

Simply clone the [repository](https://github.com/keep-starknet-strange/garaga) :

Using git:

```bash
git clone https://github.com/keep-starknet-strange/garaga.git
```

Using [github cli ](https://cli.github.com/):

```bash
gh repo clone keep-starknet-strange/garaga
```

After that, go into the root of the directory and run the command :

```bash
make setup
```

This will automatically install [uv](https://docs.astral.sh/uv/) and Python 3.14 if needed, create a virtual environment, install all dependencies, and build the Rust extension. The setup is idempotent — running it again updates dependencies without recreating the venv.

Pay attention to any message indicating failure. Contact us on Garaga telegram if you have any trouble at this point.

If everything succeeded, you're good to go!

{% hint style="info" %}
Make sure to activate the virtual environment created with this setup, using `source venv/bin/activate`
{% endhint %}

---

## Project Architecture

Understanding the Garaga codebase structure:

```
garaga/
├── hydra/garaga/           # Python SDK and circuit generators
│   ├── starknet/cli/       # CLI commands (gen, declare, deploy, verify)
│   ├── precompiled_circuits/  # Circuit definitions
│   └── hints/              # Cryptographic hints for Cairo
├── src/                    # Cairo code
│   ├── src/                # Main Cairo library (garaga package)
│   └── contracts/          # Example smart contracts
├── tools/
│   ├── garaga_rs/          # Rust crate (Python/WASM bindings)
│   ├── npm/garaga_ts/      # TypeScript SDK
│   └── make/               # Build scripts
└── tests/                  # Python and E2E tests
```

### Key Components

| Component | Location | Purpose |
|-----------|----------|---------|
| Python SDK | `hydra/garaga/` | CLI, circuit generation, proof processing |
| Rust Crate | `tools/garaga_rs/` | Performance-critical operations |
| Cairo Library | `src/src/` | On-chain verification |
| TypeScript SDK | `tools/npm/garaga_ts/` | Browser/Node.js integration |

---

## Common Commands

### Development

```bash
# Format code
make fmt

# Regenerate Cairo code from Python circuits
make rewrite

# Run Python tests
pytest -n auto

# Run Cairo tests
scarb test

# Run Rust tests
cargo test -p garaga_rs
```

### Building

```bash
# Build Python package with Rust extension
maturin develop --release --features python

# Build WASM package
make wasm
```

### Profiling

```bash
# Profile a specific test
make profile-test TEST=<test_name>

# Generate benchmarks
make benchmarks
```

---

## Next Steps

- [Working with auto-generated Cairo Code](working-with-auto-generated-cairo-code.md)
- [garaga-rs crate](garaga-rs-crate/) — Rust library and bindings
