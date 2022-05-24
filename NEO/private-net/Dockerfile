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
RUN dotnet restore neo-cli.csproj && dotnet publish neo-cli.csproj -c Release -o ./dist

# Clone modules repo
WORKDIR /
RUN git clone ${NEO_MODULES_REPO} ${NEO_MODULES_DIR}

# Build the modules
WORKDIR /${NEO_MODULES_DIR}
RUN git checkout ${NEO_GIT_VERSION}
RUN dotnet restore ./src/DBFTPlugin/DBFTPlugin.csproj && dotnet publish ./src/DBFTPlugin/DBFTPlugin.csproj -c Release -o ./dist
RUN dotnet restore ./src/LevelDBStore/LevelDBStore.csproj && dotnet publish ./src/LevelDBStore/LevelDBStore.csproj -c Release -o ./dist


##
## privatechain
##

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS privatechain

ENV NEO_NODE_DIR=neo-node
ENV NEO_MODULES_DIR=neo-modules

RUN apt-get update && apt-get install -y screen libleveldb-dev sqlite3 libsqlite3-dev libunwind8-dev procps curl nmap

WORKDIR /${NEO_NODE_DIR}

# Copy CLI
COPY --from=builder /${NEO_NODE_DIR}/neo-cli/dist ./

# Copy Modules
COPY --from=builder /${NEO_MODULES_DIR}/dist/LevelDBStore.dll ./Plugins/
COPY --from=builder /${NEO_MODULES_DIR}/dist/DBFTPlugin.dll ./Plugins/

# Copy DBFTPlugin config
COPY DBFTPlugin.config.json    ./Plugins/DBFTPlugin/config.json

# copy main config files
# using type bind
#COPY 1.config.json 1.config.json
#COPY 2.config.json 2.config.json
#COPY 3.config.json 3.config.json
#COPY 4.config.json 4.config.json

# Copy wallet files
COPY 1.json 1.json
COPY 2.json 2.json
COPY 3.json 3.json
COPY 4.json 4.json

ENTRYPOINT ["screen","-DmS","node","dotnet","neo-cli.dll"]