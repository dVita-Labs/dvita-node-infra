The NXA Blockchain Node infrastructure
======================================

NEO
---

    cd NEO
    make clean build
    make start
    make exec

    make deploy SSH=team11@neo-testnet-core.lan


NXA
---

    cd NXA
    make clean build
    make start
    make exec

    make deploy-nxa-node-testnet-core SSH=team11@neo-testnet-core.lan
    make deploy-nxa-node-testnet-on-prem SSH=team11@neo-testnet-core.lan
    make deploy-nxa-node-testnet-public SSH=team11@neo-testnet-core.lan


General usage
-------------

    # Inside executed container:
    screen -ls
    screen -r 1
    # Then inside NEO3 cli:
    show state
    list asset
    # Then press Ctrl-a Ctrl-d to detach from a screen session
    docker-compose down


Links
-----  
[https://hub.docker.com/repository/docker/okertanov/neo-node](https://hub.docker.com/repository/docker/okertanov/neo-node)  
[https://hub.docker.com/repository/docker/okertanov/nxa-testnet-node](https://hub.docker.com/repository/docker/okertanov/nxa-testnet-node)  
[https://registry.team11.lv/](https://registry.team11.lv/)  
