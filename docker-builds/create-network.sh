#!/bin/bash -e
docker network create -d macvlan     \
  --subnet=192.168.178.0/24          \
  --gateway=192.168.178.1            \
  --ip-range=192.168.178.252/30      \
  --aux-address='host=192.168.178.254' \
  -o parent=eth0 pubnet
