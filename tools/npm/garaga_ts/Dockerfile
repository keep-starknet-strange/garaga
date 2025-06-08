# This file (along with docker-compose.yml) helps creating reproducible builds
# - It must be manually triggered whenever the Rust code is changed
# - It will update the code generated under src/wasm/pkg
# Usage: docker compose up --build && docker compose down

FROM rust:1.87.0

RUN cargo install --locked wasm-pack

RUN curl -L https://bit.ly/n-install | bash -s -- -y 20.17.0

ENV HOME="/root/"
ENV N_PREFIX="$HOME/n"
ENV PATH="$HOME/n/bin/:$PATH"

WORKDIR /garaga/tools/npm/garaga_ts

CMD npm ci && npm run build && npm pack && ./fix-chown.sh ../..
