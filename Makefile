##
## Copyright (c) 2021 - Team11. All rights reserved.
##

#
# Default targets
#

all:
	make -C NEO $@
	make -C NXA $@

clean:
	make -C NEO $@
	make -C NXA $@

#
# NXA targets
#

deploy-nxa-node-testnet-core: NXA
	make -C $< $@

deploy-nxa-node-testnet-public: NXA
	make -C $< $@

deploy-nxa-node-testnet-on-prem: NXA
	make -C $< $@

#
# NEO3 targets
#

deploy-neo-node-testnet-public: NEO
	make -C $< $@

#
# Internal targets
#

.PHONY: \
	all
	clean
	deploy-nxa-node-testnet-core \
	deploy-nxa-node-testnet-public \
	deploy-nxa-node-testnet-on-prem \
	deploy-neo-node-testnet-public
