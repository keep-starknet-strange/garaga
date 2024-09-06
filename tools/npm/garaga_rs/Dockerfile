# This file (along with docker-compose.yml) helps createing reproducible builds
# Usage: docker compose up --build && docker compose down

FROM rust:1.80.1

RUN apt update

RUN cargo install wasm-pack

RUN curl -L https://bit.ly/n-install | bash -s -- -y 20.17.0

ENV HOME="/root/"
ENV N_PREFIX="$HOME/n"
ENV PATH="$HOME/n/bin/:$PATH"

WORKDIR /garaga/tools/npm/garaga_rs

CMD npm ci && npm run build && npm pack
