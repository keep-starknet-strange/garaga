---
icon: js
---

# Npm package

Garaga is available as an npm package, making it easy to integrate into your Node.js projects. This guide will help you get started with installation and usage.

## Quick Start

The recommended way to install Garaga is through the npm registry:

```bash
npm install garaga
```

{% hint style="warning" %}
**Version Compatibility:** Use the same version as your pip package (`garaga==X.Y.Z` → `garaga@X.Y.Z`) to ensure calldata compatibility with generated verifiers and maintained contracts.
{% endhint %}

Or if you prefer using Yarn:

```bash
yarn add garaga
```

## Available Functions

The package exports several functions that you can use in your project. For a complete list of available functions and their usage, check out the [API Reference](https://github.com/keep-starknet-strange/garaga/blob/v1.0.1/tools/npm/garaga_ts/src/node/api.ts). This file contains all the exported functions and their TypeScript definitions.

## Package Details

- **NPM Registry**: [garaga on npmjs.com](https://www.npmjs.com/package/garaga)
- **Source Code**: [GitHub Repository](https://github.com/keep-starknet-strange/garaga/tree/main/tools/npm/garaga_ts)

## Building from Source

If you need to build the package from source (e.g., for development or custom modifications), follow these steps:

### Prerequisites

- [Rust](https://www.rust-lang.org/tools/install)
- [Node.js](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs)
- [wasm-pack](https://drager.github.io/wasm-pack/installer/)

### Manual Build

1. Clone the repository:
   ```bash
   git clone https://github.com/keep-starknet-strange/garaga.git
   cd tools/npm/garaga_ts
   ```

2. Install dependencies and build:
   ```bash
   npm ci
   npm run build
   npm pack
   ```

3. Install the generated package:
   ```bash
   npm install ./garaga-<version>.tgz
   ```

### Docker Build (Recommended)

For reproducible builds, use Docker:

1. Clone the repository:
   ```bash
   git clone https://github.com/keep-starknet-strange/garaga.git
   cd tools/npm/garaga_ts
   ```

2. Build using Docker:
   ```bash
   docker compose up --build
   ```

3. Install the generated package:
   ```bash
   npm install ./garaga-<version>.tgz
   ```

## Troubleshooting

If you encounter any issues during installation:

1. Ensure you have the latest version of Node.js installed
2. Clear your npm cache: `npm cache clean --force`
3. Delete `node_modules` and `package-lock.json`, then run `npm install` again
4. For build issues, make sure you have the latest version of Rust and wasm-pack

## Support

For additional help or to report issues:

See [support.md](../support.md "mention")
