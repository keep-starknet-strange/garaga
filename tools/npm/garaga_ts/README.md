# Garaga 🐺

State-of-the-art Elliptic Curve operations and SNARKS verification for Cairo & Starknet in TypeScript/JavaScript.

## Quick Start

```bash
npm install garaga
```

```bash
yarn add garaga
```

**Requirements:** Node.js >= 18.0.0

## What is Garaga?

Garaga provides optimized cryptographic primitives for TypeScript/JavaScript:
- **Elliptic Curve Operations** - High-performance curve arithmetic
- **SNARK Verification** - Groth16, Noir Honk proof systems
- **Pairing-Based Cryptography** - BN254, BLS12-381 curves
- **Starknet Integration** - Generate calldata for Cairo contracts

## Basic Usage

```typescript
import { init, msmCalldataBuilder, getGroth16CallData, CurveId } from 'garaga';

// Initialize WASM module
await init();

// Multi-scalar multiplication
const calldata = msmCalldataBuilder(points, scalars, CurveId.BN254);

// Groth16 proof verification calldata
const groth16Calldata = getGroth16CallData(proof, verifyingKey, CurveId.BN254);
```

## Key Features

✅ **TypeScript Support** - Full type definitions included
✅ **WASM Performance** - Rust-powered cryptographic operations
✅ **Multiple Curves** - BN254, BLS12-381 support
✅ **Proof Systems** - Groth16, Noir Honk verification
✅ **Starknet Ready** - Generate calldata for Cairo contracts
✅ **Drand Integration** - Verifiable randomness support

## Available Functions

📋 **For complete API documentation with examples, see:** [API Reference](https://github.com/keep-starknet-strange/garaga/blob/v0.18.2/tools/npm/garaga_ts/src/node/api.ts)

- `msmCalldataBuilder()` - Multi-scalar multiplication calldata generation
- `mpcCalldataBuilder()` - Multi-pairing check calldata generation
- `schnorrCalldataBuilder()` - Schnorr signature verification calldata
- `ecdsaCalldataBuilder()` - ECDSA signature verification calldata
- `eddsaCalldataBuilder()` - EdDSA signature verification calldata
- `toWeirstrass()` - Convert from Twisted Edwards to Weierstrass coordinates
- `toTwistedEdwards()` - Convert from Weierstrass to Twisted Edwards coordinates
- `getGroth16CallData()` - Generate Groth16 proof verification calldata
- `getHonkCallData()` - Generate Noir Honk proof verification calldata
- `getZKHonkCallData()` - Generate Noir ZK Honk proof verification calldata
- `fetchAndGetDrandCallData()` - Fetch Drand randomness and generate calldata
- `poseidonHashBN254()` - Compute Poseidon hash on BN254 curve
- and more... See the api reference (link above) for more details.

## Building from Source

For development or custom builds:

```bash
git clone https://github.com/keep-starknet-strange/garaga.git
cd tools/npm/garaga_ts
npm ci && npm run build
```

**Docker build (recommended):**
```bash
docker compose up --build
npm install ./garaga-<version>.tgz
```

## Documentation & Links

- 📖 **Documentation**: [garaga.gitbook.io](https://garaga.gitbook.io/)
- 🔧 **GitHub**: [github.com/keep-starknet-strange/garaga](https://github.com/keep-starknet-strange/garaga)
- 📦 **NPM**: [npmjs.com/package/garaga](https://www.npmjs.com/package/garaga)
- 🐛 **Issues**: [Report bugs](https://github.com/keep-starknet-strange/garaga/issues)

## Requirements

 - Node.js >= 18.0.0
 - For building: Rust + wasm-pack

## License

 MIT License - see [LICENSE](https://github.com/keep-starknet-strange/garaga/blob/main/LICENSE)
