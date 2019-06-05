#!/bin/bash -e
docker network create -d macvlan     \
  --subnet=172.17.17.0/24            \
  --gateway=172.17.17.1              \
  --ip-range=172.17.17.252/30        \
  --aux-address='host=172.17.17.253' \
  -o parent=eth0 pubnet
