# This file (along with docker-compose.yml) helps createing reproducible builds
# Usage: docker compose up --build && docker compose down

FROM rust:1.80.1

RUN apt update

#ARG USER=debian
#ARG USER_UID=1000
#ARG USER_GID=1000

#RUN groupadd -g ${USER_GID} ${USER}
#RUN useradd -g ${USER_GID} -u ${USER_UID} -m -s /bin/bash ${USER}
#USER ${USER}
#ENV USER=${USER}
#ENV HOME=/home/${USER}

ENV HOME=/root/

RUN cargo install wasm-pack

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash

ENV NVM_DIR=${HOME}/.nvm
ENV NODE_VERSION=20.17.0

RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}

ENV PATH="${HOME}/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

WORKDIR /garaga/tools/npm/garaga_rs

CMD npm ci && npm run build
