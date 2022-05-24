##
## Copyright (c) 2021 - Team11. All rights reserved.
##
#SERVER_IP:=192.168.65.3:2377

run: build create-network start

build:
	docker-compose build --parallel

#start-swarm:
#	docker swarm init --advertise-addr $(SERVER_IP);
	
create-network:
	docker network create --driver=bridge --subnet=10.15.0.0/16 privchain_network
#	docker network create --driver=overlay --attachable --subnet=10.15.0.0/16 privchain_network

start:
	docker-compose up -d

stop:
	docker-compose down

exec1:
	docker-compose exec neo-node1 /bin/bash || true
	
exec2:
	docker-compose exec neo-node2 /bin/bash || true
	
exec3:
	docker-compose exec neo-node3 /bin/bash || true
	
exec4:
	docker-compose exec neo-node4 /bin/bash || true
	
clean: stop
	-@docker container prune --force
	-@docker image prune --all --force
	-@docker volume prune --force
	-@docker network rm privchain_network || true
	
remove-network:
	-docker network rm privchain_network || true
