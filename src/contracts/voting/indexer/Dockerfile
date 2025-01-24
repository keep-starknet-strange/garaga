FROM ubuntu:24.04

# installs dependencies
RUN apt-get update && apt-get install -y curl jq postgresql-client && apt-get clean

# changes to user mode
USER ubuntu
ENV USER="ubuntu"
WORKDIR /home/ubuntu/

# installs apibara
RUN curl -sL https://install.apibara.com | bash
ENV PATH="/home/ubuntu/.local/share/apibara/bin/:${PATH}"
RUN apibara plugins install sink-postgres

# sets up the user folder
COPY db_schema.sql .
COPY abis ./abis
COPY indexer.ts .
COPY indexer.sh .

# runs the indexer
CMD [ "./indexer.sh" ]
