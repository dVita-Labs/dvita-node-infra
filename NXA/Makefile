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

PROJECT_NAME=nxa-testnet-node
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

deploy-nxa-node-testnet-core: deploy-core

deploy-nxa-node-testnet-public: deploy-public

deploy-nxa-node-testnet-on-prem: deploy-on-prem

deploy-core: SSH?=team11@nxa-testnet-core.lan
deploy-core: docker-compose.xcp.testnet-core.yml publish
	ssh ${SSH} mkdir -p ./deployment/${PROJECT_NAME}/config/testnet
	scp Makefile ${SSH}:./deployment/${PROJECT_NAME}/
	scp .env ${SSH}:./deployment/${PROJECT_NAME}/
	scp $< ${SSH}:./deployment/${PROJECT_NAME}/
	scp -pr config/testnet/core ${SSH}:./deployment/${PROJECT_NAME}/config/testnet/
	scp -pr config/testnet/seed ${SSH}:./deployment/${PROJECT_NAME}/config/testnet/
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< down"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< pull"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< up -d"
	ssh ${SSH} docker ps

deploy-public: SSH?=team11@nxa-testnet-public.lan
deploy-public: docker-compose.xcp.testnet-public.yml publish
	ssh ${SSH} mkdir -p ./deployment/${PROJECT_NAME}/config/testnet
	scp Makefile ${SSH}:./deployment/${PROJECT_NAME}/
	scp .env ${SSH}:./deployment/${PROJECT_NAME}/
	scp $< ${SSH}:./deployment/${PROJECT_NAME}/
	scp -pr config/testnet/public ${SSH}:./deployment/${PROJECT_NAME}/config/testnet/
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< down"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< pull"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< up -d"
	ssh ${SSH} docker ps

deploy-on-prem: SSH?=team11@nxa-testnet-onprem.lan
deploy-on-prem: docker-compose.xcp.testnet-onprem.yml publish
	ssh ${SSH} mkdir -p ./deployment/${PROJECT_NAME}/config/testnet
	scp Makefile ${SSH}:./deployment/${PROJECT_NAME}/
	scp .env ${SSH}:./deployment/${PROJECT_NAME}/
	scp $< ${SSH}:./deployment/${PROJECT_NAME}/
	scp -pr config/testnet/onprem ${SSH}:./deployment/${PROJECT_NAME}/config/testnet/
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< down"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< pull"
	ssh ${SSH} \
		"cd ./deployment/${PROJECT_NAME}/ && \
			docker-compose -f $< up -d"
	ssh ${SSH} docker ps

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
	@echo "\n\ngetcommittee:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getcommittee", "params": [], "id": 2}' \
		localhost:20332
	@echo "\n\ngetstateheight:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getstateheight", "params": [], "id": 2}' \
		localhost:20332
	@echo "\n\ngetblockcount:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getblockcount", "params": [], "id": 3}' \
		localhost:20332
	@echo "\n\ngetbestblockhash:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getbestblockhash", "params": [], "id": 3}' \
		localhost:20332
	@echo "\n\ngetblock:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getblock", "params": ["0xa671fde77987aa5a410120ad5c6f4a6850c03b674aa0ce452b49207c38693c25"], "id": 3}' \
		localhost:20332
	@echo "\n\nopenwallet:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "openwallet", "params": ["/nxa-testnet-node-data/admin.json", "1"], "id": 4}' \
		localhost:20332
	@echo "\n\nlistaddress:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "listaddress", "params": [], "id": 5}' \
		localhost:20332
	@echo "\n\ngetwalletbalance (NXA Coin):"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getwalletbalance", "params": ["0xef4073a0f2b305a38ec4050e4d3d28bc40ea63f5"], "id": 6}' \
		localhost:20332
	@echo "\n\ngetwalletbalance (NXA GAS):"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "getwalletbalance", "params": ["0xd2a4cff31913016155e38e474a2c06d08be276cf"], "id": 6}' \
		localhost:20332
	@echo "\n\nclosewallet:"
	@curl -X POST -H 'content-type:application/json;' \
		--data '{"jsonrpc": "2.0", "method": "closewallet", "params": [], "id": 4}' \
		localhost:20332
	@echo "\n\nDone."

.PHONY: all build start stop exec publish rpc-test clean distclean \
	deploy-core \
	deploy-public \
	deploy-on-prem \
	deploy-nxa-node-testnet-core \
	deploy-nxa-node-testnet-public \
	deploy-nxa-node-testnet-on-prem

.SILENT: clean distclean
