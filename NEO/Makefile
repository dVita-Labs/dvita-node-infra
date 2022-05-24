##
## Copyright (c) 2021 - Team11. All rights reserved.
##

all: build

build:
	docker-compose build --parallel

start:
	docker-compose up -d

stop:
	docker-compose down

exec:
ifeq ($(OS),Windows_NT)
	winpty docker-compose exec nxa-testnet-node sh || true
else
	docker-compose exec nxa-testnet-node sh || true
endif

#
# Push to the registry
#
PROJECT_NAME=neo-node
HUB_REGISTRY_NAME=${PROJECT_NAME}
HUB_REGISTRY_HOST=registry.team11.lv
HUB_REGISTRY_URL=${HUB_REGISTRY_HOST}/public
HUB_REGISTRY_USER=oleg
HUB_REGISTRY_TOKEN=gbL8JDwZdWuhh7WQ
publish: build
	@echo ${HUB_REGISTRY_TOKEN} | docker login --username ${HUB_REGISTRY_USER} --password-stdin ${HUB_REGISTRY_HOST}
	docker tag ${PROJECT_NAME} ${HUB_REGISTRY_URL}/${HUB_REGISTRY_NAME}:latest
	docker push ${HUB_REGISTRY_URL}/${HUB_REGISTRY_NAME}:latest

#
# Deploy to ${SSH} connection
#
SSH?=team11@neo-testnet-core.lan
SSH_CONN=${SSH}

deploy: publish
	ssh ${SSH_CONN} mkdir -p ./deployment/${PROJECT_NAME}
	scp Makefile ${SSH_CONN}:./deployment/${PROJECT_NAME}/Makefile
	scp docker-compose.xcp.yml ${SSH_CONN}:./deployment/${PROJECT_NAME}/docker-compose.yml
	ssh ${SSH_CONN} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose down"
	ssh ${SSH_CONN} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose up -d"
	ssh ${SSH_CONN} docker ps

deploy-neo-node-testnet-public: deploy

clean: stop
	-@docker container prune --force
	-@docker image prune --all --force

distclean: stop
	-@docker container prune --force
	-@docker image prune --all --force
	-@docker volume prune --force
	-@docker system prune --all --force
	-@docker system df

rpc-test:
	@echo "getversion:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getversion", "params": [], "id": 1}' \
		localhost:20332
	@echo "\n\ngetstateheight:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getstateheight", "params": [], "id": 2}' \
		localhost:20332
	@echo "\n\ngetbestblockhash:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getbestblockhash", "params": [], "id": 3}' \
		localhost:20332
	@echo "\n\nopenwallet:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "openwallet", "params": ["/neo-node-data/admin.json", "1"], "id": 4}' \
		localhost:20332
	@echo "\n\nlistaddress:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "listaddress", "params": [], "id": 5}' \
		localhost:20332
	@echo "\n\ngetwalletbalance (NEO):"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getwalletbalance", "params": ["0xef4073a0f2b305a38ec4050e4d3d28bc40ea63f5"], "id": 6}' \
		localhost:20332
	@echo "\n\ngetwalletbalance (GAS):"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getwalletbalance", "params": ["0xd2a4cff31913016155e38e474a2c06d08be276cf"], "id": 6}' \
		localhost:20332
	@echo "\n\nclosewallet:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "closewallet", "params": [], "id": 4}' \
		localhost:20332
	@echo "\n\nDone."

.PHONY: all build start stop exec publish deploy deploy-neo-node-testnet-public rpc-test clean distclean

.SILENT: clean distclean
