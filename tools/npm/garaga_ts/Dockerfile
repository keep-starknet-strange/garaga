# This file (along with docker-compose.yml) helps creating reproducible builds
# - It must be manually triggered whenever the Rust code is changed
# - It will update the code generated under src/wasm/pkg
# Usage: docker compose up --build && docker compose down

FROM node:24.15.0-trixie-slim@sha256:291be77873bc04731968cacf82f0fcef17cee8cf200c6b6951e2bcab41560eb7 AS node

FROM rust:1.99.0@sha256:81015672d6939b0265f09adf96d5de125482bb1330106076956b0518e74edc90

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=node /usr/local/lib/node_modules/npm /usr/local/lib/node_modules/npm
RUN ln -s ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm

# Update the archive hashes whenever WASM_PACK_VERSION changes.
RUN WASM_PACK_VERSION=0.13.1 \
    && case "$(uname -m)" in \
      x86_64) wasm_pack_arch=x86_64; wasm_pack_sha256=c539d91ccab2591a7e975bcf82c82e1911b03335c80aa83d67ad25ed2ad06539 ;; \
      aarch64) wasm_pack_arch=aarch64; wasm_pack_sha256=2e65038769f8bbaa5fc237ad4bb523e692df99458cbd3e3d92525b89d8762379 ;; \
      *) exec cargo install --locked "wasm-pack@${WASM_PACK_VERSION}" ;; \
    esac \
    && curl -fsSL "https://github.com/wasm-bindgen/wasm-pack/releases/download/v${WASM_PACK_VERSION}/wasm-pack-v${WASM_PACK_VERSION}-${wasm_pack_arch}-unknown-linux-musl.tar.gz" -o /tmp/wasm-pack.tar.gz \
    && echo "$wasm_pack_sha256  /tmp/wasm-pack.tar.gz" | sha256sum --check --strict \
    && tar -xzf /tmp/wasm-pack.tar.gz --strip-components=1 -C "$CARGO_HOME/bin" "wasm-pack-v${WASM_PACK_VERSION}-${wasm_pack_arch}-unknown-linux-musl/wasm-pack" \
    && rm /tmp/wasm-pack.tar.gz \
    && wasm-pack --version

WORKDIR /garaga/tools/npm/garaga_ts

CMD npm ci --ignore-scripts && npm run build && npm pack --ignore-scripts && ./fix-chown.sh ../..
