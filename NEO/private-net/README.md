The NEO private chain
=====================

Build neo private network with 4 consensus nodes.

All wallets have same password as name.
Example 1.json wallet paasword is '1'.

Clean containers
---
    make clean

Build and start containers
---
	make run
Connect to container
---
    make exec1

Use screen to connect to process
---
    screen -ls
    screen -r 1
