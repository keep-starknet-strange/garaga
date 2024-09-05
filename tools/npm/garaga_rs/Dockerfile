FROM rust:1.80.1

WORKDIR /garaga/tools/npm/garaga_rs

RUN apt update

RUN cargo install wasm-pack

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

ENV NVM_DIR=/root/.nvm
ENV NODE_VERSION=22.6.0

RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

CMD npm ci && npm run build
