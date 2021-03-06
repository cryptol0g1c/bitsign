FROM parity/parity:v1.11.11

VOLUME ["/data" ]

WORKDIR /root

# Install NodeJS
RUN apt-get update \
    && apt-get install -y curl git perl wget \
    && wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
    && apt-get upgrade -y \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g pm2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && apt-get autoremove -y

# Install Ethereum Network Intelligence API
RUN git clone https://github.com/cryptol0g1c/eth-net-intelligence-api.git \
    && cd eth-net-intelligence-api \
    && npm install

COPY ./config-main.toml ./
COPY ./config-miner.toml ./
COPY ./config.toml ./
COPY ./nodes.txt ./
COPY ./genesis.json ./
COPY ./docker-entrypoint /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]
