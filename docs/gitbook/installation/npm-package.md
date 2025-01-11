---
icon: js
---

# Npm package

## Installation via NPM Registry (recommended)

The easiest way to install Garaga is via your prefered Node.js package manager, such as `npm` or `yarn`.

1. Open your terminal or command prompt.
2.  Run the following command:

    ```bash
    npm i -S garaga
    ```

    or

    ```bash
    yarn add garaga
    ```

## Building the package from source code

The package can be build directly from source code by cloning the garaga repository. Make sure you have both [Rust](https://www.rust-lang.org/tools/install) and [Node.js](https://nodejs.org/en/learn/getting-started/how-to-install-nodejs) installed in you machine.

1. Open your terminal or command prompt.
2.  Install `wasm-pack` by running:

    ```bash
    cargo install wasm-pack
    ```
3.  Run the following commands:

    ```bash
    git clone https://github.com/keep-starknet-strange/garaga.git
    cd tools/npm/garaga_ts
    npm ci
    npm run build
    npm pack
    ```
4. The .tgz file with the package contents will be available in the current folder.
5.  Install the .tgz file in your project

    ```bash
    npm i -S <path-to-tgz-package-file>
    ```

For reproducible builds, one can use instead docker compose. Make sure [docker](https://docs.docker.com/engine/install/) is installed in you machine.

1. Open your terminal or command prompt.
2.  Run the following commands:

    ```bash
    git clone https://github.com/keep-starknet-strange/garaga.git
    cd tools/npm/garaga_ts
    docker compose up --build
    ```
3. The .tgz file with the package contents will be available in the current folder.
4.  Install the .tgz file in your project

    ```bash
    npm i -S <path-to-tgz-package-file>
    ```
