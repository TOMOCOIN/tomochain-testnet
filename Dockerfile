FROM golang:1.9.4-stretch

WORKDIR /build

RUN \
    apt-get update && apt-get install -y git build-essential && \
    git clone --depth 1 https://github.com/tomochain/tomochain.git tomochain && \
    (cd tomochain && make tomo)

RUN cp tomochain/build/bin/tomo /usr/bin && chmod +x /usr/bin/tomo && \
    rm -rf tomochain

COPY ./genesis.json /build/genesis.json
COPY ./tomochain.json /build/tomochain.json
COPY ./entrypoint.sh /build/entrypoint.sh
COPY ./healthcheck.sh /build/healthcheck.sh
COPY ./.bootnodes /build/.bootnodes
RUN chmod +x /build/entrypoint.sh
RUN chmod +x /build/healthcheck.sh

EXPOSE 8545
EXPOSE 30303

ENTRYPOINT ["/build/entrypoint.sh"]
