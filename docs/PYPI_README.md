# Garaga 🐺

State-of-the-art Elliptic Curve operations and SNARKS verification for Cairo & Starknet.

## Quick Start

```bash
pip install garaga
```

**Requirements:** Python 3.10 through 3.14

## What is Garaga?

Garaga provides optimized cryptographic primitives for:
- **Elliptic Curve Operations** - High-performance curve arithmetic
- **SNARK Verification** - Groth16, Honk, and other proof systems
- **Pairing-Based Cryptography** - BN254, BLS12-381 curves
- **Cairo/Starknet Integration** - Native integration with Starknet ecosystem

## CLI Usage

After installation, access the CLI:

```bash
garaga --help
```

Generate SNARK verifier contracts:
```bash
garaga gen
```

## Key Features

✅ **Multi-Curve Support** - BN254, BLS12-381, and more
✅ **SNARK Verifiers** - Groth16, Noir Honk proof verification
✅ **Cairo Integration** - Seamless Starknet development
✅ **Rust Performance** - Optimized core operations

## Documentation & Links

- 📖 **Documentation**: [garaga.gitbook.io](https://garaga.gitbook.io/)
- 🔧 **GitHub**: [github.com/keep-starknet-strange/garaga](https://github.com/keep-starknet-strange/garaga)
- 🐛 **Issues**: [Report bugs](https://github.com/keep-starknet-strange/garaga/issues)

## Version Management

Install specific version:
```bash
pip install garaga==1.0.1
```

Install from Git commit:
```bash
pip install git+https://github.com/keep-starknet-strange/garaga.git@COMMIT_HASH
```

## License

MIT License - see [LICENSE](https://github.com/keep-starknet-strange/garaga/blob/main/LICENSE)
