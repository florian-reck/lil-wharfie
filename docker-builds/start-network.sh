#!/bin/bash -e
ip link add pubnet-shim link eth0 type macvlan  mode bridge
ip addr add 172.17.17.254/32 dev pubnet-shim
ip link set pubnet-shim up
ip route add 172.17.17.252/30 dev pubnet-shim
ip route add 172.17.17.253/30 dev pubnet-shim
