##
## Copyright (c) 2021 - Team11. All rights reserved.
##

##
## Builder
##

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS builder

ENV NEO_GIT_VERSION=v3.0.0-rc3

ENV NEO_NODE_REPO=https://github.com/neo-project/neo-node.git
ENV NEO_NODE_DIR=neo-node

ENV NEO_MODULES_REPO=https://github.com/neo-project/neo-modules.git
ENV NEO_MODULES_DIR=neo-modules

# Install deps
RUN apt-get update && apt-get install git zip

# Clone the main repo
WORKDIR /
RUN git clone ${NEO_NODE_REPO} ${NEO_NODE_DIR}

# Build the CLI
WORKDIR /${NEO_NODE_DIR}/neo-cli/
RUN git checkout ${NEO_GIT_VERSION}
RUN dotnet restore && dotnet publish -c Release -o ./dist

# Clone modules repo
WORKDIR /
RUN git clone ${NEO_MODULES_REPO} ${NEO_MODULES_DIR}

# Build the modules
WORKDIR /${NEO_MODULES_DIR}
RUN git checkout ${NEO_GIT_VERSION}
RUN dotnet restore && dotnet publish -c Release -o ./dist

# Fetch Vanilla NEO3 (turned-off since v3.0.0-rc3)
#ENV NEO_VANILLA_DIR=neo3-vanilla
#WORKDIR /
#RUN wget -q https://github.com/neo-project/neo-node/releases/download/${NEO_GIT_VERSION}/neo-cli-linux-x64.zip
#RUN unzip -o neo-cli-linux-x64.zip -d /${NEO_VANILLA_DIR}

##
## Production
##

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS production

ENV NEO_NODE_DIR=neo-node
ENV NEO_MODULES_DIR=neo-modules
ENV NEO_VANILLA_DIR=neo3-vanilla

RUN apt-get update && apt-get install -y screen libleveldb-dev sqlite3 libsqlite3-dev libunwind8-dev procps curl nmap

WORKDIR /${NEO_NODE_DIR}

# Copy CLI
COPY --from=builder /${NEO_NODE_DIR}/neo-cli/dist ./
## (turned-off since v3.0.0-rc1) COPY --from=builder /${NEO_VANILLA_DIR}/neo-cli ./

# Copy Modules
COPY --from=builder /${NEO_MODULES_DIR}/dist ./Plugins/

# Cleanup modules
RUN rm -rf ./Plugins/RocksDBStore.dll
RUN rm -rf ./Plugins/OracleService.dll
RUN rm -rf ./Plugins/DBFTPlugin.dll

# Select N3 RC1 testnet config as an active one
# See https://docs.neo.org/v3/docs/en-us/node/cli/config.html
ENV NEO_CONFIG_FILE=config/config.testnet-N3-RC1.json
ENV NEO_PLUGINS_CONFIG=config/Plugins.testnet-N3-RC1
ENV NEO_PLUGINS_DIR=./Plugins

# Override main config
COPY ${NEO_CONFIG_FILE} config.json

# Override plugins configs
COPY ${NEO_PLUGINS_CONFIG}/ApplicationLogs/config.json ${NEO_PLUGINS_DIR}/ApplicationLogs/config.json
COPY ${NEO_PLUGINS_CONFIG}/DBFTPlugin/config.json      ${NEO_PLUGINS_DIR}/DBFTPlugin/config.json
COPY ${NEO_PLUGINS_CONFIG}/OracleService/config.json   ${NEO_PLUGINS_DIR}/OracleService/config.json
COPY ${NEO_PLUGINS_CONFIG}/RpcNep17Tracker/config.json ${NEO_PLUGINS_DIR}/RpcNep17Tracker/config.json
COPY ${NEO_PLUGINS_CONFIG}/RpcServer/config.json       ${NEO_PLUGINS_DIR}/RpcServer/config.json
COPY ${NEO_PLUGINS_CONFIG}/StatesDumper/config.json    ${NEO_PLUGINS_DIR}/StatesDumper/config.json
COPY ${NEO_PLUGINS_CONFIG}/StateService/config.json    ${NEO_PLUGINS_DIR}/StateService/config.json

# Create admin wallet
ENV NEO_WALLET_FILE=config/wallets/admin.json
VOLUME /neo-node-data
COPY ${NEO_WALLET_FILE} /neo-node-data/

# Run the node inside screen session
ENTRYPOINT ["screen","-DmS","node","dotnet","neo-cli.dll","--rpc", "--log"]
